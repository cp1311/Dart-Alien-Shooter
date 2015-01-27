part of gameentities;

/**
 * Level
 *
 * Represents a level in the game
 */
class Level {
	// default Settings for all levels
	static final Map<String,dynamic> defaultSettings = {

		"wall" : {
			"path" : "shootergame/images/environment/wall/",
			"animated" : false,
			"animations" : {},
			"type" : "dark",
		},

		"floor" : {
			"path" : "shootergame/images/environment/floor/",
			"animated" : false,
			"animations" : {},
		},

		"start" : {
			"path" : "shootergame/images/environment/start/",
			"animated" : true,
			"animations" : {
				"close" : {
					"steps" : 3,
					"interval" : 100,
					"type" : "once",
					"kill" : false,
				}
			}
		},

		"exit" : {
			"path" : "shootergame/images/environment/exit/",
			"animated" : true,
			"animations" : {
				"open" : {
					"steps" : 3,
					"interval" : 100,
					"type" : "once",
					"kill" : false,
				}
			}
		},

		"bullet" : {
			"path" : "shootergame/images/environment/bullet/",
			"animated" : false,
			"animations" : {},
			"types" : ["alien", "player"]
		},

		"muzzleFlash" : {
			"path" : "shootergame/images/environment/muzzleFlash/",
			"animated" : true,
			"animations" : {
				"fire" : {
					"steps" : 4,
					"interval" : 50,
					"type" : "once",
					"kill" : true,
				}
			}
		},

		"alien" : {
			"path" : "shootergame/images/alien/",
			"animated" : true,
			"animations" : {
				"move" : {
					"steps" : 3,
					"interval" : 150,
					"type" : "continious",
				},
				"die" : {
					"steps" : 4,
					"interval" : 150,
					"type" : "once",
					"kill" : false,
				}
			},
			"muzzleOffset" : { "x" : -2, "y" : -16 },
			"colors" : ["brown", "green", "grey"],
			"types" : ["shooter", "runner"],
		},

		"player" : {
			"path" : "shootergame/images/player/",
			"animated" : true,
			"muzzleOffset" : { "x" : 8, "y" : -23 },
			"animations" : {
				"move" : {
					"steps" : 3,
					"interval" : 150,
					"type" : "continious",
				},
				"die" : {
					"steps" : 4,
					"interval" : 150,
					"type" : "once",
					"kill" : true,
				}
			}
		},

		"blood" : {
			"path" : "shootergame/images/environment/blood/",
			"animated" : false,
			"animations" : {},
			"types" : ["alien", "player"]
		},

		"environmentpath" : "shootergame/images/environment/",

		"wincountdown" : 5000,
	};

	List<List<String>> structure; // the levels structure
	String levelname; // the levels name
	Map<String,dynamic> settings = defaultSettings; // the settings for the level
	List<Entity> entities = new List<Entity>(); // List containing all entities in the level
	List<Entity> killEntities = new List<Entity>();
	Point start; // startpoint for the player
	bool won = false;
	bool lost = false;
	Stopwatch wintimer = new Stopwatch();
	Stopwatch dietimer = new Stopwatch();
	num width;
	num height;

	/**
	 * Level Constructor
	 *
	 * [structure] the structure holding the contents of the level
	 * [settings] the settings for the level, default: defaultSettings
	 * [levelname] the name of the level, default: "Alien Shooter Level 1"
	 */
	Level ( List<List<String>> this.structure, { Map<String,dynamic> settings, String this.levelname : "Alien Shooter Level 1", num this.width : 1024, num this.height : 768 } ) {
		if ( (settings != null) && (settings.length > 0) ) {
			this.settings = settings;
		}
	}

	/**
	 * init
	 *
	 * Initialize the level
	 * Loops through the level-structure and fills the entities-list accordingly
	 */
	void init() {
		for (num y = 0; y < this.structure.length; y++) { // loop through structure
			for (num x = 0; x < this.structure[y].length; x++) {
				String elem = this.structure[y][x];
				switch (elem) { // check the element
					case "wall" : {
						Wall wall = new Wall( (x*64), (y*64), this.settings["wall"]["type"] ); // create new entity
						this.entities.add(wall); // add entity to list
					} break;
					case "exit" : {
						Exit exit = new Exit( (x*64), (y*64) );
						this.entities.add(exit);
					} break;
					case "start" : {
						this.start = new Point( (x*64), (y*64) );
						Start start = new Start( (x*64), (y*64) );
						this.entities.add(start);
					} break;
					case "as" : {
						Random r = new Random();
						AlienShooter as = new AlienShooter( (x*64),
															(y*64),
															color : this.settings["alien"]["colors"][r.nextInt(this.settings["alien"]["colors"].length)],
															offset : new Point (this.settings["alien"]["muzzleOffset"]["x"],this.settings["alien"]["muzzleOffset"]["y"])
														  );
						this.entities.add(as);
					} break;
					case "ar" : {
						Random r = new Random();
						AlienRunner ar = new AlienRunner( (x*64), (y*64), color : this.settings["alien"]["colors"][r.nextInt(this.settings["alien"]["colors"].length)] );
						this.entities.add(ar);
					} break;
					default : {
						// ...
					} break;
				}
			}
		}
	}

	/**
	 * update
	 *
	 * update all entities in the level
	 */
	void update( PlayerCharacter player ) {
		player.pathBlockedUp = false;
		player.pathBlockedDown = false;
		player.pathBlockedLeft = false;
		player.pathBlockedRight = false;
		List<Entity> newEntities = new List<Entity>();
		this.entities.forEach( (Entity e) {
			e.update();
			if (e is Wall) {
				if (player.intersects(e)) {
					final Rectangle col = e.rec.intersection(player.rec);

					final Rectangle l = new Rectangle(player.rec.left, player.rec.top, 0, player.rec.height);
					final Rectangle r = new Rectangle(player.rec.left+player.rec.width, player.rec.top, 0, player.rec.height);
					final Rectangle t = new Rectangle(player.rec.left, player.rec.top, player.rec.width, 0);
					final Rectangle b = new Rectangle(player.rec.left, player.rec.top+player.rec.height, player.rec.width, 0);

					final Rectangle lInter = col.intersection(l);
					final Rectangle rInter = col.intersection(r);
					final Rectangle tInter = col.intersection(t);
					final Rectangle bInter = col.intersection(b);

					final num lSize = (lInter != null) ? lInter.height : 0;
					final num rSize = (rInter != null) ? rInter.height : 0;
					final num tSize = (tInter != null) ? tInter.width : 0;
					final num bSize = (bInter != null) ? bInter.width : 0;

					player.pathBlockedUp = player.pathBlockedUp || (tSize > 0) && (tSize >= rSize) && (tSize >= lSize);
					player.pathBlockedDown = player.pathBlockedDown || (bSize > 0) && (bSize >= rSize) && (bSize >= lSize);
					player.pathBlockedLeft = player.pathBlockedLeft || (lSize > 0) && (lSize >= tSize) && (lSize >= bSize);
					player.pathBlockedRight = player.pathBlockedRight || (rSize > 0) && (rSize >= tSize) && (rSize >= bSize);
				}
			} else if (e is AlienCharacter) {
				if (e.isAlive()) {
					e.entitiesInSight = this.entities.where( (b) {
						if (e != b) {
							final Rectangle r = new Rectangle( 	min( e.getCenter().x, b.getCenter().x ),
																min( e.getCenter().y, b.getCenter().y ),
																max( e.getCenter().x, b.getCenter().x ) - min( e.getCenter().x, b.getCenter().x ),
																max( e.getCenter().y, b.getCenter().y ) - min( e.getCenter().y, b.getCenter().y )
															 );
							return (   ( e.getCenter().distanceTo(b.getCenter()) <= e.visRange )
									&& ( ! this.entities.any( (c) => ( (c is Wall) || (c is AlienCharacter) ) && !(c == e) && !(c.rec.intersects(r)) ) )
							);
						}
						return false;
					}).toList();


					final Rectangle r = new Rectangle( 	min( e.getCenter().x, player.getCenter().x ),
														min( e.getCenter().y, player.getCenter().y ),
														max( e.getCenter().x, player.getCenter().x ) - min( e.getCenter().x, player.getCenter().x ),
														max( e.getCenter().y, player.getCenter().y ) - min( e.getCenter().y, player.getCenter().y )
													 );
					List<Entity> inLineOfSight = this.entities.where( (c) => ( ( (c is Wall) || (c is AlienCharacter) ) && (c != e) && ( c.rec.intersects(r)) ) ).toList();
					if (   ( e.getCenter().distanceTo(player.getCenter()) <= e.visRange )
							&& ( ! this.entities.any( (c) => ( ( (c is Wall) || ( (c is AlienCharacter) && (c.isAlive()) ) ) && (c != e) && ( c.rec.intersects(r)) ) ) )
					) {
						e.entitiesInSight.add(player);
					}

					if (e is AlienRunner) {
						e.pathBlockedDown = false;
						e.pathBlockedLeft = false;
						e.pathBlockedRight = false;
						e.pathBlockedUp = false;
						this.entities.where( (w) => (w is Wall) && (w.intersects(e)) ).forEach( (w) {
							final Rectangle col = w.rec.intersection(e.rec);

	    					final Rectangle l = new Rectangle(e.rec.left, e.rec.top, 0, e.rec.height);
	    					final Rectangle r = new Rectangle(e.rec.left+e.rec.width, e.rec.top, 0, e.rec.height);
	    					final Rectangle t = new Rectangle(e.rec.left, e.rec.top, e.rec.width, 0);
	    					final Rectangle b = new Rectangle(e.rec.left, e.rec.top+e.rec.height, e.rec.width, 0);

	    					final Rectangle lInter = col.intersection(l);
	    					final Rectangle rInter = col.intersection(r);
	    					final Rectangle tInter = col.intersection(t);
	    					final Rectangle bInter = col.intersection(b);

	    					final num lSize = (lInter != null) ? lInter.height : 0;
	    					final num rSize = (rInter != null) ? rInter.height : 0;
	    					final num tSize = (tInter != null) ? tInter.width : 0;
	    					final num bSize = (bInter != null) ? bInter.width : 0;

	    					e.pathBlockedUp = e.pathBlockedUp || (tSize > 0) && (tSize >= rSize) && (tSize >= lSize);
	    					e.pathBlockedDown = e.pathBlockedDown || (bSize > 0) && (bSize >= rSize) && (bSize >= lSize);
	    					e.pathBlockedLeft = e.pathBlockedLeft || (lSize > 0) && (lSize >= tSize) && (lSize >= bSize);
	    					e.pathBlockedRight = e.pathBlockedRight || (rSize > 0) && (rSize >= tSize) && (rSize >= bSize);
						});

						if (e.isBiting) {
							e.isBiting = false;
							if (player.isAlive() && (e.getCenter().distanceTo(player.getCenter()) < e.width)) {
								Random r = new Random();
								player.hit(10 + r.nextInt(15));
							}
						}
					}
				} else {
					if (!this.entities.any( (c) => (c is Blood) && (c.owner == e) )) {
						Blood bloodpool = new Blood(e.x, e.y, e);
						newEntities.add(bloodpool);
					}
				}
			} else if (e is Bullet) {
				if ( (e.x < 1) || (e.x > this.width) || (e.y < 1) || (e.y > this.height) ) {
					e.die();
				}
				this.entities.where((i) => (i != e.owner) && ( (i is CharacterEntity) || (i is Wall))).forEach( (Entity c) {
					if (e.alive && c.intersects(e)) {
						if (c is Wall) {
							e.die();
						} else if (c is AlienCharacter) {
							if ( (e.owner is PlayerCharacter) && c.isAlive()) {
								c.hit( 25 );
								if (!c.isAlive()) {
									player.addPoints( c.points );
								}
								e.die();
							}
						}
					}
				});
				if ( (e.owner is AlienCharacter) && (e.intersects(player)) && player.isAlive() ) {
					player.hit( e.hitpoints );
					e.die();
				}
			} else if (e is muzzleFlash) {
				// ...
			} else if (e is Exit) {
				if (player.intersects(e)) {
					e.action = "open";
					this.wintimer.start();
					this.won = (this.wintimer.elapsedMilliseconds > this.settings["wincountdown"]);
				}
			} else if (e is Start) {
				if (!player.intersects(e)) {
					e.action = "close";
				}
			}
			if ( (e is ArmedCharacter) && (e is CharacterEntity) && (e.isAlive()) && ((e as ArmedCharacter).firingBullet)) {
				(e as ArmedCharacter).firingBullet = false;
				newEntities.add(new Bullet((e as ArmedCharacter).getMuzzleCoordinates().x, (e as ArmedCharacter).getMuzzleCoordinates().y, e));
				newEntities.add(new muzzleFlash(e));
			}
			if (!e.alive) {
				this.killEntities.add(e);
			}
		});

		player.update(); // update the player
		// Boundary-check
		if (player.isAlive()) {
			if (! this.entities.any( (e) => (e is Exit) && e.intersects(player) )) {
				if (player.x > (1013 - player.width)) {
					player.x = (1013 - player.width);
				}
				if (player.x < 10) {
					player.x = 10;
				}
				if (player.y > (757 - player.width)) {
					player.y = (757 - player.width);
				}
				if (player.y < 10) {
					player.y = 10;
				}
			} else {
				if (player.x > (1024 - player.width + 25)) {
					player.x = (1024 - player.width + 25);
				}
				if (player.x < 0 - 25) {
					player.x = 0 - 25;
				}
				if (player.y > (768 - player.width + 25)) {
					player.y = (768 - player.width + 25);
				}
				if (player.y < 0 - 25) {
					player.y = 0 - 25;
				}
			}
			if (player.firingBullet) {
				player.firingBullet = false;
				newEntities.add(new Bullet(player.getMuzzleCoordinates().x, player.getMuzzleCoordinates().y, player));
				newEntities.add(new muzzleFlash(player));
			}

			player.entitiesInSight = this.entities.where( (b) {
				final Rectangle r = new Rectangle( 	min( player.getCenter().x, b.getCenter().x ),
													min( player.getCenter().y, b.getCenter().y ),
													max( player.getCenter().x, b.getCenter().x ) - min( player.getCenter().x, b.getCenter().x ),
													max( player.getCenter().y, b.getCenter().y ) - min( player.getCenter().y, b.getCenter().y )
												 );
				List<Entity> test = this.entities.where( (c) => (c is Wall) && (c != b) && (c.rec.intersects(r)) ).toList();
				return (   ( player.getCenter().distanceTo(b.getCenter()) <= player.visRange )
						&& ( ! this.entities.any( (c) => (c is Wall) && (c != b) && (c.rec.intersects(r)) ) )
				);
			}).toList();
		}

		if (!player.alive) {
			if (!this.dietimer.isRunning) {
				this.dietimer.start();
				Blood bloodpool = new Blood(player.x, player.y, player);
				newEntities.add(bloodpool);
			}

			if (this.dietimer.elapsedMilliseconds > 2000) {
				this.dietimer.stop();
				this.dietimer.reset();
				if (player.lives > 0) {
					player.alive = true;
					player.resetTo(this.start.x, this.start.y, true);
				} else {
					this.lost = true;
				}
			}
		}

		this.entities.addAll(newEntities);

		//Test for speed? this.entities.removeWhere( (e) => killEntities.contains(e) );

		this.killEntities.forEach( (Entity e) {
			this.entities.remove(e);
		});

		this.killEntities.clear();
	}
}