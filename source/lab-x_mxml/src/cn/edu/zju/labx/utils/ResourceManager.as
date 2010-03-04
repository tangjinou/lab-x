package cn.edu.zju.labx.utils
{
	public class ResourceManager
	{   
		public static const experiment1_text:String="中新网2月28日报道 据美联社报道，智利地震引发的第一波海啸已经抵达日本的偏远外岛，但是引起的海浪并不高，并未造成损失。";


        [Embed (source="../resource/swf/FirstExperiment.swf")]
		public static const experiment1_swf:Class;
		
		[Embed (source="../resource/swf/SecondExperiment.swf")]
		public static const experiment2_swf:Class;
		
		[Embed (source="../resource/picture/zoom_add.png")]
		public static const zoom_add_png:Class;
		
		[Embed (source="../resource/picture/zoom_min.png")]
		public static const zoom_min_png:Class;
		

		public function ResourceManager()
		{
			
		}
		
		

	}
}