package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
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
		public function LineRay(logic:LineRayLogic=null,length:Number=LabXConstant.RAY_DEFAULT_LENGTH)
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
		
		public function set start_point(p:Number3D):void{
           this._logic.x = p.x;
           this._logic.y = p.y;		
           this._logic.z = p.z;
		}
		public function get end_point():Number3D{
		   if(endPoint ==null){
		     endPoint =optimizeEndPoint(_logic);
		   }
           return endPoint;		
		}
		private function optimizeEndPoint(logic:LineRayLogic):Number3D
		{
			var x:Number = logic.x;
			var y:Number = logic.y;
			var z:Number = logic.z;
			
			var dx:Number = logic.dx;
			var dy:Number = logic.dy;
			var dz:Number = logic.dz;
			
			var tx:Number = (dx==0) ? Number.MAX_VALUE : ((dx>0) ? (LabXConstant.DESK_X_MAX-x)/dx : (LabXConstant.DESK_X_MIN-x)/dx);
			var ty:Number = (dy==0) ? Number.MAX_VALUE : ((dy>0) ? (500-y)/dy : (-50-y)/dy);
			var tz:Number = (dz==0) ? Number.MAX_VALUE : ((dz>0) ? (LabXConstant.DESK_Z_MAX-z)/dz : (LabXConstant.DESK_Z_MIN-z)/dz);
			
			var t:Number;
			if(tx < 0 || ty < 0 || tz < 0)
			{
				t = LabXConstant.RAY_DEFAULT_LENGTH-200;
			} else {
				t = ((tx <= ty) && (tx <= tz)) ? tx : ((ty <= tz) ? ty : tz)
			}
			
			if (t != ty)t += 200;
			
			x = t * dx + x;
			y = t * dy + y;
			z = t * dz + z;
			
			return new Number3D(x, y, z);
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
	    
	    public function get length():int{
	        return Number3D.sub(endPoint,start_point).modulo;
	    }
	}
}