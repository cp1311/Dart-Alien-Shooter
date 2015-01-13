part of gameentities;

/**
 * PlayerCharacter
 *
 * Represents the player in the game
 */
class PlayerCharacter extends CharacterEntity with ArmedCharacter {
	num score = 0;
	bool shoot = false; // did the player fire?
	bool shooting = false; // is the player still shooting or can he fire a new bullet?
	bool firingBullet = false; // is the gun firing?

	/**
	 * PlayerCharacter Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [animated] is the entity animated or static?
	 */
	PlayerCharacter (num x, num y, { bool animated : true, Point muzzleOffset }) : super.fromArmedChar(x, y, 40, 40, animated, true) {
		this.lives = 3;
		this.health = 100;
		this.bullets = 3;
		this.shotsFired = 0;
		this.char = this;
		this.animationInterval = 150;
		if (muzzleOffset == null) {
			this.muzzleOffset = new Point(15, -20);
		} else {
			this.muzzleOffset = muzzleOffset;
		}
		this.visRange = 280.0;
	}

	/**
	 * update
	 *
	 * update the player
	 */
	void update() {
		super.update(); // check for movement and update the players position and heading
		if (this.shoot) {
			if ( (!this.shooting) && (this.bullets > 0) && (this.shotsFired < 5) ) {
				this.shotsFired++;
				this.shooting = true;
				this.firingBullet = true;
			}
		} else {
			this.shooting = false;
		}
	}

	/**
	 * addPoints
	 *
	 * add points to the players score
	 */
	void addPoints( num points ) {
		//TODO: Add points to score
	}

	/**
	 * die
	 *
	 * kill the player
	 */
	void die() {
		//TODO: Reset player to start or end game
	}

	/**
	 * reset
	 *
	 * reset the player to the start location
	 */
	void reset() {
		//TODO: Reset the player to the start location
	}

	/**
	 * hit
	 *
	 * hit this player with [damage] hitpoints
	 */
	void hit( num damage ) {
		super.hit(damage);
		//TODO: Player specific hit processing
	}

}