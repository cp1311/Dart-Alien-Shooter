part of gameentities;


class Exit extends Entity {
	static final ImageElement exitimage = new ImageElement(src:"shootergame/images/exit.png");

	Exit(num x, num y) : super(x, y, 48, 48, img : exitimage) {

	}

	void update() {
		// empty
	}

}