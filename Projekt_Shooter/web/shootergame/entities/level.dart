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

		"alienPath" :  "shootergame/images/alien/",

		"playerPath" :  "shootergame/images/player/",
	};

	List<List<String>> structure; // the levels structure
	String levelname; // the levels name
	Map<String,dynamic> settings = defaultSettings; // the settings for the level
	List<Entity> entities = new List<Entity>(); // List containing all entities in the level
	Point start; // startpoint for the player

	/**
	 * Level Constructor
	 *
	 * [structure] the structure holding the contents of the level
	 * [settings] the settings for the level, default: defaultSettings
	 * [levelname] the name of the level, default: "Alien Shooter Level 1"
	 */
	Level ( List<List<String>> this.structure, { Map<String,dynamic> settings, String this.levelname : "Alien Shooter Level 1" } ) {
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
		this.entities.forEach( (Entity e) {
			if (player.intersects(e)) {
				if (e is Wall) {
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
			}
			e.update();
		});
	}
}