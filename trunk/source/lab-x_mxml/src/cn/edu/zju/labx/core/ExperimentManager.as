package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Mirror;
	import cn.edu.zju.labx.objects.SplitterBeam;
	
	import flash.display.Bitmap;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.proto.LightObject3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	
	public class ExperimentManager
	{
		private var light:LightObject3D;
		
		/*************************************************************************
		 * Sigleton Method to make sure there are only one ExperimentManager 
		 * in an application
		 * ***********************************************************************
		 */
		private static var instance:ExperimentManager = null;
		public function ExperimentManager()
		{
		}
		
		public static function get getDefault():ExperimentManager
		{
			if (instance == null) {
				instance = new ExperimentManager();
			}
			return instance;
		}
		
		
		public function setDefaultLight(defaultLight:LightObject3D):void
		{
			light = defaultLight;
		}
		
		public function createExperimentEquipments(experimentIndex:Number):ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			switch (experimentIndex)
			{
				case LabXConstant.EXPERIMENT_FIRST:
					equipmentList = createFirstExperimentEquipments();
					break;
			}
			
			for (var i:int=0; i<equipmentList.length; i++)
			{
				var equipment:LabXObject = equipmentList.getItemAt(i) as LabXObject;
				equipment.moveUp(LabXConstant.LABX_OBJECT_HEIGHT/2);
				equipment.moveForward(LabXConstant.STAGE_DEPTH/2);
				equipment.moveRight(i*LabXConstant.STAGE_WIDTH/equipmentList.length);
				StageObjectsManager.getDefault.addObject(equipment);
			}
			return equipmentList;
		}
		
		
		/**
		 * Create equipment for first experiment
		 */
		private function createFirstExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			
            equipmentList.addItem(createLightSource("激光光源"));
            equipmentList.addItem(createSplitterBeam("分光镜"));
			equipmentList.addItem(createMirror("反射镜1"));
			equipmentList.addItem(createMirror("反射镜2"));
			equipmentList.addItem(createMirror("反射镜3"));
			equipmentList.addItem(createLens("扩束镜1", 18));
			equipmentList.addItem(createLens("扩束镜2", 18));
			equipmentList.addItem(createLens("准直物镜1", 108));
			equipmentList.addItem(createLens("准直物镜2", 108));
			equipmentList.addItem(createBoard("接收屏"));
			
			return equipmentList;
		}
		
		/**
		 * Create a ray light source
		 */
		[Embed (source="../assets/textures/metal.jpg")]
		public var LIGHTSOURCE_TEXTURE:Class;
		private function createLightSource(name:String = "激光光源"):LightSource
		{
			var bitmap:Bitmap =new LIGHTSOURCE_TEXTURE() as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData);
			bitmapMaterial.interactive = true;
			var lightSource:LightSource = new LightSource(name, bitmapMaterial);
			return lightSource;
		}

		/**
		 * Create a Splitter Beam
		 */
		private function createSplitterBeam(name:String = "分光镜", material:MaterialObject3D=null):SplitterBeam
		{
			material = material || new PhongMaterial(light,0xFFFFFF,0xFF0000,100);
			material.interactive = true;
			var beam:SplitterBeam =new SplitterBeam(name, material);
			return beam;
		}
		
		/**
		 * Create a Mirror
		 */
		private function createMirror(name:String = "反射镜", material:MaterialObject3D=null):Mirror
		{
		    material = material || new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			material.interactive = true;
			var mirror:Mirror =new Mirror(name, material);
			return mirror;
		}
		
		/**
		 * Create a Lens
		 */
		private function createLens(name:String = "透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material = material || new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			material.interactive = true;
			var convexLens:ConvexLens = new ConvexLens(name,material, f);
			return convexLens;
		}
		
		/**
		 * create a board
		 */
		private function createBoard(name:String = "接收屏", material:MaterialObject3D=null):Board
		{
			material = material || new ColorMaterial(0x262626, 1, true);
			var board:Board = new  Board(name, material);
			return board;
		}
	}
}