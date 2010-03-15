package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.objects.Ray;
	
	public interface IRayMaker
	{
		function getRay():Ray;
		function setRay(ray:Ray):void;
	}
}