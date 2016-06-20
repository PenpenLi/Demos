package lzm.util
{
   import flash.utils.getTimer;
   import flash.display.Stage;
   
   public class AutoSkip
   {
       
      private var lastTimer:int;
      
      private var deadLine:int;
      
      private var minContiguousFrames:int;
      
      private var maxContiguousSkips:int;
      
      private var framesRendered:int;
      
      private var framesSkipped:int;
      
      public function AutoSkip(param1:Stage, param2:Number = 1.2, param3:int = 1, param4:int = 1)
      {
         super();
         this.lastTimer = 0;
         this.deadLine = Math.ceil(1000 / param1.frameRate * param2);
         this.minContiguousFrames = param3;
         this.maxContiguousSkips = param4;
         framesRendered = 0;
         framesSkipped = 0;
      }
      
      public function requestFrameSkip() : Boolean
      {
         var _loc3_:* = false;
         var _loc2_:int = getTimer();
         var _loc1_:int = _loc2_ - lastTimer;
         if(_loc1_ > deadLine && framesRendered >= minContiguousFrames && framesSkipped < maxContiguousSkips)
         {
            _loc3_ = true;
            framesRendered = 0;
            framesSkipped = §§dup().framesSkipped + 1;
         }
         else
         {
            framesSkipped = 0;
            framesRendered = §§dup().framesRendered + 1;
         }
         lastTimer = _loc2_;
         return _loc3_;
      }
   }
}
