package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import com.greensock.TweenLite;
	
	public class ThirdExperiment extends AbsractExperiment
	{
		public function ThirdExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void{
			var lightSource:LightSource=ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var lens1:Lens=ExperimentManager.createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=ExperimentManager.createConvexLens("准直透镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var fourierlens1:Lens=ExperimentManager.createFourierLens("傅里叶变换镜头1", 100);
			equipmentList.addItem(fourierlens1);
			var fourierlens2:Lens=ExperimentManager.createFourierLens("傅里叶变换镜头2", 100);
			equipmentList.addItem(fourierlens2);

			equipmentList.addItem(ExperimentManager.createObjectPlane("输入面"));
			equipmentList.addItem(ExperimentManager.createFourierGrating("傅立叶光栅"));
			equipmentList.addItem(ExperimentManager.createFourierBoard("接收屏"));

				
		}
		
		override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void{
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
		
		override public function getExperimentID():int{
		    return LabXConstant.EXPERIMENT_THIRD;
		}
		
	}
}