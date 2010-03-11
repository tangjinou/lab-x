package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.ILabXListener;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXEvent;
	import cn.edu.zju.labx.logicObject.LensLogic;
	import cn.edu.zju.labx.logicObject.RayLogic;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import com.greensock.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	
	public class Lens extends LabXObject implements ILabXListener ,IUserInputListener, IRayMaker
	{   
		private var _ray:Ray  = null;
		private var _focus:Number = LabXConstant.LENS_DEFAULT_FOCAL_LENGTH;
		
		
//		protected var lens:Cylinder;
	    protected var lens:DAE;
	    
	    public var width:Number =120;
	    public var height:Number=120;
   
		/**
		 * To store the old Mouse X position;
		 */
	    public var oldMouseX:Number = -1;
	    
		public function Lens(material:MaterialObject3D=null, focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			super(material);
			createChildren();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			this._focus = focus;
		}
		public function createChildren():void{
//		   	lens = new Cylinder(this.material,100,100,30,10);
//		   	this.addChild(lens);
            lens=new DAE(true);  
            lens.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);
            lens.load(ResourceManager.LENS_DAE_URL,new MaterialsList( {all:this.material} ) );		
              
		}

		public function handleLabXEvent(event:LabXEvent):Boolean
		{
			if(this._ray != null)StageObjectsManager.getDefault.originPivot.removeChild(this._ray);
			this._ray = null;
			
			if (event.type != LabXEvent.LIGHT_OFF)
			{
				var obj:LabXObject = StageObjectsManager.getDefault.getPreviousXObject(this);
				if (obj != null && obj is IRayMaker)
				{
					this._ray = makeAnNewRay(obj as IRayMaker);
					if(this._ray != null)
					{
						StageObjectsManager.getDefault.originPivot.addChild(this._ray);
						this._ray.displayRays();
					}
				}
			}
			return true;
		}
		
		private function makeAnNewRay(rayMaker:IRayMaker):Ray
		{
			var oldRay:Ray = rayMaker.getRay();
			if(oldRay != null)
			{
				oldRay.EndX = this.x;
				var lensLogic:LensLogic = new LensLogic(new Number3D(this.x, this.y, this.z), this._focus);
				var newLineRays:ArrayCollection = new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
					var resultLogic:RayLogic = lensLogic.calculateRayAfterLens(oldLineRay.logic);
					var num:Number3D = new Number3D(this.x + this._focus, this.y, this.z);
					var b:Boolean = resultLogic.isPointOnRay(num);
					newLineRays.addItem(new LineRay(resultLogic));
				}
				return  new Ray(null, newLineRays, 0, 0);
			}
			return null;
		}
		
		public function getRay():Ray
		{
//       	 	var ray:RayLogic = new RayLogic(new Number3D(this.x, this.y, this.z), new Vector3D(1, 0, 0)); 
			return this._ray;
		}
		
		public function setRay(ray:Ray):void
		{
			this._ray = ray;
		}
		
	    public function hanleUserInputEvent(event:Event):void{
	   	    if(userInputHandle!=null){
	   	       userInputHandle.call(this,event);
	   	       return;
	   	    }
	   	    if(event is MouseEvent){
	   	   	     var mouseEvent:MouseEvent = event as MouseEvent;
	   	    	 if (mouseEvent.type == MouseEvent.MOUSE_DOWN) {
	   	    	 	oldMouseX = mouseEvent.stageX;
	   	    	 } else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
	   	    	 	oldMouseX = -1;
	   	    	 } else if ((mouseEvent.type == MouseEvent.MOUSE_MOVE) && (oldMouseX != -1) && mouseEvent.buttonDown) {
	   	    	 	var xMove:Number = mouseEvent.stageX - oldMouseX;
	   	    	 	this.x += xMove;
	   	    	 	oldMouseX = mouseEvent.stageX;
	   	    	 	StageObjectsManager.getDefault.addMessage("lens move:"+xMove);
	   	    	 	StageObjectsManager.getDefault.notify(new LabXEvent(this, LabXEvent.XOBJECT_MOVE));
	   	    	 }
	    	}
	    	
	    }
	    
	    // should destribute the listener 
        override public function addEventListener(type:String, listener:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{   
			lens.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	    private function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	this.addChild(lens);  
//	        trace("beigin~~~~~~~~~~~~~");
//			trace(lens.childrenList());
//			trace("end~~~~~~~~~~~~~");
			this.useOwnContainer = true;
            lens.getChildByName("COLLADA_Scene").getChildByName("Sphere02").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
            lens.getChildByName("COLLADA_Scene").getChildByName("Sphere01").addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
        } 
		
	}
}