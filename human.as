class human {
	static function become_human (who:MovieClip){
		who.leg_health = 2;
		who.hand_health = 2;
		who.head_health = 1;
		who.torso_health = 3;
		who.has_shelm = false;
		who.has_jacket = false;
		who.blood_level = 5 + random(100) / 100;	//  литрах
		who.blood_loss_speed = 0;
	}
	
	static function be_human (who:MovieClip){
		
	}
	
	static function is_alive (who:MovieClip) : Boolean {
		if (who.head_health <= 0 || who.torso_health <= 0) return false;
		if (who.blood_level < 1.5) return false;
		return true;
	}
	
	static var iih = 0;	// injure_in_height
	static function injure (who:MovieClip, bullet:MovieClip){
		// checking collision
		iih = (who._x - bullet._x) / who.hitbox._height;
		if (iih < 0 || iih > 1){ trace (who._name + " dodged a bullet"); return; }
		
		if (iih > .8){	// head shot
			if (!who.has_shelm) who.head_health --;
						  else  who.has_shelm = false;
			trace (who._name + " headshoted");
			return;
		}
		if (iih < .45){	// leg shoted
			if (who.leg_health > 1 || random(5) != 0)
				who.leg_health --;
			trace (who._name + " has " + who.leg_health + " leg healty");
			return;
		}
		if (random(4) < 2){	// torso shoted
			trace (who._name + " torso shoted");
			who.torso_health --;
		} else {				// hand shoted
			trace (who._name + " has " + who.leg_health + " hand healty");
			who.hand_health --;
		}
		//
	}
}