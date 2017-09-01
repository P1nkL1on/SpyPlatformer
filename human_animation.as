class human_animation {
	
	//animation.model_goto( who:MovieClip, stance:String, frames:String, speed:Number, border:Boolean, direct:Number ){
	
	static function aim_to (who:MovieClip){
		who._visible = (who._parent.gr.hand_handler != undefined);
		if (who._visible) { who._x = who._parent.gr.hand_handler._x; who._y = who._parent.gr.hand_handler._y + who._parent.gr._y - 2.5; }
		// case of not having gun
		if (who._parent._parent.current_weapon == null)
			{ for (var u = 0; u < _root.updates; u++){who.anim++; if (who._currentframe > 10 ) who.gotoAndStop(1);animation.animate(who, 1, 15, 6, 1, false);} return; }
		// case of having gun
		var need_angle:Number =		Math.atan2( who._parent._parent._y  - who._parent._height / 2- who._parent._parent.view_y,
								    who._parent._parent._x - who._parent._parent.view_x ) / Math.PI * 180;
		
		if (who._parent._xscale >= 0){
			if (Math.abs(who.aim_angle - need_angle) < 40)who.aim_angle += (need_angle - who.aim_angle) / 7; else who.aim_angle = need_angle;
		} else {
			who.aim_angle *= -1;
			if (Math.abs(who.aim_angle - need_angle) < 40)who.aim_angle += (need_angle - who.aim_angle) / 7; else who.aim_angle = need_angle;
			who.aim_angle *= -1;
		}
		who.gotoAndStop(20 + (10 * (who._parent._xscale < 0) + Math.round(10 - ((who.aim_angle) / 360 * 20))) % 20);
		return;
	}
	static function leg_injure (who:MovieClip):String{
		if (who.leg_health > 1.5) return "";
		if (who.leg_health > .5) return "_injure";
		return "_injure_much";
		
	}
	static function animate (who:MovieClip){
		var md:MovieClip = who.model;
		var view_diff:Number = who.view_x - who._x;
		if (md.crounch_height_meter == undefined) md.crounch_height_meter = 1; if (md.stand_timer == undefined) md.stand_timer = 0; 
		if (md.on_ground == undefined) md.on_ground = 0; 
		
		for (var u = 0; u < _root.updates; u++){
			if (who.ground) md.on_ground++; else md.on_ground = 0;
			if (who.sp_x > 0) md._xscale = md.xs; if (who.sp_x < 0) md._xscale = -md.xs;
			
			if (/*who.ground*/ md.on_ground > 3){
				//________________ground_animation________________
				if (Math.abs ( who.sp_x + who.sp_x0 ) < .05) md.stand_timer ++; else md.stand_timer = 0;
				if (md.stand_timer > 5 || (who.want_crounch == (md.crounch_height_meter == 1))){
					//________________crounch_problems____________
						if (who.want_crounch && md.crounch_height_meter == 1)
							{ animation.model_goto ( md, 'stand', 'seat', 6, true, 1); if (animation.is_ready (md.gr)) md.crounch_height_meter = 0; who.sp_x /= 2;}
						if (!who.want_crounch && md.crounch_height_meter == 0)
							{ animation.model_goto ( md, 'stand', 'seat_back', 6, true, 1); if (animation.is_ready (md.gr)) md.crounch_height_meter = 1; who.sp_x /= 2;}
						if (who.want_crounch && md.crounch_height_meter == 0)
							animation.model_goto ( md, 'stand', 'seat_idle', 6, false, 1);
					// ___________stand_animation_________________
						if (!who.want_crounch && md.crounch_height_meter == 1)
							animation.model_goto ( md, 'stand', 'stand_idle' + leg_injure(who), 6, false, 1);
				} else {
					//________________________crounch__________________
					if (who.want_crounch){
						if (who.roll_timer == 0){
							if (view_diff < 0) md._xscale = - md.xs; if (view_diff > 0) md._xscale = md.xs;
								if ((md._xscale > 0 && who.sp_x > 0 || md._xscale < 0 && who.sp_x < 0)) md.crounch_type = "";
								if ((md._xscale > 0 && who.sp_x < 0 || md._xscale < 0 && who.sp_x > 0)) md.crounch_type = "_back";
							animation.model_goto ( md, 'walk', 'walk_crounch' + md.crounch_type, 3, false, 1 );
						}else{
							//_____________roll_______________					
							animation.model_goto ( md, 'walk', 'roll', 4, true, 1 );							
							if (md.on_ground == 4)// tолько приземлился на землю после пыжка в ролле
								md.gr.gotoAndStop('roll_middle');
						}
					}else{
						if (who.leg_health <= 1.5)
							{
								//______________leg_broken_walk_____________
								animation.model_goto ( md, 'walk', 'run' + leg_injure(who), Math.round(Math.max ( 3, 6 - 5 * (Math.abs ( who.sp_x + who.sp_x0 ) - .2))), false, 1);
							}
						else
							{
							//__________________acselerate_n_run_______________
							if (Math.abs (who.sp_x) > 0 || (Math.abs (who.sp_x0) <  who.walking_speed_max && md.btrz == false)){
								md.btrz = false;
								if (Math.abs ( who.sp_x + who.sp_x0 ) < who.walking_speed_max || (!animation.is_ready_both (md.gr) && md.stat == 'walk/walk_forward' ))	// slow run
									{ 
										if (md.move_side_str == undefined) md.move_side_str = 'for';
										if (view_diff * md._xscale < 0){ md._xscale *= -1; md.move_side_str = 'back'; }else{ if (who.sp_x != 0)md.move_side_str = 'for'; }
										animation.model_goto ( md, 'walk', 'walk_'+md.move_side_str +'ward', Math.round(Math.max ( 2, 6 - 5 * (Math.abs ( who.sp_x + who.sp_x0 ) - .2))), false, 1); 
										md.slow = true;
									}
								else{
									if (md.slow)
										{animation.model_goto ( md, 'walk', 'run_start', 5, false, 1); md.slow = !animation.is_ready (md.gr);}
									else
										animation.model_goto ( md, 'walk', 'run', 3, false, 1);
								}
							}else{
							//_____________________tormoz_____________________
								if (Math.abs (who.sp_x0) > 0)
									{animation.model_goto ( md, 'walk', 'tormoz', 5, true, 1); md.btrz = true;}
							}
						}
					}
				}
				
			} else {
				//________________air_animation________________
				if (who.roll_timer == 0)
					animation.model_goto ( md, 'jump', 'jump', Math.round(Math.max(3, 6 - Math.abs(who.sp_y + who.sp_y0))), false, 1);
				else
					animation.model_goto ( md, 'jump', 'jump_forward', 5, false, 1);
			}
		}		
	}
}