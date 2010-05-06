package cn.edu.zju.labx.experiment
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	public class ExperimentFactory
	{    
		/**
		 * Experiment Definition
		*/
		public static const EXPERIMENT_FIRST:int=1;
		public static const EXPERIMENT_SECOND:int=2;
		public static const EXPERIMENT_THIRD:int=3;
		public static const EXPERIMENT_FORTH:int=4;
		
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
				case ExperimentFactory.EXPERIMENT_FIRST:
					     return  new FirstExperiment();
				case ExperimentFactory.EXPERIMENT_SECOND:
                         return  new SecondExperiment();
				case ExperimentFactory.EXPERIMENT_THIRD:
					     return  new ThirdExperiment();
				case ExperimentFactory.EXPERIMENT_FORTH:
					     return  new FourthExperiment();
			}
			return null;
		}
		

	}
}