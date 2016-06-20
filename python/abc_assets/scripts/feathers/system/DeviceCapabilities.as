package feathers.system
{
   import flash.display.Stage;
   import flash.system.Capabilities;
   
   public class DeviceCapabilities
   {
      
      public static var tabletScreenMinimumInches:Number = 5;
      
      public static var screenPixelWidth:Number = NaN;
      
      public static var screenPixelHeight:Number = NaN;
      
      public static var dpi:int = Capabilities.screenDPI;
       
      public function DeviceCapabilities()
      {
         super();
      }
      
      public static function isTablet(param1:Stage) : Boolean
      {
         var _loc3_:Number = isNaN(screenPixelWidth)?param1.fullScreenWidth:screenPixelWidth;
         var _loc2_:Number = isNaN(screenPixelHeight)?param1.fullScreenHeight:screenPixelHeight;
         return Math.max(_loc3_,_loc2_) / dpi >= tabletScreenMinimumInches;
      }
      
      public static function isPhone(param1:Stage) : Boolean
      {
         return !isTablet(param1);
      }
      
      public static function screenInchesX(param1:Stage) : Number
      {
         var _loc2_:Number = isNaN(screenPixelWidth)?param1.fullScreenWidth:screenPixelWidth;
         return _loc2_ / dpi;
      }
      
      public static function screenInchesY(param1:Stage) : Number
      {
         var _loc2_:Number = isNaN(screenPixelHeight)?param1.fullScreenHeight:screenPixelHeight;
         return _loc2_ / dpi;
      }
   }
}
