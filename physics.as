class physics {
	static function Trace (messag:String){
		trace ("> PHYS: " + messag +';');
	}
	static function TraceError (messag:String){
		trace ("# PHYS: error: " + messag +';');
	}
	
	static function set_ground (who:MovieClip, type:Array){
		//Trace (who + ' is now ground');
		who.is_ground = true; who.typ = type;
		if (type == _root.ladders || type == _root.grounds){
			if (who.velocity_grap == undefined)who.velocity_grap = 0;
			if (who.jump_back_mult == undefined)who.jump_back_mult = 0;
			if (who.is_passible == undefined)who.is_passible = false;
			if (who.stairs_height == undefined) who.stairs_height = 5;}
		if (type == _root.ladders)
			who.is_ladder = true;
		
		who.number = type.length;
		type.push (who);
		who.onUnload = function (){
			for (var i=0; i<this.typ.length; i++)
				if (this.typ[i] == this){
					this.typ.splice(i,1);
					break;
				}}
	}
	
	static function set_physic_object (who:MovieClip, mass:Number, velocity_grap:Number, tren_mult:Number, jump_back_mult:Number):Boolean{
		//Trace (who._name + " is now phys_obj" );
		who.G_mult = 1;
		who.is_physic_object = true;
		who.mass = mass;
		who.velocity_grap = velocity_grap;
		who.tren_mult = tren_mult;
		who.jump_back_mult = jump_back_mult;
		who.sp_x = who.sp_y = who.sp_x0 = who.sp_y0 = who.sp_x_was = 0;
		who.ground = false;
		who.bullet_reflecting_chance = 0;
		who.wants_to_pass = null;
		who.standing_on = null; // земля или объект, на котором мы стоим
		if (who.hitbox == undefined){ TraceError ( who._name + ' does not have a hitbox called "hitbox"'); return false;}
		
		
		return true; // everything is fine. no errors
	}
	
	static function be_physic_object (who:MovieClip){
		for (var upd = 0; upd < _root.updates; upd ++ ){
			check_collision_width_headers_and_walls ( who );
			who.standing_on = check_collision_with_ground_and_ladders (who);
			if (!who.ground){
					who.sp_y0 += _root.G  / 60.0 * who.G_mult;
			} else {					
					if (Math.abs(who.sp_x0) > .1) who.sp_x0 /= (1 + who.velocity_grap + who.standing_on.velocity_grap);// + (who.standing_on.velocity_grap) * (who.standing_on != null));
										 	else  who.sp_x0 = 0;
			}
			// reversing inverse
			if (who.sp_x != 0 && Math.abs(who.sp_x) > Math.abs(who.sp_x0)) who.sp_x0 = 0; 
			// apllying inerce
			if (who.sp_x == 0 && who.sp_x_was != 0 && Math.abs (who.sp_x0) < Math.abs (who.sp_x_was) &&
				!(( who.sp_x0 > who.sp_x_was && who.sp_x_was > 0) || ( who.sp_x0 < who.sp_x_was && who.sp_x_was < 0)))
					who.sp_x0 = who.sp_x_was * .95;
			who.sp_x_was = who.sp_x;
		}
		who._x += (who.sp_x + who.sp_x0) * _root.time_passed;
		who._y += (who.sp_y + who.sp_y0) * _root.time_passed;
		// dead
		if (who._y > 2000) who.removeMovieClip();
	}
	
	static function check_collision_width_headers_and_walls (who:MovieClip){
		if (who.sp_x + who.sp_x0 == 0)
			return;
		for (var i = 0; i < _root.walls.length; i++){
			var wl:MovieClip = _root.walls[i];
			if (Math.abs (who._x - wl._x) < wl._width / 2){
				wl.hitbox._alpha = 100;
				if (who.hitbox.hitTest(wl.hitbox) && (wl.hitbox.hitTest( who._x, who._y, true ) || wl.ground.hitTest(who._x + who.sp_x + who.sp_x0, who.sp_y, true)))
					{ who.sp_x0 = .6 * Math.abs(who.sp_x + who.sp_x0) * ((who._x > wl._x) * 2 - 1) * 1; who.sp_x = 0; }
			}
		}
	}
	static function check_collision_with_ground_and_ladders (who:MovieClip) : MovieClip {
		if (who.sp_x + who.sp_x0 == 0 && who.sp_y + who.sp_y0 == 0 && who.standing_on != who.wants_to_pass)
			return who.standing_on;
		for (var i = 0; i < _root.grounds.length + _root.ladders.length; i++){
			// if ground
			if (i < _root.grounds.length){
				var gr:MovieClip = _root.grounds[i];
				if (gr == who || (gr.is_passible && who.wants_to_pass == gr ) 
					|| Math.abs ( who._x - gr._x ) > .6 * gr._width  || Math.abs (who._y - gr._y) > 30) continue;
				gr.hitbox._alpha = 100;
				if  (who.sp_y + who.sp_y0 >= 0 && who.hitbox.hitTest(gr.hitbox) && 
					(( gr.ground.hitTest(who._x, who._y + 1, true) ||  gr.ground.hitTest (who._x + who.sp_x + who.sp_x0, who._y + who.sp_y + who.sp_y0))))
					{	if (who.jump_back_mult + gr.jump_back_mult != 0 && Math.abs(who.sp_y + who.sp_y0) >= 1)
							{ who.sp_y0 = -(who.jump_back_mult + gr.jump_back_mult ) * (who.sp_y + who.sp_y0); who.sp_y = 0; 
							  who._y = gr._y - 1; 
							  who.ground = false; return gr;}
						else
							{ who.sp_y = 0; who.sp_y0 = Math.min (who.sp_y0 , 0); 
							  who._y = gr._y; 
							  who.ground = true; return gr;}
					}}
			// if ladder
			else {
				var ld:MovieClip = _root.ladders[i - _root.grounds.length];
				if (ld.is_passible && who.wants_to_pass == ld
					|| Math.abs ( who._x - ld._x ) > .6 * ld._width || Math.abs ( who._y - ld._y ) > .6 * ld._width) continue;
				ld.hitbox._alpha = 100;
				var ladder_y = ld._y - ( (ld.is_reversed != true)* 2 -1 ) * ld._height / 1.3 * (  - who._x + ld._x ) / ld._width;
					
				if (who.sp_y + who.sp_y0 >= 0 && (who.sp_x + who.sp_x0)*(ld._xscale / ld.xs) <= 0 &&
					ld.hitbox.hitTest( who.hitbox ) && (Math.abs( ladder_y + 8 - (who._y + who.sp_y + who.sp_y0) ) < 10  || Math.abs( ladder_y  + 8 - who._y ) < 8) )
				{	
					who._y = Math.min ( who._y, ladder_y);
					if (who.jump_back_mult + ld.jump_back_mult != 0 && Math.abs(who.sp_y + who.sp_y0) >= 1){
						who.ground = ladder_y <= who._y + ld.stairs_height;  
						if (who.ground){
							var sp_y0_new = -(who.jump_back_mult + ld.jump_back_mult) * (who.sp_x + who.sp_x0);
							var sp_x0_new = (who.jump_back_mult + ld.jump_back_mult) * (who.sp_y + who.sp_y0) * ( (ld.is_reversed != true)* 2 -1 );
							who.sp_y0 = sp_y0_new; who.sp_y = 0; 
							who.sp_x0 = sp_x0_new; who.sp_x = 0; 
							return ld;}
					}else{
						who.ground = ladder_y <= who._y + ld.stairs_height;  
						if (who.ground){ who.sp_y = 0; who.sp_y0 = 0; return ld;}
					}
					return null;					
				}
				
			}
		}
		who.ground = false; return null;
	}

}