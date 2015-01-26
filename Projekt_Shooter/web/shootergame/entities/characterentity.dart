part of gameentities;

/**
 * CharacterEntity
 *
 * - extends [Entity]
 *
 * Baseclass for all characters in the game
 */
abstract class CharacterEntity extends Entity {
	double visRange = 200.0; // the visible range for this character
	num lives; // how many times can this character die
	num health; // how many hitpoints are left
	bool up = false; // is the character moving up?
	bool down = false; // .. down?
	bool left = false; // .. left?
	bool right = false; // .. right?
	bool pathBlockedUp = false; // is the character running into something solid?
	bool pathBlockedDown = false;
	bool pathBlockedLeft = false;
	bool pathBlockedRight = false;
	bool dieing = false;
	List<Entity> entitiesInSight = new List<Entity>();

	/**
	 * CharacterEntity Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [width] entity-width
	 * [height] entity-height
	 * [animated] is the entity animated or static?
	 */
	CharacterEntity (num x, num y, num width, num height, { bool centerInGrid : true }) : super (x, y, width, height, centerInGrid : centerInGrid) {
		this.heading = "up"; // which way is the character facing?
	}

	CharacterEntity.fromArmedChar (num x, num y, num width, num height, bool centerInGrid) : this(x, y, width, height, centerInGrid : centerInGrid);

	/**
	 * update
	 *
	 * update this character
	 */
	void update() {
		this.move(); // check for any movement and update the coordinates accordingly
		bool pathBlockedUp = false;
    	bool pathBlockedDown = false;
    	bool pathBlockedLeft = false;
    	bool pathBlockedRight = false;
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
    		this.action = "move";
			if (this.right && !this.pathBlockedRight) {
				moveX += 1;
			}
			if (this.left && !this.pathBlockedLeft) {
				moveX -= 1;
			}
			if (this.up && !this.pathBlockedUp) {
				moveY -= 1;
			}
			if (this.down && !this.pathBlockedDown) {
				moveY += 1;
			}
			this.x += moveX;
			this.y += moveY;
    	} else {
    		this.action = "";
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

		this.heading = newHeading;

		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
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