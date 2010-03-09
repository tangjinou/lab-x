package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.RayLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	
	public class LineRay
	{
		var _logic:RayLogic; 
		var _length:Number;
		/**
		 *  This is for line's end point
		 */
		var endPoint:Vertex3D;
		
		public function LineRay(logic:RayLogic,length:Number=1200)
		{
			_logic = logic;
			_length= length;
		}
		
		public function LineRay(startPoint:Vertex3D,endPoint:Vertex3D){
		    this.endPoint = endPoint;
		    this._length  = MathUtils.distanceToNumber3D(startPoint.toNumber3D(),endPoint.toNumber3D());
		    var cosx:Number  = (endPoint.x - startPoint.x)/_length;
		    var cosy:Number  = (endPoint.y - startPoint.y)/_length;
		    var cosz:Number  = (endPoint.z - startPoint.z)/_length;
		    _logic =new RayLogic(startPoint.toNumber3D(),new Vector3D(cosx,cosy,cosz));
		}
		
		public function get start_point():Vertex3D{
		   return new Vertex3D(_logic.point.x,_logic.point.y,_logic.point.z);
		}
		
		public function get end_point():Vertex3D{
		   if(endPoint ==null){
		     var x:Number= _length * _logic.vector.x+_logic.point.x;
		     var y:Number= _length * _logic.vector.y+_logic.point.y;
		     var z:Number= _length * _logic.vector.z+_logic.point.z;
		     endPoint =new Vertex3D(x,y,z);
		   }
           return endPoint;		
		}
		
		public function get vector():Vector3D{
		   return _logic.vector;
		}
		
		public function get logic():RayLogic
	    {
	    	return this._logic;
	    }
	}
}