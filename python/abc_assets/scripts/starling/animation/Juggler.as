package starling.animation
{
   import starling.events.EventDispatcher;
   import starling.events.Event;
   
   public class Juggler implements starling.animation.IAnimatable
   {
       
      private var mObjects:Vector.<starling.animation.IAnimatable>;
      
      private var mElapsedTime:Number;
      
      public function Juggler()
      {
         super();
         mElapsedTime = 0;
         mObjects = new Vector.<starling.animation.IAnimatable>(0);
      }
      
      public function add(param1:starling.animation.IAnimatable) : void
      {
         var _loc2_:* = null;
         if(param1 && mObjects.indexOf(param1) == -1)
         {
            mObjects.push(param1);
            _loc2_ = param1 as EventDispatcher;
            if(_loc2_)
            {
               _loc2_.addEventListener("removeFromJuggler",onRemove);
            }
         }
      }
      
      public function contains(param1:starling.animation.IAnimatable) : Boolean
      {
         return mObjects.indexOf(param1) != -1;
      }
      
      public function remove(param1:starling.animation.IAnimatable) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:EventDispatcher = param1 as EventDispatcher;
         if(_loc3_)
         {
            _loc3_.removeEventListener("removeFromJuggler",onRemove);
         }
         var _loc2_:int = mObjects.indexOf(param1);
         if(_loc2_ != -1)
         {
            mObjects[_loc2_] = null;
         }
      }
      
      public function removeTweens(param1:Object) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(param1 == null)
         {
            return;
         }
         _loc3_ = mObjects.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = mObjects[_loc3_] as Tween;
            if(_loc2_ && _loc2_.target == param1)
            {
               _loc2_.removeEventListener("removeFromJuggler",onRemove);
               mObjects[_loc3_] = null;
            }
            _loc3_--;
         }
      }
      
      public function containsTweens(param1:Object) : Boolean
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(param1 == null)
         {
            return false;
         }
         _loc3_ = mObjects.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = mObjects[_loc3_] as Tween;
            if(_loc2_ && _loc2_.target == param1)
            {
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public function purge() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         _loc2_ = mObjects.length - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = mObjects[_loc2_] as EventDispatcher;
            if(_loc1_)
            {
               _loc1_.removeEventListener("removeFromJuggler",onRemove);
            }
            mObjects[_loc2_] = null;
            _loc2_--;
         }
      }
      
      public function delayCall(param1:Function, param2:Number, ... rest) : starling.animation.IAnimatable
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:DelayedCall = DelayedCall.fromPool(param1,param2,rest);
         _loc4_.addEventListener("removeFromJuggler",onPooledDelayedCallComplete);
         add(_loc4_);
         return _loc4_;
      }
      
      public function repeatCall(param1:Function, param2:Number, param3:int = 0, ... rest) : starling.animation.IAnimatable
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc5_:DelayedCall = DelayedCall.fromPool(param1,param2,rest);
         _loc5_.repeatCount = param3;
         _loc5_.addEventListener("removeFromJuggler",onPooledDelayedCallComplete);
         add(_loc5_);
         return _loc5_;
      }
      
      private function onPooledDelayedCallComplete(param1:Event) : void
      {
         DelayedCall.toPool(param1.target as DelayedCall);
      }
      
      public function tween(param1:Object, param2:Number, param3:Object) : starling.animation.IAnimatable
      {
         var _loc5_:* = null;
         var _loc4_:Tween = Tween.fromPool(param1,param2);
         var _loc8_:* = 0;
         var _loc7_:* = param3;
         for(var _loc6_ in param3)
         {
            _loc5_ = param3[_loc6_];
            if(_loc4_.hasOwnProperty(_loc6_))
            {
               _loc4_[_loc6_] = _loc5_;
               continue;
            }
            if(param1.hasOwnProperty(_loc6_))
            {
               _loc4_.animate(_loc6_,_loc5_ as Number);
               continue;
            }
            throw new ArgumentError("Invalid property: " + _loc6_);
         }
         _loc4_.addEventListener("removeFromJuggler",onPooledTweenComplete);
         add(_loc4_);
         return _loc4_;
      }
      
      private function onPooledTweenComplete(param1:Event) : void
      {
         Tween.toPool(param1.target as Tween);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc4_:int = mObjects.length;
         var _loc2_:* = 0;
         mElapsedTime = §§dup().mElapsedTime + param1;
         if(_loc4_ == 0)
         {
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = mObjects[_loc5_];
            if(_loc3_)
            {
               if(_loc2_ != _loc5_)
               {
                  mObjects[_loc2_] = _loc3_;
                  mObjects[_loc5_] = null;
               }
               _loc3_.advanceTime(param1);
               _loc2_++;
            }
            _loc5_++;
         }
         if(_loc2_ != _loc5_)
         {
            _loc4_ = mObjects.length;
            while(_loc5_ < _loc4_)
            {
               _loc2_++;
               _loc5_++;
               mObjects[_loc2_] = mObjects[_loc5_];
            }
            mObjects.length = _loc2_;
         }
      }
      
      private function onRemove(param1:Event) : void
      {
         remove(param1.target as starling.animation.IAnimatable);
         var _loc2_:Tween = param1.target as Tween;
         if(_loc2_ && _loc2_.isComplete)
         {
            add(_loc2_.nextTween);
         }
      }
      
      public function get elapsedTime() : Number
      {
         return mElapsedTime;
      }
      
      protected function get objects() : Vector.<starling.animation.IAnimatable>
      {
         return mObjects;
      }
   }
}
