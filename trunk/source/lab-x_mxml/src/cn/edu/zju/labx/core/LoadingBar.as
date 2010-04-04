package cn.edu.zju.labx.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class LoadingBar extends DownloadProgressBar
	{
		public function LoadingBar()
		{
			super();
			downloadingLabel="正在下载中...欢迎光临浙江大学光学实验室";
			initializingLabel="正在初始化内容...";
		}

	}
}