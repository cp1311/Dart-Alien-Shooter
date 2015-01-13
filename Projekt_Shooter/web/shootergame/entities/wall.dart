part of gameentities;

/**
 * Wall
 *
 * a piece of wall in the game
 */
class Wall extends Entity {
	num walltype;

	Wall(num x, num y, { num walltype : 0 }) : super(x, y, 64, 64, centerInGrid : true) {
		this.walltype = walltype;
	}

	void update () {
		// empty
	}
}