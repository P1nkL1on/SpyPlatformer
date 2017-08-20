class guard {
	static function become_guard (u:MovieClip){
		human.become_human ( u );
		
		u._x = random(800); u._y = 0; 
		u.sp_x0 = (random(41) - 20) / 60;
		// physics.set_ground (u, _root.grounds);
		
		u.onEnterFrame = function (){
			human.be_human (this);
			physics.be_physic_object (this);
			
			if (human.is_alive (this))
				if (random(90) == 0) this.sp_x = (random(2)*2-1) * (1+random(30)/10); else this.sp_x = 0;
		}
	}
}