class background{
	static function become_door (d:MovieClip){
		d.wid = d.p._width; d.xs = d.p._xscale; d.ds = d.d._xscale;
		d.angl = 0;
	}
	static function being_door (door:MovieClip){
		door.p._xscale = Math.cos(door.angl - Math.PI) * door.xs
		door.d._xscale = (Math.sin(door.angl + Math.PI)) * door.ds
		door.d._x = Math.cos(door.angl - Math.PI) * door.wid;
		if (door.angl > Math.PI) door.angl -= 2 *  Math.PI;
	}
	
	static function can_see (p1:MovieClip, p2:MovieClip) : Boolean{
		
		
		var res:Boolean = true;
		var x1:Number = p1._x; var x2:Number = p2._x; 
		var y1:Number = p1._y - p1.hitbox._height * .9; var y2:Number = p2._y - p2.hitbox._height * .9;
		
		for (var i = 0; i < _root.hitable.length; i++){
			if (!res) continue;
			var ht:MovieClip = _root.hitable[i].pater; //trace (ht._name + '/' + ht.is_ground + '/' + ht.is_wall);
			if (ht.is_ground && !ht.is_ladder && !block_vision_horiz( x1,x2,y1,y2,ht._y, ht._x - ht._width / 2, ht._x + ht._width / 2 ))
				res = false;
			if (ht.is_wall && !block_vision_vert( x1,x2,y1,y2,ht._x, ht._y - ht._height / 2, ht._y + ht._height / 2 ))
				res = false;
			if (ht.is_ladder && !getN4( x1,x2,y1,y2,ht._x - ht._width * .51, ht._x + ht._width * .51, 
									   				ht._y - ht._height * .39, ht._y + ht._height * .39 ))
				res = false;
		}
		
		_root.lineStyle(1,(res)? 0x00FF00 : 0xFF0000,100);
		_root.moveTo(x1, y1); 
		_root.lineTo(x2, y2);
		return res;
	}
	
	static function block_vision_vert (x1,x2,y1,y2,x3,y3min,y3max):Boolean{
		if ((x1 > x3 && x2 > x3) || (x1 < x3 && x2 < x3))
			return true;
		var res_y = getN3 (x1,x2,y1,y2,x3);
		return ( res_y > y3max || res_y < y3min);
	}
	static function block_vision_horiz (x1,x2,y1,y2,y3,x3min,x3max):Boolean{
		if ((y1 > y3 && y2 > y3) || (y1 < y3 && y2 < y3))
			return true;
		var res_x = getN3 (x1,x2,y1,y2,y3, true);
		return ( res_x > x3max || res_x < x3min);
	}
	// found vertical position between 2 points
	static function getN3 ( x1,x2, y1,y2, x3, tr ):Number {
		if (x2 < x1)
			{var t:Number = x1; x1 = x2; x2 = t; t = y1; y1 = y2; y2 = t;} // swap
		
		return (tr == undefined)? y1 + (y2 - y1) / (x2 - x1) * (x3 - x1) 
								: x1 + (x2 - x1) / (y2 - y1) * (x3 - y1);
	}
	// found vertical position between 2 points
	static function getN4 ( x1,x2, y1,y2, x3, x4, y3, y4 ):Boolean {
        return true;
	}
}