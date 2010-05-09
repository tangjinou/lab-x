package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	
	/**
	 * This experiment is aim to let the student learn how to ajust convex lens.
	 *
	 */
	public class PreStepTwoExperiment extends AbstractPreStepExperiment
	{
		public function PreStepTwoExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void
		{
			var lightSource:LightSource = ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource);
			
			var lens:Lens = ExperimentManager.createConvexLens("透镜", 80);
			lens.rotationX += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			lens.rotationY += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			lens.rotationZ += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			lens.height += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			equipmentList.addItem(lens);
			
			equipmentList.addItem(ExperimentManager.createMachZehnderInterfBoard("接收屏"));
		}
		
		override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void
		{
			//DO Nothing
		}
		
		override public function getExperimentID():int
		{
			return ExperimentFactory.PRE_STEP_TWO_EXPERIMENT;
		}
		
	}
}