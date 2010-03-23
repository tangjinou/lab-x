package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.objects.ConvexLens;
	import cn.edu.zju.labx.objects.DoubleSlitInterfBoard;
	import cn.edu.zju.labx.objects.FourierLens;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.Lens;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.MachZehnderInterfBoard;
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
		
		
		private var _experimentIndex:int;
		private var _equipmentList:ArrayCollection;
		
		/**
		 * Create the equipment according to the experiment
		 */
		public function createExperimentEquipments(experimentIndex:Number):ArrayCollection
		{
			this._experimentIndex = experimentIndex;
			switch (experimentIndex)
			{
				case LabXConstant.EXPERIMENT_FIRST:
					_equipmentList = createFirstExperimentEquipments();
					break;
				case LabXConstant.EXPERIMENT_SECOND:
					_equipmentList = createSecondExperimentEquipments();
					break;
			}
			
			for (var i:int=0; i<_equipmentList.length; i++)
			{
				var equipment:LabXObject = _equipmentList.getItemAt(i) as LabXObject;
				equipment.moveUp(LabXConstant.LABX_OBJECT_HEIGHT/2);
				equipment.moveForward(LabXConstant.STAGE_DEPTH/2);
				equipment.moveRight(i*LabXConstant.STAGE_WIDTH/_equipmentList.length);
				StageObjectsManager.getDefault.addObject(equipment);
			}
			
			return _equipmentList;
		}
		
		
		
		/**
		 * Create equipment for first experiment
		 */
		private function createFirstExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			
			var lightSource:LightSource = createLightSource("激光光源");
            equipmentList.addItem(lightSource);
            
            var splitterBeam:SplitterBeam = createSplitterBeam("分光镜");
            equipmentList.addItem(splitterBeam);
            
            var mirror1:Mirror = createMirror("反射镜1")
			equipmentList.addItem(mirror1);
			
            var mirror2:Mirror = createMirror("反射镜2")
			equipmentList.addItem(mirror2);
			
            var mirror3:Mirror = createMirror("反射镜3")
			equipmentList.addItem(mirror3);
			
			var lens1:Lens = createConvexLens("扩束镜1", 18);
			lens1.scale = 0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens = createConvexLens("扩束镜2", 18);
			lens2.scale = 0.4;
			equipmentList.addItem(lens2);
			var lens3:Lens = createConvexLens("准直物镜1", 108);
			lens3.scale = 0.8;
			equipmentList.addItem(lens3);
			var lens4:Lens = createConvexLens("准直物镜2", 108);
			lens4.scale = 0.8;
			equipmentList.addItem(lens4);
			
			equipmentList.addItem(createDoubleSlitInterfBoard("接收屏"));
			
			return equipmentList;
		}
		
		/**
		 * Move the equipments in first experiment to optimize place
		 */
		public function moveFirstExperimentEquipments():void{
		
		      for(var i:int=0;i<StageObjectsManager.getDefault.getObjectList().length;i++){
		      
		          var labXObject:LabXObject = StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
		          
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
         			   for(var i:int=0;i<_equipmentList.length;i++){
         			       StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
         			   }
         			   timer.stop();
                    }
              timer.start();
		}
				
		/**
		 * Create equipment for second experiment
		 */
		private function createSecondExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			
			var lightSource:LightSource = createLightSource("激光光源");
            equipmentList.addItem(lightSource);
            
			var lens1:Lens = createConvexLens("扩束镜", 18);
			lens1.scale = 0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens = createConvexLens("准直物镜", 108);
			lens2.scale = 0.8;
			equipmentList.addItem(lens2);
			
            var splitterBeam:SplitterBeam = createSplitterBeam("分光镜");
            equipmentList.addItem(splitterBeam);
            
             var splitterBeam2:SplitterBeam = createSplitterBeam("分光镜2");
            equipmentList.addItem(splitterBeam2);
            
            var mirror1:Mirror = createMirror("反射镜1")
			equipmentList.addItem(mirror1);
			
            var mirror2:Mirror = createMirror("反射镜2")
			equipmentList.addItem(mirror2);
			
			var lens4:Lens = createConvexLens("透镜", 400);
			lens4.scale = 0.8;
			equipmentList.addItem(lens4);
			
			equipmentList.addItem(createMachZehnderInterfBoard("接收屏"));
			
			return equipmentList;
		}
		
		/**
		 * Move the equipments in second experiment to optimize place
		 */
		public function moveSecondExperimentEquipments():void{
		
		      for(var i:int=0;i<StageObjectsManager.getDefault.getObjectList().length;i++){
		      
		          var labXObject:LabXObject =StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
		          
		          if(labXObject.name =="激光光源"){
		             TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:60, z:-100});
		          }
		          else if(labXObject.name =="扩束镜"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:200, z:-100});	
		          }
		          else if(labXObject.name =="准直物镜"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:327,z:-100});	
		          }
		          else if(labXObject.name =="分光镜"){
		             TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:450,z:-100,rotationY:32.5});
		          }
		          else if(labXObject.name =="反射镜2"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:753,z:-100,rotationY:32.5});	
		          }
		          else if(labXObject.name =="反射镜1"){
                     TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:350,z:110,rotationY:32.5});		            
		          }
		          else if(labXObject.name =="透镜"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:500,z:110});	
		          }
		          else if(labXObject.name =="分光镜2"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:650,z:110,rotationY:32.5});	
		          }
		          else if(labXObject.name =="接收屏"){ 
		          	 TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:LabXConstant.DESK_WIDTH*0.9,z:110});	
		          }
                     
		      }
		      var timer:Timer= new Timer((LabXConstant.MOVE_DELAY+1)*1000);
		      timer.addEventListener(TimerEvent.TIMER, onTimer);
    				function onTimer(event:TimerEvent):void{
         			   for(var i:int=0;i<_equipmentList.length;i++){
         			       StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
         			   }
         			   timer.stop();
                    }
              timer.start();
		}
		
		
		public function createThirdExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			
			var lightSource:LightSource = createLightSource("激光光源");
            equipmentList.addItem(lightSource);
            
			var lens1:Lens = createConvexLens("扩束镜", 18);
			lens1.scale = 0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens = createConvexLens("准直透镜", 108);
			lens2.scale = 0.8;
			equipmentList.addItem(lens2);
			
            var fourierlens1:Lens = createFourierLens("傅里叶变换镜头1");
            equipmentList.addItem(fourierlens1);
            var fourierlens2:Lens = createFourierLens("傅里叶变换镜头2");
            equipmentList.addItem(fourierlens2);
            
            //lack of 3 equipment, "输入面", "频谱面", "输出面"
			
			equipmentList.addItem(createMachZehnderInterfBoard("接收屏"));
			
			return equipmentList;
			
		}
		
		
		public function createForthExperimentEquipments():ArrayCollection
		{
			var equipmentList:ArrayCollection = new ArrayCollection();
			
			var lightSource:LightSource = createLightSource("激光光源");
            equipmentList.addItem(lightSource);
            
			var lens1:Lens = createConvexLens("扩束镜", 18);
			lens1.scale = 0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens = createConvexLens("准直透镜", 108);
			lens2.scale = 0.8;
			equipmentList.addItem(lens2);
			
			var splitterBeam:SplitterBeam = createSplitterBeam("偏振分光镜");
			equipmentList.addItem(splitterBeam);
			
			var lens3:Lens = createConvexLens("成像透镜", 80);
			equipmentList.addItem(lens3);
			
			equipmentList.addItem(createMachZehnderInterfBoard("接收屏"));
			
			//lack "液晶光阀"
			var lens4:Lens = createConvexLens("成像透镜", 80);
			equipmentList.addItem(lens4);
			
			//lack "图像透明片", "非相干照明光源"
			
			
			return equipmentList;
			
		}
		
		


		/*******************************************************************************************************
		 * move the objects to the right place
		 *******************************************************************************************************/
		private var opitimize:Boolean = false;
		public function movingObjects():void{
		   if(opitimize == false){  
		    		switch (_experimentIndex)
					{
						case LabXConstant.EXPERIMENT_FIRST:
					 		moveFirstExperimentEquipments();
					 		break;
						case LabXConstant.EXPERIMENT_SECOND:
					 		moveSecondExperimentEquipments();
					 		break;
					}
			  opitimize = true;
		   }
	       else{
	          moveExperimentEquipmentsDefault();
	          opitimize = false;
	       }	
		}
		
		/**
		 * Move equipments to default place.
		 */
		public function  moveExperimentEquipmentsDefault():void{
			for(var i:int=0;i<StageObjectsManager.getDefault.getObjectList().length;i++){
		        var labXObject:LabXObject = StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
	          	TweenLite.to(labXObject,LabXConstant.MOVE_DELAY,{x:i*LabXConstant.STAGE_WIDTH/_equipmentList.length,y:LabXConstant.LABX_OBJECT_HEIGHT/2,z:LabXConstant.STAGE_DEPTH/2,rotationY:0,rotationX:0,rotationZ:0});
		    }
		    
		   	var timer:Timer= new Timer((LabXConstant.MOVE_DELAY+1)*1000);
		      timer.addEventListener(TimerEvent.TIMER, onTimer);
    				function onTimer(event:TimerEvent):void{
         			   for(var i:int=0;i<_equipmentList.length;i++){
         			       StageObjectsManager.getDefault.objectStateChanged(_equipmentList.getItemAt(i) as LabXObject);
         			   }
         			   timer.stop();
                    }
              timer.start();
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
		private function createConvexLens(name:String = "透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material = material || new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			material.interactive = true;
			var convexLens:ConvexLens = new ConvexLens(name,material, f);
			return convexLens;
		}
		
		/**
		 * Create a Lens
		 */
		private function createFourierLens(name:String = "傅里叶变换透镜", f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH, material:MaterialObject3D=null):Lens
		{
			material = material || new PhongMaterial(light,0xFFFFFF,0x6ccff8,100);
			material.interactive = true;
			var fourierLens:FourierLens = new FourierLens(name,material, f);
			return fourierLens;
		}
		
		/**
		 * create a board
		 */
		private function createDoubleSlitInterfBoard(name:String = "接收屏", material:MaterialObject3D=null):DoubleSlitInterfBoard
		{
			material = material || new ColorMaterial(0x262626, 1, true);
			return new DoubleSlitInterfBoard(name, material);
		}
		
		private function createMachZehnderInterfBoard(name:String = "接收屏", material:MaterialObject3D=null):MachZehnderInterfBoard
		{
			material = material || new ColorMaterial(0x262626, 1, true);
			return new MachZehnderInterfBoard(name, material);
		}
		

	}
}