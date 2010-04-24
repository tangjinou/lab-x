package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.IState;
	import cn.edu.zju.labx.core.OptimizeMovingState;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.collections.ArrayCollection;
	
	public interface IExperiment extends IState
	{     
		 /**create experiment equipments,not include default experiment equipment*/
		 function createExperimentEquipments():void;
		 
		 /****return the id of the experiment*/
		 function getExperimentID():int;
		
		 /**return this list of the all the equipments, include the default*/
		 function getEquipmentList():ArrayCollection;
		 
		 /**add the default expriment equipment   *************************/
		 function addDefaultExperimentEquipments():void;
		 
		 /**revove this experiment,should remove all the equipments**********/
		 function remove():void;
		 
		 /**get the move state of this experiment */
		 function getMovingState():OptimizeMovingState;
		 
		 /**just move one equipment,should give the every equiment's positon where to move ****/
		 function moveExperimentEquipmentOptimize(labXObject:LabXObject):void;
	      
	     /**just move one equipment to defualt position**/
	     function moveExperimentEquipmentDefault():void;
	     
	     /**move all equipments back to default position*/
	     function moveAllExperimentEquipmentsDefault():void;
	     
	     /**move all equipments to optimize position*/
	     function moveAllExperimentEquipmentsOptimize():void;  
 
	}
}