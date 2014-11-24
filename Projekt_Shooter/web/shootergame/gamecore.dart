part of gameengine;

class GameCore {
	final CanvasRenderingContext2D stage;
	final PlayerChar player = new PlayerChar(512, 700);
	int width;
	int height;

	GameCore (CanvasRenderingContext2D this.stage, [int width = 1024, int height = 768]) {
		this.width = width;
		this.height = height;
		stage.fillStyle = "#000000";
		stage.fillRect(0, 0, this.width, this.height);
	}

	void update() {
		player.update();
	}

	void draw() {
		stage.fillStyle = "#000000";
		stage.fillRect(0, 0, this.width, this.height);
		drawBackground();
		stage.drawImage(player.img, player.x, player.y);
	}

	void pause() {

	}

	void drawBackground() {
		final ImageElement bgImg = new ImageElement(src:"shootergame/images/metal_floor.png");
		if ( (bgImg.width != 0) && (bgImg.height != 0) ) {
			final int maxX = (this.width / bgImg.width).ceil();
			final int maxY = (this.height / bgImg.height).ceil();
			for ( int m=0; m < maxX; m++ ) {
				for ( int n=0; n < maxY; n++ ) {
					stage.drawImage(bgImg, (m*bgImg.width), (n*bgImg.height));
				}
			}
		}
	}
}