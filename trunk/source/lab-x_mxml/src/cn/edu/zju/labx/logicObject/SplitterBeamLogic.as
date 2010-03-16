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
            var pointInPlat:Number3D =MathUtils.calculatePointInFlat2(_position,_normal,oldLineRay.normal,oldLineRay.start_point);
            _incidentRay = Number3D.sub(pointInPlat,oldLineRay.start_point);
            var dreflectionVector:Number3D = MathUtils.calculate3DreflectionVector(_incidentRay,_normal);
            return new LineRay(new LineRayLogic(pointInPlat,dreflectionVector));
        }
	}
}