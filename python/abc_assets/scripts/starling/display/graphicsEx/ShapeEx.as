package starling.display.graphicsEx
{
   import starling.display.DisplayObjectContainer;
   
   public class ShapeEx extends DisplayObjectContainer
   {
       
      private var _graphics:starling.display.graphicsEx.GraphicsEx;
      
      public function ShapeEx()
      {
         super();
         _graphics = new starling.display.graphicsEx.GraphicsEx(this);
      }
      
      public function get graphics() : starling.display.graphicsEx.GraphicsEx
      {
         return _graphics;
      }
   }
}
