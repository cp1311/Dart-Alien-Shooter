part of gameentities;

/**
 * AlienCharacter
 *
 * Baseclass for all Aliens in the game
 */
abstract class AlienCharacter extends CharacterEntity {
	String color; // the color of the alien
	String type; // the type of the alien
	num points = 10;
	bool canSeePlayer = false;

	/**
	 * AlienCharacter Constructor
	 *
	 * [x] x coordinate
	 * [y] y coordinate
	 * [type] the type of the alien
	 * [color] the color of the alien
	 * [animated] is the entity animated or static?
	 */
	AlienCharacter (num x, num y, String this.type, String this.color) : super (x, y, 48, 48) {
		// ...
	}

	/**
	 * AlienCharacter Constructor
	 *
	 * To be called with ArmedCharacter
	 */
	AlienCharacter.fromArmedChar (num x, num y, String type, String color ) : this(x, y, type, color);

	/**
	 * canSee
	 *
	 * can this alien see [e]?
	 *
	 * returns true if the alien can see [e], false if not
	 */
	bool canSee( Entity e ) {
		return this.entitiesInSight.contains(e);
	}

	void die(); // abstract

	void hit( num damage );  // abstract
}

