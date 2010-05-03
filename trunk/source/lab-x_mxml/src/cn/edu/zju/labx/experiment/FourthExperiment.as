package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.beam.PolarizationBeamSplitter;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import com.greensock.TweenLite;
	
	import org.papervision3d.materials.ColorMaterial;
	
	public class FourthExperiment extends AbstractExperiment
	{
		public function FourthExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void{
			var lightSource2:LightSource=ExperimentManager.createLamps("照明光源");
			equipmentList.addItem(lightSource2);
			var lightSource1:LightSource=ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource1);

			var lens1:Lens=ExperimentManager.createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=ExperimentManager.createConvexLens("准直透镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var splitter:PolarizationBeamSplitter=ExperimentManager.createPolarizationBeamSplitter("偏振分光棱镜");
			equipmentList.addItem(splitter);

			var lens3:Lens=ExperimentManager.createConvexLens("成像透镜1", 40);
			equipmentList.addItem(lens3);

			equipmentList.addItem(ExperimentManager.createDifferentialCoefficientBoard("接收屏"));
			equipmentList.addItem(ExperimentManager.createLCLV("液晶光阀"));
			equipmentList.addItem(ExperimentManager.createArrowObjectPlane("物1", null, new ColorMaterial(0x00FFFF)));
			equipmentList.addItem(ExperimentManager.createArrowObjectPlane("物2", null, new ColorMaterial(0xFFFF00)));

			var lens4:Lens=ExperimentManager.createConvexLens("成像透镜2", 80);
			equipmentList.addItem(lens4);

			}
			
			override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void{
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
			override public function getExperimentID():int{
		   		 return LabXConstant.EXPERIMENT_FORTH;
			}	
	}
}