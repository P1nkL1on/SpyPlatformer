class spy{
	static function become_spy ( u:MovieClip ){
		human.become_human ( u );
		movement.become_humanoid_mover ( u );
		
		_root.hero = u; u._x = 500; u._y = 300; //
		u.can_jump_timer = 0; u.trigger_hold = 0; u.drop_wanna = 0;
		u.marked_guard = null; u.to_run = 0; u.double_press_run = 0;
		u.attachMovie('spy_model', 'model', u.getNextHighestDepth()); u.model._height /= 1.3; u.model._y = -14; u.model.xs = u.model._xscale;
		
		_root.attachMovie("enemy_target", "hero_mark", _root.getNextHighestDepth()); u.marker = _root.hero_mark; u.marker.gotoAndStop(2);
		
		u.onEnterFrame = function (){
			if (Key.isDown (67)){
						_root.time_slow = 1;
						human.become_human ( this );
						_root.cam.clr.setTransform({rb: 0, gb: 0, bb: 0});
					}
			//human.be_human (this);
			human_animation.animate(this);
			physics.be_physic_object (this);
			human.be_human (this);
			
			for (var i = 0; i < _root.updates; i++){
				if (Math.abs ( this.marked_guard._x - this.view_x ) > 60 || Math.abs ( this.marked_guard._y - this.view_y ) > 60) this.marked_guard = null;
				if (this.marked_guard!=null){ this.marker._x += (this.marked_guard._x - this.marker._x)/ 3; this.marker._y += (this.marked_guard._y - this.marked_guard._height - this.marker._y )/3; }
				this.marker._visible = (this.marked_guard != null && human.is_alive (this.marked_guard)); if (!this.marker._visible){ this.marker._x = this.view_x; this.marker._y = this.view_y - 40; }
				
				this.view_x = _root._xmouse; this.view_y = _root._ymouse;
				
				if (Key.isDown(65)) this.to_run --; else this.to_run = Math.max(0, this.to_run);
				if (Key.isDown(68)) this.to_run ++; else this.to_run = Math.min(0, this.to_run);
				if (Math.abs (this.to_run) == 1){ if (this.double_press_run <= 0)this.double_press_run = 15; else this.want_run = true;}else this.double_press_run--;
				if (this.want_crounch || (this.want_run && this.to_run == 0)) this.want_run = false;
				
				this.want_go_left = (Key.isDown(65)); 
				this.want_go_right = (Key.isDown (68));
				this.want_go_down = (Key.isDown (83));
				this.want_jump = (Key.isDown(87));  
					this.trigger_hold = (Key.isDown(1))? this.trigger_hold + 1 : 0;
					this.want_shot = ((this.trigger_hold > 0 && this.trigger_hold < 10)); 
				this.want_crounch = (Key.isDown(Key.SHIFT));
				this.want_get_weapon = (Key.isDown(69));
					this.drop_wanna = (Key.isDown(71))? this.drop_wanna + 1 : 0;
					this.want_drop_weapon = ((this.drop_wanna > 0 && this.drop_wanna < 10));
				movement.being_humanoid_mover ( this );
			}
		}
	}
}