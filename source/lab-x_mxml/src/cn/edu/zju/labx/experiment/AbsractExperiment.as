package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.OptimizeMovingState;
	import cn.edu.zju.labx.core.manager.ExperimentManager;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.beam.BeamSplitter;
	import cn.edu.zju.labx.objects.beam.Mirror;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	
	import com.greensock.TweenLite;
	
	import mx.collections.ArrayCollection;

	public class AbsractExperiment implements IExperiment
	{   
		protected var  equipmentList:ArrayCollection;
		
		protected var  state:OptimizeMovingState;
		
		protected var  defaultEquipment_size:int=0;
		
		
		public function AbsractExperiment(){
		    equipmentList = new ArrayCollection();
		    state = new OptimizeMovingState();
		}
		
	   
	/********************* implements IState  ******************************************/
		public function getNextState():int{
		   return state.getNextState();
		}
		public function nextState():int{
		    if(0<=state.getCurrentState() && state.getCurrentState()<StageObjectsManager.getDefault.getObjectList().length - defaultEquipment_size){
            	moveExperimentEquipmentOptimize(StageObjectsManager.getDefault.getObjectList().getItemAt(state.nextState()) as LabXObject);
            }
		   return state.getCurrentState();
		}
		public function getPreState():int{
		   return state.getPreState();
		}
		public function resume():void{
		   return state.resume();
		}
		public function getCurrentState():int{
		   return state.getCurrentState();
		}
		public function preState():int{
		   return state.preState();
		}
		public function setCurrentState(_state:int):void{
		   state.setCurrentState(_state);
		}
		
		
	   /******************should be overrided****************************************/
	    public function createExperimentEquipments():void{
		}
		
	   /******************should be overrided****************************************/
		public function getExperimentID():int{
			return -1;
		}
		
		public function getEquipmentList():ArrayCollection{
		    return equipmentList;
		}
		
		public function addDefaultExperimentEquipments():void{
		    equipmentList.addItem(ExperimentManager.createParallelCrystal("平行平晶"));
			defaultEquipment_size++;
			equipmentList.addItem(ExperimentManager.createParallelBeamDetector("剪切干涉屏幕"));
		    defaultEquipment_size++;
		}
		
		public function moveAllExperimentEquipmentsOptimize():void{
		     for(var i:int=0;i<equipmentList.length;i++){
		        var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
		        moveExperimentEquipmentOptimize(labXObject);
		        state.nextState();
		     }
		}
		
		/******************should be overrided****************************************/
		public function moveExperimentEquipmentOptimize(labXObject:LabXObject):void{
              
		}
		
		public function moveExperimentEquipmentDefault():void{
			if(this.getCurrentState()>0 && this.getCurrentState() <= StageObjectsManager.getDefault.getObjectList().length){
			   	var labXObject:LabXObject=StageObjectsManager.getDefault.getObjectList().getItemAt(preState()) as LabXObject;
				TweenLite.to(labXObject, LabXConstant.MOVE_DELAY, {x: getCurrentState() * LabXConstant.STAGE_WIDTH / equipmentList.length, y: LabXConstant.LABX_OBJECT_HEIGHT / 2, z: LabXConstant.STAGE_DEPTH / 2, rotationY: 0, rotationX: 0, rotationZ: 0});
			 }
		}
		
		public function moveAllExperimentEquipmentsDefault():void{
		    for (var i:int=0; i < StageObjectsManager.getDefault.getObjectList().length; i++)
			{
		       moveExperimentEquipmentDefault();
		    }
		    state.resume();
		} 
		
		public  function remove():void{
		    if (equipmentList != null)
			{
				for (var i:int=0; i < equipmentList.length; i++)
				{
					var equipment:LabXObject=equipmentList.getItemAt(i) as LabXObject;
					if(equipmentList.contains(equipment)){
						StageObjectsManager.getDefault.removeObject(equipment);
					}
				}
			}
			equipmentList=null;
		}
		
	    public  function getMovingState():OptimizeMovingState{
		     return this.state;
		}

		
	}
}