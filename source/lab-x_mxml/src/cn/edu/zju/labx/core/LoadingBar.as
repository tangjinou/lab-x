package cn.edu.zju.labx.core
{
	import mx.preloaders.DownloadProgressBar;

	public class LoadingBar extends DownloadProgressBar
	{
		public function LoadingBar()
		{
			super();
            downloadingLabel="正在下载中...";
            initializingLabel="正在初始化内容...";
		}
		
	}
}