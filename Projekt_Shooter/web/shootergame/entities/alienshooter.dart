part of gameentities;

/**
 * AlienShooter
 *
 * An alien that shoots at the player as soon as it can see him
 */
class AlienShooter extends AlienCharacter with ArmedCharacter {
	bool shoot = false; // is the alien shooting at someone?

	AlienShooter (num x, num y, { String color : "green", Point muzzleOffset }) : super.fromArmedChar(x, y, "shooter", color, true) {
		this.lives = 1;
		this.health = 50;
		this.char = this;
		if (muzzleOffset == null) {
			this.muzzleOffset = new Point(0, -16);
		} else {
			this.muzzleOffset = muzzleOffset;
		}
	}

	void update() {
		if (this.isAlive()) {
			this.move();
			if (this.shoot) {
				//TODO: Shoot a new bullet at the player
			}
		} else {
			//TODO: automate animationstep count detection
			if (this.animationStep < 3) {
    			if (this.animationTimer.elapsedMilliseconds >= this.animationInterval) {
        			this.animationStep++;
        			this.animationTimer.reset();
    			}
    		}
		}
	}

	void die() {
		//TODO: Animate death of this alien
		this.dieing = true;
		this.animationStep = 0;
		this.animationTimer.start();
	}

	void hit( num damage ) {
		super.hit(damage);
		//TODO: Alien specific hit processing
	}

	void attack( Entity e ) {
		//TODO: Alien specific attack routines
	}

}