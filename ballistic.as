class ballistic {
	static var bullets:Array = new Array();
	
	static function shoot_bullet (bullet_path:String, b_x:Number, b_y:Number, spd:Number, ang:Number, host:MovieClip){
		//trace (bullet_path);
		_root.layer_bullets.attachMovie (bullet_path, "bl_" + bullets.length,
								   _root.layer_bullets.getNextHighestDepth());
		var bl:MovieClip = _root.layer_bullets["bl_" + bullets.length];
		//
		bl._x = b_x; bl._y = b_y; bl.host = host;
		bl.sp_x0 = Math.cos ( ang ) * spd; bl.sp_y0 = Math.sin ( ang ) * spd; bl.bullet_spd = 0; bl.bl_rot = 0; bl.damaged = false;
		bl.live_timer = 0; bl.dead = false; bl.get_to = null; bl.get_x_diff = 0; bl.get_y_diff = 0;
		bl._rotation = ang / Math.PI * 180;
		//
		bullets.push(bl);
	}
	static var bx:Number = 0;	static var by:Number = 0; static var steps:Number = 0;
	static function being_bullet (bl:MovieClip){
		if (!bl.dead){
			for (var i = 0; i < _root.updates; i ++){
				bl.sp_x0 /= 1.01; bl.sp_y0 /= 1.01; bl.sp_y0 += _root.G / 60.0;
			}
			bl._rotation = Math.atan2(bl.sp_y0, bl.sp_x0) / Math.PI * 180;
			bullet_move (bl);
		}else{
			if (bl.get_to  != null) { 
				bl._x = bl.get_to._x - bl.get_x_diff; bl._y = bl.get_to._y - bl.get_y_diff; 
				if (!bl.damaged && bl.get_to.is_human == true && bl.bullet_spd != 0)
					 human.injure ( bl.get_to, bl );
				if (!bl.damaged && bl.get_to.is_human != true && bl.bullet_spd > 0)
					{sound_phys.sound ('ground_shot', bl, 0, 0, bl.bullet_spd * 5); bl.damaged = true;}
			}
		}
			
		bl.live_timer += _root.time_passed; if (bl.live_timer > 300) bl.removeMovieClip();
	}
	static function bullet_move (bl:MovieClip){
		steps = Math.max(3, Math.round ( _root.time_passed *  .15 * (Math.abs(bl.sp_x0) + Math.abs(bl.sp_y0) )));
		for (var  i = 0; i < steps * (bl.hitTest(_root.layer_background)); i++){
			bx = bl._x + bl.sp_x0 * _root.time_passed * i / steps; 
			by = bl._y + bl.sp_y0 * _root.time_passed * i / steps;
				//trace (bl.host +'/'+ bl.live_timer);
			for (var j = 0; j < _root.hitable.length; j++)
				if (!(_root.hitable[j].pater == bl.host && bl.live_timer < 15) &&
					_root.hitable[j].hitTest(bx, by, true) && !(_root.hitable[j].pater.is_weapon && _root.hitable[j].pater.host != null))
				{ bl.get_to = _root.hitable[j].pater; 
				  bl.get_to.sp_x0 += (bl.sp_x0)/ bl.get_to.mass / 3.0; bl.get_to.sp_y0 += (bl.sp_y0) / bl.get_to.mass / 3.0;				
				  bl.dead = true; bl._x = bx; bl._y = by;if ( bl.bullet_spd == 0){ bl.bullet_spd = Math.sqrt( bl.sp_x0 * bl.sp_x0 + bl.sp_y0 * bl.sp_y0 ); bl.bl_rot = bl._rotation; }bl.sp_x0 = 0; bl.sp_y0 = 0; 
				  bl.get_x_diff = bl.get_to._x - bl._x; bl.get_y_diff = bl.get_to._y - bl._y;
				  if (bl.get_to.bullet_reflecting_chance != undefined && random(101) < bl.get_to.bullet_reflecting_chance)
					{reflect_bullet(bl);}
				  break; }
			}
		bl._x += bl.sp_x0 * _root.time_passed; bl._y += bl.sp_y0 * _root.time_passed;
	}
	
	static function set_hitable (hitbox:MovieClip, hitbox_pater:MovieClip){
		_root.hitable.push (hitbox);
		hitbox.pater = hitbox_pater;
	}
	
	static function reflect_bullet (bl:MovieClip){
		bl.bullet_spd /= 1.6; 
		if (bl.bullet_spd < 10){  return; }
		var ang:Number = (bl.bl_rot + (random(2)*2-1)*(100 - bl.bullet_spd) / 200 * random(360) + (random(3) == 0)*180) / 180 * Math.PI;	
		bl.sp_x0 = Math.cos( ang ) * bl.bullet_spd; bl.sp_y0 = Math.sin( ang ) * bl.bullet_spd;
		bl.bullet_spd = 0; bl.bl_rot = 0; bl.damaged = false; bl.live_timer = 0; bl.dead = false; bl.host = bl.get_to; // просто убер ход - типа не сможет снова зацепить того, от кого отпрыгнула
		bl.get_to = null;
	}
}