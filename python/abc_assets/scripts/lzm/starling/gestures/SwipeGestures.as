package lzm.starling.gestures
{
   import flash.geom.Point;
   import starling.events.Touch;
   import flash.utils.getTimer;
   import starling.display.DisplayObject;
   
   public class SwipeGestures extends Gestures
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private static const DISTIME:int = 300;
      
      private static const DIS:int = 50;
       
      private var _downPoint:Point;
      
      private var _downTime:int;
      
      public function SwipeGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         var _loc2_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1.phase == "began")
         {
            _downPoint = param1.getLocation(_target.stage);
            _downTime = getTimer();
         }
         else if(param1.phase == "ended")
         {
            _loc2_ = getTimer() - _downTime;
            _loc5_ = param1.getLocation(_target.stage);
            if(300 < _loc2_)
            {
               return;
            }
            _loc3_ = _loc5_.x - _downPoint.x;
            _loc4_ = _loc5_.y - _downPoint.y;
            if(Math.abs(_loc3_) > Math.abs(_loc4_))
            {
               if(Math.abs(_loc3_) > 50 && _callBack != null)
               {
                  _callBack(_loc3_ > 0?"right":"left");
               }
            }
            else if(Math.abs(_loc4_) > 50 && _callBack != null)
            {
               _callBack(_loc4_ > 0?"down":"up");
            }
         }
      }
   }
}
