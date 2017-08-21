class human {
	static function become_human (who:MovieClip){
		who.is_human = true;
		who.leg_health = 2;
		who.hand_health = 2;
		who.head_health = 1;
		who.torso_health = 3;
		who.has_shelm = false;
		who.has_jacket = false;
		who.blood_level = 6 + random(100) / 100;	//  литрах
		who.blood_loss_speed = 0;	// litr v sekundu
		who.blood_minimum = who.blood_level;
		who.jacket_hp = new Array(10, 10);
	}
	
	static function be_human (who:MovieClip){
		for (var u = 0; u<_root.updates; u++){
			//who.blood_level -= who.blood_loss_speed;
			who.blood_minimum = 6 * (who.head_health) * ( who.torso_health + 1 ) / 4 * (who.hand_health + 5) / 7 * (who.leg_health + 1) / 3;
			who.blood_level = Math.max( who.blood_level - who.blood_loss_speed / 60,  who.blood_minimum); 
			if (who.hitTest(_root._xmouse, _root._ymouse, true))
				_root.doll.watch = who;
		}
	}
	
	static function is_alive (who:MovieClip) : Boolean {
		if (who.head_health <= 0 || who.torso_health <= 0 || who.blood_level < 0.5)
			{ who.model.gotoAndStop('dead'); return false;}
		return true;
	}
	
	static var iih = 0;	// injure_in_height
	static function injure (who:MovieClip, bullet:MovieClip){
		bullet.damaged = true;
		// checking collision
		iih = (who._y - bullet._y) / (who.hitbox._height * who._yscale / 100);
		iih = (iih - .2) * 1.5;
		
		if (iih > .8){	// head shot
			if (!who.has_shelm) who.head_health --;
						  else  {if (bullet.bullet_spd > 10)who.has_shelm = false; trace('shelm hit');}
			trace (who._name + " headshoted");
			return;
		}
		if (iih < .25){	// leg shoted
			if (who.leg_health > 1 || random(5) != 0)
				{ if (who.leg_health > 0)who.leg_health --; else who.torso_health--; who.blood_loss_speed += .1;}
			trace (who._name + " has " + who.leg_health + " leg healty");
			return;
		}
		var detect_side:Number = (bullet._x < who._x) * 1;
		if (who.has_jacket &&  who.jacket_hp[detect_side] >= 0){
			who.jacket_hp[detect_side] = Math.max (0, who.jacket_hp[detect_side] - bullet.bullet_spd / 10); 
			who.torso_health -= 1 - who.jacket_hp[detect_side] / 10;
			trace ("> Jacket " + detect_side + " dealed "+who.jacket_hp[detect_side]);
		} else {
			// has no jacket
			if (random(4) < 2 && who.hand_health > 0){	// руки не попали под выстрел
				trace (who._name + " torso shoted");
				who.torso_health --;
				who.blood_loss_speed += .15;
			} else {				// hand shoted
				who.hand_health --;
				who.blood_loss_speed += .1;	
				trace (who._name + " has " + who.hand_health + " hand healty");
			}
		}
		//
	}
}