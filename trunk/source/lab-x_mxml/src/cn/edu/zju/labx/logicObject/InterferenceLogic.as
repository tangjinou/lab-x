package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	public class InterferenceLogic
	{
		private var _theta:Number;
		private var _waveLength:Number;
		
		public function InterferenceLogic(theta:Number, waveLength:Number = LabXConstant.WAVE_LENGTH)
		{
			_theta = theta;
			_waveLength = waveLength;
		}
		public function getDistance():Number
		{
			var resOfSin:Number = Math.sin(_theta/2);
			if (resOfSin == 0)
			{
				return 0;
			}
			else
			{
				return _waveLength/2/resOfSin;
			}
		}

	}
}