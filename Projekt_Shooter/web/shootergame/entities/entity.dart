part of gameentities;

/**
 * Entity
 *
 * Baseclass for all entities in the game
 */
abstract class Entity {
	num x; // x coordinate of the entitys upper left corner in the game world
	num y; // y coordinate of the entitys upper left corner
	num width;
	num height;
	num animationStep = 0; // the curent step in the animation(-cycle)
	Stopwatch animationTimer = new Stopwatch();
	num animationInterval = 100; // ms for each animationstep
	bool animated; // determines if this entity is animated or static
	Rectangle rec = new Rectangle(0, 0, 0, 0); // the rectangle representing the entity in the gameworld
	bool centerInGrid;
	bool alive = true;

	/**
	 * Entity Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [width] entity-width
	 * [height] entity-height
	 * [animated] is the entity animated or static?
	 */
	Entity (num this.x, num this.y, num this.width, num this.height, { bool this.animated : false, this.centerInGrid : false }) {
		if (this.centerInGrid) {
			final num dx = 64 - this.width;
			final num dy = 64 - this.height;
			if (dx > 1) {
				this.x += (dx/2).floor();
			}
			if (dy > 1) {
				this.y += (dy/2).floor();
			}
		}
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
	}

	/**
	 * intersects
	 *
	 * determines if [this.rec] intersects with [e.rec]
	 * returns true if they intersect, false if not.
	 */
	bool intersects( Entity e ) {
		return ( this.rec.intersects(e.rec) );
	}

	/**
	 * getCenter
	 *
	 * Returns a [Point] respresenting the center-coordinates of this Entity
	 */
	Point getCenter() {
		return new Point(this.x + this.width ~/ 2, this.y + this.height ~/ 2);
	}

	void update(); // abstract
}