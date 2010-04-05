package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.beam.ArrowObjectPlane;
	import cn.edu.zju.labx.objects.beam.BeamSplitter;
	import cn.edu.zju.labx.objects.beam.FourierGrating;
	import cn.edu.zju.labx.objects.beam.LCLV;
	import cn.edu.zju.labx.objects.beam.Mirror;
	import cn.edu.zju.labx.objects.beam.ParallelCrystal
	import cn.edu.zju.labx.objects.beam.ObjectPlane;
	import cn.edu.zju.labx.objects.beam.PolarizationBeamSplitter;
	import cn.edu.zju.labx.objects.board.DifferentialCoefficientBoard;
	import cn.edu.zju.labx.objects.board.DoubleSlitInterfBoard;
	import cn.edu.zju.labx.objects.board.FourierDisplayBoard;
	import cn.edu.zju.labx.objects.board.MachZehnderInterfBoard;
	import cn.edu.zju.labx.objects.board.ParallelBeamDetector;
	import cn.edu.zju.labx.objects.lens.ConvexLens;
	import cn.edu.zju.labx.objects.lens.FourierLens;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.Lamps;
	import cn.edu.zju.labx.objects.lightSource.Laser;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.proto.LightObject3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	public class ExperimentManager
	{

		/*************************************************************************
		 * Sigleton Method to make sure there are only one ExperimentManager
		 * in an application
		 * ***********************************************************************
		 */
		private static var instance:ExperimentManager=null;

		public static function get getDefault():ExperimentManager
		{
			if (instance == null)
			{
				instance=new ExperimentManager();
			}
			return instance;
		}

		public function ExperimentManager()
		{
		}

		/**
		 * Create a Laser
		 */
		[Embed(source="../assets/textures/metal.jpg")]
		public var LIGHTSOURCE_TEXTURE:Class;
		private var _equipmentList:ArrayCollection;


		private var _experimentIndex:int;
		private var light:LightObject3D;



		/*******************************************************************************************************
		 * move the objects to the right place
		 *******************************************************************************************************/
		private var opitimize:Boolean=false;

		/**
		 * Create the equipment according to the experiment
		 */
		public function createExperimentEquipments(experimentIndex:Number):ArrayCollection
		{
			this._experimentIndex=experimentIndex;
			remove();
			switch (experimentIndex)
			{
				case LabXConstant.EXPERIMENT_FIRST:
					_equipmentList=createFirstExperimentEquipments();
					break;
				case LabXConstant.EXPERIMENT_SECOND:
					_equipmentList=createSecondExperimentEquipments();
					break;
				case LabXConstant.EXPERIMENT_THIRD:
					_equipmentList=createThirdExperimentEquipments();
					break;
				case LabXConstant.EXPERIMENT_FORTH:
					_equipmentList=createForthExperimentEquipments();
					break;
			}
			addDefaultExperimentEquipments(_equipmentList);
			for (var i:int=0; i < _equipmentList.length; i++)
			{
				var equipment:LabXObject=_equipmentList.getItemAt(i) as LabXObject;
				equipment.moveUp(LabXConstant.LABX_OBJECT_HEIGHT / 2);
				equipment.moveForward(LabXConstant.STAGE_DEPTH / 2);
				equipment.moveRight(i * LabXConstant.STAGE_WIDTH / _equipmentList.length);
				StageObjectsManager.getDefault.addObject(equipment);
			}
			return _equipmentList;
		}


		public function createForthExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection=new ArrayCollection();

			var lightSource1:LightSource=createLaser("激光光源");
			equipmentList.addItem(lightSource1);

			var lens1:Lens=createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=createConvexLens("准直透镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var splitter:PolarizationBeamSplitter=createPolarizationBeamSplitter("偏振分光棱镜");
			equipmentList.addItem(splitter);

			var lens3:Lens=createConvexLens("成像透镜1", 40);
			equipmentList.addItem(lens3);

			equipmentList.addItem(createDifferentialCoefficientBoard("接收屏"));
			equipmentList.addItem(createLCLV("液晶光阀"));
			equipmentList.addItem(createArrowObjectPlane("物1", null, new ColorMaterial(0x00FFFF)));
			equipmentList.addItem(createArrowObjectPlane("物2", null, new ColorMaterial(0xFFFF00)));


			//lack "液晶光阀"
			var lens4:Lens=createConvexLens("成像透镜2", 80);
			equipmentList.addItem(lens4);

			//lack "图像透明片", "非相干照明光源"
			var lightSource2:LightSource=createLamps("照明光源");
			equipmentList.addItem(lightSource2);


			return equipmentList;

		}


		public function createThirdExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection=new ArrayCollection();

			var lightSource:LightSource=createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var lens1:Lens=createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=createConvexLens("准直透镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var fourierlens1:Lens=createFourierLens("傅里叶变换镜头1", 100);
			equipmentList.addItem(fourierlens1);
			var fourierlens2:Lens=createFourierLens("傅里叶变换镜头2", 100);
			equipmentList.addItem(fourierlens2);

			equipmentList.addItem(createObjectPlane("输入面"));
			equipmentList.addItem(createFourierGrating("傅立叶光栅"));
			equipmentList.addItem(createFourierBoard("接收屏"));


			return equipmentList;

		}

		/**
		 * Move equipments to default place.
		 */
		public function moveExperimentEquipmentsDefault():void
		{
			opitimize=false;

			for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{
				var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
				TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: i * LabXConstant.STAGE_WIDTH / _equipmentList.length, y: LabXConstant.LABX_OBJECT_HEIGHT / 2, z: LabXConstant.STAGE_DEPTH / 2, rotationY: 0, rotationX: 0, rotationZ: 0});
			}

			var timer:Timer=new Timer((LabXConstant.MOVE_DELAY + 1) * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			function onTimer(event:TimerEvent):void
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
				}
				timer.stop();
			}
			timer.start();
		}

		/**
		 * Move the equipments in first experiment to optimize place
		 */
		public function moveFirstExperimentEquipments():void
		{

			for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{

				var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;

				if (labXObject.name == "激光光源")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 50, z: 0});
				}
				else if (labXObject.name == "分光镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 200, z: 0, rotationY: 45});
				}
				else if (labXObject.name == "反射镜1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 200, z: 200, rotationY: 54.217});
				}
				else if (labXObject.name == "反射镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 300, z: 0, rotationY: -45});
				}
				else if (labXObject.name == "反射镜3")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 300, z: -166.7, rotationY: -54.2});
				}
				else if (labXObject.name == "扩束镜1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 380, z: 140, rotationY: 18.5});
				}
				else if (labXObject.name == "扩束镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 380, z: -140, rotationY: -18.5});
				}
				else if (labXObject.name == "准直物镜1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 500, z: 100, rotationY: 18.5});
				}
				else if (labXObject.name == "准直物镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 500, z: -100, rotationY: -18.5});
				}
				else if (labXObject.name == "接收屏")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: LabXConstant.DESK_WIDTH * 0.9, z: 0});
				}

			}
			var timer:Timer=new Timer((LabXConstant.MOVE_DELAY + 1) * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			function onTimer(event:TimerEvent):void
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
				}
				timer.stop();
			}
			timer.start();
		}

		/**
		 * Move the equipments in forth experiment to optimize place
		 */
		public function moveForthExperimentEquipments():void
		{

			for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{

				var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
				if (labXObject.name == "激光光源")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 50, z: 0});
				}
				else if (labXObject.name == "扩束镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 150, z: 0});
				}
				else if (labXObject.name == "成像透镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 250, z: 0});
				}
				else if (labXObject.name == "物2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 300, z: 0});
				}
				else if (labXObject.name == "偏振分光棱镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 400, z: 0, rotationY: 45});
				}
				else if (labXObject.name == "液晶光阀")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 500, z: 0});
				}
				else if (labXObject.name == "成像透镜1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 600, z: 0});
				}
				else if (labXObject.name == "物1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 700, z: 0});
				}
				else if (labXObject.name == "照明光源")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 800, z: 0, rotationY: 180});
				}
				else if (labXObject.name == "准直透镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 400, z: -100, rotationY: 90});
				}
				else if (labXObject.name == "接收屏")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 400, z: -230, rotationY: 90});
				}
			}
			var timer:Timer=new Timer((LabXConstant.MOVE_DELAY + 1) * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			function onTimer(event:TimerEvent):void
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
				}
				timer.stop();
			}
			timer.start();
		}

		/**
		 * Move the equipments in second experiment to optimize place
		 */
		public function moveSecondExperimentEquipments():void
		{

			for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{

				var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;

				if (labXObject.name == "激光光源")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 60, z: -100});
				}
				else if (labXObject.name == "扩束镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 200, z: -100});
				}
				else if (labXObject.name == "准直物镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 327, z: -100});
				}
				else if (labXObject.name == "分光镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 450, z: -100, rotationY: 32.5});
				}
				else if (labXObject.name == "反射镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 753, z: -100, rotationY: 32.5});
				}
				else if (labXObject.name == "反射镜1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 350, z: 110, rotationY: 32.5});
				}
				else if (labXObject.name == "透镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 500, z: 110});
				}
				else if (labXObject.name == "分光镜2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 650, z: 110, rotationY: 32.5});
				}
				else if (labXObject.name == "接收屏")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: LabXConstant.DESK_WIDTH * 0.9, z: 110});
				}

			}
			var timer:Timer=new Timer((LabXConstant.MOVE_DELAY + 1) * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			function onTimer(event:TimerEvent):void
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
				}
				timer.stop();
			}
			timer.start();
		}

		/**
		 * Move the equipments in third experiment to optimize place
		 */
		public function moveThirdExperimentEquipments():void
		{
			for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{

				var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;

				if (labXObject.name == "激光光源")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 50, z: 0});
				}
				else if (labXObject.name == "扩束镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 200, z: 0});
				}
				else if (labXObject.name == "准直透镜")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 326, z: 0});
				}
				else if (labXObject.name == "输入面")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 400, z: 0});
				}
				else if (labXObject.name == "傅里叶变换镜头1")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 500, z: 0});
				}
				else if (labXObject.name == "傅立叶光栅")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 600, z: 0});
				}
				else if (labXObject.name == "傅里叶变换镜头2")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 700, z: 0});
				}
				else if (labXObject.name == "接收屏")
				{
					TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: 800, z: 0});
				}

			}
			var timer:Timer=new Timer((LabXConstant.MOVE_DELAY + 1) * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			function onTimer(event:TimerEvent):void
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
				}
				timer.stop();
			}
			timer.start();
		}

		public function movingObjects():void
		{
			if (opitimize == false)
			{
				switch (_experimentIndex)
				{
					case LabXConstant.EXPERIMENT_FIRST:
						moveFirstExperimentEquipments();
						break;
					case LabXConstant.EXPERIMENT_SECOND:
						moveSecondExperimentEquipments();
						break;
					case LabXConstant.EXPERIMENT_THIRD:
						moveThirdExperimentEquipments();
						break;
					case LabXConstant.EXPERIMENT_FORTH:
						moveForthExperimentEquipments();
						break;
				}
				opitimize=true;
			}
			else
			{
				moveExperimentEquipmentsDefault();
			}
		}


		public function setDefaultLight(defaultLight:LightObject3D):void
		{
			light=defaultLight;
		}

		private function addDefaultExperimentEquipments(eqList:ArrayCollection):void
		{
			eqList.addItem(createParallelCrystal("平行平晶"));
			eqList.addItem(createParallelBeamDetector("剪切干涉屏幕"));
		}

		/**
		 * Create a Splitter Beam
		 */
		private function createBeamSplitter(name:String="分光镜", material:MaterialObject3D=null):BeamSplitter
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0xFF0000, 100);
			material.interactive=true;
			var beam:BeamSplitter=new BeamSplitter(name, material);
			return beam;
		}

		/**
		 * Create a Lens
		 */
		private function createConvexLens(name:String="透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var convexLens:ConvexLens=new ConvexLens(name, material, f);
			return convexLens;
		}

		/**
		 * create Differential Coefficient board zehnder interfBoard
		 */
		private function createDifferentialCoefficientBoard(name:String="接收屏", material:MaterialObject3D=null):DifferentialCoefficientBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new DifferentialCoefficientBoard(name, material);
		}

		/**
		 * create a board
		 */
		private function createDoubleSlitInterfBoard(name:String="接收屏", material:MaterialObject3D=null):DoubleSlitInterfBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new DoubleSlitInterfBoard(name, material);
		}

		/**
		 * Create equipment for first experiment
		 */
		private function createFirstExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection=new ArrayCollection();

			var lightSource:LightSource=createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var splitterBeam:BeamSplitter=createBeamSplitter("分光镜");
			splitterBeam.scale=0.5;
			equipmentList.addItem(splitterBeam);

			var mirror1:Mirror=createMirror("反射镜1")
			mirror1.scale=0.5;
			equipmentList.addItem(mirror1);

			var mirror2:Mirror=createMirror("反射镜2")
			mirror2.scale=0.5;
			equipmentList.addItem(mirror2);

			var mirror3:Mirror=createMirror("反射镜3")
			mirror3.scale=0.5;
			equipmentList.addItem(mirror3);

			var lens1:Lens=createConvexLens("扩束镜1", 18);
			lens1.scale=0.3;
			equipmentList.addItem(lens1);
			var lens2:Lens=createConvexLens("扩束镜2", 18);
			lens2.scale=0.3;
			equipmentList.addItem(lens2);
			var lens3:Lens=createConvexLens("准直物镜1", 108);
			lens3.scale=0.7;
			equipmentList.addItem(lens3);
			var lens4:Lens=createConvexLens("准直物镜2", 108);
			lens4.scale=0.7;
			equipmentList.addItem(lens4);

			equipmentList.addItem(createDoubleSlitInterfBoard("接收屏"));

			return equipmentList;
		}

		/**
		 * create a fourier board
		 */
		private function createFourierBoard(name:String="输出面", material:MaterialObject3D=null):FourierDisplayBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new FourierDisplayBoard(name, material);
		}

		/**
		 * Create a FourierGrating
		 */
		private function createFourierGrating(name:String="傅立叶光栅", material:MaterialObject3D=null):FourierGrating
		{
			material=material || new ColorMaterial(0x6ccff8, 1, true);
			material.interactive=true;
			var grating:FourierGrating=new FourierGrating(name, material);
			return grating;
		}

		/**
		 * Create a Lens
		 */
		private function createFourierLens(name:String="傅里叶变换透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var fourierLens:FourierLens=new FourierLens(name, material, f);
			return fourierLens;
		}

		/**
		 * Create a LCLV
		 */
		private function createLCLV(name:String="液晶光阀", material:MaterialObject3D=null):LCLV
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var lclv:LCLV=new LCLV(name, material);
			return lclv;
		}

		/***
		 * Create a Lamps
		 */
		private function createLamps(name:String="照明光源", material:MaterialObject3D=null):LightSource
		{
//		    var bitmap:Bitmap =new LIGHTSOURCE_TEXTURE() as Bitmap;
//			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
//			bitmapMaterial.interactive = true;
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x00FF00, 100);
			material.interactive=true;
			var lightSource:LightSource=new Lamps(name, material);
			return lightSource;
		}

		private function createLaser(name:String="激光光源", material:MaterialObject3D=null):LightSource
		{
//			var bitmap:Bitmap =new LIGHTSOURCE_TEXTURE() as Bitmap;
//			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
//			bitmapMaterial.interactive = true;
//			var lightSource:LightSource = new Laser(name, bitmapMaterial);
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x0000FF, 100);
			material.interactive=true;
			var lightSource:LightSource=new Laser(name, material);
			return lightSource;
		}

		/**
		 * create mach zehnder interfBoard
		 */
		private function createMachZehnderInterfBoard(name:String="接收屏", material:MaterialObject3D=null):MachZehnderInterfBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new MachZehnderInterfBoard(name, material);
		}

		/**
		 * Create a Mirror
		 */
		private function createMirror(name:String="反射镜", material:MaterialObject3D=null):Mirror
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var mirror:Mirror=new Mirror(name, material);
			return mirror;
		}

		/**
		 * Create a ObjectPlane
		 */
		private function createObjectPlane(name:String="输入面", material:MaterialObject3D=null):ObjectPlane
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var plane:ObjectPlane=new ObjectPlane(name, material);
			return plane;
		}

		private function createParallelBeamDetector(name:String="剪切干涉屏幕", material:MaterialObject3D=null):ParallelBeamDetector
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new ParallelBeamDetector(name, material);
		}
		
		/**
		 * Create a ParallelCrystal
		 */
		private function createParallelCrystal(name:String="反射镜", material:MaterialObject3D=null):ParallelCrystal
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var crystal:ParallelCrystal=new ParallelCrystal(name, material);
			return crystal;
		}

		/**
		 * Create a PBS
		 */
		private function createPolarizationBeamSplitter(name:String="分光镜", material:MaterialObject3D=null):PolarizationBeamSplitter
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0xFF0000, 100);
			material.interactive=true;
			var beam:PolarizationBeamSplitter=new PolarizationBeamSplitter(name, material);
			return beam;
		}

//		/**
//		 * create a retangle object plane
//		 */
//		private function createRetangleObjectPlane(name:String="物1", material:MaterialObject3D=null):RetangleObjectPlane
//		{
//			material=material || new ColorMaterial(0x262626, 1, true);
//			return new RetangleObjectPlane(name, material);
//		}

		/**
		 * Create equipment for second experiment
		 */
		private function createSecondExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection=new ArrayCollection();

			var lightSource:LightSource=createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var lens1:Lens=createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=createConvexLens("准直物镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var splitterBeam:BeamSplitter=createBeamSplitter("分光镜");
			equipmentList.addItem(splitterBeam);

			var splitterBeam2:BeamSplitter=createBeamSplitter("分光镜2");
			equipmentList.addItem(splitterBeam2);

			var mirror1:Mirror=createMirror("反射镜1")
			equipmentList.addItem(mirror1);

			var mirror2:Mirror=createMirror("反射镜2")
			equipmentList.addItem(mirror2);

			var lens4:Lens=createConvexLens("透镜", 400);
			lens4.scale=0.8;
			equipmentList.addItem(lens4);

			equipmentList.addItem(createMachZehnderInterfBoard("接收屏"));

			return equipmentList;
		}

		/**
		 *  create a ttype plane
		 */
		private function createArrowObjectPlane(name:String="物2", material:MaterialObject3D=null, objMaterial:MaterialObject3D=null):ArrowObjectPlane
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new ArrowObjectPlane(name, material, objMaterial);
		}

		/**
		 *  remove the last experiment's equipments
		 */
		private function remove():void
		{
			StageObjectsManager.getDefault.rayManager.closeAllLight();
			StageObjectsManager.getDefault.rayManager.clearRays();
			if (_equipmentList != null)
			{
				for (var i:int=0; i < _equipmentList.length; i++)
				{
					var equipment:LabXObject=_equipmentList.getItemAt(i) as LabXObject;
					StageObjectsManager.getDefault.removeObject(equipment);
				}
			}
			_equipmentList=null;
		}
	}
}