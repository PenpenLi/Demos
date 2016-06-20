package starling.display
{
   public class GraphicsSolidFill implements IGraphicsData
   {
       
      protected var mColor:uint;
      
      protected var mAlpha:Number;
      
      public function GraphicsSolidFill(param1:uint, param2:Number)
      {
         super();
         mColor = param1;
         mAlpha = param2;
      }
      
      public function get color() : uint
      {
         return mColor;
      }
      
      public function get alpha() : Number
      {
         return mAlpha;
      }
   }
}
