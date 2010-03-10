package
{
	import org.papervision3d.view.BasicView;

	public class BoardView extends BasicView
	{
		public function BoardView(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
		}
		
	}
}