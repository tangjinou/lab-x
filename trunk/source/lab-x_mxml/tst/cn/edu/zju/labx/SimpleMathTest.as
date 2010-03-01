package cn.edu.zju.labx
{
    import cn.edu.zju.labx.utils.SimpleMath;
    
    import org.flexunit.Assert;  
      
    /** 
     * SimpleMath类的测试类  
     * @author Alex 
     *  
     */   
    public class SimpleMathTest  
    {  
//        private static var simpleMath:SimpleMath ;  
//          
//        [BeforeClass]  
//        public static function runBeforeClass():void {     
//            // run for one time before all test cases     
//            simpleMath = new SimpleMath();  
//        }     
//            
//        [AfterClass]    
//        public static function runAfterClass():void {     
//            // run for one time after all test cases     
//        }     
          
        [Test]    
        public function addition():void {     
            Assert.assertEquals(12, SimpleMath.add(7, 6));     
        }  
  
    }  
}