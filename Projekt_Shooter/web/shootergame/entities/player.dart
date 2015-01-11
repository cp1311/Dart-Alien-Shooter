part of gameentities;

/**
 * PlayerCharacter
 *
 * Represents the player in the game
 */
class PlayerCharacter extends CharacterEntity {
	num bullets = 3;
	num shotsFired = 0;
	num score = 0;
	bool shoot = false; // did the player fire?

	/**
	 * PlayerCharacter Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [animated] is the entity animated or static?
	 */
	PlayerCharacter (num x, num y, { bool animated : true }) : super (x, y, 48, 48, animated : animated) {
		this.lives = 3;
		this.health = 100;
	}

	/**
	 * update
	 *
	 * update the player
	 */
	void update() {
		super.update(); // check for movement and update the players position and heading
		if (this.shoot) {
			//TODO: Shoot a new bullet
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