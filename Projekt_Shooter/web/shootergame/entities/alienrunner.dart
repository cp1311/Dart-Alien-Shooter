part of gameentities;

/**
 * AlienRunner
 *
 * An alien that runs towards the player and tries to hit and kill him once it sees him
 */
class AlienRunner extends AlienCharacter {
	bool isBiting = false; // is the Alien currently biting the player?
	bool isChewing = false; // can the Alien bite again?
	bool bite = false; // is this Alien in Range to bite?
	Stopwatch biteTimer = new Stopwatch();
	num biteCooldown = 1500;

	AlienRunner (num x, num y, {String color : "green"}) : super (x, y, "runner", color) {
		this.lives = 1;
		this.health = 50;
	}

	void update() {
		if (this.isAlive()) {
			if (!this.isChewing) {
				this.move();
			}
			if ( this.entitiesInSight.any( (e) => (e is PlayerCharacter) ) ) {
				Entity e = this.entitiesInSight.firstWhere( (e) => (e is PlayerCharacter) );
				num xdif = max(this.getCenter().x, e.getCenter().x) - min(this.getCenter().x, e.getCenter().x);
				num ydif = max(this.getCenter().y, e.getCenter().y) - min(this.getCenter().y, e.getCenter().y);
				this.bite = (xdif + ydif) < (this.width ~/ 2);
				if ( !this.bite ) {
					if ( (xdif > ydif && !this.pathBlockedLeft && !this.pathBlockedRight) || this.pathBlockedDown || this.pathBlockedUp ) {
						if (this.getCenter().x < e.getCenter().x) {
							this.heading = "right";
							this.right = true;
							this.left = false;
							this.up = false;
							this.down = false;
						} else {
							this.heading = "left";
							this.left = true;
							this.right = false;
							this.up = false;
							this.down = false;
						}
					} else {
						if (this.getCenter().y < e.getCenter().y) {
							this.heading = "down";
							this.down = true;
							this.up = false;
							this.right = false;
							this.left = false;
						} else {
							this.heading = "up";
							this.up = true;
							this.left = false;
							this.right = false;
							this.down = false;
						}
					}
				} else {
					this.up = false;
    				this.right = false;
    				this.down = false;
    				this.left = false;
				}
			} else {
				if (this.pathBlockedDown && this.down) {
					this.down = false;
				}
				if (this.pathBlockedRight && this.right) {
					this.right = false;
				}
				if (this.pathBlockedLeft && this.left) {
					this.left = false;
				}
				if (this.pathBlockedUp && this.up) {
					this.up = false;
				}
			}
			if (this.bite) {
				this.biteTimer.start();
    			if (!this.isChewing) {
    				this.isBiting = true;
    				this.isChewing = true;
    				this.biteTimer.reset();
    			} else {
					this.isChewing = (this.biteTimer.elapsedMilliseconds < this.biteCooldown);
    			}
    		} else if (this.isChewing) {
    			this.isChewing = (this.biteTimer.elapsedMilliseconds < this.biteCooldown);
    		}
		}
	}

	void die() {
		this.action = "die";
	}

	void hit( num damage ) {
		super.hit(damage);
	}

}