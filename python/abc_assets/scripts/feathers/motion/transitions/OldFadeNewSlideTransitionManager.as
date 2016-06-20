package feathers.motion.transitions
{
   import feathers.controls.ScreenNavigator;
   import starling.animation.Tween;
   import starling.display.DisplayObject;
   import starling.core.Starling;
   import flash.utils.getQualifiedClassName;
   import feathers.controls.IScreen;
   
   public class OldFadeNewSlideTransitionManager
   {
       
      protected var navigator:ScreenNavigator;
      
      protected var _stack:Vector.<String>;
      
      protected var _activeTransition:Tween;
      
      protected var _savedCompleteHandler:Function;
      
      protected var _savedOtherTarget:DisplayObject;
      
      public var duration:Number = 0.25;
      
      public var delay:Number = 0.1;
      
      public var ease:Object = "easeOut";
      
      public var skipNextTransition:Boolean = false;
      
      public function OldFadeNewSlideTransitionManager(param1:ScreenNavigator, param2:Class = null, param3:String = null)
      {
         var _loc4_:* = null;
         _stack = new Vector.<String>(0);
         super();
         if(!param1)
         {
            throw new ArgumentError("ScreenNavigator cannot be null.");
         }
         this.navigator = param1;
         if(param2)
         {
            _loc4_ = getQualifiedClassName(param2);
         }
         if(_loc4_ && param3)
         {
            _loc4_ = _loc4_ + ("~" + param3);
         }
         if(_loc4_)
         {
            this._stack.push(_loc4_);
         }
         this.navigator.transition = this.onTransition;
      }
      
      public function clearStack() : void
      {
         this._stack.length = 0;
      }
      
      protected function onTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         var _loc4_:* = null;
         if(this._activeTransition)
         {
            Starling.juggler.remove(this._activeTransition);
            this._activeTransition = null;
            this._savedOtherTarget = null;
         }
         if(!param1 || this.skipNextTransition)
         {
            this.skipNextTransition = false;
            this._savedCompleteHandler = null;
            if(param2)
            {
               param2.x = 0;
            }
            if(param3 != null)
            {
               param3();
            }
            return;
         }
         this._savedCompleteHandler = param3;
         if(!param2)
         {
            param1.x = 0;
            this._activeTransition = new Tween(param1,this.duration,this.ease);
            this._activeTransition.fadeTo(0);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onComplete = activeTransition_onComplete;
            Starling.juggler.add(this._activeTransition);
            return;
         }
         var _loc5_:String = getQualifiedClassName(param2);
         if(param2 is IScreen)
         {
            _loc5_ = _loc5_ + ("~" + IScreen(param2).screenID);
         }
         var _loc6_:int = this._stack.indexOf(_loc5_);
         if(_loc6_ < 0)
         {
            _loc4_ = getQualifiedClassName(param1);
            if(param1 is IScreen)
            {
               _loc4_ = _loc4_ + ("~" + IScreen(param1).screenID);
            }
            this._stack.push(_loc4_);
            param1.x = 0;
            param2.x = this.navigator.width;
         }
         else
         {
            this._stack.length = _loc6_;
            param1.x = 0;
            param2.x = -this.navigator.width;
         }
         param2.alpha = 1;
         this._savedOtherTarget = param1;
         this._activeTransition = new Tween(param2,this.duration,this.ease);
         this._activeTransition.animate("x",0);
         this._activeTransition.delay = this.delay;
         this._activeTransition.onUpdate = activeTransition_onUpdate;
         this._activeTransition.onComplete = activeTransition_onComplete;
         Starling.juggler.add(this._activeTransition);
      }
      
      protected function activeTransition_onUpdate() : void
      {
         if(this._savedOtherTarget)
         {
            this._savedOtherTarget.alpha = 1 - this._activeTransition.currentTime / this._activeTransition.totalTime;
         }
      }
      
      protected function activeTransition_onComplete() : void
      {
         this._activeTransition = null;
         this._savedOtherTarget = null;
         if(this._savedCompleteHandler != null)
         {
            this._savedCompleteHandler();
         }
      }
   }
}
