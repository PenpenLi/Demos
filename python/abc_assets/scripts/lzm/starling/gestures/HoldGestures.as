package lzm.starling.gestures
{
   import flash.utils.Timer;
   import starling.events.Touch;
   import flash.events.TimerEvent;
   import starling.display.DisplayObject;
   
   public class HoldGestures extends Gestures
   {
       
      private var _timer:Timer;
      
      private var _holdTime:int = 500;
      
      private var _callBackTime:int = 100;
      
      private var _firstHold:Boolean = false;
      
      private var _holdStartCallBack:Function;
      
      private var _holdEndCallBack:Function;
      
      public function HoldGestures(param1:DisplayObject, param2:Function = null, param3:Function = null, param4:Function = null)
      {
         super(param1,param2);
         _holdEndCallBack = param3;
         _holdStartCallBack = param4;
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         if(param1.phase == "began")
         {
            if(_timer == null)
            {
               _timer = new Timer(_holdTime);
               _timer.addEventListener("timer",onTimer);
            }
            _timer.start();
         }
         else if(param1.phase != "moved")
         {
            if(param1.phase == "ended")
            {
               if(_holdEndCallBack && _timer.delay == _callBackTime)
               {
                  _holdEndCallBack();
               }
               _timer.stop();
               _timer.reset();
               _timer.delay = _holdTime;
            }
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(_timer.delay == _holdTime)
         {
            _timer.delay = _callBackTime;
         }
         if(!_firstHold && _holdStartCallBack)
         {
            _holdStartCallBack();
            _firstHold = true;
         }
         if(_callBack)
         {
            _callBack();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(_timer)
         {
            _timer.stop();
            _timer.removeEventListener("timer",onTimer);
            _timer = null;
         }
         _holdEndCallBack = null;
      }
   }
}
