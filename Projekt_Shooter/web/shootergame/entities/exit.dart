part of gameentities;


class Exit extends Entity {
	static final ImageElement exitimage = new ImageElement(src:"shootergame/images/exit.png");

	Exit(num x, num y) : super(x, y, img : exitimage) {

	}

	void update() {
		// empty
	}

}