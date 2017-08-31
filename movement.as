class movement{
	
	static function become_humanoid_mover (who:MovieClip){
		// weapons
		who.want_shot = false;
		who.want_reload = false; who.want_drop_weapon = false; who.want_get_weapon = false;
		who.current_weapon = null; who.alternate_weapon = null;
		// movement
		who.want_go_left = false; who.want_go_right = false;
		who.want_jump = false; who.want_go_down = false;
		who.want_crounch = false; who.want_run = false;
		who.angle_add = 0;
		
		who.side = 0;
		who.walking_speed_max = 2; who.jumping_height = 3.7;
		who.view_x = who._x; who.view_y = who._y;
		who.roll_timer = 0; who.roll_cd = 0; who.roll_spd = 0;
	}
	
	static function being_humanoid_mover (who:MovieClip) : Boolean{
			if (who.paus){ 
				who.want_go_left = false; who.want_go_right = false;
				who.want_jump = false; who.want_go_down = false;
				who.want_crounch = false; who.want_shot = false;
				return (human.is_alive (who));	
			}
			if (human.is_alive (who) && who.spirit){
					if (who.roll_timer != 0 ){who.want_crounch = true; if (!who.ground){ who.roll_timer = who.roll_timer / Math.abs(who.roll_timer) * 30; }}
					//who.view_x = _root._xmouse; who.view_y = _root._ymouse;
					who.side = (-1 * (who.want_go_left) + 1 * (who.want_go_right)); // what side do you wish to go
					who.angle_add = ( Math.abs(who.sp_x + who.sp_x0) * 2 + 4 ) * (2 - (who.model.crounch_height_meter == undefined || who.model.crounch_height_meter == 0) * 1 ) 
									* ( 2 - 1 * ((who._x - who.view_x)*(who.model._xscale) < 0) );
					if (who.ground)
						who.sp_x = ((who.roll_timer != 0)? who.roll_timer / Math.abs(who.roll_timer) * who.roll_spd : who.side) 	// roll speed here!!!
							* ( ( who.walking_speed_max * .3 ) * who.leg_health + who.walking_speed_max * .2 ) * (1 - .5 * who.want_crounch + .5 * (who.want_run && who.leg_health > 1.5)) 
							* (1 - .5 *( who.standing_on.is_ladder == true && ((who.side < 0) != (who.standing_on.is_reversed==true))));
					else
						{ if (who.rolling_timer != 0 && Math.abs(who.sp_x) > who.walking_speed_max * 1.25) who.sp_x /= 1.1; 
						  who.sp_x += who.side * .1 * ( Math.abs ( who.sp_x + who.sp_x0 + who.side * .2) < who.walking_speed_max ); }
					 
					if (who.want_jump && !who.want_crounch && who.can_jump_timer > 0 && who.roll_cd <= 0)
						{who.can_jump_timer = 0; who.sp_y0 = - who.jumping_height * ( who.leg_health + 1)/3 ; who.ground = false; who.standing_on = null; who.wants_to_pass = null;}
					if (who.want_go_down && who.standing_on != null)
						 who.wants_to_pass = who.standing_on; 
					if (who.want_shot && who.current_weapon != null && who.alternate_weapon != null && who.current_weapon.total_ammo <= 0 && who.alternate_weapon.total_ammo > 0)
						weapon.swap_weapon ( who );
						 
					who.can_jump_timer--; if (who.ground)who.can_jump_timer = 10;	
					// roll mode
					if (who.want_crounch && who.want_jump && who.ground && who.roll_timer == 0 && who.roll_cd <= 0)
						{ who.roll_timer = ((who.view_x - who._x > 0)*2 - 1) * 35; who.roll_spd = 7.8; who.roll_cd = 40; who.model.crounch_height_meter = 0; }// если ты скакнул в прыжок не из присяда, то считается, что ты в него автоматом сел
					if (who.roll_timer != 0 && who.ground) who.roll_timer += ((who.roll_timer > 0)? -1 : 1);	// descrease timer
					if (who.roll_spd > 0) who.roll_spd -= .23 * (1 - .8 * !who.ground);
					who.roll_cd -= 1 * (who.ground && who.roll_cd > 0);
				}else{
					who.sp_x = 0; who.sp_y = 0;
					if (who.current_weapon != null) weapon.drop_weapon ( who );
					//who.model.gotoAndStop ((who.alive)? 2 : 3);
				}
			who.hit._height = who.model.gr._height / 1.4; who.hit._y = -who.model.gr._height / 2;
			who.hitbox._height = who.model.gr._height; who.hitbox._y = -who.hitbox._height / 2;
			
			return (human.is_alive (who));		
	}
	
}