class ballistic {
	static var bullets:Array = new Array();
	
	static function shoot_bullet (bullet_path:String, b_x:Number, b_y:Number, spd:Number, ang:Number){
		//trace (bullet_path);
		_root.layer_bullets.attachMovie (bullet_path, "bl_" + bullets.length,
								   _root.layer_bullets.getNextHighestDepth());
		var bl:MovieClip = _root.layer_bullets["bl_" + bullets.length];
		//
		bl._x = b_x; bl._y = b_y;
		bl.sp_x = Math.cos ( ang ) * spd; bl.sp_y = Math.sin ( ang ) * spd;
		bl.live_timer = 300; bl.dead = false; bl.get_to = null; bl.get_x_diff = 0; bl.get_y_diff = 0;
		//
		bullets.push(bl);
	}
	static var bx:Number = 0;	static var by:Number = 0; static var steps:Number = 0;
	static function being_bullet (bl:MovieClip){
		if (!bl.dead){
			for (var i = 0; i < _root.updates; i ++){
				bl.sp_x /= 1.01; bl.sp_y /= 1.01; bl.sp_y += _root.G / 60.0;
			}
			bl._rotation = Math.atan2(bl.sp_y, bl.sp_x) / Math.PI * 180;
			steps = Math.round ( _root.time_passed *  .5 * (Math.abs(bl.sp_x) + Math.abs(bl.sp_y) ));
			for (var  i = 0; i < steps; i++){
				bx = bl._x + bl.sp_x * _root.time_passed * i / steps; 
				by = bl._y + bl.sp_y * _root.time_passed * i / steps;
				for (var j = 0; j < _root.hitable.length; j++)
					if (_root.hitable[j].hitTest(bx, by, true))
					{ bl._x = bx; bl._y = by; bl.sp_x = 0; bl.sp_y = 0; bl.dead = true; 
					  bl.get_to = _root.hitable[j].pater; bl.get_x_diff = bl.get_to._x - bl._x; bl.get_y_diff = bl.get_to._y - bl._y;
					  break; }
				}
			bl._x += bl.sp_x * _root.time_passed; bl._y += bl.sp_y * _root.time_passed;
		}else{
			//trace (bl.get_to +'/' +bl.get_x_diff +'/' +bl.get_y_diff);
			if (bl.get_to  != null) { bl._x = bl.get_to._x - bl.get_x_diff; bl._y = bl.get_to._y - bl.get_y_diff; }
		}
			
			bl.live_timer -= _root.time_passed; if (bl.live_timer < 0) bl.removeMovieClip();
	}
	
	static function set_hitable (hitbox:MovieClip, hitbox_pater:MovieClip){
		_root.hitable.push (hitbox);
		hitbox.pater = hitbox_pater;
	}
}