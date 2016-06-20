package starling.display
{
   public class GraphicsLine implements IGraphicsData
   {
       
      protected var mThickness:Number = NaN;
      
      protected var mColor:int = 0;
      
      protected var mAlpha:Number = 1.0;
      
      public function GraphicsLine(param1:Number = NaN, param2:int = 0, param3:Number = 1.0)
      {
         super();
         mThickness = param1;
         mColor = param2;
         mAlpha = param3;
      }
      
      public function get thickness() : Number
      {
         return mThickness;
      }
      
      public function get color() : int
      {
         return mColor;
      }
      
      public function get alpha() : Number
      {
         return mAlpha;
      }
   }
}
