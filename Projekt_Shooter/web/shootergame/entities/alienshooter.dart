part of gameentities;

/**
 * AlienShooter
 *
 * An alien that shoots at the player as soon as it can see him
 */
class AlienShooter extends AlienCharacter {

	num bullets = 1;
	num shotsFired = 0;
	bool shoot = false; // is the alien shooting at someone?

	AlienShooter (num x, num y, {String color : "green"}) : super (x, y, "shooter", color) {
		this.lives = 1;
		this.health = 50;
	}

	void update() {
		this.move();
		if (this.shoot) {
			//TODO: Shoot a new bullet at the player
		}
	}

	void die() {
		//TODO: Animate death of this alien
	}

	void hit( num damage ) {
		super.hit(damage);
		//TODO: Alien specific hit processing
	}

	void attack( Entity e ) {
		//TODO: Alien specific attack routines
	}

}