class spy{
	static function become_spy ( u:MovieClip ){
		human.become_human ( u );
		
		_root.hero = u; u._height = 40;
		u.can_jump_timer = 0; u.side = 0; u._x = 200;
		u.onEnterFrame = function (){
			human.be_human (this);
			physics.be_physic_object (this);
			for (var i = 0; i < _root.updates; i++)
				if (human.is_alive (this)){
					this.view_x = _root._xmouse; this.view_y = _root._ymouse;
					this.side = (1 * (Key.isDown (68)) - 1 * (Key.isDown(65))); // what side do you wish to go
					
					if (this.ground)
						this.sp_x = this.side * 2;
					else
						this.sp_x += this.side * .1 * ( Math.abs ( this.sp_x + this.sp_x0 + this.side * .2) < 2 ); 
						
					if (Key.isDown (87) && this.can_jump_timer > 0){this.can_jump_timer = 0; this.sp_y0 = - 3.5; this.ground = false; this.standing_on = null; this.wants_to_pass = null;}
					if (Key.isDown (83) && this.standing_on != null)
						 this.wants_to_pass = this.standing_on; 
						 
					this.can_jump_timer--; if (this.ground)this.can_jump_timer = 5;
					if (Key.isDown (1))
						ballistic.shoot_bullet ("bullet_usuall", this._x + 10, this._y - this._height / 2, 5, Math.PI / 4)
				}
			
		}
	}
}