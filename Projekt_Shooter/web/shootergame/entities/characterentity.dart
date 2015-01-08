part of gameentities;

/**
 * CharacterEntity
 *
 * - extends [Entity]
 *
 * Baseclass for all characters in the game
 */
abstract class CharacterEntity extends Entity {
	double visRange; // the visible range for this character
	num lives; // how many times can this character die
	num health; // how many hitpoints are left
	bool up = false; // is the character moving up?
	bool down = false; // .. down?
	bool left = false; // .. left?
	bool right = false; // .. right?
	String heading = "up"; // which way is the character facing?

	/**
	 * CharacterEntity Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [width] entity-width
	 * [height] entity-height
	 * [animated] is the entity animated or static?
	 */
	CharacterEntity (num x, num y, num width, num height, { bool animated : true }) : super (x, y, width, height, animated : animated) {
		// ...
	}

	/**
	 * update
	 *
	 * update this character
	 */
	void update() {
		this.move(); // check for any movement and update the coordinates accordingly
	}

	/**
	 * move
	 *
	 * Determines if the character is moving and updates the coordinates and the heading accordingly
	 */
	void move() {
		num moveX = 0; // movement in x direction, initialy 0
    	num moveY = 0; // movement in y direction, initialy 0
    	String newHeading = this.heading;
    	final bool moving = this.right || this.left || this.up || this.down; // is the character moving at all?

    	if (moving) {
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
    	}

		// Select heading for current direction and step
		if (this.up && !this.down) {
			if (this.left && !this.right) {
				newHeading = "up_left"; // not implemented yet
			} else if (this.right && !this.left) {
				newHeading = "up_right"; // not implemented yet
			} else {
				newHeading = "up";
			}
		} else if (this.down && !this.up) {
			if (this.left && !this.right) {
				newHeading = "down_left"; // not implemented yet
			} else if (this.right && !this.left) {
				newHeading = "down_right"; // not implemented yet
			} else {
				newHeading = "down";
			}
		} else if (this.left && !this.right) {
			newHeading = "left";
		} else if (this.right && !this.left) {
			newHeading = "right";
		}

		// if heading did not change: set next step in animation
		if ( moving && (this.heading == newHeading) ) {
			this.animationStep = (this.animationStep == 1) ? 2 : 1;
		} else {
			this.heading = newHeading;
			this.animationStep = 0;
		}

		// Boundary-check
		if (this.x > (1023 - this.width)) {
			this.x = (1023 - this.width);
		}
		if (this.x < 1) {
			this.x = 1;
		}
		if (this.y > (767 - this.width)) {
			this.y = (767 - this.width);
		}
		if (this.y < 1) {
			this.y = 1;
		}
	}

	/**
	 * isAlive
	 *
	 * check if the character is still alive
	 *
	 * returns true if characters health is above 0, false if 0 or below
	 */
	bool isAlive() {
		return (this.health > 0);
	}

	/**
	 * hit
	 *
	 * distracts [damage] from characters health and calls die if character died
	 */
	void hit( num damage ) {
		this.health -= damage; // distract damage from health
		if (!this.isAlive()) { // if character died
			this.die(); // kill this character
		}
	}

	void die(); // abstract
}