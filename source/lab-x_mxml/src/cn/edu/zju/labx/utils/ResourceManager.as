package cn.edu.zju.labx.utils
{
	import flash.display.Bitmap;
	
	public class ResourceManager
	{   
		public static const experiment1_text:String="中新网2月28日报道 据美联社报道，智利地震引发的第一波海啸已经抵达日本的偏远外岛，但是引起的海浪并不高，并未造成损失。";

        [Embed (source="../assets/swf/FirstExperiment.swf")]
		public static const experiment1_swf:Class;
		
		[Embed (source="../assets/swf/SecondExperiment.swf")]
		public static const experiment2_swf:Class;
		
		[Embed (source="../assets/icon/zoom_add.png")]
		public static const zoom_add_png:Class;
		
		[Embed (source="../assets/icon/zoom_min.png")]
		public static const zoom_min_png:Class;
		
//		public static const CONVEX_LENS_DAE_URL:String = "../assets/models/lens_convex.DAE";
//		
//		public static const CONCAVE_LENS_DAE_URL:String = "../assets/models/lens_concave.DAE";
//		
//		public static const RAY_DAE_URL:String = "../assets/models/ray.DAE";
//		
//		public static const DESK_DAE_URL:String = "../assets/models/desk.DAE";
//
//		public static const DESK_TEXTURE:String = "../assets/textures/metal_desk.jpg";
		
		

	}
}