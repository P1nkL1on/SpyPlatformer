class guard {
	static function become_guard (u:MovieClip){
		human.become_human ( u );
		movement.become_humanoid_mover ( u );
		
		u.has_shelm = (random(2) == 0);
		u.has_jacket = (random(2) == 0);
		u.attachMovie('guard_model', 'model', u.getNextHighestDepth()); u.model._height /= 1.3; u.model._y = -9; u.model.xs = -u.model._xscale;
		_root.attachMovie("enemy_target", "et" + u, _root.getNextHighestDepth()); u.tar = _root["et" + u];
		
		u._x = random(800); u._y = 0;  u.get_aim_timer = 0; u.aim_spd = 20;
		u.sp_x0 = (random(41) - 20) / 60;
		u.sleep = true;
		
		u.onEnterFrame = function (){
			human.be_human (this);
			physics.be_physic_object (this);
			
			for (var u = 0; u < _root.updates; u++){						
				// become target for player
				if (this.hitTest(_root._xmouse, _root._ymouse, true))
					{_root.doll.watch = this; _root.hero.marked_guard = this;}
				//if (this.want_shot) trace ('bau');
				if (!movement.being_humanoid_mover ( this )){
					this._rotation += (90 - this._rotation) / 20;
					this.tar.removeMovieClip(); this.tar = null;
				}
				if (!human.is_full_health(this)) this.sleep = false; if (this.sleep) {this.view_x = this._x; this.view_y = this._y; continue;}
				
				this.get_aim_timer = (Math.abs (this._x - _root.hero._x) < 200 && Math.abs (this._y - _root.hero._y) < 100) * (this.get_aim_timer + 1);
				if (this.get_aim_timer > 40 * this.shoot_skills){
					this.view_x += (_root.hero._x - (random(101) / 100 - .5) * _root.hero._width - this.view_x) / (this.aim_spd * (1 - this.shoot_skills) + 2); 
					this.view_y += (_root.hero._y - (random(100) / 100) * _root.hero._height - this.view_y) / (this.aim_spd * (1 - this.shoot_skills) + 2); 
				} else { this.view_x = this._x; this.view_y = this._y; }
				
				this.tar._alpha = ( this.get_aim_timer - 20 ) * 2.5;
				this.tar._y += (this.view_y - this.tar._y) / 3; this.tar._x += (this.view_x - this.tar._x) / 3;
				
				this.want_go_left = (random(30) == 0); 
				this.want_go_right = (random(30) == 0);
				this.want_go_down = (_root.hero._y > this._y - 10 && Math.abs (_root.hero._x - this._x) < 100);
				this.want_jump = (random(Math.max(Math.round(50 + this.get_aim_timer / 2), 10)) == 0 && _root.hero._y < this._y + 40);
				
				this.want_shot = (human.is_alive (this) && (random(Math.max(Math.round(100 - this.get_aim_timer / 10), 20)) == 0)
									&& ((this.get_aim_timer > 60 * (1 - this.stressfull)) || (Math.abs (this.view_x - _root.hero._x) + Math.abs(this.view_y - _root.hero._y) < 70)));
			}
			/*
			for (var u = 0; u < _root.updates; u++){
				if (human.is_alive (this)){
					if (random(90) == 0) this.sp_x = (random(2)*2-1) * (1+random(30)/10); else this.sp_x = 0;
					
					
					
					if (random(25) == 0 && this.shoot_timer > 60 && this.hand_health > 0){
						var want_shoot_x = this.shoot_x; var want_shoot_y = this.shoot_y - _root.hero._height  * (random(101) / 100);
						ballistic.shoot_bullet ("bullet_usuall", this._x + 15 * (-1 + 2 * ( want_shoot_x > this._x ) ), this._y - this._height / 2, 35, 
														Math.PI +  Math.atan2 ( this._y - this._height / 2 - want_shoot_y, this._x - want_shoot_x ));
					}
				}else{
					this._rotation += (90 - this._rotation) / 20;
					this.tar.removeMovieClip(); this.tar = null;
			}}*/
		}
	}
}