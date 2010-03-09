package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.RayLogic;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Number3D;
	
	public class LineRay
	{
		var _logic:RayLogic; 
		var _length:Number;
		
		/**
		 *  This is for line's end point
		 */
		var endPoint:Number3D;
		
		public function LineRay(logic:RayLogic,length:Number=1200)
		{
			_logic = logic;
			_length= length;
		}
		
		public function get start_point():Number3D{
		   return _logic.point;
		}
		
		public function get end_point():Number3D{
		   if(endPoint ==null){
		     var x:Number= _length * Math.cos(_logic.vector.x)+_logic.point.x;
		     var y:Number= _length * Math.cos(_logic.vector.y)+_logic.point.y;
		     var z:Number= _length * Math.cos(_logic.vector.z)+_logic.point.z;
		     endPoint = new new Number3D(x,y,z);
		   }
           return endPoint;		
		}
		
		public function get vector():Vector3D{
		   return _logic.vector;
		}
		
	}
}