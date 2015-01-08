part of gameentities;

/**
 * Bullet
 *
 * A bullet fired by a character
 */
class Bullet extends Entity {
	num heading = 0; // the heading of the bullet in degrees
	num velocity = 10; // the speed of the bullet
	Entity owner; // the entitiy that fired the bullet

	Bullet (num x, num y, Entity this.owner, { num this.velocity, bool animated : true }) : super (x, y, 8, 8, animated : animated) {
		// ...
	}

	void update() {
		//TODO: hit someone or something ...
		this.move();
	}

	void die() {
		//TODO: Animate death of this bullet
	}

	void move() {
		//TODO: Move the bullet along its path (heading) according its velocity
	}

}