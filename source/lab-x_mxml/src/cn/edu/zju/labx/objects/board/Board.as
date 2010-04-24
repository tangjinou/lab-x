package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import flash.events.Event;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;

	/**
	 * Board is an LabX Object used to display the light result
	 *
	 */
	public class Board extends LabXObject implements IUserInputListener, IRayHandle
	{
		protected var cube:Cube;
		private var leftMaterial:MaterialObject3D;

		private var userInputTool:LabXObjectUserInputHandleTool;

		/**
		 * Create a board
		 *
		 * @param material the material to create object in it
		 *
		 */
		public function Board(name:String, material:MaterialObject3D=null)
		{
			super(material, name);
			createDisplayObject();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			userInputTool=new LabXObjectUserInputHandleTool(this);
		}

		protected var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);

		public function createDisplayObject():void
		{

			width=LabXConstant.LABX_OBJECT_WIDTH / 10;

			var materialsList:MaterialsList=new MaterialsList();
			leftMaterial=material.clone();
			leftMaterial.interactive=true;
			materialsList.addMaterial(material, "front");
			materialsList.addMaterial(material, "back");
			materialsList.addMaterial(leftMaterial, "left");
			materialsList.addMaterial(material, "right");
			materialsList.addMaterial(material, "top");
			materialsList.addMaterial(material, "bottom");
			cube=new Cube(materialsList, width, depth, height);
			this.addChild(cube);

			effectLayer.addDisplayObject3D(cube, true);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			displayCursor();

		}

		private var lines:Lines3D=new Lines3D;

		private function displayCursor():void
		{
			var blueMaterial:LineMaterial=new LineMaterial(0x0000FF);
			var start:Vertex3D;
			var end:Vertex3D;
			var line:Line3D;
			start=new Vertex3D(-5, 0, -10);
			end=new Vertex3D(-5, 0, 10);
			line=new Line3D(lines, blueMaterial, 1, start, end);
			lines.addLine(line);
			start=new Vertex3D(-5, -10, 0);
			end=new Vertex3D(-5, 10, 0);
			line=new Line3D(lines, blueMaterial, 1, start, end);
			lines.addLine(line);
			effectLayer.addDisplayObject3D(lines);
			this.addChild(lines);
		}

		protected function removeCursor():void
		{
			effectLayer.removeDisplayObject3D(lines);
		}

		public function hanleUserInputEvent(event:Event):void
		{
			userInputTool.handleUserInputEvent(event);
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			cube.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		//should keep the reference to free resource
//	    protected var bmp:BitmapData;
		protected var new_material:MaterialObject3D;

		//This is will be  automaticlly called when Ray chenged 
		public function unDisplayInterferenceImage():void
		{
			if (new_material != null)
			{
				new_material.destroy();
				new_material=null;
//				bmp.dispose();
//				bmp = null;
				cube.replaceMaterialByName(leftMaterial, "left");
			}
			oldRay1=null;
			oldRay2=null;
		}


		/************************************************************
		 *
		 *  This is implement of IRayHandle
		 *
		 ************************************************************/

		/**
		 *  deal with when the ray on the object
		 **/

		protected var oldRay1:Ray=null;
		protected var oldRay2:Ray=null;

		/**
		 *  save the two rays
		 */
		public function saveRays(oldRay:Ray):void
		{
			if (oldRay1 == null)
			{
				oldRay1=oldRay;
			}
			else if (oldRay2 == null)
			{
				oldRay2=oldRay;
			}
		}

		/***
		 *  save the oldRay and reproduce the oldRay
		 */
		override public function onRayHandle(oldRay:Ray):void
		{
			stopOldRay(oldRay);
			handleRay(oldRay);
			super.onRayHandle(oldRay);
		}
		
		protected function handleRay(oldRay:Ray):void
		{
			//Do Nothing
		}

		protected function isParellel(ray:Ray):Boolean
		{
			for (var i:int=0; i < ray.getLineRays().length; i++)
			{
				for (var j:int=0; j < ray.getLineRays().length; j++)
				{
					var lineRay1:LineRay=ray.getLineRays().getItemAt(i) as LineRay;
					var lineRay2:LineRay=ray.getLineRays().getItemAt(j) as LineRay;
					if (!MathUtils.isParellel(lineRay1.normal, lineRay2.normal))
					{
						return false;
					}
				}
			}
			return true;
		}

		/***
		 *   it should be override in sub class
		 */
		protected function isRayWayRight(_ray:Ray):Boolean
		{

			return true;
		}


		/**
		 *   get the distance between  the object's centrol point and the ray's start point
		 *
		 *   if return -1 means that the distance is infinite
		 *
		 **/
		public function getDistance(ray:Ray):Number
		{
			if (ray.getLineRays().length > 0)
			{
				var lineRay:LineRay=ray.getLineRays().getItemAt(0) as LineRay;
				return MathUtils.distanceToNumber3D(getPosition(), lineRay.start_point);
				;
			}
			return -1;
		}

		/**
		 *   judge the ray if is on the object
		 */
		public function isOnTheRay(ray:Ray):Boolean
		{
			if (ray != null && ray.getLineRays() != null && ray.getLineRays().length > 0)
			{
				for each (var lineRay:LineRay in ray.getLineRays())
				{
					if (lineRay != null && isLineRayOnObject(lineRay.logic))
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 *   This is for get object with the material on it, it should be overrite
		 *
		 *   when the this materials not on the basic object,
		 *
		 *   for example: lens may not have the materials on
		 *
		 *   root,but on the sphere
		 *
		 */
		override public function getObjectWithMaterial():TriangleMesh3D
		{
			return cube;
		}

		override public function onRayClear():void
		{
			unDisplayInterferenceImage();
			super.onRayClear();
		}

	}
}