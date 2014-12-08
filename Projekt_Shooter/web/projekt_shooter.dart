import 'dart:html';
import 'dart:async';
import 'shootergame/gameengine.dart';

bool gameRunning = false;
bool mouselocked = false;
int level = 1;
GameCore gCore;

void main() {
	querySelector("#startbutton").onMouseDown.listen(startGame);
}

void startGame(MouseEvent event) {
	final HtmlElement target = event.target;
	if (!gameRunning) {
		gameRunning = true;
		target.classes.add("disabled");
		initGame();
	}
}

void initGame() {
	final CanvasElement canvas = querySelector("#game");
	canvas.classes.remove("hidden");
	final CanvasRenderingContext2D stage = canvas.getContext("2d");

	gCore = new GameCore(stage);
	final Timer clock = new Timer.periodic(new Duration(milliseconds:8), gameTick);
	window.animationFrame.then(drawFrame);

	window.onKeyUp.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.left = false;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.right = false;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.up = false;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.down = false;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = false;
		}
	});

	window.onKeyDown.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.right = false;
			gCore.player.up = false;
			gCore.player.down = false;
			gCore.player.left = true;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.left = false;
			gCore.player.up = false;
			gCore.player.down = false;
			gCore.player.right = true;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.left = false;
			gCore.player.right = false;
			gCore.player.down = false;
			gCore.player.up = true;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.left = false;
			gCore.player.right = false;
			gCore.player.up = false;
			gCore.player.down = true;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = true;
		}
	});
}

void gameTick(Timer clock) {
	gCore.update();
}

void drawFrame(num d) {
	if (gCore != null) {
		gCore.draw();
	}
	window.animationFrame.then(drawFrame);
}