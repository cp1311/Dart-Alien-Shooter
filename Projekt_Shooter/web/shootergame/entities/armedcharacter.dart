part of gameentities;

/**
 * ArmedCharacter
 *
 * A character bearing weapons (of mass destruction...)
 */
class ArmedCharacter {
	num bullets = 1; // max shots to have underway at any time
	num shotsFired = 0; // count of shots already underway
	Point muzzleOffset;
	CharacterEntity char; // TODO: find a better way to reference this char

	/**
	 * getMuzzleCoordinates
	 *
	 * Returns the coordinates for the muzzleflash and bullet to exit
	 */
	Point getMuzzleCoordinates() {
		Point muzzle;
		switch(this.char.heading) {
			case "up" : {
				muzzle = new Point( (this.char.getCenter().x + this.muzzleOffset.x ), (this.char.getCenter().y + this.muzzleOffset.y) );
			} break;
			case "right" : {
				muzzle = new Point( (this.char.getCenter().x - this.muzzleOffset.y ), (this.char.getCenter().y + this.muzzleOffset.x) );
			} break;
			case "down" : {
				muzzle = new Point( (this.char.getCenter().x - this.muzzleOffset.x ), (this.char.getCenter().y - this.muzzleOffset.y) );
			} break;
			case "left" : {
				muzzle = new Point( (this.char.getCenter().x + this.muzzleOffset.y ), (this.char.getCenter().y - this.muzzleOffset.x) );
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