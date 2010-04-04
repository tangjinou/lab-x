package cn.edu.zju.labx.logicObject
{

	import cn.edu.zju.labx.core.LabXConstant;

	import flexunit.framework.TestCase;

	public class InterferenceLogicTest extends TestCase
	{
		public function InterferenceLogicTest()
		{
		}

		public function testThetaEqualsToPI():void
		{
			var distance:Number=InterferenceLogic.doubleSlitInterferenceLogic(Math.PI, LabXConstant.WAVE_LENGTH);
			assertEquals(LabXConstant.WAVE_LENGTH / 2, distance);
		}

		public function testThetaEqualsToHalfPI():void
		{
			var distance:Number=InterferenceLogic.doubleSlitInterferenceLogic(Math.PI / 2, LabXConstant.WAVE_LENGTH);
			assertEquals(LabXConstant.WAVE_LENGTH / 2 / Math.sin(Math.PI / 4), distance);
		}

		public function testThetaEqualsToZero():void
		{
			var distance:Number=InterferenceLogic.doubleSlitInterferenceLogic(0, LabXConstant.WAVE_LENGTH);
			assertEquals(0, distance);
		}
	}
}