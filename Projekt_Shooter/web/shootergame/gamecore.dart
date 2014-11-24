part of gameengine;

class GameCore {
	CanvasRenderingContext2D stage;
	PlayerChar player;

	GameCore (CanvasRenderingContext2D this.stage) {
		stage.fillStyle = "#000000";
		stage.fillRect(0,0, 1024, 768);
		player = new PlayerChar(512, 700);
	}

	void update() {
		player.update();
	}

	void draw() {
		stage.fillStyle = "#000000";
		stage.fillRect(0, 0, 1024, 768);
		stage.drawImage(player.img, player.x, player.y);
	}

	void pause() {

	}
}