part of gameengine;

/**
 * GameCore
 *
 * The core of the gameengine, controlling all major functions
 */
class GameCore {
	final CanvasRenderingContext2D stage; // the stage to draw on
	int width; // width of the gamefield
	int height; // height of the gamefield
	List<Level> gamelevels = []; // list of all levels to play through
	int activeLevel = 0; // the active level
	PlayerCharacter player; // the player

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
	 * [gamelevels] a list of levels to play through
	 */
	GameCore (CanvasRenderingContext2D this.stage, [ int this.width = 1024, int this.height = 768, List<Level> gamelevels ] ) {
		stage.fillStyle = "#000000"; // backgroundcolor
		stage.fillRect(0, 0, this.width, this.height); // paint the stage black

		if (gamelevels == null) {
			this.addLevel(new Level(defaultLevelStructure)); // load the default Level
		} else {
			this.gamelevels = gamelevels;
		}
		this.gamelevels[activeLevel].init(); // initialize the active (first) level
		this.loadLevelContents();
		this.player = new PlayerCharacter(this.gamelevels[activeLevel].start.x, this.gamelevels[activeLevel].start.y); // place the player on start
	}

	/**
	 * update
	 *
	 * trigger an update for all entities in the game
	 */
	void update() {
		final Level level = this.gamelevels[activeLevel]; // get the active Level

		level.update( this.player ); // update all entities in the level
	}

	/**
	 * draw
	 *
	 * draw all levelcontent to the stage
	 */
	void draw() {
		this.stage.fillStyle = "#000000"; // paint the stage black
		this.stage.fillRect(0, 0, this.width, this.height);

		final Level level = this.gamelevels[activeLevel]; // get the active level

		final ImageElement bgImg = new ImageElement(src: level.settings["floorPath"] + "defaultFloor.png"); // get the floor image
		if ( (bgImg.width != 0) && (bgImg.height != 0) ) { // draw the floor
			final int maxX = (this.width / bgImg.width).ceil();
			final int maxY = (this.height / bgImg.height).ceil();
			for ( int m=0; m < maxX; m++ ) {
				for ( int n=0; n < maxY; n++ ) {
					this.stage.drawImage(bgImg, (m*bgImg.width), (n*bgImg.height));
				}
			}
		}

		level.entities.forEach( (Entity e) { // loop throught the entities in the level and paint them according to their type
			if (e is Wall) { // typecheck
				final String imagename = "" + (e.animated ? e.animationStep.toString() : "defaultWall") + ".png"; // generate imagename
				final ImageElement img = new ImageElement(src: level.settings["wallPath"] + imagename); // set up ImageElement
				final dx = e.getCenter().x - ( e.width ~/ 2 );
				final dy = e.getCenter().y - ( e.height ~/ 2 );
				this.stage.drawImage(img , dx, dy); // paint to the stage
			}
			if (e is Exit) {
				final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
				final ImageElement img = new ImageElement(src: level.settings["exitPath"] + imagename);
				final dx = e.getCenter().x - ( e.width ~/ 2 );
				final dy = e.getCenter().y - ( e.height ~/ 2 );
				this.stage.drawImage(img , dx, dy);
			}
			if (e is Start) {
				final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
				final ImageElement img = new ImageElement(src: level.settings["startPath"] + imagename);
				final dx = e.getCenter().x - ( e.width ~/ 2 );
				final dy = e.getCenter().y - ( e.height ~/ 2 );
				this.stage.drawImage(img , dx, dy);
			}
			if (e is AlienCharacter) {
				if (e.isAlive()) {
					final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
					final ImageElement img = new ImageElement(src: level.settings["alienPath"] + e.type + "/" + e.color + "/" + e.heading + "/" + imagename);
					final dx = e.getCenter().x - ( e.width ~/ 2 );
					final dy = e.getCenter().y - ( e.height ~/ 2 );
					this.stage.drawImage(img , dx, dy);
				} else {
					final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
					final ImageElement img = new ImageElement(src: level.settings["alienPath"] + e.type + "/" + e.color + "/die/" + imagename);
					final dx = e.getCenter().x - ( e.width ~/ 2 );
					final dy = e.getCenter().y - ( e.height ~/ 2 );
					this.stage.drawImage(img , dx, dy);
				}
			}
			if (e is Bullet) {
				final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
				final ImageElement img = new ImageElement(src: level.settings["bulletPath"] + e.heading + "/" + imagename);
				final dx = e.getCenter().x - ( e.width ~/ 2 );
				final dy = e.getCenter().y - ( e.height ~/ 2 );
				this.stage.drawImage(img , dx, dy);
			}
			if (e is muzzleFlash) {
				final String imagename = "" + (e.animated ? e.animationStep.toString() : "0") + ".png";
				final ImageElement img = new ImageElement(src: level.settings["muzzleFlashPath"] + e.heading + "/" + imagename);
				final dx = e.getCenter().x - ( e.width ~/ 2 );
				final dy = e.getCenter().y - ( e.height ~/ 2 );
				this.stage.drawImage(img , dx, dy);
			}
		});

		// at last draw the player on the stage
		final String playerimgname = "" + (this.player.animated ? this.player.animationStep.toString() : "0") + ".png";
		final ImageElement playerimg = new ImageElement(src: level.settings["playerPath"] + this.player.heading + "/" + playerimgname);
		final ImageElement visrangeimg = new ImageElement(src: level.settings["environmentPath"] + "visRange.png");
		final ImageElement shadowimg = new ImageElement(src: level.settings["environmentPath"]  + "shadow.png");

		this.stage.drawImage(playerimg , this.player.x, this.player.y);
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
		this.activeLevel++;
		this.gamelevels[activeLevel].init(); // initialize the new level
		this.loadLevelContents();
		this.player.x = this.gamelevels[activeLevel].start.x;
		this.player.y = this.gamelevels[activeLevel].start.y; // place the player on start
	}

	/**
	 * loadLevelContents
	 *
	 * Preload Resources for Level
	 */
	void loadLevelContents() {
		//TODO: Load Level Contents
		//TODO: Display Loading Screen?

	}

	/**
	 * loadLevel
	 *
	 * (not implemented)
	 *
	 * ...
	 */
	void loadLevel() {
		//TODO: Load new level (from file?) or generate new level?
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
}