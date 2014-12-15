part of gameentities;

abstract class AlienCharacter extends CharacterEntity {

	String color;
	String type;

	AlienCharacter (num x, num y, String this.type, String this.color) : super (x, y, 48, 48) {
		Map<String, Map<num, ImageElement>> images = {
    		"up" : {},
    		"down" : {},
    		"left" : {},
    		"right" : {},
    		"die" : {}
    	};
		images.forEach((k,v) => initImageMap(k,v));
		this.animations = images;
		this.setImage(this.animations["up"][0]);
	}

	void canSee( Entity e ) {
		//TODO: Check if the alien can see the specified entity
	}

	Map<num, ImageElement> initImageMap(String key, Map<num, ImageElement> elem) {
		for (var i = 0; i <= 2; i++) {
			elem[i] = new ImageElement(src:"shootergame/images/alien/${this.type}/${this.color}/$key/$i.png");
		}
		return elem;
	}

	void die();

	void attack( Entity e );

	void hit( num damage );

}