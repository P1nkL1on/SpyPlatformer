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
		
		who.side = 0;
		who.walking_speed_max = 2; who.jumping_height = 3.7;
		who.view_x = who._x; who.view_y = who._y;
	}
	
	static function being_humanoid_mover (who:MovieClip) : Boolean{
			if (who.paus){ 
				who.want_go_left = false; who.want_go_right = false;
				who.want_jump = false; who.want_go_down = false;
				who.want_crounch = false; who.want_shot = false;
				return (human.is_alive (who));	
			}
			if (human.is_alive (who) && who.spirit){
					//who.model.gotoAndStop((who.sleep)? 4:1);
					//who.view_x = _root._xmouse; who.view_y = _root._ymouse;
					who.side = (-1 * (who.want_go_left) + 1 * (who.want_go_right)); // what side do you wish to go
					
					if (who.ground)
						who.sp_x = who.side * ( ( who.walking_speed_max * .3 ) * who.leg_health + who.walking_speed_max * .2 ) * (1 - .5 * who.want_crounch + .5 * who.want_run);
					else
						who.sp_x += who.side * .1 * ( Math.abs ( who.sp_x + who.sp_x0 + who.side * .2) < who.walking_speed_max ); 
					 
					if (who.want_jump && !who.want_crounch && who.can_jump_timer > 0)
						{who.can_jump_timer = 0; who.sp_y0 = - who.jumping_height * ( who.leg_health + 1)/3 ; who.ground = false; who.standing_on = null; who.wants_to_pass = null;}
					if (who.want_go_down && who.standing_on != null)
						 who.wants_to_pass = who.standing_on; 
					if (who.want_shot && who.current_weapon != null && who.alternate_weapon != null && who.current_weapon.total_ammo <= 0 && who.alternate_weapon.total_ammo > 0)
						weapon.swap_weapon ( who );
						 
					who.can_jump_timer--; if (who.ground)who.can_jump_timer = 10;	
					
				}else{
					who.sp_x = 0; who.sp_y = 0;
					if (who.current_weapon != null) weapon.drop_weapon ( who );
					//who.model.gotoAndStop ((who.alive)? 2 : 3);
				}
			return (human.is_alive (who));		
	}
	
}