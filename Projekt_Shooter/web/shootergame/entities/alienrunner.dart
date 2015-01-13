part of gameentities;

/**
 * AlienRunner
 *
 * An alien that runs towards the player and tries to hit and kill him once it sees him
 */
class AlienRunner extends AlienCharacter {
	bool isRunning = false; // is the Alien currently moving?
	bool hitEnemy = false; // is this Alien hitting someone?

	AlienRunner (num x, num y, {String color : "green"}) : super (x, y, "runner", color) {
		this.lives = 1;
		this.health = 50;
	}

	void update() {
		if (this.isAlive()) {
			this.move();
			if (this.hitEnemy) {
				//TODO: Hit the enemy target
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