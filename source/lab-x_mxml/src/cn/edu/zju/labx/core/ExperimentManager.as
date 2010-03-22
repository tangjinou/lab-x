package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.Board;
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Mirror;
	import cn.edu.zju.labx.objects.SplitterBeam;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		
		
		private var experimentIndex:int;
		
		public function get experimentId():int
		{
			return experimentIndex;
		}
		
		public function createExperimentEquipments(experimentIndex:Number):ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			this.experimentIndex = experimentIndex;
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
		
		
		private var equipmentList:ArrayCollection;
		
		/**
		 * Create equipment for first experiment
		 */
		private function createFirstExperimentEquipments():ArrayCollection
		{
			equipmentList = new ArrayCollection();
			
			var lightSource:LightSource = createLightSource("激光光源");
            lightSource.moveDown(10);
            equipmentList.addItem(lightSource);
            
            var splitterBeam:SplitterBeam = createSplitterBeam("分光镜");
            equipmentList.addItem(splitterBeam);
            
            var mirror1:Mirror = createMirror("反射镜1")
			equipmentList.addItem(mirror1);
			
            var mirror2:Mirror = createMirror("反射镜2")
			equipmentList.addItem(mirror2);
			
            var mirror3:Mirror = createMirror("反射镜3")
			equipmentList.addItem(mirror3);
			
			var lens1:Lens = createLens("扩束镜1", 18);
			lens1.scale = 0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens = createLens("扩束镜2", 18);
			lens2.scale = 0.4;
			equipmentList.addItem(lens2);
			var lens3:Lens = createLens("准直物镜1", 108);
			lens3.scale = 0.8;
			equipmentList.addItem(lens3);
			var lens4:Lens = createLens("准直物镜2", 108);
			lens4.scale = 0.8;
			equipmentList.addItem(lens4);
			
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
		
		public function movingObjects():void{
		     
		    switch (experimentIndex)
			{
				case LabXConstant.EXPERIMENT_FIRST:
					 moveFirstExperimentEquipments();
					 break;
			}
		
		}	

		public function moveFirstExperimentEquipments():void{
		
		      for(var i:int=0;i<equipmentList.length;i++){
		      
		          var labXObject:LabXObject = equipmentList.getItemAt(i) as LabXObject;
		          
		          if(labXObject.name =="激光光源"){
		             TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:50,z:0});
		          }
		          else if(labXObject.name =="分光镜"){
		             TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:200,z:0,rotationY:45});
		          }
		          else if(labXObject.name =="反射镜1"){
                     TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:200,z:200,rotationY:54.217});		            
		          }
		          else if(labXObject.name =="反射镜2"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:300,z:0,rotationY:-45});	
		          }
		          else if(labXObject.name =="反射镜3"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:300,z:-166.7,rotationY:-54.2});	
		          }
		          else if(labXObject.name =="扩束镜1"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:380,z:140,rotationY:18.5});	
		          }
		          else if(labXObject.name =="扩束镜2"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:380,z:-140,rotationY:-18.5});	
		          }
		          else if(labXObject.name =="准直物镜1"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:500,z:100,rotationY:18.5});	
		          }
		          else if(labXObject.name =="准直物镜2"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:500,z:-100,rotationY:-18.5});	
		          }
		          else if(labXObject.name =="接收屏"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:LabXConstant.DESK_WIDTH*0.9,z:0});	
		          }
                     
		      }
		      var timer:Timer= new Timer((LabXConstant.MOVE_DELAY+1)*1000);
		      timer.addEventListener(TimerEvent.TIMER, onTimer);
    				function onTimer(event:TimerEvent):void{
         			   for(var i:int=0;i<equipmentList.length;i++){
         			       StageObjectsManager.getDefault.objectStateChanged(equipmentList.getItemAt(i) as LabXObject);
         			   }
         			   timer.stop();
                    }
              timer.start();
		}
	}
}