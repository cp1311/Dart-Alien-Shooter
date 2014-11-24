part of gameentities;


class Block {
	ImageElement img;
	num x;
	num y;
	Rectangle rec;

	int score;
	int health;
	int hits = 0;
	Map<int,String> colors;

	Block(num this.x, num this.y, ImageElement this.img, Map <int,String> this.colors, int this.health, int this.score) {

	}

	void hit () {
		this.hits++;
		this.health--;
	}

	void update () {

	}
}