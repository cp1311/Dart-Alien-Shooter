part of gameentities;

/**
 * Wall
 *
 * a piece of wall in the game
 */
class Wall extends Entity {
	String walltype;

	Wall(num x, num y, String this.walltype) : super(x, y, 64, 64, centerInGrid : true) {
		// ...
	}

	void update () {
		// empty
	}
}