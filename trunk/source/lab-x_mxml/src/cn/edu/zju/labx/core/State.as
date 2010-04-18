package cn.edu.zju.labx.core
{
	public class State implements IState
	{   
		private var index:int;
		
		public function State()
		{
			this.index =0;
		}
		public function getNextState():int
		{
			return index+1;
		}
		public function nextState():int
		{
			return index++;
		}
		public function preState():int{
		    return index--;
		}
		public function getPreState():int
		{
			return index-1;
		}
		public function getCurrentState():int
		{
		    return index;
		}
		public function resume():void
		{
			this.index = 0;
		}
		public function setCurrentState(state:int):void
		{
		    this.index = state;
		}
	}
}