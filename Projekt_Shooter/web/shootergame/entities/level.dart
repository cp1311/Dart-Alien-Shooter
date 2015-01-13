part of gameentities;

/**
 * Level
 *
 * Represents a level in the game
 */
class Level {
	// default Settings for all levels
	static final Map<String,dynamic> defaultSettings = {
		"wallPath" : "shootergame/images/environment/wall/",

		"startPath" : "shootergame/images/environment/start/",

		"exitPath" : "shootergame/images/environment/exit/",

		"floorPath" : "shootergame/images/environment/floor/",

		"bulletPath" : "shootergame/images/environment/bullet/",

		"muzzleFlashPath" : "shootergame/images/environment/muzzleFlash/",

		"alienPath" :  "shootergame/images/alien/",

		"playerPath" :  "shootergame/images/player/",

		"environmentPath" :  "shootergame/images/environment/",
	};

	List<List<String>> structure; // the levels structure
	String levelname; // the levels name
	Map<String,dynamic> settings = defaultSettings; // the settings for the level
	List<Entity> entities = new List<Entity>(); // List containing all entities in the level
	Point start; // startpoint for the player
	num width;
	num height;

	/**
	 * Level Constructor
	 *
	 * [structure] the structure holding the contents of the level
	 * [settings] the settings for the level, default: defaultSettings
	 * [levelname] the name of the level, default: "Alien Shooter Level 1"
	 */
	Level ( List<List<String>> this.structure, { num this.width : 1024, num this.height : 768, Map<String,dynamic> settings, String this.levelname : "Alien Shooter Level 1" } ) {
		if (settings != null) {
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
						Wall wall = new Wall( (x*64), (y*64) ); // create new entity
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
						AlienShooter as = new AlienShooter( (x*64), (y*64) );
						this.entities.add(as);
					} break;
					case "ar" : {
						AlienRunner ar = new AlienRunner( (x*64), (y*64) );
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
		List<Entity> killEntities = new List<Entity>();
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
			} else if (e is AlienRunner) {
				if (e.isAlive()) {
					if (e.isRunning) {
						this.entities.forEach( (Entity c) {
							if (c is Wall) {
								if (c.intersects(e)) {
									//TODO: Alien is hitting Wall
								}
							}
						});
					}
				}
			} else if (e is AlienShooter) {
				if (e.isAlive()) {
					if (e.shoot) {
						newEntities.add(new Bullet(e.getMuzzleCoordinates().x, e.getMuzzleCoordinates().y, e));
					}
				}
			} else if (e is Bullet) {
				if (e.alive) {
					if ( (e.x < 0) || (e.x > this.width) || (e.y < 0) || (e.y > this.height) ) {
						e.die();
					}
					this.entities.forEach( (Entity c) {
						if (c is Wall) {
							if (c.intersects(e)) {
								e.die();
							}
						} else if (c is AlienCharacter) {
							if (c.intersects(e)) {
								c.hit( 25 );
								e.die();
							}
						}
					});
				} else {
					killEntities.add(e);
				}
			} else if (e is muzzleFlash) {
				if ( (e.animationStep == 4) && (e.animationTimer.elapsedMilliseconds > e.animationInterval) ) {
					killEntities.add(e);
				}
			} else if (e is Exit) {
				// ...
			}
		});

		player.update(); // update the player
		// Boundary-check
		if (player.x > (1023 - player.width)) {
			player.x = (1023 - player.width);
		}
		if (player.x < 1) {
			player.x = 1;
		}
		if (player.y > (767 - player.width)) {
			player.y = (767 - player.width);
		}
		if (player.y < 1) {
			player.y = 1;
		}
		if (player.firingBullet) {
			player.firingBullet = false;
			newEntities.add(new Bullet(player.getMuzzleCoordinates().x, player.getMuzzleCoordinates().y, player));
			newEntities.add(new muzzleFlash(player.getMuzzleCoordinates().x, player.getMuzzleCoordinates().y, player));
		}

		newEntities.forEach( (Entity e) {
			this.entities.add(e);
		});

		killEntities.forEach( (Entity e) {
			this.entities.remove(e);
		});
	}
}