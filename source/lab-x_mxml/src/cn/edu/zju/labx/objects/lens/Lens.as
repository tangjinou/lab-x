package cn.edu.zju.labx.objects.lens
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.events.IUserInputListener;
	import cn.edu.zju.labx.events.LabXObjectUserInputHandleTool;
	import cn.edu.zju.labx.logicObject.LensLogic;
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import com.greensock.*;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.utils.MeshUtil;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Lens extends LabXObject implements IUserInputListener, IRayHandle
	{

		/**
		 * For display Lens Object
		 */
		protected var lensPart1:TriangleMesh3D;
		protected var lensPart2:TriangleMesh3D;
		protected var lens:TriangleMesh3D;
		private var LENS_DAE_URL:String;
		public var sp:Sphere;

		/**
		 * Focus of the lens, concave lens should always negative, and convex lens
		 * should always positive
		 */
		private var _focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH;
		private var userInputTool:LabXObjectUserInputHandleTool;

		/**
		 *Create a lens
		 */
		public function Lens(name:String, material:MaterialObject3D=null, focus:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			super(material, name);
			createChildren();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
			this._focus=focus;

			userInputTool=new LabXObjectUserInputHandleTool(this);
		}

		public function createChildren():void
		{
			var radius:Number=100;
			var shift:Number=Math.sqrt(radius * radius - 130 * 130 / 4);
			sp=new Sphere(this.material, radius, 24, 12);
			var normal:Number3D=new Number3D(radius, 0, 0);
			var point:Number3D=new Number3D(shift, 0, 0);
			var cutPlane:Plane3D=Plane3D.fromNormalAndPoint(normal, point);
			var meshes:Array=MeshUtil.cutTriangleMesh(sp, cutPlane);
			lensPart1=meshes[0];
			lensPart1.moveLeft(shift);
			normal.x=-radius;
			point.x=-shift;
			var meshes2:Array=MeshUtil.cutTriangleMesh(meshes[1], cutPlane);
			lensPart2=meshes2[0];
			lensPart2.moveRight(shift);
			lens=new TriangleMesh3D(null, null, null);
			lens.addChild(lensPart1);
			lens.addChild(lensPart2);
			this.addChild(lens);
			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(sp, true);
			effectLayer.alpha=0.8;
//			effectLayer.blendMode = BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
			sp.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
		}

		public function set lens_dae_url(url:String):void
		{
			this.LENS_DAE_URL=url;
		}

		private function makeAnNewRay(oldRay:Ray):Ray
		{
			if (oldRay != null)
			{
				var resultRay:Ray=extendNewRay(oldRay);
				var lensLogic:LensLogic=new LensLogic(getPosition(), getNormal(), this._focus);
				var newLineRays:ArrayCollection=new ArrayCollection();
				for each (var oldLineRay:LineRay in oldRay.getLineRays())
				{
					if (isLineRayOnObject(oldLineRay.logic))
					{
						var resultLogic:LineRayLogic=lensLogic.processRay(oldLineRay.logic);
						if (resultLogic != null)
						{
							newLineRays.addItem(new LineRay(resultLogic));
						}

					}
				}
				resultRay.setLineRays(newLineRays);
				resultRay.setOtherInfo(oldRay.getOtherInfo());
				return resultRay;
			}
			return null;
		}


		public function hanleUserInputEvent(event:Event):void
		{
			if (userInputHandle != null)
			{
				userInputHandle.call(this, event);
				return;
			}
			userInputTool.handleUserInputEvent(event);
		}


		// should destribute the listener 
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			lens.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}




		protected function daeFileOnloaded(evt:FileLoadEvent):void
		{
			this.addChild(lens);
//	        trace("beigin~~~~~~~~~~~~~");
//			trace(lens.childrenList());
//			trace("end~~~~~~~~~~~~~");
//			this.useOwnContainer = true;
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
			return sp;
		}


		/************************************************************
		 *
		 *  This is implement of IRayHandle
		 *
		 ************************************************************/
		/**
		 *  deal with when the ray on the object
		 **/
		override public function onRayHandle(oldRay:Ray):void
		{
			stopOldRay(oldRay);
			this._ray=makeAnNewRay(oldRay);
			if (this._ray != null)
			{
				StageObjectsManager.getDefault.originPivot.addChild(this._ray);
				this._ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
			}

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

		public function get focus():Number
		{
			return this._focus;
		} 
	}
}