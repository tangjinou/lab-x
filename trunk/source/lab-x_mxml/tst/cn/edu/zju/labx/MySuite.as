package cn.edu.zju.labx
{
	import cn.edu.zju.labx.core.StageObjectsManagerTest;
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
        public function MySuite()  
        {  
        }  
    }  
}