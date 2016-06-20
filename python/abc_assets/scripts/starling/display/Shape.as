package starling.display
{
   public class Shape extends DisplayObjectContainer
   {
       
      private var _graphics:starling.display.Graphics;
      
      public function Shape()
      {
         super();
         _graphics = new starling.display.Graphics(this);
      }
      
      public function get graphics() : starling.display.Graphics
      {
         return _graphics;
      }
   }
}
