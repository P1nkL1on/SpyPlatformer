class human {
	static function ttrace (who:MovieClip, messag:String){
		trace ("Injure: " + who._name+" " + messag +";");
	}
	
	static function become_human (who:MovieClip){
		who.is_human = true;
		
		who.pain_resist = .0 + random(11)/100;
		who.bleed_resist = random(11)/100;
		who.shoot_skills = .1 + random(51)/100;
		who.pain_threshold = 100;
		who.stress_threshold = 100;
		
		who.is_human = true;
		who.leg_health = 2;
		who.hand_health = 2;
		who.head_health = 1;
		who.torso_health = 3;
		who.has_shelm = false;
		who.has_jacket = false;
		
		who.blood_level = 7;
		who.blood_loss_speed = 0; who.blood_minimum = who.blood_level;
		who.jacket_hp = new Array(10, 10);	who.pain_percent = 0; who.stress_percent = 0;
		who.alive = true; who.spirit = true; who.refresh_timer = random(300)+30;	who.stunned_time = 0;
		who.paus = false;
	}
	
	static function be_human (who:MovieClip){
		if (!who.alive) return;
		for (var u = 0; u<_root.updates; u++){
				if (who.paus) continue;
			//who.blood_level -= who.blood_loss_speed;
				if (who.pain_percent > 20 && who.pain_percent < who.pain_threshold) who.pain_percent -= .04 * (Math.max(0, who.blood_minimum)) / 7; 
				who.blood_minimum = -3 + 9 * (who.head_health) * ( who.torso_health + 1) / 4 * (who.hand_health + 5) / 7 * (who.leg_health + 3) / 5;
				who.blood_level -= who.blood_loss_speed / (90 * (1 + 4 * (who.blood_level < who.blood_minimum))) * (1 - who.bleed_resist);
			// checking a spirit loosing conditions
				who.stunned_time = who.stunned_time - 1 * (who.stunned_time > 0);
					if (Math.round(who.stunned_time) == 1){ who.stunned_time = - 200; who.spirit = true; who.stress_percent = who.stress_threshold / 2; who.refresh_timer = 150; ttrace (who, " reseted his mind!");}
				who.refresh_timer = (who.refresh_timer + 1 ) %360;
				if ( who.spirit && who.refresh_timer == 0 &&  random(101)*(1 - who.blood_loss_speed) < Math.round(30 *Math.exp(who.stress_percent - who.stress_threshold)))
					{ who.spirit = false; who.stunned_time += 60 * 60 * 1; ttrace (who, "loose spirit for " + who.stunned_time / 60 +" sec");} 
			// checking death mate
				if (who.alive && (who.head_health <= 0 || who.torso_health <= 0 || who.blood_level <= 1 || who.pain_percent * (who.spirit) >= who.pain_threshold))
					{who.alive = false; who.spirit = false; who.stunned_time = -1; who.refresh_timer = -60; ttrace (who, "is killed");}		
		}
	}
	
	static function is_alive (who:MovieClip) : Boolean {
		return who.alive;
	}
	static function is_full_health (who:MovieClip) : Boolean {
		return (who.blood_level >= 7 && who.pain_percent == 0 && who.stress_percent == 0);
	}
	static function deal_damage (who:MovieClip, pain_add:Number, stress_add:Number, blood_loss_add:Number){
		who.pain_percent = (who.pain_percent + pain_add) * (2 - who.pain_resist) / 2;
		if (pain_add > 10 && random( 51 ) < pain_add - 10)
			{ weapon.drop_weapon ( who, 0 ); ttrace (who, "dropped weapon from sudden pain");}
		who.stress_percent += stress_add;
		who.blood_loss_speed += blood_loss_add;
	}
	static function injure (who:MovieClip, bullet:MovieClip){
		var bullet_mv:Number = bullet.bullet_spd / 30;
		bullet.damaged = true;
		var collision_place:Number = (who._y - bullet._y) / (who.hitbox._height * who._yscale / 100);
		var body_height:Number = (who.hitbox._height * who._yscale / 100);
		//collision_place = (collision_place - .2) * 1.35;
		ttrace (who, "was shoted by "+bullet.host._name);
		
		// top
		if (collision_place > .7){
			if (!who.has_shelm || bullet_mv > 2.5)
				{ who.head_health --; deal_damage( who, 80, 0, .4); who.blood_level --; sound_phys.sound ('head_shot', who, 0, - .8 * body_height); ttrace(who, "headshoted"); }
			else
				{
					var stun_chance:Number = 0;
					sound_phys.sound ('shelm_shot', who, 0, - .9 * body_height);
					if (bullet_mv >= 1.1)
						{ who.has_shelm = false; deal_damage (who, 1, 10, 0); stun_chance = 20; ttrace (who, "loose shelm");}
					else
						{ if (random(2)==0) who.has_shelm = false; deal_damage (who, 3, 1, .05 * (random(2) == 0)); stun_chance = 25; ttrace(who, "was shoted in a shelm");} 
					if (random(101) < stun_chance * 3) 
						{ballistic.reflect_bullet (bullet); ttrace(who,'>>>bullet reflected');}
					if (random(101) < stun_chance)
						{ who.spirit = false; who.stunned_time += 30 * bullet_mv; ttrace(who, "was stunned for "+who.stunned_time / 60 +" sec");}
				}
		}
		// middle
		if (collision_place <= .7 && collision_place > .33){
			if (who.hand_health > 0 && random(2)==0){
				deal_damage( who, 25, 30, .1 * bullet_mv);
				who.hand_health --;
				ttrace (who, "hand damaged");
				if (bullet_mv > 2 || random(2) == 0 || who.hand_health < .5)
					{weapon.drop_weapon (who, -2);  ttrace (who, "dropped a weapon"); sound_phys.sound ('body_shot', who, 0, - .6 * body_height);}
			}else{
				// detecting a side of shooting
				var detect_side:Number = (bullet._x < who._x) * 1;
				var jacket_lost:Number = 0; var health_lost:Number = 0;
					if (who.has_jacket && who.jacket_hp[detect_side] > 0){
						jacket_lost = bullet.bullet_spd / 10 * bullet_mv;				
						who.jacket_hp[detect_side] = Math.max (0, who.jacket_hp[detect_side] - jacket_lost); 
						
						health_lost = .5 * (1 - who.jacket_hp[detect_side] / 10 * bullet_mv);	
						who.torso_health -= health_lost;
						
						deal_damage ( who, 10, 5, (10 - who.jacket_hp[detect_side]) * .01 * bullet_mv);
						
						sound_phys.sound ('jacket_shot', who, 0, - .5 * body_height);
						ttrace (who, "damaged in a jacket. Recieve only " + Math.round(100 * health_lost) / 100);
						ttrace (who, "jacket side " + detect_side + " have " + Math.round(100 * who.jacket_hp[detect_side]) /100+"/10");
						
						if (who.jacket_hp[detect_side] == 0 && random(Math.round(Math.max(5 - bullet_mv, 1))) == 0)
							{ who.spirit = false; who.stunned_time += 60 * bullet_mv; ttrace (who, "was stunned for "+who.stunned_time / 60 +" sec");}
					} else {
						deal_damage ( who, 30 * bullet_mv, 20, .2 * bullet_mv );
						who.torso_health -= bullet_mv;
						sound_phys.sound ('body_shot', who, 0, - .5 * body_height);
						ttrace (who, "was bodyshoted");
					}
			}
		}
		// bottom
		if (collision_place <= .33){
			sound_phys.sound ('body_shot', who, 0, - .2 * body_height);
			if (who.leg_health > 0 && random(5) != 0)
				{ who.leg_health--; deal_damage (who, 30, 40, .15 * bullet_mv); ttrace (who, "shoted in leg");}
			else
				{ who.torso_health -= .4 * bullet_mv; deal_damage( who, 10, 30, .1); ttrace (who, "overshoted in leg"); }
		}
	}
}