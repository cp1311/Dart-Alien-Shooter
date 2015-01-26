part of gameentities;

/**
 * Blood
 *
 * a piece of wall in the game
 */
class Blood extends Entity {
	String bloodtype;

	Blood(num x, num y, String this.bloodtype) : super(x, y, 64, 64, centerInGrid : true) {
		// ...
	}

	void update () {
		// empty
	}
}