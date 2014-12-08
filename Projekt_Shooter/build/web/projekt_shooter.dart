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
	canvas.onClick.listen( (Event e) {
		canvas.requestPointerLock();
	});
	final CanvasRenderingContext2D stage = canvas.getContext("2d");
	document.onPointerLockChange.listen(pointerLockChange);

	gCore = new GameCore(stage);
	final Timer clock = new Timer.periodic(new Duration(milliseconds:8), gameTick);
	window.animationFrame.then(drawFrame);

	window.onKeyUp.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.moveLeft = false;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.moveRight = false;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.moveUp = false;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.moveDown = false;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = false;
		}
	});

	window.onKeyDown.listen( (KeyboardEvent e) {
		if ((e.keyCode == 37) || (e.keyCode == 65)) {
			gCore.player.moveLeft = true;
		}
		if ((e.keyCode == 39) || (e.keyCode == 68)) {
			gCore.player.moveRight = true;
		}
		if ((e.keyCode == 38) || (e.keyCode == 87)) {
			gCore.player.moveUp = true;
		}
		if ((e.keyCode == 40) || (e.keyCode == 83)) {
			gCore.player.moveDown = true;
		}
		if (e.keyCode == 32) {
			gCore.player.shoot = true;
		}
	});

	document.onMouseMove.listen(mouseMove);
}


void mouseMove(MouseEvent event) {
	if (!mouselocked) {
		return;
	}
}

bool get pointerLocked => querySelector("#game") == document.pointerLockElement;

void pointerLockChange(Event e) {
	mouselocked = pointerLocked;
	if (!mouselocked) {
		gCore.pause();
	}
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