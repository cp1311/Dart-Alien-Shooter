part of gameentities;

class PlayerCharacter extends CharacterEntity {
	static final Map<String, Map<num, ImageElement>> images = {
		"up" : {
			0 : new ImageElement(src:"shootergame/images/player/up/0.png"),
			1 : new ImageElement(src:"shootergame/images/player/up/1.png"),
			2 : new ImageElement(src:"shootergame/images/player/up/2.png"),
		},
		"down" : {
			0 : new ImageElement(src:"shootergame/images/player/down/0.png"),
			1 : new ImageElement(src:"shootergame/images/player/down/1.png"),
			2 : new ImageElement(src:"shootergame/images/player/down/2.png"),
		},
		"left" : {
			0 : new ImageElement(src:"shootergame/images/player/left/0.png"),
			1 : new ImageElement(src:"shootergame/images/player/left/1.png"),
			2 : new ImageElement(src:"shootergame/images/player/left/2.png"),
		},
		"right" : {
			0 : new ImageElement(src:"shootergame/images/player/right/0.png"),
			1 : new ImageElement(src:"shootergame/images/player/right/1.png"),
			2 : new ImageElement(src:"shootergame/images/player/right/2.png"),
		},
		"die" : {
			0 : new ImageElement(src:"shootergame/images/player/die/0.png"),
			1 : new ImageElement(src:"shootergame/images/player/die/1.png"),
			2 : new ImageElement(src:"shootergame/images/player/die/2.png"),
		}
	};

	num bullets = 3;
	num shotsFired = 0;
	num score = 0;
	bool shoot = false;

	PlayerCharacter (num x, num y) : super (x, y, 48, 48) {
		this.animations = images;
		this.lives = 3;
		this.health = 100;
	}

	void update() {
		this.move();
		if (this.shoot) {
			//TODO: Shoot a new bullet
		}
	}

	void addPoints( num points ) {
		//TODO: Add points to score
	}

	void die() {
		//TODO: Reset player to start or end game
	}

	void reset() {
		//TODO: Reset the player to the start location
	}

	void hit( num damage ) {
		super.hit(damage);
		//TODO: Player specific hit processing
	}

}