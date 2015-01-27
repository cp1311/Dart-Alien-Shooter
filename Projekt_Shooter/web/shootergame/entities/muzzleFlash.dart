part of gameentities;

/**
 * muzzleFlash
 *
 * Flash when a bullet is fired by a character
 */
class muzzleFlash extends Entity {
	CharacterEntity owner;
	String heading; // which way is the muzzleflash pointing?

	muzzleFlash (this.owner) : super (0, 0, 8, 8) {
		this.x = (this.owner as ArmedCharacter).getMuzzleCoordinates().x - this.width ~/ 2;
		this.y = (this.owner as ArmedCharacter).getMuzzleCoordinates().y - this.width ~/ 2;
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		this.heading = owner.heading;
		this.action = "fire";
	}

	void update() {
		this.x = (this.owner as ArmedCharacter).getMuzzleCoordinates().x - this.width ~/ 2;
		this.y = (this.owner as ArmedCharacter).getMuzzleCoordinates().y - this.width ~/ 2;
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		this.heading = owner.heading;
	}

}