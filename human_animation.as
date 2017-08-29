class human_animation {
	
	//animation.model_goto( who:MovieClip, stance:String, frames:String, speed:Number, border:Boolean, direct:Number ){
	
	
	static function animate (who:MovieClip){
		var md:MovieClip = who.model;
		var view_diff:Number = who.view_x - who._x;
		if (md.crounch_height_meter == undefined) md.crounch_height_meter = 1; if (md.stand_timer == undefined) md.stand_timer = 0; 
		
		for (var u = 0; u < _root.updates; u++){
			if (who.sp_x > 0) md._xscale = md.xs; if (who.sp_x < 0) md._xscale = -md.xs;
			
			if (who.ground){
				
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
							animation.model_goto ( md, 'stand', 'stand_idle', 6, false, 1);
				} else {
					//________________________crounch__________________
					if (who.want_crounch){
						if (view_diff < 0) md._xscale = - md.xs; if (view_diff > 0) md._xscale = md.xs;
						animation.model_goto ( md, 'walk', 'walk_crounch', 3, false, (md._xscale > 0 && who.sp_x > 0 || md._xscale < 0 && who.sp_x < 0)? 1 : -1 );
					}else{
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
				
			} else {
				//________________air_animation________________
				animation.model_goto ( md, 'stand', 'stand_idle', 1, false, 1);
			}
		}		
	}
}