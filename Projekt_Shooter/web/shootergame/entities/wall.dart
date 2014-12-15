part of gameentities;


class Wall extends Entity {
	static final Map<int, ImageElement> wallimages = {
		0 : new ImageElement(src:"shootergame/images/wall/defaultWall.png"),
	};

	num walltype;

	Wall(num x, num y, { num walltype : 0 }) : super(x, y, 64, 64, img : wallimages[walltype]) {
		this.walltype = walltype;
	}

	void update () {
		// empty
	}
}