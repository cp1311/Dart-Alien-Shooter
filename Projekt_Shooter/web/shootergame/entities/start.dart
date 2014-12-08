part of gameentities;


class Start extends Entity {
	static final ImageElement startimage = new ImageElement(src:"shootergame/images/start.png");

	Start(num x, num y) : super(x, y, img : startimage) {

	}

	void update() {
		// empty
	}

}