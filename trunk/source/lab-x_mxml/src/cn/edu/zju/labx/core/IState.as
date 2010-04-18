package cn.edu.zju.labx.core
{
	public interface IState
	{   
		function getNextState():int;
		function nextState():int;
		function getPreState():int;
		function resume():void;
		function getCurrentState():int;
		function preState():int;
		function setCurrentState(state:int):void;
	}
}