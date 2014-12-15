part of gameentities;

abstract class CharacterEntity extends Entity {
	double visRange;
	num lives;
	num health;
	Map<String, Map<num, ImageElement>> animations = new Map<String, Map<num, ImageElement>>();
	bool up = false;
	bool down = false;
	bool left = false;
	bool right = false;
	num step = 0;
	String heading = "up";

	CharacterEntity (num x, num y, num width, num height, { Map<String, Map<num, ImageElement>> this.animations }) : super (x, y, width, height) {
		if (this.animations != null) {
			this.setImage( this.animations["up"][1] );
		}
	}

	void update() {
		this.move();
	}

	void move() {
		num moveX = 0;
    	num moveY = 0;
    	String newHeading = this.heading;
    	final bool moving = this.right || this.left || this.up || this.down;

		// Position update
		if (this.right) {
			moveX += 1;
		}
		if (this.left) {
			moveX -= 1;
		}
		if (this.up) {
			moveY -= 1;
		}
		if (this.down) {
			moveY += 1;
		}
		if (moveX != 0) {
			this.x += moveX;
		}
		if (moveY != 0) {
			this.y += moveY;
		}

		// Select image for current direction and  step
		if (this.up && !this.down) {
			if (this.left && !this.right) {
				newHeading = "up_left";
			} else if (this.right && !this.left) {
				newHeading = "up_right";
			} else {
				newHeading = "up";
			}
		} else if (this.down && !this.up) {
			if (this.left && !this.right) {
				newHeading = "down_left";
			} else if (this.right && !this.left) {
				newHeading = "down_right";
			} else {
				newHeading = "down";
			}
		} else if (this.left && !this.right) {
			newHeading = "left";
		} else if (this.right && !this.left) {
			newHeading = "right";
		}

		if ( moving && (this.heading == newHeading) ) {
			this.step = (this.step == 1) ? 2 : 1;
		} else {
			this.heading = newHeading;
			this.step = 0;
		}
		this.setImage( animations[this.heading][this.step] );

		if (this.x > (1023 - this.img.width)) {
			this.x = (1023 - this.img.width);
		}
		if (this.x < 1) {
			this.x = 1;
		}
		if (this.y > (767 - this.img.width)) {
			this.y = (767 - this.img.width);
		}
		if (this.y < 1) {
			this.y = 1;
		}
	}

	bool isAlive() {
		return (this.health > 0);
	}

	void hit( num damage ) {
		this.health -= damage;
		if (!this.isAlive()) {
			this.die();
		}
	}

	void die();
}