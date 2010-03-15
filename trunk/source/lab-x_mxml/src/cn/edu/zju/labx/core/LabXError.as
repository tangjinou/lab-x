package cn.edu.zju.labx.core
{
	public class LabXError extends Error
	{
		public function LabXError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}