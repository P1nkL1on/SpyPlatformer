class human {
	static function become_human (who:MovieClip){
		who.bleed_resist = random(11) / 100;	// 0 -> .5 -> 1    1 == вообще не теряет кровь, у нормальных людей 0 - .1 random
		who.pain_resist = (random(11) + 0) / 100; // 0 -> 1 чувствует ли боль
		who.stressfull = (10 + random(11)) / 100;	// 0 -> 1 уровень вспыльчивости и воздействия стресса
		who.shoot_skills = .1 + random(51)/100;	// 0 -> 1 от новичка в стрельбе до убер профессионала
		who.intellectual = (20 + random(11)) / 100; // 0 -> 1 от дурачка до мегомозга
		who.pain_threshold = 100;	// 100 -> infinity - процент боли, от которого можно умереть, от 75% болевого порога можно потерять сознание
		
		//___________
		
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
		who.pain_percent = 0;
		who.stress_percent = 0; who.spw = 0; who.spwt = 0;
		who.alive = true;
		who.spirit = true;
		who.spirit_timer = - random(360);
		who.stunned_time = 0;
	}
	
	static function be_human (who:MovieClip){
		if (!who.alive) return;
		for (var u = 0; u<_root.updates; u++){
			//who.blood_level -= who.blood_loss_speed;
			if (who.pain_percent > 20 && who.pain_percent < 100) who.pain_percent -= .02 * (1 + 1 * who.pain_resist); 
			who.blood_minimum = -3 + 9 * (who.head_health) * ( who.torso_health + 1) / 4 * (who.hand_health + 5) / 7 * (who.leg_health + 3) / 5;
			who.blood_level -= who.blood_loss_speed / (90 * (1 + 4 * (who.blood_level < who.blood_minimum))) * (1 - who.bleed_resist);
			
			if (who.hitTest(_root._xmouse, _root._ymouse, true))
				_root.doll.watch = who;
			
			// CHECK SPIRIT CONDITIONS
			if (who.alive){
				who.spw = who.stress_percent;
				who.stress_percent = (who.stress_percent +  who.pain_percent / 6000);
				if (who.stress_percent - who.spw <= .2) who.spwt++; else who.spwt = 0; if (who.spwt > 60 * 60 * (.5 + who.stressfull)) who.stress_percent *= .99;
				who.spirit_timer ++; 
				if (who.spirit_timer > 180){ who.spirit_timer = 0;} 
				who.stunned_time -= 1 * (who.stunned_time > 0); 
				if (who.stunned_time == 1) who.spirit = true;
			}
			
			if (who.alive && who.spirit && who.spirit_timer % 10 == 0 && (( who.blood_level < 6 && random( Math.round(Math.max(2, 5*who.blood_level) ) ) == 0)
				||( who.pain_percent >= who.pain_threshold * .25 && random(Math.round(40 * (1 - who.stressfull))) == 0 )))
				who.stress_percent += 4;
			if (who.spirit_timer == 0 && who.alive && who.spirit && (who.stress_percent > 100))
				{ who.spirit = false; who.stunned_time = 60 * 30 * (1 + .5 * Math.abs(.5 * who.blood_level)) * (1 + who.stressfull); trace (who._name + " loose a spirit for " + Math.round(100 * who.stunned_time/60/60) / 100 + "min"); }
			// CHECK LIVE CONDITIONS
			if (who.alive && (who.head_health <= 0 || who.torso_health <= 0 || who.blood_level <= 1 || who.pain_percent * (who.spirit) >= who.pain_threshold))
				{who.alive = false; who.spirit = false; who.stunned_time = -1; who.spirit_timer = -60; who.gotoAndStop('dead'); var dead:String = "@@@ " + who._name + " dead by "; 
				 if (who.head_health <= 0) dead += "HEADSHOT!"; if (who.torso_health <= 0) dead += "torso overshot"; if (who.blood_level <= 1) dead += "blood loss"; if (who.pain_percent >= 100) dead += "pain level";  trace (dead);}		
		}
	}
	
	static function is_alive (who:MovieClip) : Boolean {
		return who.alive;
	}
	static function make_pain (who, much){
		who.pain_percent = (who.pain_percent + much * (1 - who.pain_resist)) * (1.2);
		if (much > 20 && random(5) == 0)
			weapon.drop_weapon ( who, 0 );
		who.stress_percent += much * .2 * (1 + who.stressfull);
	}
	static var iih = 0;	// injure_in_height
	static var whoname = "";
	static var impulse = 1;
	static function injure (who:MovieClip, bullet:MovieClip){
		impulse = 1 * bullet.bullet_spd / 30; // trace ("? Bullet impulse " + Math.round ( impulse * 10)/ 10 );
		bullet.damaged = true; whoname = who._name; if (who == _root.hero) whoname = ">>>" + whoname;
		// checking collision
		iih = (who._y - bullet._y) / (who.hitbox._height * who._yscale / 100);
		iih = (iih - .2) * 1.5;
		
		if (iih > .8){	// head shot
			if (!who.has_shelm || impulse > 2.5){who.head_health --; make_pain (who, 80); trace (whoname + " - HEADSHOT");  }
						  else  {if (bullet.bullet_spd > 5) {who.has_shelm = false; make_pain (who, 3); trace(whoname + ' shelm  out'); if (bullet.bullet_spd > 10 && random(3) == 0){who.stunned_time = 60 * 2.5; who.spirit = false; trace(who._name + " was cantused!");}}}
			return;
		}
		if (iih < .25){	// leg shoted
			if (who.leg_health > 1 || random(5) != 0)
				{ if (who.leg_health > 0){who.leg_health --; make_pain (who, 30); trace (whoname + " - shoted in a leg");}
									else {who.torso_health-=.5 * impulse; make_pain (who, 18); trace (whoname + " - too much leg shot damages a body");} who.blood_loss_speed += .1;}
			return;
		}
		var detect_side:Number = (bullet._x < who._x) * 1;
		var jacket_lost:Number = 0; var health_lost:Number = 0;
			// has no jacket
		if (random(4) < 2 || who.hand_health <= 0){	// руки не попали под выстрел
			if (who.has_jacket &&  who.jacket_hp[detect_side] >= 0){
				jacket_lost = bullet.bullet_spd / 10 * impulse;				who.jacket_hp[detect_side] = Math.max (0, who.jacket_hp[detect_side] - jacket_lost); 
				health_lost = 1 - who.jacket_hp[detect_side] / 10 * impulse;	who.torso_health -= health_lost;
				who.blood_loss_speed += (10 - who.jacket_hp[detect_side]) * .01 * impulse;	
				make_pain (who, 10); 
				if (bullet.bullet_spd > 10 && random(5) == 0){who.stunned_time = 60 * .4 * (3 - .3 * who.jacket_hp[detect_side]); who.spirit = false;}
				trace (whoname + "'s jacket shoted from " + detect_side +" side\n\tBlocked: " + Math.round(jacket_lost * 10) / 10+" Damaged: " + Math.round(health_lost*10)/10);
			} else {
				make_pain (who, 30); 
				trace (whoname + " torso shoted");
				who.torso_health -= impulse;
				who.blood_loss_speed += .15 * impulse;
			}
		} else {				// hand shoted
			make_pain (who, 25); 
			who.hand_health --;
			who.blood_loss_speed += .1 * impulse;	
			trace (whoname + " hand shoted");
			if (impulse > 2 || random(3) == 0 || who.hand_heath < .5){
				trace (whoname + " dropped a weapon!"); weapon.drop_weapon ( who, -2 );
			}
		}
		
		
	}
}