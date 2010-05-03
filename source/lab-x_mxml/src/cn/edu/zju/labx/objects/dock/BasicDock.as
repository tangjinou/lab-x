package cn.edu.zju.labx.objects.dock
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.view.layer.ViewportLayer;

	public class BasicDock 
	{   
		private var _material:MaterialObject3D;
		private var materialsList:MaterialsList=new MaterialsList();
		private var body:Cylinder;
		private var bottom:Cube;
		private var effectLayer:ViewportLayer;
		
		/**
		 *  the parent who created the Dock
		 */ 
		private var _parent:LabXObject;
		
		private var DOCK_NOG_H:int = 0;
		private var DOCK_NOG_H_PRE:int =0;
		
		private var DOCK_NOG_R:int = 0;
		
		public function BasicDock(parent:LabXObject,material:MaterialObject3D)
		{   
			_parent = parent;
			_material = material;
			createDisplayObject();
		}
		
		public function createDisplayObject():void{
            
			materialsList.addMaterial(_material, "front");
			materialsList.addMaterial(_material, "back");
			materialsList.addMaterial(_material, "left");
			materialsList.addMaterial(_material, "right");
			materialsList.addMaterial(_material, "top");
			materialsList.addMaterial(_material, "bottom");
            bottom = new Cube(materialsList,LabXConstant.DOCK_BOTTOM_R,LabXConstant.DOCK_BOTTOM_R,LabXConstant.DOCK_BOTTOM_H);
		}
		
		/***
		 *  change the size of dock
		 */
		public function update():void{
		    DOCK_NOG_H = _parent.y + LabXConstant.DOCK_NOG_H;
		    /**Because, the parent will change it's scale**/
		    DOCK_NOG_H = DOCK_NOG_H / _parent.scale;
		    DOCK_NOG_R = DOCK_NOG_R / _parent.scale;
		    
            /**no need to upgrate**/		    
		    if(Math.abs(DOCK_NOG_H_PRE - DOCK_NOG_H) < 1){
		       return;
		    }
		    /**Record the DOCK_NOG_H**/
		    DOCK_NOG_H_PRE = DOCK_NOG_H;
			
			if(body!=null)
			  {  
			  	 body.removeChild(bottom);
			     _parent.removeChild(body); 
			     StageObjectsManager.getDefault.layerManager.equipmentLayer.removeLayer(effectLayer);
			     effectLayer = null;
			  }
		    
		    body = new Cylinder(_material,LabXConstant.DOCK_NOG_R,DOCK_NOG_H,4,3);
		    body.addChild(bottom);
            body.moveDown(DOCK_NOG_H / 2);
            bottom.y = body.y - 10 + LabXConstant.DOCK_BOTTOM_H;
		    _parent.addChild(body);
		    effectLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(body, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
		}
		
	}
}