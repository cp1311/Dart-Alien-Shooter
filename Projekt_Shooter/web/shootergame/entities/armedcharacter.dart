part of gameentities;

/**
 * ArmedCharacter
 *
 * A character bearing weapons (of mass destruction...)
 */
class ArmedCharacter {
	num bullets = 5; // max shots to have underway at any time
	num shotsFired = 0; // count of shots already underway
	bool shoot = false; // does the character want to fire?
	bool shooting = false; // is the still shooting or can he fire a new bullet?
	bool firingBullet = false; // is the gun firing?
	num maxShootsPerTime = 1; // max num of bullets this character can have flying at any time
	Point muzzleOffset;

	/**
	 * getMuzzleCoordinates
	 *
	 * Returns the coordinates for the muzzleflash and bullet to exit
	 */
	Point getMuzzleCoordinates() {
		Point muzzle;
		switch((this as CharacterEntity).heading) {
			case "up" : {
				muzzle = new Point( ((this as CharacterEntity).getCenter().x + this.muzzleOffset.x ), ((this as CharacterEntity).getCenter().y + this.muzzleOffset.y) );
			} break;
			case "right" : {
				muzzle = new Point( ((this as CharacterEntity).getCenter().x - this.muzzleOffset.y ), ((this as CharacterEntity).getCenter().y + this.muzzleOffset.x) );
			} break;
			case "down" : {
				muzzle = new Point( ((this as CharacterEntity).getCenter().x - this.muzzleOffset.x ), ((this as CharacterEntity).getCenter().y - this.muzzleOffset.y) );
			} break;
			case "left" : {
				muzzle = new Point( ((this as CharacterEntity).getCenter().x + this.muzzleOffset.y ), ((this as CharacterEntity).getCenter().y - this.muzzleOffset.x) );
			} break;
			default : {
				// ...
			}
		}
		return muzzle;
	}

	void addBullets( num bullets ) {
		this.bullets += bullets;
	}

	void addShotToFire() {
		this.shotsFired--;
	}

}