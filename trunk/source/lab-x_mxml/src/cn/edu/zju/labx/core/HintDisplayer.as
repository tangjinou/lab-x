package cn.edu.zju.labx.core
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class HintDisplayer
	{
		private var _text:TextField;
		private var _textFormat:TextFormat;
		private var _isDisplay:Boolean = true;
		public function HintDisplayer()
		{
			_text = new TextField();
			_textFormat = new TextFormat();
			_textFormat.size = 20;
			_textFormat.align = "center";
			_text.defaultTextFormat = _textFormat;
			_text.text = "选中物体之后可以用鼠标进行移动或者用如下按钮进行微调\n" + 
					"按W, S, A, D在水平面移动\n" + 
					"按PageUp, PageDown垂直移动\n" + 
					"按Q, E进行旋转\n" + 
					"移动鼠标到右下角按钮上方可获得相应帮助";
			_text.textColor = 0xFF6600;
			_text.x = LabXConstant.STAGE_WIDTH/3;
			_text.y = LabXConstant.STAGE_HEIGHT;
			_text.width = 600;
			_text.height = 200;
			_text.wordWrap = true;
			_text.filters = [new DropShadowFilter(1, 45, 0xa3610a, 1, 2, 2)];

			
		}
		
		public function displayMoveHint():void
		{
			if (_isDisplay)
			{
				if ( _text.parent == null )
				{
					StageObjectsManager.getDefault.mainView.addChild(_text);
				}
				else
				{
					_text.alpha = 1;
				}

				var timer:Timer = new Timer(100, 100);
				timer.addEventListener(TimerEvent.TIMER, fadeOut);
				timer.start();

			}
		}
		
		private function fadeOut(event:TimerEvent):void
		{
			_text.alpha -=0.01;
		}
		
		public function disableHint():void
		{
			_isDisplay = false;
		}
	}
}