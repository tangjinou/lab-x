package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.logicObject.LineRayLogic;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.papervision3d.core.math.Number3D;
	
	public class LineRay
	{
		protected var _logic:LineRayLogic; 
		protected var _length:Number;
		/**
		 *  This is for line's end point
		 */
		private var endPoint:Number3D;
		
		public function LineRay(logic:LineRayLogic=null,length:Number=1200)
		{
			_logic = logic;
			_length= length;
		}
		
		public function newLineRay(startPoint:Number3D,endPoint:Number3D):void{
		    this.endPoint = endPoint;
		    this._length  = MathUtils.distanceToNumber3D(startPoint,endPoint);
		    var cosx:Number  = (endPoint.x - startPoint.x)/_length;
		    var cosy:Number  = (endPoint.y - startPoint.y)/_length;
		    var cosz:Number  = (endPoint.z - startPoint.z)/_length;
		    _logic =new LineRayLogic(startPoint,new Number3D(cosx,cosy,cosz));

		}
		
		public function get start_point():Number3D{
		   return new Number3D(_logic.x,_logic.y,_logic.z);
		}
		
		public function get end_point():Number3D{
		   if(endPoint ==null){
		     var x:Number= _length * _logic.dx+_logic.x;
		     var y:Number= _length * _logic.dy+_logic.y;
		     var z:Number= _length * _logic.dz+_logic.z;
		     endPoint =new Number3D(x,y,z);
		   }
           return endPoint;		
		}
		
		public function set end_point(endPoint:Number3D):void{
		   	this.endPoint = endPoint;
		    this._length  = MathUtils.distanceToNumber3D(start_point,endPoint);
		    _logic.dx  = (endPoint.x - start_point.x)/_length;
		    _logic.dy  = (endPoint.y - start_point.y)/_length;
		    _logic.dz  = (endPoint.z - start_point.z)/_length;
		}
		
		public function get logic():LineRayLogic
	    {
	    	return this._logic;
	    }
	    public function get normal():Number3D{
	        return new Number3D(this._logic.dx,this._logic.dy,this._logic.dz);
	    }
	}
}