package cn.edu.zju.labx.core
{
	import org.papervision3d.view.layer.ViewportLayer;
	   
	/***
    * 
    *  Definition for different viewport layers for z-sorting ,should be newed in main application;
    */  
	public class LayerManager
	{
        /** first level layers **/
        public var deskLayer:ViewportLayer;
		public var equipmentLayer:ViewportLayer;
		
		/** second level layers **/
		public var lensLayer:ViewportLayer;
		public var lightSourceLayer:ViewportLayer;
		public var boardLayer:ViewportLayer;
		public var rayLayer:ViewportLayer;
       
       	/*************************************************************************
		 * Sigleton Method to make sure there are only one LayerManager 
		 * in an application
		 * ***********************************************************************
		 */
		protected static var instance:LayerManager = null;
		public static function get getDefault():LayerManager
		{
			if (instance == null)
				instance = new LayerManager();
			return instance;
		}
	}
}