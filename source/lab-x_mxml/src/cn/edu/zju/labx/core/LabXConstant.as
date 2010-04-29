package cn.edu.zju.labx.core
{
	import org.hamcrest.mxml.object.Null;

	public class LabXConstant
	{
		/**
		 * Constants for Stage
		 */
		public static const STAGE_HEIGHT:Number=600;
		public static const STAGE_WIDTH:Number=1000;
		public static const STAGE_DEPTH:Number=600;

		public static const DEFAULT_CAMERA_ZOOM:Number=90;
		public static const DEFAULT_CAMERA_PITCH:Number=60;
		public static const DEFAULT_CAMERA_YAW:Number=270;
		
		/**
		 *  Constants for Desk
		 */
		public static const DESK_WIDTH:Number=930;
		public static const DESK_DEPTH:Number=500;
		public static const DESK_DOWN_OFFSET:Number=50;


		public static const DESK_X_MIN:Number=30;
		public static const DESK_X_MAX:Number=930;
		public static const DESK_Z_MIN:Number=-LabXConstant.DESK_DEPTH / 2;
		public static const DESK_Z_MAX:Number=LabXConstant.DESK_DEPTH / 2;

        /**
        *  Constants for GRID
        */
        public static const GRID_DOWN_OFFSET:Number=DESK_DOWN_OFFSET + 35; 


		/**
		 * Constant for LabXObject and its sub classes
		 */
		public static const LABX_OBJECT_WIDTH:Number=30;
		public static const LABX_OBJECT_HEIGHT:Number=120;
		public static const LABX_OBJECT_DEPTH:Number=100;

		public static const LENS_DEFAULT_FOCAL_LENGTH:Number=10;


		public static const RAY_DEFAULT_LENGTH:Number=STAGE_WIDTH;
		/**
		 * Constants for User Input Event
		 */
		public static const X_MOVE_MIN:Number=3;
		public static const Y_MOVE_MIN:Number=3;
		public static const Z_MOVE_MIN:Number=3;

		public static const X_KEY_MOVE_MIN:Number=1;
		public static const Y_KEY_MOVE_MIN:Number=1;
		public static const Z_KEY_MOVE_MIN:Number=1;

		public static const X_KEY_ROTATE_MIN:Number=1;
		public static const Y_KEY_ROTATE_MIN:Number=1;
		public static const Z_KEY_ROTATE_MIN:Number=1;

		/**
		 * Precision for number calculation
		 */
		public static const NUMBER_PRECISION:Number=0.000001;

		/**
		 * Wave length of red light
		 */
		public static const WAVE_LENGTH:Number=740; //unit:nm


		/**
		 * Experiment Definition
		 */
		public static const EXPERIMENT_FIRST:int=1;
		public static const EXPERIMENT_SECOND:int=2;
		public static const EXPERIMENT_THIRD:int=3;
		public static const EXPERIMENT_FORTH:int=4;

		/**
		 *  Reset Moving objects Delay time
		 */
		public static const MOVE_DELAY:int=3;

		/**
		 * For small rectangle
		 */
		public static const rectW:Number=8;
		public static const rectH:Number=25;
		
		/**
		 * Ray Color
		 */
		public static const BLUE:Number = 1;
		public static const YELLOW:Number = 2;
		
		/**
		 * DOCK
		 */ 
		public static const DOCK_NOG_R:Number = 8;
		public static const DOCK_BOTTOM_R:Number = 30;
		public static const DOCK_BOTTOM_H:Number = 10;
        public static const DOCK_NOG_H:Number = 100;
	}
}