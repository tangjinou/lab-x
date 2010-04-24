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
	
	public class FirstExperiment extends AbsractExperiment
	{
		public function FirstExperiment()
		{
			super();
		}
		
		override public function createExperimentEquipments():void{
			var lightSource:LightSource=ExperimentManager.createLaser("激光光源");
			equipmentList.addItem(lightSource);

			var splitterBeam:BeamSplitter=ExperimentManager.createBeamSplitter("分光镜");
			splitterBeam.scale=0.5;
			equipmentList.addItem(splitterBeam);

			var mirror1:Mirror=ExperimentManager.createMirror("反射镜1")
			mirror1.scale=0.5;
			equipmentList.addItem(mirror1);

			var mirror2:Mirror=ExperimentManager.createMirror("反射镜2")
			mirror2.scale=0.5;
			equipmentList.addItem(mirror2);

			var mirror3:Mirror=ExperimentManager.createMirror("反射镜3")
			mirror3.scale=0.5;
			equipmentList.addItem(mirror3);

			var lens1:Lens=ExperimentManager.createConvexLens("扩束镜1", 18);
			lens1.scale=0.3;
			equipmentList.addItem(lens1);
			var lens2:Lens=ExperimentManager.createConvexLens("扩束镜2", 18);
			lens2.scale=0.3;
			equipmentList.addItem(lens2);
			var lens3:Lens=ExperimentManager.createConvexLens("准直物镜1", 108);
			lens3.scale=0.7;
			equipmentList.addItem(lens3);
			var lens4:Lens=ExperimentManager.createConvexLens("准直物镜2", 108);
			lens4.scale=0.7;
			equipmentList.addItem(lens4);
			equipmentList.addItem(ExperimentManager.createDoubleSlitInterfBoard("接收屏"));
		}
		override public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void{
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
		
		override public function getExperimentID():int{
		    return LabXConstant.EXPERIMENT_FIRST;
		}
		
		
	}
}