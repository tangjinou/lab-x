package cn.edu.zju.labx.core.manager
{
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;

	import cn.edu.zju.labx.core.LabXConstant;
	/***
	 *
	 *  Definition for different viewport layers for z-sorting ,should be newed in main application;
	 */
	public class LayerManager
	{
		/** first level layers **/
		public var deskLayer:ViewportLayer;
		public var equipmentLayer:ViewportLayer;
		public var deskLegLayer:ViewportLayer;
		public var gridLayer:ViewportLayer;

		private var rayEffectBlue:Array;
		private var rayEffectYellow:Array;
		/*************************************************************************
		 * Sigleton Method to make sure there are only one LayerManager
		 * in an application
		 * ***********************************************************************
		 */
		protected static var instance:LayerManager=null;

		public static function get getDefault():LayerManager
		{
			if (instance == null)
			{
				instance=new LayerManager();
				instance.initViewportLayers();
			}
			return instance;
		}

		/***
		 *  It will be called in onRenderTick
		 */
		public function viewLayerChange():void
		{

			if (StageObjectsManager.getDefault.mainView.camera.y < StageObjectsManager.getDefault.originPivot.y)
			{
				equipmentLayer.layerIndex=1;
				gridLayer.layerIndex=2;
				deskLayer.layerIndex=3;
				deskLegLayer.layerIndex=4;
			}
			else
			{
				equipmentLayer.layerIndex=4;
				gridLayer.layerIndex=3;
				deskLayer.layerIndex=2;
				deskLegLayer.layerIndex=1;
			}

		}

		private function initViewportLayers():void
		{
			var viewport:Viewport3D=StageObjectsManager.getDefault.mainView.viewport;
			equipmentLayer=new ViewportLayer(viewport, null);
			deskLayer=new ViewportLayer(viewport, null);
			deskLegLayer=new ViewportLayer(viewport, null);
			gridLayer=new ViewportLayer(viewport, null);
			viewport.containerSprite.addLayer(equipmentLayer);
			viewport.containerSprite.addLayer(deskLayer);
			viewport.containerSprite.addLayer(deskLegLayer);
			viewport.containerSprite.addLayer(gridLayer);
			viewport.containerSprite.sortMode=ViewportLayerSortMode.INDEX_SORT;
			equipmentLayer.layerIndex=1;
			gridLayer.layerIndex=2;
			deskLayer.layerIndex=3;
			deskLegLayer.layerIndex=4;
			equipmentLayer.sortMode=ViewportLayerSortMode.Z_SORT;

			var bf:BlurFilter=new BlurFilter(3, 3, 1);
//			var growFilterBlueIn:GlowFilter = new GlowFilter(0x00ffff, 2, 20, 10, 2, 3, true, false);
			var growFilterBlue:GlowFilter=new GlowFilter(0x00ffff, 2, 16, 10, 3, 9, false, false);
//			var dropShadow:DropShadowFilter = new DropShadowFilter(0, 360, 0x000fff, 1, 70, 70, 5, 3, false, false, false);
			var dropShadowBlue:DropShadowFilter=new DropShadowFilter(0, 360, 0x000fff, 1, 50, 50, 3, 2, false, false, false);
			rayEffectBlue = [growFilterBlue, dropShadowBlue];
			var growFilterYellowIn:GlowFilter = new GlowFilter(0xFDD017, 2, 20, 10, 2, 3, true, false);
			var growFilterYellow:GlowFilter = new GlowFilter(0xFDD017, 2, 8, 8, 3, 9, false, false);
			var dropShadowYellow:DropShadowFilter = new DropShadowFilter(0, 360, 0xFDD017, 1, 50, 50, 3, 2, false, false, false);
			rayEffectYellow = [growFilterYellowIn, growFilterYellow, dropShadowYellow];
		}

		public function addRayLayer(rayLayer:ViewportLayer, color:Number = LabXConstant.BLUE, eqLayer:ViewportLayer=null):void
		{
			if (color == LabXConstant.BLUE) 
				rayLayer.filters = rayEffectBlue;
			else if (color == LabXConstant.YELLOW)
				rayLayer.filters = rayEffectYellow;
			if (eqLayer == null)
				eqLayer=equipmentLayer;
			eqLayer.addLayer(rayLayer);
		}

		public function removeRayLayer(rayLayer:ViewportLayer, eqLayer:ViewportLayer=null):void
		{
			if (eqLayer == null)
				eqLayer=equipmentLayer;
			eqLayer.removeLayer(rayLayer);
		}
	}
}