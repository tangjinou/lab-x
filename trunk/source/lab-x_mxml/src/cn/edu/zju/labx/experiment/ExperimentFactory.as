package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	public class ExperimentFactory
	{
		/*************************************************************************
		 * Sigleton Method to make sure there are only one ExperimentManager
		 * in an application
		 * ***********************************************************************
		 */
		private static var instance:ExperimentFactory = null;

		public static function get getDefault():ExperimentFactory
		{
			if (instance == null)
			{
				instance=new ExperimentFactory();
			}
			return instance;
		}
		
		private var _experimentIndex:int;
		
		public function createExperiment(experimentIndex:Number):IExperiment{
		  switch (experimentIndex)
			{
				case LabXConstant.EXPERIMENT_FIRST:
					     return  new FirstExperiment();
				case LabXConstant.EXPERIMENT_SECOND:
                         return  new SecondExperiment();
				case LabXConstant.EXPERIMENT_THIRD:
					     return  new ThirdExperiment();
				case LabXConstant.EXPERIMENT_FORTH:
					     return  new FourthExperiment();
			}
			return null;
		}
		
		

	}
}