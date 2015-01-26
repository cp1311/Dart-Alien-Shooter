part of gameentities;

/**
 * AlienShooter
 *
 * An alien that shoots at the player as soon as it can see him
 */
class AlienShooter extends AlienCharacter with ArmedCharacter {
	bool shoot = false; // is the alien shooting at someone?
	Stopwatch shootTimer = new Stopwatch();
	num reloadTime = 1000;

	AlienShooter (num x, num y, { String color : "green", Point muzzleOffset }) : super.fromArmedChar(x, y, "shooter", color) {
		this.lives = 1;
		this.health = 50;
		this.char = this;
		this.points = 15;
		if (muzzleOffset == null) {
			this.muzzleOffset = new Point(-2, -16);
		} else {
			this.muzzleOffset = muzzleOffset;
		}
	}

	void update() {
		if (this.isAlive()) {
			this.move();
			if ( this.entitiesInSight.any( (e) => (e is PlayerCharacter) ) ) {
				Entity e = this.entitiesInSight.firstWhere( (e) => (e is PlayerCharacter) );
				num xdif = max(this.x, e.getCenter().x) - min(this.x, e.getCenter().x);
				num ydif = max(this.y, e.getCenter().y) - min(this.y, e.getCenter().y);
				if (xdif > ydif) {
					if (this.x < e.x) {
						this.heading = "right";
						this.shoot = (ydif < this.width);
					} else {
						this.heading = "left";
						this.shoot = (ydif < this.width);
					}
				} else {
					if (this.y < e.y) {
						this.heading = "down";
						this.shoot = (xdif < this.width);
					} else {
						this.heading = "up";
						this.shoot = (xdif < this.width);
					}
				}
			} else {
				this.shoot = false;
			}
			if (this.shoot) {
				//TODO: Shoot a new bullet at the player
				this.shootTimer.start();
    			if ( (!this.shooting) && (this.bullets > 0) && (this.shotsFired < this.maxShootsPerTime) ) {
    				this.shotsFired++;
    				//this.bullets--;  Unendliche Muniton!
    				this.shooting = true;
    				this.firingBullet = true;
    				this.shootTimer.reset();
    			} else {
					this.shooting = (this.shootTimer.elapsedMilliseconds < this.reloadTime);
    			}
    		} else {
    			this.shooting = true;
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