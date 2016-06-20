package starling.animation
{
   import starling.events.EventDispatcher;
   
   public class DelayedCall extends EventDispatcher implements IAnimatable
   {
      
      private static var sPool:Vector.<starling.animation.DelayedCall> = new Vector.<starling.animation.DelayedCall>(0);
       
      private var mCurrentTime:Number;
      
      private var mTotalTime:Number;
      
      private var mCall:Function;
      
      private var mArgs:Array;
      
      private var mRepeatCount:int;
      
      public function DelayedCall(param1:Function, param2:Number, param3:Array = null)
      {
         super();
         reset(param1,param2,param3);
      }
      
      static function fromPool(param1:Function, param2:Number, param3:Array = null) : starling.animation.DelayedCall
      {
         if(sPool.length)
         {
            return sPool.pop().reset(param1,param2,param3);
         }
         return new starling.animation.DelayedCall(param1,param2,param3);
      }
      
      static function toPool(param1:starling.animation.DelayedCall) : void
      {
         param1.mCall = null;
         param1.mArgs = null;
         param1.removeEventListeners();
         sPool.push(param1);
      }
      
      public function reset(param1:Function, param2:Number, param3:Array = null) : starling.animation.DelayedCall
      {
         mCurrentTime = 0;
         mTotalTime = Math.max(param2,1.0E-4);
         mCall = param1;
         mArgs = param3;
         mRepeatCount = 1;
         return this;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Number = mCurrentTime;
         mCurrentTime = Math.min(mTotalTime,mCurrentTime + param1);
         if(_loc4_ < mTotalTime && mCurrentTime >= mTotalTime)
         {
            if(mRepeatCount == 0 || mRepeatCount > 1)
            {
               mCall.apply(null,mArgs);
               if(mRepeatCount > 0)
               {
                  mRepeatCount = §§dup().mRepeatCount - 1;
               }
               mCurrentTime = 0;
               advanceTime(_loc4_ + param1 - mTotalTime);
            }
            else
            {
               _loc2_ = mCall;
               _loc3_ = mArgs;
               dispatchEventWith("removeFromJuggler");
               _loc2_.apply(null,_loc3_);
            }
         }
      }
      
      public function get isComplete() : Boolean
      {
         return mRepeatCount == 1 && mCurrentTime >= mTotalTime;
      }
      
      public function get totalTime() : Number
      {
         return mTotalTime;
      }
      
      public function get currentTime() : Number
      {
         return mCurrentTime;
      }
      
      public function get repeatCount() : int
      {
         return mRepeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         mRepeatCount = param1;
      }
   }
}
