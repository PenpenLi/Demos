package feathers.core
{
   import flash.geom.Point;
   
   public interface ITextRenderer extends IFeathersControl
   {
       
      function get text() : String;
      
      function set text(param1:String) : void;
      
      function get baseline() : Number;
      
      function measureText(param1:Point = null) : Point;
   }
}
