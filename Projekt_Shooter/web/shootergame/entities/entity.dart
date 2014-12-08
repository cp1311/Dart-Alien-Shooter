part of gameentities;

abstract class Entity {
	ImageElement img = new ImageElement(src:"shootergame/images/empty.png");
	num x;
	num y;
	num width;
	num height;
	Rectangle rec = new Rectangle(0, 0, 0, 0);

	Entity (num this.x, num this.y, { ImageElement img }) {
		if (img != null) {
			this.setImage( img );
		}
	}

	void setImage( ImageElement image ) {
		if (image != null) {
			this.img = image;
			this.width = this.img.width;
			this.height = this.img.height;
			this.rec = new Rectangle(this.x, this.y, this.width, this.height);
		}
	}

	void draw( CanvasRenderingContext2D stage ) {
		stage.drawImage(this.img, this.x, this.y);
	}

	bool intersects( Entity e ) {
		//TODO: detect intersetcion
		return false;
	}

	void update();
}