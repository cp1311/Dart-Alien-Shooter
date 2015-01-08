part of gameentities;

/**
 * Entity
 *
 * Baseclass for all entities in the game
 */
abstract class Entity {
	num x; // x coordinate of the entity in the game world
	num y; // y coordinate
	num width;
	num height;
	num animationStep = 0; // the curent step in the animation(-cycle)
	bool animated; // determines if this entity is animated or static
	Rectangle rec = new Rectangle(0, 0, 0, 0); // the rectangle representing the entity in the gameworld

	/**
	 * Entity Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [width] entity-width
	 * [height] entity-height
	 * [animated] is the entity animated or static?
	 */
	Entity (num this.x, num this.y, num this.width, num this.height, { bool this.animated : false }) {
		num dx = 64 - width;
		num dy = 64 - height;
		if (dx > 1) {
			this.x += (dx/2).floor();
		}
		if (dy > 1) {
			this.y += (dy/2).floor();
		}
	}

	/**
	 * intersects
	 *
	 * determines if [this.rec] intersects with [e.rec]
	 * returns true if they intersect, false if not.
	 */
	bool intersects( Entity e ) {
		//TODO: detect intersetcion
		return false;
	}

	void update(); // abstract
}