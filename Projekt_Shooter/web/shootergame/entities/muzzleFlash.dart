part of gameentities;

/**
 * muzzleFlash
 *
 * Flash when a bullet is fired by a character
 */
class muzzleFlash extends Entity {
	CharacterEntity owner;
	String heading; // which way is the muzzleflash pointing?

	muzzleFlash (num x, num y, this.owner, { bool animated : true }) : super (x, y, 8, 8, animated : animated) {
		this.x = this.x - this.width ~/ 2;
		this.y = this.y - this.width ~/ 2;
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		this.heading = owner.heading;
		this.animationInterval = 50;
		this.animationTimer.start();
	}

	void update() {
		//TODO: automate animationstep count detection
		if (this.animationTimer.elapsedMilliseconds >= this.animationInterval) {
			if (this.animationStep < 4) {
    			this.animationStep++;
    			this.animationTimer.reset();
    		}
		}
	}

}