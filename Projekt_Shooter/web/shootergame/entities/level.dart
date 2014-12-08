part of gameentities;

class Level {

	static final List<List<String>> testlevel = [
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

	List<List<String>> structure;
	Map<String, List<Entity>> entities;
	Point start;

	Level ( { String levelname : "test" } ) {
		this.load(levelname);
		this.init();
	}

	void init() {
		this.entities = {
			"static" : new List<Entity>(),
			"dynamic" : new List<Entity>(),
		};
		for (num y = 0; y < this.structure.length; y++) {
			for (num x = 0; x < this.structure[y].length; x++) {
				String elem = this.structure[y][x];
				switch (elem) {
					case "wall" : {
						Wall wall = new Wall( (x*64), (y*64) );
						this.entities["static"].add(wall);
					} break;
					case "exit" : {
						Exit exit = new Exit( (x*64), (y*64) );
						this.entities["static"].add(exit);
					} break;
					case "start" : {
						this.start = new Point( (x*64), (y*64) );
						Start start = new Start( (x*64), (y*64) );
						this.entities["static"].add(start);
					} break;
					case "as" : {
						AlienShooter as = new AlienShooter( (x*64), (y*64) );
						this.entities["dynamic"].add(as);
					} break;
					case "ar" : {
						AlienRunner ar = new AlienRunner( (x*64), (y*64) );
						this.entities["dynamic"].add(ar);
					} break;
					default : {
						// ...
					} break;
				}
			}
		}
		//TODO: Fill Level with entities according to structure
	}

	void update() {
		//TODO: Run through all entities in level and update each
	}

	void draw( CanvasRenderingContext2D stage ) {
		//TODO: Run through all entities in level and draw then onto the stage
	}

	void load( String levelname /* filename? levelnumber? */ ) {
		if (levelname == "test") {
			this.structure = testlevel;
		} else {
			//TODO: Load new level (from file?) or generate new level?
		}
	}

}