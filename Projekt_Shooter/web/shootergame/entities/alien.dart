part of gameentities;

/**
 * AlienCharacter
 *
 * Baseclass for all Aliens in the game
 */
abstract class AlienCharacter extends CharacterEntity {
	String color; // the color of the alien
	String type; // the type of the alien

	/**
	 * AlienCharacter Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [type] the type of the alien
	 * [color] the color of the alien
	 * [animated] is the entity animated or static?
	 */
	AlienCharacter (num x, num y, String this.type, String this.color, { bool animated : true }) : super (x, y, 48, 48, animated : animated) {
		// ...
	}

	/**
	 * AlienCharacter Constructor
	 *
	 * To be called with ArmedCharacter
	 */
	AlienCharacter.fromArmedChar (num x, num y, String type, String color, bool animated ) : this(x, y, type, color, animated : animated);

	/**
	 * canSee
	 *
	 * can this alien see [e]?
	 *
	 * returns true if the alien can see [e], false if not
	 */
	bool canSee( Entity e ) {
		final Point c = this.getCenter();
		final Point d = e.getCenter();
		return ( sqrt( pow( (c.x-d.x), 2 ) + pow( (c.y-d.y), 2 ) ) >= this.visRange );
	}

	void die(); // abstract

	void attack( Entity e );  // abstract

	void hit( num damage );  // abstract
}

