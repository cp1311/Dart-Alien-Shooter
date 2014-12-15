part of gameentities;

class Bullet extends Entity {

	static final bulletImage = new ImageElement(src:"shootergame/images/bullet.png");
	num heading = 1;
	num velocity = 10;
	Entity owner;

	Bullet (num x, num y, Entity this.owner, { num this.velocity }) : super (x, y, 8, 8, img : bulletImage) {

	}

	void update() {
		this.move();
	}

	void die() {
		//TODO: Animate death of this bullet
	}

	void move() {
		//TODO: Move the bullet along its path (heading) according its velocity
	}

}