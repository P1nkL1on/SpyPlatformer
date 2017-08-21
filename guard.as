class guard {
	static function become_guard (u:MovieClip){
		human.become_human ( u );
		u.has_shelm = (random(2) == 0);
		u.has_jacket = (random(2) == 0);
		
		u._x = random(800); u._y = 0;  u.shoot_timer = 0; u.shoot_x = u._x; u.shoot_y = u._x; u.target_spd = 20;
		u.sp_x0 = (random(41) - 20) / 60;
		// physics.set_ground (u, _root.grounds);
		
		u.onEnterFrame = function (){
			human.be_human (this);
			physics.be_physic_object (this);
			
			for (var u = 0; u < _root.updates; u++){
				if (human.is_alive (this)){
					if (random(90) == 0) this.sp_x = (random(2)*2-1) * (1+random(30)/10); else this.sp_x = 0;
					
					this.shoot_timer = (Math.abs (this._x - _root.hero._x) < 200 && Math.abs (this._y - _root.hero._y) < 100) * (this.shoot_timer + 1);
					
					this.shoot_x += (_root.hero._x - this.shoot_x) / this.target_spd;
					this.shoot_y += (_root.hero._y - this.shoot_y) / this.target_spd;
					if (random(25) == 0 && this.shoot_timer > 60 && this.hand_health > 0){
						var want_shoot_x = this.shoot_x; var want_shoot_y = this.shoot_y - _root.hero._height  * (random(101) / 100);
						ballistic.shoot_bullet ("bullet_usuall", this._x + 15 * (-1 + 2 * ( want_shoot_x > this._x ) ), this._y - this._height / 2, 35, 
														Math.PI +  Math.atan2 ( this._y - this._height / 2 - want_shoot_y, this._x - want_shoot_x ));
					}
				}else{
					this._rotation += (90 - this._rotation) / 20;
			}}
		}
	}
}