class weapon{
	static var num:Number = 0;
	static function spawn_gun_inner ( path:String, Host:MovieClip, X, Y ){
		var weaponclass:String = "";
		if (path.indexOf("gun") >= 0) weaponclass = "gun";
		
		_root.layer_physics.attachMovie("weapon_" + weaponclass, path + "_" + num, _root.layer_physics.getNextHighestDepth());
		var wp:MovieClip = _root.layer_physics[path + "_" + num]; num++;
		wp._x = X; wp._y = Y; wp._alpha = 10; wp.weapon_name = path; wp.weapon_class = weaponclass;
		
		become_weapon (wp);
		set_weapon_host (wp, Host);
		
		if ( path == "gun" )
			{ wp.mass = 2; wp.magaz_ammo = 7;	wp.part_reload = 5;	wp.full_reload = 60; wp.bullet_speed = 350;	wp.long = 10; }
		if ( path == "ttgun" )
			{ wp.mass = 3.2; wp.magaz_ammo = 6;	wp.part_reload = 11;	wp.full_reload = 70; wp.bullet_speed = 480;	wp.long = 8; wp.shot_back = 33; wp.no_ammo_back = 12;}
		
		wp.total_ammo = 5 * wp.magaz_ammo;
		wp.current_ammo = wp.magaz_ammo;
		wp.angle = 0; wp.ys = wp._yscale;
		
		wp.onEnterFrame = function () {
			//_root.wpwp.text = this.current_reload + "// " + this.current_ammo + "/" + this.magaz_ammo + ' / ' + this.total_ammo;
			if (this.host == null){
				physics.be_physic_object (this); 
				for (var j = 0; j < _root.hitable.length; j++)
					if (_root.hitable[j].pater.is_human && _root.hitable[j].pater.want_get_weapon && _root.hitable[j].hitTest(this._x, this._y - 6, true))
						{ if (set_weapon_host ( this, _root.hitable[j].pater )){ this.sp_x = 0; this.sp_x0 = 0; this.sp_y = 0; this.sp_y0 = 0; } 
						  trace (_root.hitable[j].pater._name + " get a "+this._name );}
			} else {
				if (this == this.host.current_weapon){
					this.angle = Math.atan2 ( this.host.view_y - this.host._y + this.host._xscale / 2.5 / 2, this.host.view_x - this.host._x ); 
					this._x = this.host._x  + 10 * Math.cos (this.angle); 
					this._y = this.host._y - this.host.model.gr._height / 2 - 12+ 10 * Math.sin (this.angle);
					this._rotation = this.angle / Math.PI * 180; this._yscale = (( this.host.view_x > this.host._x ) * 2 - 1 ) * this.ys;
				} else {this._x = this.host._x; this._y = this.host._y - this.host._xscale / 2.5 * .25; this._rotation = 0;}
				
				for (var u = 0; u < _root.updates; u++){
					this.model.gotoAndStop ((this.total_ammo > 0)? ((this.current_reload > 0)? 2 : 1) : 3 );
					 
					if (this.host.current_weapon == this && this.current_reload > 0){
						this.current_reload --;
						if (this.current_reload == 1 && this.current_ammo == 0)
							this.current_ammo = Math.min ( this.magaz_ammo, this.total_ammo );
					}
					if (this == this.host.current_weapon && this.host.hand_health > 0){	
						if (this.host.want_shot && this.current_reload <= 0 && this.total_ammo <= 0)
							{this.host.model.hands.pistol.gotoAndPlay( this.weapon_class + "_no_ammo" ); 
							sound_phys.sound (this.weapon_class + "_no_ammo", this, 0, 10);
							this.current_reload = this.part_reload;}
						if (this.host.want_shot && this.current_reload <= 0 && this.current_ammo > 0 && this.total_ammo > 0 && this.host.roll_timer == 0){
							this.host.model.hands.pistol.gotoAndPlay( this.weapon_class + "_shoot" );
							sound_phys.sound (this.weapon_name + "_shoot", this, 0, 10);
							shoot_from_weapon (this.host, this); this.current_ammo --; this.total_ammo --;
							if (this.current_ammo <=0 ) sound_phys.sound (this.weapon_name + "_reload", this, 0, 10);
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
			sound_phys.sound (ww.weapon_class + "_get", ww, 0, 10);
			return true;
		}else{
			if (hh.alternate_weapon == null){
				ww.host = hh; hh.alternate_weapon = ww;
				return true;
			}
		}
		return false;
	}
	static function drop_weapon (hh, spd){
		hh.current_weapon.host = null; 
		if (spd == undefined){ hh.current_weapon.sp_x0 = ( hh.view_x - hh._x ) / 50; hh.current_weapon.sp_y0 = ( hh.view_y - hh._y ) / 20; }
						else { hh.current_weapon.sp_y0 = -spd; hh.current_weapon.sp_x0 = random(201)/100 - 1;}
		hh.current_weapon = hh.alternate_weapon; hh.alternate_weapon = null;
		hh.drop_wanna = 60; hh.want_drop_weapon = false;
		hh.model.hands.pistol.gotoAndStop( hh.current_weapon.weapon_name );
	}
	
	static function shoot_from_weapon (who:MovieClip, weapon:MovieClip){
		who.trigger_hold = 60;
		var add_ang:Number = (random(Math.round(1000 *  who.angle_add)) / 1000 - who.angle_add * .5) / 180 * Math.PI ; //trace (who.angle_add + '/' + add_ang * 180 / Math.PI);
		if (isNaN(add_ang)) add_ang = 0;

		ballistic.shoot_bullet (weapon.bullet_type+"", 
								who._x  + Math.cos (weapon.angle) * (weapon.long + 12),//+ //15 * (-1 + 2 * ( who.view_x > who._x ) ), 
								who._y  + Math.sin (weapon.angle) * (weapon.long + 12) - who.model.gr._height / 3 * 2,//- //who._xscale / 2.5 / 2, 
								weapon.bullet_speed / 10, 
								Math.PI +  Math.atan2 ( who._y - who.model.gr._height / 2 - who.view_y, who._x - who.view_x ) + add_ang, who);
	}
	
	static function swap_weapon (who:MovieClip){
		if (who.alternate_weapon != null)
			{ var wp:MovieClip = who.alternate_weapon; who.alternate_weapon = who.current_weapon; who.current_weapon = wp; }
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
		who.long = 10;
		who.shot_back = 22;
		who.no_ammo_back = 34;
		physics.set_physic_object (who, 1, .1, .2, .5);
		who.bullet_reflecting_chance = 20;
	}
}