part of gameentities;

/**
 * PlayerCharacter
 *
 * Represents the player in the game
 */
class PlayerCharacter extends CharacterEntity with ArmedCharacter {
	num score = 0;

	/**
	 * PlayerCharacter Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [animated] is the entity animated or static?
	 */
	PlayerCharacter (num x, num y, { Point muzzleOffset }) : super.fromArmedChar(x, y, 40, 40, true) {
		this.lives = 3;
		this.health = 100;
		this.bullets = 10;
		this.shotsFired = 0;
		this.maxShootsPerTime = 1;
		this.char = this;
		if (muzzleOffset == null) {
			this.muzzleOffset = new Point(8, -22);
		} else {
			this.muzzleOffset = muzzleOffset;
		}
		this.visRange = 400.0;
	}

	/**
	 * update
	 *
	 * update the player
	 */
	void update() {
		super.update(); // check for movement and update the players position and heading
		if (this.shoot) {
			if ( (!this.shooting) && (this.bullets > 0) && (this.shotsFired < this.maxShootsPerTime) ) {
				this.shotsFired++;
				//this.bullets--;  Unendliche Muniton!
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
		this.score += points;
	}

	/**
	 * die
	 *
	 * kill the player
	 */
	void die() {
		//TODO: Reset player to start or end game
		this.lives--;
		this.action = "die";
	}

	/**
	 * resetTo
	 *
	 * reset the player to the given location
	 */
	void resetTo(num x, num y) {
		this.x = x;
		this.y = y;
		if (this.centerInGrid) {
			final num dx = 64 - this.width;
			final num dy = 64 - this.height;
			if (dx > 1) {
				this.x += (dx/2).floor();
			}
			if (dy > 1) {
				this.y += (dy/2).floor();
			}
		}
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
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