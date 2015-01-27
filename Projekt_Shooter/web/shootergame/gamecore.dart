part of gameengine;

/**
 * GameCore
 *
 * The core of the gameengine, in charge of updating and displaying the game
 */
class GameCore {
	final CanvasRenderingContext2D stage; // the stage to draw on
	int width; // width of the gamefield
	int height; // height of the gamefield
	List<Level> gamelevels = []; // list of all levels to play through
	int activeLevel = -1; // the active level
	PlayerCharacter player; // the player
	List<Map<String,dynamic>> renderList = [];
	Map<String,HtmlElement> gui;
	bool loading = true;
	Stopwatch fpstimer = new Stopwatch();
	num fps = 0;
	bool gameover = false;

	// a default level structure to display, if no levels get loaded.
	static final List<List<String>> defaultLevelStructure = [
		[ "wall",	"wall",	"wall",	"exit",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall", ],
		[ "wall",	"as", 	"",		"",		"wall",	"",		"",		"wall",	"",		"",		"",		"as",	"",		"",		"",		"wall", ],
		[ "wall",	"", 	"wall",	"wall",	"wall",	"wall",	"",		"wall",	"",		"wall",	"wall",	"wall",	"wall",	"wall",	"",		"wall", ],
		[ "wall",	"ar", 	"",		"",		"",		"",		"as",	"wall",	"",		"wall",	"",		"",		"",		"wall",	"",		"wall", ],
		[ "wall",	"", 	"wall",	"wall",	"",		"wall",	"wall",	"wall",	"",		"wall",	"",		"wall",	"wall",	"wall",	"",		"wall", ],
		[ "wall",	"", 	"as",	"wall",	"",		"",		"",		"",		"as",	"wall",	"",		"",		"",		"",		"",		"wall", ],
		[ "wall",	"wall",	"wall",	"",		"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"",		"wall",	"",		"wall", ],
		[ "wall",	"",		"",		"ar",	"wall",	"ar",	"",		"",		"",		"",		"",		"wall",	"",		"wall",	"ar",	"wall", ],
		[ "wall",	"", 	"wall",	"wall",	"wall",	"",		"wall",	"",		"wall",	"wall",	"",		"",		"",		"wall",	"wall",	"wall", ],
		[ "wall",	"", 	"",		"",		"wall",	"",		"wall",	"",		"wall",	"wall",	"",		"wall",	"wall",	"wall",	"",		"wall", ],
		[ "wall",	"", 	"wall",	"as",	"",		"",		"wall",	"start","wall",	"as",	"",		"",		"",		"",		"ar",	"wall", ],
		[ "wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall",	"wall", ],
	];

	/**
	 * GameCore Constructor
	 * [stage] the stage to draw on
	 * [width] the width of the gamefield, default: 1024
	 * [height] the height of the gamefield, defaulf: 768
	 * [levelFile] file containing levels
	 */
	GameCore (CanvasRenderingContext2D this.stage, Map<String,HtmlElement> this.gui, [ String levelFile, int this.width = 1024, int this.height = 768 ] ) {
		stage.fillStyle = "#000000"; // backgroundcolor
		stage.fillRect(0, 0, this.width, this.height); // paint the stage black

		fpstimer.start();
		this.player = new PlayerCharacter(1, 1);
		if (levelFile == null) {
			this.addLevel(new Level(defaultLevelStructure)); // load the default Level
			this.initFirstLevel();
		} else {
			this.loading = true;
			this.loadLevelsFromFile("levels.txt");
		}
	}

	/**
	 * initFirstLevel
	 *
	 * Initializes the first level to play
	 */
	void initFirstLevel() {
		this.loadNextLevel();
		Map<String,dynamic> item = new Map<String,dynamic>();
		item["entity"] = this.player;
		item["action"] = "";
		item["type"] = "player";
		item["animated"] = this.gamelevels[activeLevel].settings["player"]["animated"];
		if (item["animated"]) {
			item["timer"] = new Stopwatch();
			item["step"] = 0;
			item["root"] = this.gamelevels[activeLevel].settings["player"]["path"];
		}
		final ImageElement img = new ImageElement(src: this.gamelevels[activeLevel].settings["player"]["path"] + this.player.heading + "/" + "0.png");
		item["image"] = img;
		this.renderList.add(item);
	}

	/**
	 * update
	 *
	 * trigger an update for all entities in the game
	 */
	void update() {
		fps++;
		if (!this.loading && !this.gameover) {
			final Level level = this.gamelevels[activeLevel]; // get the active Level

			level.update( this.player ); // update all entities in the level

			level.entities.forEach( (e) {
				if ( !renderList.any( (i) => i["entity"] == e) ) {
					Map<String,dynamic> item = new Map<String,dynamic>();
					item["entity"] = e;
					item["action"] = "";
					item["type"] = "";

					if (e is Exit) {
						item["type"] = "exit";
						item["root"] = level.settings["exit"]["path"];
	    				item["animated"] = level.settings["exit"]["animated"];
					}
					if (e is Start) {
						item["type"] = "start";
						item["root"] = level.settings["start"]["path"];
	    				item["animated"] = level.settings["start"]["animated"];
	    			}
					if (e is Wall) {
						item["type"] = "wall";
						item["root"] = level.settings["wall"]["path"] + e.walltype + "/";
	    				item["animated"] = level.settings["wall"]["animated"];
					}
					if (e is Blood) {
						item["type"] = "blood";
						item["root"] = level.settings["blood"]["path"] + e.bloodtype + "/";
	    				item["animated"] = level.settings["blood"]["animated"];
					}
					if (e is AlienCharacter) {
						item["type"] = "alien";
						item["root"] = level.settings["alien"]["path"] + e.type + "/" + e.color + "/";
	    				item["animated"] = level.settings["alien"]["animated"];
	    			}
					if (e is Bullet) {
						item["type"] = "bullet";
	    				final String owner = (e.owner is AlienCharacter) ? "alien" : "player";
						item["root"] = level.settings["bullet"]["path"] + owner + "/";
	    				item["animated"] = level.settings["bullet"]["animated"];
	    			}
					if (e is muzzleFlash) {
						item["type"] = "muzzleFlash";
						item["root"] = level.settings["muzzleFlash"]["path"];
	    				item["animated"] = level.settings["muzzleFlash"]["animated"];
	    			}

					if (item["animated"]) {
						item["timer"] = new Stopwatch();
						item["step"] = 0;
					}

					final ImageElement img = new ImageElement(src: item["root"] + (e.action != "" ? e.action + "/" : "") + ( (e.heading != "") ? e.heading + "/" : "" ) + "0.png");
					item["image"] = img;

					renderList.add(item);
				}
			});

			renderList.retainWhere( (i) => (level.entities.contains(i["entity"]) || i["entity"] is PlayerCharacter) );

			renderList.forEach( (item) {
				Entity e = item["entity"];

				if (item["animated"]) {
					if (e.action != "") {
						if (e.action != item["action"]) {
							item["step"] = 0;
							item["timer"].start();
							item["timer"].reset();
						}
						item["action"] = e.action;
						final num maxstep = level.settings[item["type"]]["animations"][e.action]["steps"];
						final String animtype = level.settings[item["type"]]["animations"][e.action]["type"];
						final num interval = level.settings[item["type"]]["animations"][e.action]["interval"];
						if (item["timer"].elapsedMilliseconds > interval) {
							if (item["step"]+1 >= maxstep) {
								if (animtype != "once") {
									item["step"] = 0;
								} else if (level.settings[item["type"]]["animations"][e.action]["kill"]) {
									e.alive = false;
								}
							} else {
								item["step"]++;
							}
							item["timer"].reset();
						}
					} else {
						item["timer"].stop();
						item["step"] = 0;
						item["action"] = "";
					}
					final ImageElement img = new ImageElement(src: item["root"] + (e.action != "" ? e.action + "/" : "") + ( (e.heading != "") ? e.heading + "/" : "" ) + item["step"].toString() + ".png");
					item["image"] = img;
				}
			});

			if (level.won) {
				this.loadNextLevel();
			}

			if (level.lost) {
				this.end();
			}
		}
	}


	/**
	 * draw
	 *
	 * draw all levelcontent to the stage
	 */
	void draw() {
		if (!this.gameover) {
			this.stage.fillStyle = "#000000"; // paint the stage black
			this.stage.fillRect(0, 0, this.width, this.height);

			if (!this.loading) {
				final Level level = this.gamelevels[activeLevel]; // get the active level

				final ImageElement bgImg = new ImageElement(src: level.settings["floor"]["path"] + "defaultFloor.png"); // get the floor image
				if ( (bgImg.width != 0) && (bgImg.height != 0) ) { // draw the floor
					final int maxX = (this.width / bgImg.width).ceil();
					final int maxY = (this.height / bgImg.height).ceil();
					for ( int m=0; m < maxX; m++ ) {
						for ( int n=0; n < maxY; n++ ) {
							this.stage.drawImage(bgImg, (m*bgImg.width), (n*bgImg.height));
						}
					}
				}

				renderList.where((i) => !(i["entity"] is CharacterEntity)).forEach( (Map i) { // loop throught the entities in the renderlist and draw them
					Entity e = i["entity"];
					if (!(e is AlienCharacter) || ( (e is CharacterEntity) && (!e.isAlive())) || this.player.entitiesInSight.contains(e)) {
						final dx = e.getCenter().x - ( e.width ~/ 2 );
						final dy = e.getCenter().y - ( e.height ~/ 2 );
						this.stage.drawImage(i["image"] , dx, dy);
					}
				});

				renderList.where((i) => (i["entity"] is CharacterEntity) && (i["entity"] != this.player) ).forEach( (Map i) { // loop throught the entities in the renderlist and draw them
					Entity e = i["entity"];
					if (!(e is AlienCharacter) || ( (e is CharacterEntity) && (!e.isAlive())) || this.player.entitiesInSight.contains(e)) {
						final dx = e.getCenter().x - ( e.width ~/ 2 );
						final dy = e.getCenter().y - ( e.height ~/ 2 );
						this.stage.drawImage(i["image"] , dx, dy);
					}
				});

				renderList.where((i) => i["entity"] == this.player).forEach( (Map i) {
					Entity e = i["entity"];
					final dx = e.getCenter().x - ( e.width ~/ 2 );
					final dy = e.getCenter().y - ( e.height ~/ 2 );
					this.stage.drawImage(i["image"] , dx, dy);
				});

				// at last draw the player on the stage
				final ImageElement visrangeimg = new ImageElement(src: level.settings["environmentpath"] + "visRange.png");
				final ImageElement shadowimg = new ImageElement(src: level.settings["environmentpath"]  + "shadow.png");
				final num visrangeX = (this.player.getCenter().x - (this.player.visRange ~/ 2));
				final num visrangeY = (this.player.getCenter().y - (this.player.visRange ~/ 2));
				this.stage.drawImageScaled( visrangeimg,
											visrangeX,
											visrangeY,
											player.visRange.toInt(),
											player.visRange.toInt()
										);
				this.stage.fillRect(0, 0, visrangeX, this.height );
				this.stage.fillRect(visrangeX + player.visRange.toInt(), 0, this.width - visrangeX - player.visRange.toInt(), this.height );
				this.stage.fillRect(0, 0, this.width, visrangeY );
				this.stage.fillRect(0, visrangeY + player.visRange.toInt(), this.width, this.height - visrangeY - player.visRange.toInt() );
			}
		}

//		this.stage.fillStyle = "#ffff00";
//		this.stage.fillText(( fps ~/ ( fpstimer.elapsedMilliseconds / 1000 ) ).toString(), 960, 40);
//		this.stage.fillStyle = "#000000";

		String hearts = "";
		for (num i = 1; i <= player.lives; i++) {
			hearts += "♥";
		}
		this.gui["health"].setInnerHtml( hearts + " | " + player.health.toString());
		this.gui["ammo"].setInnerHtml(player.bullets.toString());
		this.gui["score"].setInnerHtml(player.score.toString());
	}

	/**
	 * addLevel
	 *
	 * Add [level] to the list of gamelevels to play
	 */
	void addLevel( Level level ) {
		this.gamelevels.add(level);
	}

	/**
	 * loadNextLevel
	 *
	 * start the next level
	 */
	void loadNextLevel() {
		this.loading = true;
		if (activeLevel+1 < this.gamelevels.length) {
    		this.gui["progress"].setAttribute("value", "0");
    		this.gui["progress"].classes.remove("hidden");
			this.activeLevel++;
			this.gamelevels[this.activeLevel].init(); // initialize the new level
			renderList.retainWhere((i) => i["entity"] == this.player);
			this.loadLevelContents();
			this.resetPlayer();
			this.gui["level"].setInnerHtml(this.gamelevels[this.activeLevel].levelname);
		} else {
			this.end();
		}
	}

	/**
	 * resetPlayer
	 *
	 * reset the player to the start location
	 */
	void resetPlayer() {
		final Point m = new Point(this.gamelevels[this.activeLevel].settings["player"]["muzzleOffset"]["x"],this.gamelevels[this.activeLevel].settings["player"]["muzzleOffset"]["y"]);
		this.player.muzzleOffset = m;
		this.player.resetTo(this.gamelevels[this.activeLevel].start.x, this.gamelevels[this.activeLevel].start.y);
	}

	/**
	 * loadLevelContents
	 *
	 * Preload Resources for Level
	 */
	void loadLevelContents() {
		Level level = this.gamelevels[activeLevel];
		List<String> loadData = new List<String>();
		level.settings.forEach( (String type, dynamic set) {
			if (set is Map) {
				String path = set["path"];
				if (type == "floor") {
					loadData.add(path + "defaultFloor.png");
				} else if (type == "wall") {
					loadData.add(path + set["type"] + "/0.png");
				} else if ((type == "blood") || (type == "bullet")) {
					set["types"].forEach( (String btype) {
						String bpath = path + btype + "/";
						loadData.add(bpath + "up/0.png");
	    				loadData.add(bpath + "down/0.png");
	    				loadData.add(bpath + "left/0.png");
	    				loadData.add(bpath + "right/0.png");
					});
				} else {
					if ( (type != "alien") && (type != "muzzleFlash") ) {
						loadData.add(path + "up/0.png");
	    				loadData.add(path + "down/0.png");
	    				loadData.add(path + "left/0.png");
	    				loadData.add(path + "right/0.png");
					}

					if (set["animated"]) {
						set["animations"].forEach( (String action, Map ani) {
							if (type == "alien") {
								set["types"].forEach( (String alientype) {
									set["colors"].forEach( (String color) {
										String subpath = path + alientype + "/" + color + "/" + action + "/";
										for (var i = 0; i < ani["steps"]; i++) {
			    							loadData.add(subpath + "up/" + i.toString() + ".png");
			    			    			loadData.add(subpath + "down/" + i.toString() + ".png");
			    			    			loadData.add(subpath + "left/" + i.toString() + ".png");
			    			    			loadData.add(subpath + "right/" + i.toString() + ".png");
			    						}
									});
								});
							} else {
								String subpath = path + action + "/";
								for (var i = 0; i < ani["steps"]; i++) {
	    							loadData.add(subpath + "up/" + i.toString() + ".png");
	    			    			loadData.add(subpath + "down/" + i.toString() + ".png");
	    			    			loadData.add(subpath + "left/" + i.toString() + ".png");
	    			    			loadData.add(subpath + "right/" + i.toString() + ".png");
	    						}
							}
						});
					} else {
						loadData.add(path + "0.png");
					}
				}
			}
		});
		this.gui["progress"].setAttribute("max", loadData.length.toString());
		loadData.forEach( (String file) {
			ImageElement img = new ImageElement(src : file);
			img.onLoad.listen( (t) {
				this.updateProgressbar();
			});
			img.onError.listen( (t) {
				this.updateProgressbar();
			});
		});
	}

	/**
	 * updateProgressbar
	 *
	 * ...
	 */
	void updateProgressbar() {
		this.gui["progress"].setAttribute("value", (int.parse(this.gui["progress"].getAttribute("value")) + 1).toString() );
		if (this.gui["progress"].getAttribute("value") == this.gui["progress"].getAttribute("max")) {
			this.gui["progress"].classes.add("hidden");
			this.loading = false;
		}
	}

	/**
	 * loadLevel
	 *
	 * load levels from levels.txt
	 */
	void loadLevelsFromFile(String filename) {
		HttpRequest.getString('shootergame/'+filename).then((leveldata) {
			final Map levels = JSON.decode(leveldata);
			levels.forEach( (String levelname, Map level) {
				if (level["settings"].length > 0) {
					this.gamelevels.add(new Level(level["structure"], settings : level["settings"], levelname : levelname));
				} else {
					this.gamelevels.add(new Level(level["structure"], levelname : levelname));
				}
			});
			this.initFirstLevel();
		});
	}

	/**
	 * pause
	 *
	 * (not implemented)
	 *
	 * pause the game
	 */
	void pause() {
		//TODO: Pause game
	}

	/**
	 * end
	 *
	 * end the game
	 */
	void end() {
		this.loading = false;
		this.gameover = true;

		this.stage.fillStyle = "rgba(0,0,0,0.85)";
		this.stage.fillRect(0, 0, this.width, this.height);

		this.stage.font = "bold 76pt Calibri";
		this.stage.textAlign = 'center';
		if (this.gamelevels[this.activeLevel].won) {
			this.stage.fillStyle = "rgba(255,255,255,1)";
			this.stage.fillText("YOU WIN!", this.width ~/ 2, this.height ~/ 2);
		} else {
			this.stage.fillStyle = "rgba(255,200,100,1)";
			this.stage.fillText("YOU LOSE!", this.width ~/ 2, this.height ~/ 2);
		}
	}
}