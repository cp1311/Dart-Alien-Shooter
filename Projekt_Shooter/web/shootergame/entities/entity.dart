part of gameentities;

abstract class Entity {
	ImageElement img = new ImageElement(src:"shootergame/images/empty.png");
	num x;
	num y;
	num width;
	num height;
	Rectangle rec = new Rectangle(0, 0, 0, 0);

	Entity (num x, num y, num width, num height, { ImageElement img }) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		if (img != null) {
			this.setImage( img );
		}
		num dx = 64 - width;
		num dy = 64 - height;
		if (dx > 1) {
			this.x += (dx/2).floor();
		}
		if (dy > 1) {
			this.y += (dy/2).floor();
		}
	}

	void setImage( ImageElement image ) {
		if (image != null) {
			this.img = image;
			this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		}
	}

	bool intersects( Entity e ) {
		//TODO: detect intersetcion
		return false;
	}

	void update();
}