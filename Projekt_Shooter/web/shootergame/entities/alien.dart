part of gameentities;

abstract class AlienCharacter extends CharacterEntity {

	String color;
	String type;

	AlienCharacter (num x, num y, String this.type, String this.color) : super (x, y) {
		Map<String, Map<num, ImageElement>> images = {
    		"up" : {},
    		"down" : {},
    		"left" : {},
    		"right" : {},
    		"die" : {}
    	};
		images.forEach((k,v) => initImageMap(k,v));
		this.animations = images;
	}

	void canSee( Entity e ) {
		//TODO: Check if the alien can see the specified entity
	}

	void initImageMap(String key, Map<num, ImageElement> elem) {
		for (var i = 0; i <= 2; i++) {
			elem[i] = new ImageElement(src:"shootergame/images/alien/${this.type}/${this.color}/$key/$i.png");
		}
	}

	void die();

	void attack( Entity e );

	void hit( num damage );

}