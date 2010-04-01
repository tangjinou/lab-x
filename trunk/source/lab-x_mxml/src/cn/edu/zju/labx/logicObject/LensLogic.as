package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	
	/**
	 * geom logic for lens class
	 */
	public class LensLogic
	{
		/**
		 * normal of the lens
		 */
		private var normal:Number3D;
		
		/**
		 * position of the lens
		 */
		public var position:Number3D;
		
		/**
		 * Focus of the lens.
		 */
		public var f:Number;
		
		/**
		 * Construct a Lens Logic object
		 */
		public function LensLogic(position:Number3D=null, normal:Number3D=null, f:Number=LabXConstant.LENS_DEFAULT_FOCAL_LENGTH)
		{
			this.position = position || new Number3D();
			this.normal = normal || new Number3D(1, 0, 0);
			this.normal.normalize();
			this.f = ((f == 0)?LabXConstant.LENS_DEFAULT_FOCAL_LENGTH : f);
		}
		
		/**
		 * Get the focus points of the lens.
		 */
		public function getFocusPoints():ArrayCollection
		{
			var focusPoints:ArrayCollection = new ArrayCollection();
			
			var d:Number3D = normal.clone();
			d.multiplyEq(f);
			
			var focusPoint1:Number3D =  Number3D.add(position, d);
			focusPoints.addItem(focusPoint1);
			
			d.multiplyEq(-1);
			var focusPoint2:Number3D =  Number3D.add(position, d);
			focusPoints.addItem(focusPoint2);
			return focusPoints;
		}
		
		/**
		 * Calculate the ray after the lens, if the ray are not pass through the lens, return null.
		 * otherwise, return the result ray.
		 * 
		 * @param   lineRay  ray to processed
		 * 
		 */
		public function processRay(lineRay:LineRayLogic):LineRayLogic {
			var rayPoint:Number3D = new Number3D(lineRay.x, lineRay.y, lineRay.z);
			
			var lensNormalRay:LineRayLogic = new LineRayLogic(position, normal);
			var lensPlane:Plane3D = new Plane3D(normal, position);
			
			//if the ray through the center of the lens, pass through
			if (lineRay.isPointOnRay(this.position))
			{
				return new LineRayLogic(position, new Number3D(lineRay.dx, lineRay.dy, lineRay.dz));
			}
			
			//if the ray point on lens normal, or the point distance if same as f, choose another point for calculate 
			if (lensNormalRay.isPointOnRay(rayPoint) || (Math.abs(lensPlane.distance(rayPoint)) == f))
			{
				rayPoint.x -= lineRay.dx;
				rayPoint.y -= lineRay.dy;
				rayPoint.z -= lineRay.dz;
			}
			
			var resultPoint:Number3D = getImagePosition(lensPlane, rayPoint);
			
			//calculate the lens and ray intersection point
			var anotherPointOnRay:Number3D = new Number3D(lineRay.x+lineRay.dx, lineRay.y+lineRay.dy, lineRay.z+lineRay.dz);
			var intersaction:Number3D = lensPlane.getIntersectionLineNumbers(anotherPointOnRay, rayPoint);
			
			//if the intersaction of the ray is not on the direction of the ray, we assume that the ray is no need to processed.
			if(!MathUtils.isVetorTheSameDirection(Number3D.sub(intersaction, rayPoint), new Number3D(lineRay.dx, lineRay.dy, lineRay.dz)))
			{
				return null;
//				rayPoint = Number3D.sub(intersaction, new Number3D(lineRay.dx, lineRay.dy, lineRay.dz));
			}
			
			var vector:Number3D = Number3D.sub(resultPoint, intersaction);
			vector.normalize();
			if (f<0 || (Math.abs(lensPlane.distance(rayPoint)) < f))
			{
				vector.multiplyEq(-1);
			}
			return new LineRayLogic(intersaction, vector);
		}
		
		/**
		 * We use the image formula to calculate the image position 
		 * 1. convex lens:			1/u + 1/v = 1/f (u>f),    1/u - 1/v = 1/f (u < f)
		 * 2. concave lens:			1/u - 1/v = -1/f
		 * 
		 * We assume that f' > 0 means convex lens, f' < 0 means concave lens.
		 * We assume that v' > 0 means image is on the other side with object, v' < 0 means the image is the same side with object
		 * If f' > 0, u > f', then v' > 0, we got the fomula:  1/v' = 1/f' - 1/u
		 * If f' > 0, u < f', then v' < 0, we got the fomula:  1/v' = 1/f' - 1/u
		 * If f' < 0, u < f', then v' < 0, we got the fomula:  1/v' = 1/f' - 1/u
		 * 
		 * So, we got the same formula.
		 * 
		 */
		private function getImagePosition(lensPlane:Plane3D, objPoint:Number3D):Number3D
		{
			var u:Number = Math.abs(lensPlane.distance(objPoint));
			var v:Number = 1/(1/f - 1/u);
			
			var pu:Number = Number3D.sub(position, objPoint).modulo;
			var pv:Number = pu * v / u;
			
			var resultPoint:Number3D =  Number3D.sub(position, objPoint);
			resultPoint.normalize();
			resultPoint.multiplyEq(pv);
			resultPoint = Number3D.add(resultPoint, position);
			return resultPoint;
		}
		
		
		/**
		 * Get the focus point in the image side
		 * If the point is on lens plane, return null.
		 */
		public function getImageFocus(point:Number3D):Number3D
		{
			var focusPoints:ArrayCollection = getFocusPoints();
			var p1:Number3D = focusPoints.getItemAt(0) as Number3D;
			var p2:Number3D = focusPoints.getItemAt(1) as Number3D;
			
			var d1:Number = Number3D.sub(p1, point).moduloSquared;
			var d2:Number = Number3D.sub(p2, point).moduloSquared;
			//TODO:
			if(f>0)
			{
				return (d1 > d2) ? p1 : p2;
			}
			else if (f < 0)
			{
				return (d1 > d2) ? p2 : p1;
			}
			
			return null;
		}
		
	}
}