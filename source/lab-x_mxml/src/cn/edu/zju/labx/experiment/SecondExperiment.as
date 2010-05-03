package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.OptimizeMovingState;
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.beam.BeamSplitter;
	import cn.edu.zju.labx.objects.beam.Mirror;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import com.greensock.TweenLite;
	
	import mx.collections.ArrayCollection;
	
	public class SecondExperiment extends AbstractExperiment
	{
		public function SecondExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void{
			var lightSource:LightSource=ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var lens1:Lens=ExperimentManager.createConvexLens("扩束镜", 18);
			lens1.scale=0.4;
			equipmentList.addItem(lens1);
			var lens2:Lens=ExperimentManager.createConvexLens("准直物镜", 108);
			lens2.scale=0.8;
			equipmentList.addItem(lens2);

			var splitterBeam:BeamSplitter=ExperimentManager.createBeamSplitter("分光镜");
			equipmentList.addItem(splitterBeam);

			var splitterBeam2:BeamSplitter=ExperimentManager.createBeamSplitter("分光镜2");
			equipmentList.addItem(splitterBeam2);

			var mirror1:Mirror=ExperimentManager.createMirror("反射镜1")
			equipmentList.addItem(mirror1);

			var mirror2:Mirror=ExperimentManager.createMirror("反射镜2")
			equipmentList.addItem(mirror2);

			var lens4:Lens=ExperimentManager.createConvexLens("透镜", 400);
			lens4.scale=0.8;
			equipmentList.addItem(lens4);
			equipmentList.addItem(ExperimentManager.createMachZehnderInterfBoard("接收屏"));
		}
		
		override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void{
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
		
		override public function getExperimentID():int{
				return LabXConstant.EXPERIMENT_SECOND;
		}
		
	}
}