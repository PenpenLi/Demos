package extend
{
   import starling.display.Image;
   import flash.geom.Point;
   import starling.textures.Texture;
   
   public class Gauge extends Image
   {
       
      private var _ratio:Number;
      
      public function Gauge(param1:Texture)
      {
         super(param1);
      }
      
      private function update() : void
      {
         scaleX = _ratio;
         setTexCoords(1,new Point(_ratio,0));
         setTexCoords(3,new Point(_ratio,1));
      }
      
      public function get ratio() : Number
      {
         return _ratio;
      }
      
      public function set ratio(param1:Number) : void
      {
         if(param1 != _ratio)
         {
            _ratio = Math.max(0,Math.min(1,param1));
            update();
         }
      }
   }
}
