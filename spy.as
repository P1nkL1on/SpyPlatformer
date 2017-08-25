class spy{
	static function become_spy ( u:MovieClip ){
		human.become_human ( u );
		movement.become_humanoid_mover ( u );
		
		_root.hero = u; u._height = 40; u._x = 200;
		u.can_jump_timer = 0; u.trigger_hold = 0;
		
		u.onEnterFrame = function (){
			if (Key.isDown (67)){
						_root.time_slow = 1;
						human.become_human ( this );
						_root.cam.clr.setTransform({rb: 0, gb: 0, bb: 0});
					}
			//human.be_human (this);
			physics.be_physic_object (this);
			human.be_human (this);
			
			for (var i = 0; i < _root.updates; i++){
				this.view_x = _root._xmouse; this.view_y = _root._ymouse;
				
				this.want_go_left = (Key.isDown(65)); 
				this.want_go_right = (Key.isDown (68));
				this.want_go_down = (Key.isDown (83));
				this.want_jump = (Key.isDown(87));  
					this.trigger_hold = (Key.isDown(1))? this.trigger_hold + 1 : 0;
					this.want_shot = ((this.trigger_hold > 0 && this.trigger_hold < 10)); 
				this.want_crounch = (Key.isDown(Key.SHIFT));
				movement.being_humanoid_mover ( this );
			}
				/*if (human.is_alive (this)){
					this.view_x = _root._xmouse; this.view_y = _root._ymouse;
					this.side = (1 * (Key.isDown (68)) - 1 * (Key.isDown(65))); // what side do you wish to go
					
					if (this.ground)
						this.sp_x = this.side * ( .7 * this.leg_health + .4 );
					else
						this.sp_x += this.side * .1 * ( Math.abs ( this.sp_x + this.sp_x0 + this.side * .2) < 2 ); 
						
					if (Key.isDown (87) && this.can_jump_timer > 0){this.can_jump_timer = 0; this.sp_y0 = - 3.5; this.ground = false; this.standing_on = null; this.wants_to_pass = null;}
					if (Key.isDown (83) && this.standing_on != null)
						 this.wants_to_pass = this.standing_on; 
						 
					this.can_jump_timer--; if (this.ground)this.can_jump_timer = 5;
					if (Key.isDown (1)) this.want_shoot ++; else this.want_shoot = 0;
					if (this.want_shoot == 1 && this.hand_health > 0)
						ballistic.shoot_bullet ("bullet_usuall", this._x + 15 * (-1 + 2 * ( _root._xmouse > this._x ) ), this._y - this._height / 2, 35, 
												Math.PI +  Math.atan2 ( this._y - this._height / 2 - _root._ymouse, this._x - _root._xmouse ));
				}else{
					this.sp_x = 0; this.sp_y = 0;
				}*/
		}
	}
}