part of gameentities;

/**
 * Exit
 *
 * The goal of the level
 */
class Exit extends Entity {

	Exit(num x, num y, { bool animated : true }) : super(x, y, 64, 64, animated : animated, centerInGrid : true) {
		// ...
	}

	void update() {
		// empty
	}

}