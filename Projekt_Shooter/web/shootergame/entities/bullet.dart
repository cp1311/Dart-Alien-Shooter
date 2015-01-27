part of gameentities;

/**
 * Bullet
 *
 * A bullet fired by a character
 */
class Bullet extends Entity {
	num direction; // the direction of the bullet in degrees
	num velocity; // the speed of the bullet
	CharacterEntity owner; // the entitiy that fired the bullet
	String heading; // which way is the character facing?
	num hitpoints;

	Bullet (num x, num y, CharacterEntity this.owner, { num this.direction, num this.hitpoints : 25, num this.velocity : 4 }) : super (x, y, 4, 4) {
		this.x = this.x - this.width ~/ 2;
		this.y = this.y - this.width ~/ 2;
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		if (this.direction == null) {
			this.heading = owner.heading;
			switch (this.heading) {
				case "up" : {
					this.direction = 0;
				} break;
				case "right" : {
					this.direction = 90;
				} break;
				case "down" : {
					this.direction = 180;
				} break;
				case "left" : {
					this.direction = 270;
				} break;
				default: {
					// ...
				}
			}
		} else {
			if ( (this.direction > 45) && (this.direction <= 135) ) {
	        	this.heading = "right";
			} else if ( (this.direction > 135) && (this.direction <= 225) ) {
	        	this.heading = "down";
			} else if ( (this.direction > 225) && (this.direction <= 315) ) {
	        	this.heading = "left";
			} else {
	        	this.heading = "up";
			}
		}
	}

	void update() {
		this.move();
	}

	void die() {
		ArmedCharacter a = this.owner as ArmedCharacter;
		a.addShotToFire();
		this.alive = false;
	}

	void move() {
		switch (this.heading) {
			case "up" : {
				this.y -= this.velocity;
			} break;
			case "right" : {
				this.x += this.velocity;
			} break;
			case "down" : {
				this.y += this.velocity;
			} break;
			case "left" : {
				this.x -= this.velocity;
			} break;
			default : {
				 //...
			}
		}
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
	}

}