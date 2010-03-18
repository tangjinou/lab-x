package cn.edu.zju.labx
{
	import cn.edu.zju.labx.core.StageObjectsManagerTest;
	import cn.edu.zju.labx.logicObject.LensLogicTest;
	import cn.edu.zju.labx.logicObject.LineRayLogicTest;
	import cn.edu.zju.labx.logicObject.Plane3DTest;
	import cn.edu.zju.labx.logicObject.InterferenceLogicTest;
	import cn.edu.zju.labx.objects.LensTest;
	import cn.edu.zju.labx.objects.LineRaysTest;
	import cn.edu.zju.labx.utils.MathUtilsTest;

	
	[Suite]  
    [RunWith("org.flexunit.runners.Suite")]  
    /** 
     *一个测试组  
     * @author tang 
     *  
     */  
    public class MySuite  
    {  
        public var t1:MathUtilsTest;
		public var t2:StageObjectsManagerTest;
 		
 		public var t3:LineRayLogicTest;
		public var t4:LensLogicTest;
		public var t5:LineRaysTest;


		public var t10:LensTest;
		public var t11:Plane3DTest;

		public var t12:InterferenceLogicTest;
        
		public function MySuite()  
        {  
        }  
    }  
}