package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.utils.MathUtils;
	
	import org.papervision3d.core.math.Number3D;
	
	public class SplitterBeamLogic
	{   
		private var _position:Number3D;
		private var _normal:Number3D; 
		private var _incidentRay:Number3D;
		public function SplitterBeamLogic(position:Number3D,normal:Number3D)
		{ 
			_position= position;
			_normal= normal;
		}
        public function calculateRayAfterSplit(oldRayLogic:LineRayLogic):LineRayLogic{
        	var start_point:Number3D = new Number3D(oldRayLogic.x,oldRayLogic.y,oldRayLogic.z);
        	var vector:Number3D = new Number3D(oldRayLogic.dx,oldRayLogic.dy,oldRayLogic.dz);
            var pointInPlane:Number3D =MathUtils.calculatePointInPlane2(_position,_normal,vector,start_point);
            if(pointInPlane == null){
               return  null;
            }
            var dreflectionVector:Number3D = MathUtils.calculate3DreflectionVector(vector,_normal);
            //I don' know , but should do this here
//            dreflectionVector.z = 0 - dreflectionVector.z;
            return new LineRayLogic(pointInPlane,dreflectionVector);
        }
	}
}