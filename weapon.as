class weapon{
	static var num:Number = 0;
	static function spawn_gun_inner ( path:String, Host:MovieClip, X, Y ){
		_root.layer_physics.attachMovie("weapon_" + path, path + "_" + num, _root.layer_physics.getNextHighestDepth());
		var wp:MovieClip = _root.layer_physics[path + "_" + num]; num++;
		wp._x = X; wp._y = Y;
		
		become_weapon (wp);
		set_weapon_host (wp, Host);
		
		if ( path == "gun" ){
			wp.magaz_ammo = 7;
			wp.part_reload = 5;
			wp.full_reload = 60;
			wp.bullet_speed = 350;
		}
		
		wp.total_ammo = 5 * wp.magaz_ammo;
		wp.current_ammo = wp.magaz_ammo;
		
		wp.onEnterFrame = function () {
			//_root.wpwp.text = this.current_reload + "// " + this.current_ammo + "/" + this.magaz_ammo + ' / ' + this.total_ammo;
			if (this.host == null){
				physics.be_physic_object (this);
			} else {
				for (var u = 0; u < _root.updates; u++){
					this.model.gotoAndStop ((this.total_ammo > 0)? ((this.current_reload > 0)? 2 : 1) : 3 );
					 
					if (this.host.current_weapon == this && this.current_reload > 0){
						this.current_reload --;
						if (this.current_reload == 1 && this.current_ammo == 0)
							this.current_ammo = Math.min ( this.magaz_ammo, this.total_ammo );
					}
					
					this._x = this.host._x + 10 * ( (this.host.view_x > this.host._x) * 2 - 1 ); 
					this._y = this.host._y + 10 * (this == this.host.alternate_weapon) - this.host._height / 2;
					
					if (this == this.host.current_weapon && this.host.hand_health > 0){	
						if (this.host.want_shot && this.current_reload <= 0 && this.current_ammo > 0 && this.total_ammo > 0){
							shoot_from_weapon (this.host, this); this.current_ammo --; this.total_ammo --;
							this.current_reload =(this.current_ammo > 0)? this.part_reload : this.full_reload;
						}
						if (this.host.want_drop_weapon)
							drop_weapon (this.host);
					}
				}
			}
		}
	}
	
	static function set_weapon_host (ww, hh):Boolean{
		if (hh.current_weapon == null){
			ww.host = hh; hh.current_weapon = ww;
			return true;
		}else{
			if (hh.alternate_weapon == null){
				ww.host = hh; hh.alternate_weapon = ww;
				return true;
			}
		}
		return false;
	}
	static function drop_weapon (hh){
		hh.current_weapon.host = null; hh.current_weapon.sp_x = 0; hh.current_weapon.sp_y = -5;
		hh.current_weapon = hh.alternate_weapon; hh.alternate_weapon = null;
	}
	
	static function shoot_from_weapon (who:MovieClip, weapon:MovieClip){
		who.trigger_hold = 60;
		ballistic.shoot_bullet (weapon.bullet_type+"", who._x + 15 * (-1 + 2 * ( who.view_x > who._x ) ), who._y - who._height / 2, weapon.bullet_speed / 10, 
								Math.PI +  Math.atan2 ( who._y - who._height / 2 - who.view_y, who._x - who.view_x ));
	}
	
	static function become_weapon (who:MovieClip){
		who.is_weapon = true;
		who.total_ammo = 20;
		who.magaz_ammo = 5;
		who.current_ammo = 0;
		who.part_reload = 10;
		who.full_reload = 90;
		who.current_reload = 0;
		who.bullet_type = "bullet_usuall";
		who.bullet_speed = 500;
		who.host = null;
		physics.set_physic_object (who, 1, .1, .1, .1);
	}
}