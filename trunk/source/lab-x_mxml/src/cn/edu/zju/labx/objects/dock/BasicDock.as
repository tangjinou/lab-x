package cn.edu.zju.labx.objects.dock
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Cylinder;

	public class BasicDock 
	{   
		private var _material:MaterialObject3D;
		
//		private var lineMaterial:LineMaterial=new LineMaterial(0xFF0000, 1);
//		private var dock_lines:Lines3D = new Lines3D(lineMaterial);
//		private var lineBold:Number=5;
		
		private var body:Cylinder;
		private var bottom:Cylinder;
		
		/**
		 *  the parent who created the Dock
		 */ 
		private var _parent:LabXObject;
		
		private var DOCK_NOG_H:int = 0;
		private var DOCK_NOG_R:int = 0;
		
		public function BasicDock(parent:LabXObject,material:MaterialObject3D)
		{   
			_parent = parent;
			_material = material;
			createDisplayObject();
		}
		
		public function createDisplayObject():void{
            bottom = new Cylinder(_material,LabXConstant.DOCK_BOTTOM_R,LabXConstant.DOCK_BOTTOM_H,4,3);
		}
		
		
		/***
		 *  change the size of dock
		 */
		public function update():void{
			
			/*   
			 *   Will
			 *
			 *   here: will create new dock, should be add the layermanager
			 * 
			 */ 
			if(body!=null)
			  {  
			  	 body.removeChild(bottom);
			     _parent.removeChild(body);
			  }
		    DOCK_NOG_H = _parent.y + LabXConstant.DOCK_NOG_H;
		    /*Because, the parent will change it's scale*/
		    DOCK_NOG_H = DOCK_NOG_H / _parent.scale;
		    DOCK_NOG_R = DOCK_NOG_R / _parent.scale;
		    
		    body = new Cylinder(_material,LabXConstant.DOCK_NOG_R,DOCK_NOG_H,4,3);
		    body.addChild(bottom);
            body.moveDown(DOCK_NOG_H / 2);
            bottom.y = body.y - 10 + LabXConstant.DOCK_BOTTOM_H;
		    _parent.addChild(body);
		    
		    
		    
		    
//		    var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
//			effectLayer.addDisplayObject3D(displayObject, true);
//			effectLayer.blendMode=BlendMode.HARDLIGHT;
		    
//		    d.moveDown(DOCK_NOG_H / 2 );



//             if(dock_lines!=null)
//                _parent.removeChild(dock_lines);
//             
//             dock_lines.removeAllLines();
//             
//             var start_point:Vertex3D = new Vertex3D(_parent.x,_parent.y,_parent.z);
//             
//             var end_point:Vertex3D = new Vertex3D(_parent.x,_parent.y - LabXConstant.DOCK_NOG_H,_parent.z);
//             
//             dock_lines.addLine(new Line3D(dock_lines, lineMaterial, lineBold , start_point, end_point));
//	         
//	         _parent.addChild(dock_lines);
	         
		}
		
	}
}