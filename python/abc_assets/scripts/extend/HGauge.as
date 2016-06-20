package extend
{
   import starling.display.Image;
   import flash.geom.Point;
   import starling.textures.Texture;
   
   public class HGauge extends Image
   {
       
      private var _ratio:Number;
      
      public function HGauge(param1:Texture)
      {
         super(param1);
      }
      
      private function update() : void
      {
         scaleY = _ratio;
         setTexCoords(2,new Point(0,_ratio));
         setTexCoords(3,new Point(1,_ratio));
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
