part of gameentities;

class PlayerChar {
	ImageElement img;
	num x;
	num y;
	Rectangle rec;

	final ImageElement upImg = new ImageElement(src:"shootergame/images/player_up.png");
	final ImageElement upRightImg = new ImageElement(src:"shootergame/images/player_up_right.png");
	final ImageElement upLeftImg = new ImageElement(src:"shootergame/images/player_up_left.png");
	final ImageElement downImg = new ImageElement(src:"shootergame/images/player_down.png");
	final ImageElement downLeftImg = new ImageElement(src:"shootergame/images/player_down_left.png");
	final ImageElement downRightImg = new ImageElement(src:"shootergame/images/player_down_right.png");
	final ImageElement leftImg = new ImageElement(src:"shootergame/images/player_left.png");
	final ImageElement rightImg = new ImageElement(src:"shootergame/images/player_right.png");

	num moveX = 0;
	num moveY = 0;
	bool moveUp = false;
	bool moveDown = false;
	bool moveLeft = false;
	bool moveRight = false;
	bool shoot = false;

	num health = 100;
	num lives = 3;
	num score = 0;
	int mouseDelta = 0;

	PlayerChar (num this.x, num this.y) {
		this.img = this.upImg;
		rec = new Rectangle(this.x, this.y, this.img.width, this.img.height);
	}

	void update() {
		if (this.moveRight) {
			this.moveX += 1;
		}
		if (this.moveLeft) {
			this.moveX -= 1;
		}
		if (this.moveUp) {
			this.moveY -= 1;
		}
		if (this.moveDown) {
			this.moveY += 1;
		}
		if (this.moveX != 0) {
			this.x += this.moveX;
			this.moveX = 0;
		}
		if (this.moveY != 0) {
			this.y += this.moveY;
			this.moveY = 0;
		}

		if (this.moveUp && !this.moveDown) {
			if (this.moveLeft && !this.moveRight) {
				this.img = this.upLeftImg;
			} else if (this.moveRight && !this.moveLeft) {
				this.img = this.upRightImg;
			} else {
				this.img = this.upImg;
			}
		} else if (this.moveDown && !this.moveUp) {
			if (this.moveLeft && !this.moveRight) {
				this.img = this.downLeftImg;
			} else if (this.moveRight && !this.moveLeft) {
				this.img = this.downRightImg;
			} else {
				this.img = this.downImg;
			}
		} else if (this.moveLeft && !this.moveRight) {
			this.img = this.leftImg;
		} else if (this.moveRight && !this.moveLeft) {
			this.img = this.rightImg;
		}

		if (this.mouseDelta != 0) {
			// Look at MousePos
		}

		if (this.x > (994 - this.img.width)) {
			this.x = (994 - this.img.width);
		}
		if (this.x < 30) {
			this.x = 30;
		}

		if (this.y > (738 - this.img.width)) {
			this.y = (738 - this.img.width);
		}
		if (this.y < 30) {
			this.y = 30;
		}

		this.rec = new Rectangle(this.x, this.y, this.img.width, this.img.height);
	}
}