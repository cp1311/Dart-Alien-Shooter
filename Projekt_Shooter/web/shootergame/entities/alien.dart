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
	 * canSee
	 *
	 * can this alien see [e]?
	 *
	 * returns true if the alien can see [e], false if not
	 */
	bool canSee( Entity e ) {
		//TODO: Check if the alien can see the specified entity
		return false;
	}

	void die(); // abstract

	void attack( Entity e );  // abstract

	void hit( num damage );  // abstract
}