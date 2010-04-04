package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;

	import flexunit.framework.TestCase;

	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;

	public class Plane3DTest extends TestCase
	{
		public function Plane3DTest(methodName:String=null)
		{
			super(methodName);
		}

		public function testIntersectionNumbers():void
		{
			var plane:Plane3D=new Plane3D(new Number3D(1, 0, 0), new Number3D(80, 0, 0));
			var point1:Number3D=new Number3D(2, 0, 0);
			var point2:Number3D=new Number3D(5, 0, 0);

			var inter:Number3D=plane.getIntersectionLineNumbers(point1, point2);
			assertEquals(80, inter.x);
			assertTrue(Math.abs(inter.x - 80) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(inter.y - 0) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(inter.y - 0) < LabXConstant.NUMBER_PRECISION);
		}

		public function testIntersectionNumbers2():void
		{
			var plane:Plane3D=new Plane3D(new Number3D(-1, 0, 0), new Number3D(80, 0, 0));
			var point1:Number3D=new Number3D(2, 0, 0);
			var point2:Number3D=new Number3D(5, 0, 0);

			var inter:Number3D=plane.getIntersectionLineNumbers(point1, point2);
			assertEquals(80, inter.x);
			assertTrue(Math.abs(inter.x - 80) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(inter.y - 0) < LabXConstant.NUMBER_PRECISION);
			assertTrue(Math.abs(inter.y - 0) < LabXConstant.NUMBER_PRECISION);
		}

	}
}