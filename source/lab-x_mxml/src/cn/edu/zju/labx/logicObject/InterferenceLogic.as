package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;

	public class InterferenceLogic
	{
		public static function doubleSlitInterferenceLogic(theta:Number, waveLength:Number=LabXConstant.WAVE_LENGTH):Number
		{

			var resOfSin:Number=Math.sin(theta / 2);
			if (resOfSin == 0)
			{
				return 0;
			}
			else
			{
				return waveLength / 2 / resOfSin;
			}
		}

		public function InterferenceLogic()
		{

		}

	}
}