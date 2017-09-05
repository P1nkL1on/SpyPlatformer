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
}