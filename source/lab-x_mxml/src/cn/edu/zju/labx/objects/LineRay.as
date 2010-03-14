package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	
	public class LineRay
	{
		protected var _logic:LineRayLogic; 
		protected var _length:Number;
		/**
		 *  This is for line's end point
		 */
		private var endPoint:Vertex3D;
		
		public function LineRay(logic:LineRayLogic=null,length:Number=3200)
		{
			_logic = logic;
			_length= length;
		}
		
		public function newLineRay(startPoint:Vertex3D,endPoint:Vertex3D):void{
		    this.endPoint = endPoint;
		    this._length  = MathUtils.distanceToNumber3D(startPoint.toNumber3D(),endPoint.toNumber3D());
		    var cosx:Number  = (endPoint.x - startPoint.x)/_length;
		    var cosy:Number  = (endPoint.y - startPoint.y)/_length;
		    var cosz:Number  = (endPoint.z - startPoint.z)/_length;
		    _logic =new LineRayLogic(startPoint.getPosition(), new Number3D(cosx, cosy, cosz));
		}
		
		public function get start_point():Vertex3D{
		   return new Vertex3D(_logic.x,_logic.y,_logic.z);
		}
		
		public function get end_point():Vertex3D{
		   if(endPoint ==null){
		     var x:Number= _length * _logic.dx+_logic.x;
		     var y:Number= _length * _logic.dy+_logic.y;
		     var z:Number= _length * _logic.dz+_logic.z;
		     endPoint =new Vertex3D(x,y,z);
		   }
           return endPoint;		
		}
		
		public function set end_point(endPoint:Vertex3D):void{
		   	this.endPoint = endPoint;
		    this._length  = MathUtils.distanceToNumber3D(start_point.toNumber3D(),endPoint.toNumber3D());
		    _logic.dx  = (endPoint.x - start_point.x)/_length;
		    _logic.dy  = (endPoint.y - start_point.y)/_length;
		    _logic.dz  = (endPoint.z - start_point.z)/_length;
		}
		
		public function get logic():LineRayLogic
	    {
	    	return this._logic;
	    }
	}
}