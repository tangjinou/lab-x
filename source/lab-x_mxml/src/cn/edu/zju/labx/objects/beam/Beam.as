package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
	import cn.edu.zju.labx.logicObject.BeamLogic;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;

	import flash.display.BlendMode;
	import flash.events.Event;

	import mx.collections.ArrayCollection;

	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Beam extends LabXObject implements IUserInputListener, IRayHandle
	{

		private var userInputhandleTool:LabXObjectUserInputHandleTool;
		protected var displayObject:Cube;

		public function Beam(material:MaterialObject3D, name:String, vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
			createDisplayObject();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			userInputhandleTool=new LabXObjectUserInputHandleTool(this);
		}

		public function hanleUserInputEvent(event:Event):void
		{
			if (userInputHandle != null)
			{
				userInputHandle.call(this, event);
				return;
			}
			userInputhandleTool.handleUserInputEvent(event);
		}

		/**
		 * @@@@@@@@@@@@@@@@@@@@@
		 * 		This function will not intend to override by children
		 * @@@@@@@@@@@@@@@@@@@@@
		 * we should stop the old ray when process the ray
		 */
		public function onRayHandle(oldRay:Ray):void
		{
			stopOldRay(oldRay);
			handleRay(oldRay);
		}

		/**
		 * Child Class override this method to process ray.
		 */
		protected function handleRay(oldRay:Ray):void
		{
			//do nothing
		}


		/**
		 * Create a basic display object for beam
		 * Override this method if subclass want to create a different display object,
		 */
		public function createDisplayObject():void
		{

			width=15;
			depth=100;

			var materialsList:MaterialsList=new MaterialsList();
			materialsList.addMaterial(material, "front");
			materialsList.addMaterial(material, "back");
			materialsList.addMaterial(material, "left");
			materialsList.addMaterial(material, "right");
			materialsList.addMaterial(material, "top");
			materialsList.addMaterial(material, "bottom");
			displayObject=new Cube(materialsList, width, depth, height);

			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(displayObject, true);
			effectLayer.blendMode=BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);

			this.addChild(displayObject);
		}

		// should destribute the listener 
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			displayObject.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * help method to display a ray
		 */
		protected function displayNewRay(ray:Ray):void
		{
			if (ray != null)
			{
				StageObjectsManager.getDefault.originPivot.addChild(ray);
				ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(ray);
			}
		}

		/**
		 * make a reflection ray through input ray
		 */
		protected function makeReflectionRay(oldRay:Ray, reverse:Boolean=false):Ray
		{
			if (oldRay != null)
			{
				var resultRay:Ray=new Ray(this, null, null)
				var newLineRays:ArrayCollection=new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
					var beamLogic:BeamLogic=new BeamLogic(getPosition(), getNormal());
					var lineRayLogic:LineRayLogic=beamLogic.calculateReflectionRay(oldLineRay.logic);
					if (lineRayLogic != null)
					{
						newLineRays.addItem(new LineRay(lineRayLogic));
					}
					if (!reverse && isReverseNormal(lineRayLogic, oldLineRay.logic))
						resultRay=null;
				}
				if (resultRay != null)
				{
					resultRay.setLineRays(newLineRays);
					resultRay.setOtherInfo(oldRay.getOtherInfo());
				}
				return resultRay;
			}
			return null;
		}

		/**
		 * make a new ray that pass the current object with out changing its normal
		 */
		protected function makePassThroughRay(oldRay:Ray):Ray
		{
			if (oldRay != null)
			{
				var resultRay:Ray=new Ray(this, null, null);
				var newLineRays:ArrayCollection=new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
					var start_point_new:Number3D=MathUtils.calculatePointInPlane2(getPosition(), getNormal(), oldLineRay.normal, oldLineRay.start_point);
					if (start_point_new != null)
					{
						var lineRayLogic:LineRayLogic=new LineRayLogic(start_point_new.clone(), oldLineRay.normal);
						newLineRays.addItem(new LineRay(lineRayLogic));
					}
				}
				resultRay.setLineRays(newLineRays);
				resultRay.setOtherInfo(oldRay.getOtherInfo());
				return resultRay;
			}
			return null
		}

		/**
		 * If the normal is reverse from each other
		 */
		protected function isReverseNormal(a:LineRayLogic, b:LineRayLogic):Boolean
		{
			var n1:Number3D=new Number3D(a.dx, a.dy, a.dz);
			var n2:Number3D=new Number3D(b.dx, b.dy, b.dz);
			return Number3D.add(n1, n2).modulo < LabXConstant.NUMBER_PRECISION;
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
				var lineRay:LineRay=ray.getLineRays().getItemAt(0) as LineRay;
				if (lineRay != null)
					return isLineRayOnObject(lineRay.logic);
				return false;
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
			return displayObject;
		}

	}
}