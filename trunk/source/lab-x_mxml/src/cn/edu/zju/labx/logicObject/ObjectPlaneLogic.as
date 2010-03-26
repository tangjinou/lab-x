package cn.edu.zju.labx.logicObject
{
	import cn.edu.zju.labx.objects.beam.ObjectPlane;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.math.util.ClassificationUtil;
	
	public class ObjectPlaneLogic
	{
		private var board:ObjectPlane;
		
		public function ObjectPlaneLogic(board:ObjectPlane)
		{
			this.board = board;
		}
		
		public function processRay(oldRay:Ray):Ray {
			if (oldRay == null) return null;
			if (oldRay.getLineRays() == null) return null;
			
			var lineRays:ArrayCollection = oldRay.getLineRays();
			var boardplane:Plane3D = board.getObjectPlane();
			
			if (lineRays.length == 1)
			{
				var lineRay:LineRay = lineRays.getItemAt(0) as LineRay;
				var lineRayNormal:Number3D = new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz); 
				return createParaRayAfterObjectBoard(lineRayNormal);
			}
			
			var firstLine:LineRay = lineRays.getItemAt(0) as LineRay;
			var secondLine:LineRay = lineRays.getItemAt(1) as LineRay;
			
			var intersaction:Number3D = MathUtils.calculate3DIntersection(firstLine.start_point, firstLine.end_point, secondLine.start_point, secondLine.end_point);
			if (intersaction != null) {
				var startPointSide:uint = boardplane.pointOnSide(firstLine.start_point);
				var intersectionPointSide:uint = boardplane.pointOnSide(intersaction);
				
				if (intersectionPointSide == ClassificationUtil.COINCIDING)
				{
					//the intersaction is on the plane
					return createWithIntersactionOnObjectBoard(intersaction, oldRay);
				} else if ( intersectionPointSide != startPointSide)
				{
					//TOODO: intersaction is ray out comming side
					return createRayWithPoint(intersaction, false);
				} else
				{
					//TODO: intersaction is ray incoming side
					return createRayWithPoint(intersaction, true);
				}
				
			} else {
				return createParaRayAfterObjectBoard(new Number3D(firstLine.logic.dx, firstLine.logic.dy, firstLine.logic.dz));
			}
				
		}
		
		/**
		 * Create a parallel ray from the object board
		 */
		private function createParaRayAfterObjectBoard(normal:Number3D):Ray
		{
			var lineRays:ArrayCollection = new ArrayCollection();
			var points:ArrayCollection = board.getRectPoints();
			for each (var point:Number3D in points)
			{
				lineRays.addItem(new LineRay(new LineRayLogic(point, normal)));
			}
			
			return new Ray(board, null, lineRays);
		}
		
		/**
		 * Create a ray from the object board according to the input ray's intersaction point
		 */
		private function createRayWithPoint(startPoint:Number3D, reverse:Boolean):Ray
		{
			var lineRays:ArrayCollection = new ArrayCollection();
			var points:ArrayCollection = board.getRectPoints();
			for each (var point:Number3D in points)
			{
				var normal:Number3D = Number3D.sub(startPoint, point);
				normal.normalize();
				if(reverse)
				{
					normal.multiplyEq(-1);
				}
				lineRays.addItem(new LineRay(new LineRayLogic(point, normal)));
			}
			
			return new Ray(board, null, lineRays);
		}
		
		/**
		 * Create a ray from the oldRay with oldRay intersaction in the object plane
		 */
		private function createWithIntersactionOnObjectBoard(startPoint:Number3D, oldRay:Ray):Ray
		{
			//TODO:
			var points:ArrayCollection = board.getRectPoints();
			
			var p1:Number3D = points.getItemIndex(0) as Number3D;
			var p2:Number3D = points.getItemIndex(1) as Number3D;
			var p3:Number3D = points.getItemIndex(2) as Number3D;
			var p4:Number3D = points.getItemIndex(3) as Number3D;
			
			var p5:Number3D = points.getItemIndex(4) as Number3D;
			var p6:Number3D = points.getItemIndex(5) as Number3D;
			var p7:Number3D = points.getItemIndex(6) as Number3D;
			var p8:Number3D = points.getItemIndex(7) as Number3D;
			
			
			if(checkPointInRectangle(startPoint, p1, p2, p3, p4) || checkPointInRectangle(startPoint, p5, p6, p7, p8))
			{
				var resultLineRays:ArrayCollection = new ArrayCollection();
				var lineRays:ArrayCollection = oldRay.getLineRays();
				for each (var lineRay:LineRay in lineRays)
				{
					var lineRayNormal:Number3D = new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz); 
					resultLineRays.addItem(new LineRay(new LineRayLogic(startPoint, lineRayNormal)));
				}
				return new Ray(board, null, resultLineRays);
			}
			return null;
		}
		
		/**
		 * Check if the point in the rectangle
		 * p is the point for check. p1, p2, p3, p4 is the rectangle vetex point in clockwise order 
		 *  
		 *
		 */
		private function checkPointInRectangle(p:Number3D, p1:Number3D, p2:Number3D, p3:Number3D, p4:Number3D):Boolean
		{
			var v1:Number3D = Number3D.sub(p3, p4);
			var v3:Number3D = Number3D.sub(p4, p3);
			var v4:Number3D = Number3D.sub(p, p1);
			var v5:Number3D = Number3D.sub(p, p3);
			
			v1.normalize();
			v3.normalize();
			v4.normalize();
			v5.normalize();
			
			if ((Number3D.dot(v1, v4) > 0) && (Number3D.dot(v3, v5) > 0))
			{
				return true;
			}
			return false;
		}
		
	}
}