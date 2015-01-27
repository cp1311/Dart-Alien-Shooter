part of gameentities;

/**
 * Blood
 *
 * a piece of wall in the game
 */
class Blood extends Entity {
	String bloodtype;
	CharacterEntity owner;

	Blood(num x, num y, CharacterEntity this.owner) : super(x, y, 50, 50, centerInGrid : true) {
		this.x = x + (owner.width - this.width);
		this.y = y + (owner.height - this.height);
		this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		this.heading = owner.heading;
		if (this.owner is PlayerCharacter) {
			this.bloodtype = "player";
		} else {
			this.bloodtype = "alien";
		}
	}

	void update () {
		// empty
	}
}