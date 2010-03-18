package cn.edu.zju.labx.core
{
	import org.hamcrest.mxml.object.Null;
	
	public class LabXConstant
	{
		/**
		 * Constants for Stage
		 */
		public static const STAGE_HEIGHT:Number = 600;
		public static const STAGE_WIDTH:Number = 1000;
		public static const STAGE_DEPTH:Number = 600;
		
		/**
		 *  Constants for Desk
		 */
		public static const DESK_WIDTH:Number = STAGE_WIDTH * 0.8;
		
		/**
		 * Constant for LabXObject and its sub classes
		 */
		public static const LABX_OBJECT_WIDTH:Number = 30;
		public static const LABX_OBJECT_HEIGHT:Number = 100;
		public static const LABX_OBJECT_DEPTH:Number = 100;
		public static const LENS_DEFAULT_FOCAL_LENGTH:Number = 10;
		
		
		public static const RAY_DEFAULT_LENGTH:Number = STAGE_WIDTH;
		/**
		 * Constants for User Input Event
		 */
		public static const X_MOVE_MIN:Number = 5;
		public static const Y_MOVE_MIN:Number = 5;
		public static const Z_MOVE_MIN:Number = 5;
		
		public static const NUMBER_PRECISION:Number = 0.000001;
		
		public static const WAVE_LENGTH:Number = 740; //unit:nm
		

	}
}