	class animation {
	// main animate tool
	// who - объект воздействия, startFrame..finishFrame - начальный и конечный кадр анимации. (если последний кадр будет абстрактным - 1..100, а в клипе всего 20 кадров,
	// то анимация не будет цикличной.) speed - количество кадров оригинального времени 1\_root.FPS_stable, котореое должно пройти для перехода к след. кадру анимации
	// direct - направление анимации, по умолчанию задано 1 - прямое.
		static function animate (who:MovieClip, startFrame, finishFrame, speed:Number, direct, border:Boolean){	//animate an object according to improoved timeline
				if (border == undefined) border = false;									// direct -1 or 1 :: a side where do you wish to animate
				if (who == null) return;  													// ограничение - чтобы не накапливались слишком большие числа
				if (isNaN(who.anim)) {_root.console_trace("# Warning! Object ("+who+") can not be animate cause do not have an 'anim' property!"); return; }	//error
				if (isNaN(direct))direct = 1;												// default direction of animating is from left to right
				who.frame_from = startFrame; who.frame_to = finishFrame; who.direct= direct;
				
				if (who.anim%speed == 0 || isNaN(speed)){									// если скорость неопределена или аним подоспел под скорость
					var fr = who._currentframe; 
					if (!(border && ((fr == finishFrame && direct == 1) || (fr == startFrame && direct == -1))))fr += direct;
					if (fr<startFrame)fr = finishFrame; if (fr>finishFrame)fr = startFrame;	//increasing or descresing a frame counter
					who.gotoAndStop(fr);													// applying changes
		}}
	// framefinder. 
	// Исользует моментальный переход в кадр с заданным именем. Потом запоминает его номер и возвращается обратно. Помогает не высчитывать необходимые кадры и избавится
	// от привязки к числовым значениям кадров. Единственный минус - может вызывать срабатывание триггеров, которые находятся на этих кадрах.
	// Строго рекоммендую не ставить триггеры на кадры с ключевыми названиями.
	// getByName ( target:MovieClip, name_of_frame:String, Number )
		static function getByName (who:MovieClip, nam:String):Number{
			var temp = who._currentframe; who.gotoAndStop(nam); var res = who._currentframe; who.gotoAndStop(temp);
			return res;
		}
	// check is animation completed
		static function is_ready (who:MovieClip){
			return ((who._currentframe == who.frame_from && who.direct == -1) || (who._currentframe == who.frame_to && who.direct == 1));
		}
	// check is animation completed
		static function is_ready_both (who:MovieClip){
			return ((who._currentframe == who.frame_from) || (who._currentframe == who.frame_to));
		}
	// being animated all the time
		static function model_goto( who:MovieClip, stance, frames:String, speed:Number, border:Boolean, direct:Number ){
			who.gotoAndStop(stance);
			if (who.stat != stance+'/'+frames) { who.stat = stance+'/'+frames; who.gr.gotoAndStop(getByName (who.gr, frames));}
			if (who.gr.anim == undefined) who.gr.anim = 0; else who.gr.anim++;
			
			animate (who.gr, getByName (who.gr, frames), getByName (who.gr, frames + "_end"), speed, direct, border);
		}
}