package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.objects.LineRay;
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
        public function calculateRayAfterSplit(oldLineRay:LineRay):LineRay{
            var pointInPlane:Number3D =MathUtils.calculatePointInPlane2(_position,_normal,oldLineRay.normal,oldLineRay.start_point);
            if(pointInPlat == null){
               return  null;
            }
            _incidentRay = Number3D.sub(pointInPlane,oldLineRay.start_point);
            var dreflectionVector:Number3D = MathUtils.calculate3DreflectionVector(_incidentRay,_normal);
            //I don' know , but should do this here
//            dreflectionVector.z = 0 - dreflectionVector.z;
            return new LineRay(new LineRayLogic(pointInPlat,dreflectionVector));
        }
	}
}