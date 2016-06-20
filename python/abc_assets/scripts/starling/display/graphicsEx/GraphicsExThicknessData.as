package starling.display.graphicsEx
{
   public class GraphicsExThicknessData
   {
       
      public var startThickness:Number = -1;
      
      public var endThickness:Number = -1;
      
      public var thicknessCallback:Function = null;
      
      public function GraphicsExThicknessData(param1:int, param2:int, param3:Function = null)
      {
         super();
         startThickness = param1;
         endThickness = param2;
         thicknessCallback = param3;
      }
      
      public function clone() : GraphicsExThicknessData
      {
         var _loc1_:GraphicsExThicknessData = new GraphicsExThicknessData(startThickness,endThickness,thicknessCallback);
         return _loc1_;
      }
   }
}
