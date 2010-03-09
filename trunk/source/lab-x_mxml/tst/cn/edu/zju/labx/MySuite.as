package cn.edu.zju.labx
{
	import cn.edu.zju.labx.core.StageObjectsManagerTest;
	import cn.edu.zju.labx.logicObject.LensLogicTest;
	import cn.edu.zju.labx.logicObject.RayLogicTest;
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
        

        public var t3:RayLogicTest;
        public var t4:LensLogicTest;
        public var t5:LineRaysTest;
        
        public var t10:LensTest;
        
        public function MySuite()  
        {  
        }  
    }  
}