package cn.edu.zju.labx.core
{
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	/***
    * 
    *  Definition for different viewport layers for z-sorting ,should be newed in main application;
    */  
	public class LayerManager
	{
        /** first level layers **/
        public var deskLayer:ViewportLayer;
		public var equipmentLayer:ViewportLayer;
		
		private var rayEffect:Array;
       
       	/*************************************************************************
		 * Sigleton Method to make sure there are only one LayerManager 
		 * in an application
		 * ***********************************************************************
		 */
		protected static var instance:LayerManager = null;
		public static function get getDefault():LayerManager
		{
			if (instance == null) {
				instance = new LayerManager();
				instance.initViewportLayers();
			}
			return instance;
		}
		
		/***
		 *  It will be called in onRenderTick
		 */ 
		public function viewLayerChange():void{
		    
		  if (StageObjectsManager.getDefault.mainView.camera.y < StageObjectsManager.getDefault.originPivot.y)
            {
            	equipmentLayer.layerIndex = 1;
				deskLayer.layerIndex = 2;
            }else
            {
            	equipmentLayer.layerIndex = 2;
				deskLayer.layerIndex = 1;
            }
		
		}
		
		private function initViewportLayers():void
		{
			var viewport:Viewport3D = StageObjectsManager.getDefault.mainView.viewport;
			equipmentLayer = new ViewportLayer(viewport, null);
			deskLayer = new ViewportLayer(viewport, null);
			viewport.containerSprite.addLayer(equipmentLayer);
			viewport.containerSprite.addLayer(deskLayer);
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			equipmentLayer.layerIndex = 1;
			deskLayer.layerIndex = 2;
			equipmentLayer.sortMode = ViewportLayerSortMode.Z_SORT;
			
			var bf:BlurFilter = new BlurFilter(3,3,1);
//			var growFilter_in:GlowFilter = new GlowFilter(0x00ffff, 2, 20, 10, 2, 3, true, false);
			var growFilter_out:GlowFilter = new GlowFilter(0x00ffff, 2, 16, 10, 3, 9, false, false);
			var dropShadow:DropShadowFilter = new DropShadowFilter(0, 360, 0x000fff, 1, 70, 70, 5, 3, false, false, false);
			rayEffect = [growFilter_out, dropShadow];
		}
		
		public function addRayLayer(rayLayer:ViewportLayer, eqLayer:ViewportLayer = null):void
		{
			rayLayer.filters = rayEffect;
			if(eqLayer == null)
				eqLayer = equipmentLayer;
			eqLayer.addLayer(rayLayer);
		}
		
		public function removeRayLayer(rayLayer:ViewportLayer, eqLayer:ViewportLayer = null):void
		{
			if(eqLayer == null)
				eqLayer = equipmentLayer;
			eqLayer.removeLayer(rayLayer);
		}
	}
}