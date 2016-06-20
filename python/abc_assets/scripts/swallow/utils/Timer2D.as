package swallow.utils
{
   import swallow.events.TimerEvent2D;
   import flash.utils.getTimer;
   
   public class Timer2D
   {
       
      public var delay:int;
      
      public var repeatCount:int = -1;
      
      public var targetRepeatCount:int;
      
      private var _targetDelay:int;
      
      private var _currentDelay:int;
      
      private var _start:Boolean;
      
      private var timerRunFunction:Function;
      
      private var timerEndFunction:Function;
      
      private var timerResetFunction:Function;
      
      private var timerStartFunction:Function;
      
      private var timerStopFunction:Function;
      
      private var suspendValue:int;
      
      private var _suspendValue:int;
      
      private var _suspendValueEnd:int;
      
      private var timerEvent2D:TimerEvent2D;
      
      public function Timer2D(param1:int = 10)
      {
         super();
         TimerLists.target.addTimer(this);
         this.delay = param1;
         timerEvent2D = new TimerEvent2D();
         timerEvent2D.target = this;
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         var _loc3_:* = param1;
         if(TimerEvent2D.TIMER !== _loc3_)
         {
            if(TimerEvent2D.TIMER_END !== _loc3_)
            {
               if(TimerEvent2D.TIMER_RESET !== _loc3_)
               {
                  if(TimerEvent2D.TIMER_SRATR !== _loc3_)
                  {
                     if(TimerEvent2D.TIMER_STOP === _loc3_)
                     {
                        timerStopFunction = param2;
                     }
                  }
                  else
                  {
                     timerStartFunction = param2;
                  }
               }
               else
               {
                  timerResetFunction = param2;
               }
            }
            else
            {
               timerEndFunction = param2;
            }
         }
         else
         {
            timerRunFunction = param2;
         }
      }
      
      public function removeEventListener(param1:String) : void
      {
         var _loc2_:* = param1;
         if(TimerEvent2D.TIMER !== _loc2_)
         {
            if(TimerEvent2D.TIMER_END !== _loc2_)
            {
               if(TimerEvent2D.TIMER_RESET !== _loc2_)
               {
                  if(TimerEvent2D.TIMER_SRATR !== _loc2_)
                  {
                     if(TimerEvent2D.TIMER_STOP === _loc2_)
                     {
                        timerStopFunction = null;
                     }
                  }
                  else
                  {
                     timerStartFunction = null;
                  }
               }
               else
               {
                  timerResetFunction = null;
               }
            }
            else
            {
               timerEndFunction = null;
            }
         }
         else
         {
            timerRunFunction = null;
         }
      }
      
      public function start() : void
      {
         if(!_start)
         {
            _start = true;
            _targetDelay = getTimer();
            if(timerStartFunction != null)
            {
               timerStartFunction(timerEvent2D);
            }
         }
      }
      
      public function stop() : void
      {
         _start = false;
         if(timerStopFunction != null)
         {
            timerStopFunction(timerEvent2D);
         }
      }
      
      public function reset() : void
      {
         _targetDelay = getTimer();
         targetRepeatCount = 0;
         if(timerResetFunction != null)
         {
            timerResetFunction(timerEvent2D);
         }
      }
      
      public function dispose() : void
      {
         TimerLists.target.removeTimer(this);
      }
      
      public function suspend(param1:int) : void
      {
         if(_start)
         {
            suspendValue = param1;
            _suspendValue = getTimer();
         }
      }
      
      public function run() : void
      {
         if(suspendValue != 0)
         {
            _suspendValueEnd = getTimer();
            if(_suspendValueEnd - _suspendValue >= suspendValue)
            {
               suspendValue = 0;
            }
            else
            {
               return;
            }
         }
         if(_start)
         {
            _currentDelay = getTimer();
            if(_currentDelay - _targetDelay >= delay)
            {
               _targetDelay = getTimer();
               targetRepeatCount = targetRepeatCount + 1;
               if(timerRunFunction != null)
               {
                  timerEvent2D.targetRepeatCount = targetRepeatCount;
                  timerEvent2D.repeatCount = repeatCount;
                  timerRunFunction(timerEvent2D);
               }
               if(repeatCount != -1 && targetRepeatCount >= repeatCount)
               {
                  _start = false;
                  if(timerEndFunction != null)
                  {
                     timerEndFunction(timerEvent2D);
                  }
               }
            }
         }
      }
   }
}
