package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	/**
	 * This experiment is aimed to let the student to learn how 
	 * to ajust the <b>lightsource</b> state
	 */
	public class PreStepOneExperiment extends AbstractPreStepExperiment
	{
		
		
		public function PreStepOneExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void
		{
			var lightSource:LightSource = ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource);
			lightSource.rotationX += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			lightSource.rotationY += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			lightSource.rotationZ += Math.floor((Math.random() - 0.5) * 20);//random range (-10, 10)
			
			equipmentList.addItem(ExperimentManager.createMachZehnderInterfBoard("接收屏"));
		}
		
		override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void
		{
			//DO Nothing
		}
		
		override public function getExperimentID():int
		{
			return ExperimentFactory.PRE_STEP_ONE_EXPERIMENT;
		}
		
	}
}