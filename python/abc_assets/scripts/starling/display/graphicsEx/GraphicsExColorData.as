package starling.display.graphicsEx
{
   public class GraphicsExColorData
   {
       
      public var endAlpha:Number = 1.0;
      
      public var endRed:int = 255;
      
      public var endGreen:int = 255;
      
      public var endBlue:int = 255;
      
      public var startAlpha:Number = 1.0;
      
      public var startRed:int = 255;
      
      public var startGreen:int = 255;
      
      public var startBlue:int = 255;
      
      public var colorCallback:Function = null;
      
      public var alphaCallback:Function = null;
      
      public function GraphicsExColorData(param1:uint = 16777215, param2:uint = 16777215, param3:Number = 1.0, param4:Number = 1.0, param5:Function = null, param6:Function = null)
      {
         super();
         endAlpha = param4;
         endRed = param2 >> 16 & 255;
         endGreen = param2 >> 8 & 255;
         endBlue = param2 & 255;
         startAlpha = param3;
         startRed = param1 >> 16 & 255;
         startGreen = param1 >> 8 & 255;
         startBlue = param1 & 255;
         colorCallback = param5;
         alphaCallback = param6;
      }
      
      public function clone() : GraphicsExColorData
      {
         var _loc1_:GraphicsExColorData = new GraphicsExColorData();
         _loc1_.endAlpha = endAlpha;
         _loc1_.endRed = endRed;
         _loc1_.endGreen = endGreen;
         _loc1_.endBlue = endBlue;
         _loc1_.startAlpha = startAlpha;
         _loc1_.startRed = startRed;
         _loc1_.startGreen = startGreen;
         _loc1_.startBlue = startBlue;
         _loc1_.alphaCallback = alphaCallback;
         _loc1_.colorCallback = colorCallback;
         return _loc1_;
      }
   }
}
