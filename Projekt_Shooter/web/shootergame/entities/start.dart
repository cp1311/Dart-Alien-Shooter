part of gameentities;

/**
 * Start
 *
 * the starting field of the game
 */
class Start extends Entity {

	Start(num x, num y, { bool animated : true }) : super(x, y, 64, 64, animated : animated) {
		this.animationTimer.start();
	}

	void update() {
		if (this.animationTimer.elapsedMilliseconds >= 500) {
			if (this.animationStep < 2) {
				this.animationStep++;
				this.animationTimer.reset();
			} else {
				this.animationTimer..stop()..reset();
			}
		}
	}
}