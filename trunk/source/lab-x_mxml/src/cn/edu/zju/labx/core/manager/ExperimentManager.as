package cn.edu.zju.labx.core.manager
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.experiment.ExperimentFactory;
	import cn.edu.zju.labx.experiment.IExperiment;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.beam.ArrowObjectPlane;
	import cn.edu.zju.labx.objects.beam.BeamSplitter;
	import cn.edu.zju.labx.objects.beam.FourierGrating;
	import cn.edu.zju.labx.objects.beam.LCLV;
	import cn.edu.zju.labx.objects.beam.Mirror;
	import cn.edu.zju.labx.objects.beam.ObjectPlane;
	import cn.edu.zju.labx.objects.beam.ParallelCrystal;
	import cn.edu.zju.labx.objects.beam.PolarizationBeamSplitter;
	import cn.edu.zju.labx.objects.board.DifferentialCoefficientBoard;
	import cn.edu.zju.labx.objects.board.DoubleSlitInterfBoard;
	import cn.edu.zju.labx.objects.board.FourierDisplayBoard;
	import cn.edu.zju.labx.objects.board.MachZehnderInterfBoard;
	import cn.edu.zju.labx.objects.board.ParallelBeamDetector;
	import cn.edu.zju.labx.objects.dock.BasicDock;
	import cn.edu.zju.labx.objects.lens.ConvexLens;
	import cn.edu.zju.labx.objects.lens.FourierLens;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.Lamps;
	import cn.edu.zju.labx.objects.lightSource.Laser;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
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
		private static var light:LightObject3D;
		
		
		private var defaultEquipment_size:int = 2;

		/*******************************************************************************************************
		 * move the objects to the right place
		 *******************************************************************************************************/
		private var opitimize:Boolean=false;
        
        
        private var expriment:IExperiment;
		/**
		 * Create the equipment according to the experiment
		 */
		public function createExperimentEquipments(experimentIndex:Number):ArrayCollection
		{
			this._experimentIndex=experimentIndex;
			remove();

            opitimize = false;
            expriment = ExperimentFactory.getDefault.createExperiment(experimentIndex);
			expriment.createExperimentEquipments();
			expriment.addDefaultExperimentEquipments();
			
//			addDefaultExperimentEquipments(_equipmentList);
			for (var i:int=0; i < expriment.getEquipmentList().length; i++)
			{
				var equipment:LabXObject=expriment.getEquipmentList().getItemAt(i) as LabXObject;
				equipment.moveUp(LabXConstant.LABX_OBJECT_HEIGHT / 2);
				equipment.moveForward(LabXConstant.STAGE_DEPTH / 2);
				equipment.moveRight(i * LabXConstant.STAGE_WIDTH / expriment.getEquipmentList().length);
				StageObjectsManager.getDefault.addObject(equipment);
				if(equipment.name == "接收屏")
				{
					StageObjectsManager.getDefault.setResultObject(equipment);
				}
			}
			_equipmentList = expriment.getEquipmentList();
			return _equipmentList;
		}
		
		
		/**
		 *  Move next step
		 */
		public function movingNextStep():void{
            expriment.nextState();
            refresh();
		}
		/**
		 *  Move pre step
		 */
		public function movingPreStep():void{
			expriment.moveExperimentEquipmentDefault();
			refresh();
		}
		
		/**
		 * Move Objects to it's optimize place
		 */
		public function movingObjects():void
		{
			if (opitimize == false)
			{
                expriment.moveAllExperimentEquipmentsOptimize();
				opitimize = true;
			}
			else
			{   
                expriment.moveAllExperimentEquipmentsDefault();
                opitimize = false;
			}
			refresh();
		}


		/**
		 * Move equipments to default place.
		 */
		public function moveAllExperimentEquipmentsDefault():void
		{
			opitimize=false;
            expriment.moveAllExperimentEquipmentsDefault();
		}
		
		/***
		 *  Refresh the state of object
		 */
		private function refresh():void{
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
		 * Set the defualt light for the created object's materials
		 */
		public function setDefaultLight(defaultLight:LightObject3D):void
		{
			light=defaultLight;
		}

		public static function  addDefaultExperimentEquipments(eqList:ArrayCollection):void
		{
			eqList.addItem(createParallelCrystal("平行平晶"));
			eqList.addItem(createParallelBeamDetector("剪切干涉屏幕"));
		}

		/**
		 * Create a Splitter Beam
		 */
		public static function createBeamSplitter(name:String="分光镜", material:MaterialObject3D=null):BeamSplitter
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0xFF0000, 100);
			material.interactive=true;
			var beam:BeamSplitter=new BeamSplitter(name, material);
			return beam;
		}

		/**
		 * Create a Lens
		 */
		public static function createConvexLens(name:String="透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var convexLens:ConvexLens=new ConvexLens(name, material, f);
			return convexLens;
		}

		/**
		 * create Differential Coefficient board zehnder interfBoard
		 */
		public static function createDifferentialCoefficientBoard(name:String="接收屏", material:MaterialObject3D=null):DifferentialCoefficientBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new DifferentialCoefficientBoard(name, material);
		}

		/**
		 * create a board
		 */
		public static function createDoubleSlitInterfBoard(name:String="接收屏", material:MaterialObject3D=null):DoubleSlitInterfBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new DoubleSlitInterfBoard(name, material);
		}

		

		/**
		 * create a fourier board
		 */
		public static function createFourierBoard(name:String="输出面", material:MaterialObject3D=null):FourierDisplayBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new FourierDisplayBoard(name, material);
		}

		/**
		 * Create a FourierGrating
		 */
		public static function createFourierGrating(name:String="傅立叶光栅", material:MaterialObject3D=null):FourierGrating
		{
			material=material || new ColorMaterial(0x6ccff8, 1, true);
			material.interactive=true;
			var grating:FourierGrating=new FourierGrating(name, material);
			return grating;
		}

		/**
		 * Create a Lens
		 */
		public static function createFourierLens(name:String="傅里叶变换透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var fourierLens:FourierLens=new FourierLens(name, material, f);
			return fourierLens;
		}

		/**
		 * Create a LCLV
		 */
		public static function createLCLV(name:String="液晶光阀", material:MaterialObject3D=null):LCLV
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var lclv:LCLV=new LCLV(name, material);
			return lclv;
		}

		/***
		 * Create a Lamps
		 */
		public static function createLamps(name:String="照明光源", material:MaterialObject3D=null):LightSource
		{
//		    var bitmap:Bitmap =new LIGHTSOURCE_TEXTURE() as Bitmap;
//			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
//			bitmapMaterial.interactive = true;
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x00FF00, 100);
			material.interactive=true;
			var lightSource:LightSource=new Lamps(name, material);
			return lightSource;
		}

		public static function createLaser(name:String="激光光源", material:MaterialObject3D=null):LightSource
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
		public static function createMachZehnderInterfBoard(name:String="接收屏", material:MaterialObject3D=null):MachZehnderInterfBoard
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new MachZehnderInterfBoard(name, material);
		}

		/**
		 * Create a Mirror
		 */
		public static function createMirror(name:String="反射镜", material:MaterialObject3D=null):Mirror
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var mirror:Mirror=new Mirror(name, material);
			return mirror;
		}

		/**
		 * Create a ObjectPlane
		 */
		public static function createObjectPlane(name:String="输入面", material:MaterialObject3D=null):ObjectPlane
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var plane:ObjectPlane=new ObjectPlane(name, material);
			return plane;
		}

		public static function createParallelBeamDetector(name:String="剪切干涉屏幕", material:MaterialObject3D=null):ParallelBeamDetector
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new ParallelBeamDetector(name, material);
		}
		
		/**
		 * Create a ParallelCrystal
		 */
		public static function createParallelCrystal(name:String="反射镜", material:MaterialObject3D=null):ParallelCrystal
		{
			material=material || new PhongMaterial(light, 0xFFFFFF, 0x6ccff8, 100);
			material.interactive=true;
			var crystal:ParallelCrystal=new ParallelCrystal(name, material);
			return crystal;
		}

		/**
		 * Create a PBS
		 */
		public static function createPolarizationBeamSplitter(name:String="分光镜", material:MaterialObject3D=null):PolarizationBeamSplitter
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
		 *  create a ttype plane
		 */
		public static function createArrowObjectPlane(name:String="物2", material:MaterialObject3D=null, objMaterial:MaterialObject3D=null):ArrowObjectPlane
		{
			material=material || new ColorMaterial(0x262626, 1, true);
			return new ArrowObjectPlane(name, material, objMaterial);
		}
		
		

		/**
		 *  remove the last experiment's equipments
		 */
		public  function remove():void
		{
			StageObjectsManager.getDefault.rayManager.closeAllLight();
            if(expriment!= null)
            	expriment.remove();
		}
	}
}