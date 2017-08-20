class ballistic {
	static var bullets:Array = new Array();
	
	static function shoot_bullet (bullet_path:String, b_x:Number, b_y:Number, spd:Number, ang:Number){
		trace (bullet_path);
		_root.layer_bullets.attachMovie (bullet_path, "bl_" + bullets.length,
								   _root.layer_bullets.getNextHighestDepth());
		var bl:MovieClip = _root.layer_bullets["bl_" + bullets.length];
		//
		bl.sp_x = Math.cos ( ang ) * spd; bl.sp_y = Math.sin ( ang ) * spd;
		//bl.timer = 600;
		//
		bullets.push(bl);
	}
	
	static function being_bullet (bl:MovieClip){
		bl._x += bl.sp_x * _root.time_passed; bl._y += bl.sp_y * _root.time_passed;
		bl._rotation = Math.atan2(bl.sp_y, bl.sp_x) / Math.PI * 180;
		//bl.timer -= _root.updates; if (bl.timer <= 0) bl.removeMovieClip();
	}
}