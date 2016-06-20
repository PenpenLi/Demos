package feathers.motion.transitions
{
   import feathers.controls.ScreenNavigator;
   import feathers.controls.TabBar;
   import starling.animation.Tween;
   import starling.display.DisplayObject;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class TabBarSlideTransitionManager
   {
       
      protected var navigator:ScreenNavigator;
      
      protected var tabBar:TabBar;
      
      protected var _activeTransition:Tween;
      
      protected var _savedOtherTarget:DisplayObject;
      
      protected var _savedCompleteHandler:Function;
      
      protected var _oldScreen:DisplayObject;
      
      protected var _newScreen:DisplayObject;
      
      protected var _oldIndex:int;
      
      protected var _isFromRight:Boolean = true;
      
      protected var _isWaitingOnTabBarChange:Boolean = true;
      
      protected var _isWaitingOnTransitionChange:Boolean = true;
      
      public var duration:Number = 0.25;
      
      public var delay:Number = 0.1;
      
      public var ease:Object = "easeOut";
      
      public var skipNextTransition:Boolean = false;
      
      public function TabBarSlideTransitionManager(param1:ScreenNavigator, param2:TabBar)
      {
         super();
         if(!param1)
         {
            throw new ArgumentError("ScreenNavigator cannot be null.");
         }
         this.navigator = param1;
         this.tabBar = param2;
         this._oldIndex = param2.selectedIndex;
         this.tabBar.addEventListener("change",tabBar_changeHandler);
         this.navigator.transition = this.onTransition;
      }
      
      protected function onTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         this._oldScreen = param1;
         this._newScreen = param2;
         this._savedCompleteHandler = param3;
         if(!this._isWaitingOnTabBarChange)
         {
            this.transitionNow();
         }
         else
         {
            this._isWaitingOnTransitionChange = false;
         }
      }
      
      protected function transitionNow() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(this._activeTransition)
         {
            this._savedOtherTarget = null;
            Starling.juggler.remove(this._activeTransition);
            this._activeTransition = null;
         }
         if(!this._oldScreen || !this._newScreen || this.skipNextTransition)
         {
            this.skipNextTransition = false;
            _loc2_ = this._savedCompleteHandler;
            this._savedCompleteHandler = null;
            if(this._oldScreen)
            {
               this._oldScreen.x = 0;
            }
            if(this._newScreen)
            {
               this._newScreen.x = 0;
            }
            if(_loc2_ != null)
            {
               _loc2_();
            }
         }
         else
         {
            this._oldScreen.x = 0;
            if(this._isFromRight)
            {
               this._newScreen.x = this.navigator.width;
               _loc1_ = this.activeTransitionFromRight_onUpdate;
            }
            else
            {
               this._newScreen.x = -this.navigator.width;
               _loc1_ = this.activeTransitionFromLeft_onUpdate;
            }
            this._savedOtherTarget = this._oldScreen;
            this._activeTransition = new Tween(this._newScreen,this.duration,this.ease);
            this._activeTransition.animate("x",0);
            this._activeTransition.delay = this.delay;
            this._activeTransition.onUpdate = _loc1_;
            this._activeTransition.onComplete = activeTransition_onComplete;
            Starling.juggler.add(this._activeTransition);
         }
         this._oldScreen = null;
         this._newScreen = null;
         this._isWaitingOnTabBarChange = true;
         this._isWaitingOnTransitionChange = true;
      }
      
      protected function activeTransitionFromRight_onUpdate() : void
      {
         var _loc1_:* = null;
         if(this._savedOtherTarget)
         {
            _loc1_ = DisplayObject(this._activeTransition.target);
            this._savedOtherTarget.x = _loc1_.x - this.navigator.width;
         }
      }
      
      protected function activeTransitionFromLeft_onUpdate() : void
      {
         var _loc1_:* = null;
         if(this._savedOtherTarget)
         {
            _loc1_ = DisplayObject(this._activeTransition.target);
            this._savedOtherTarget.x = _loc1_.x + this.navigator.width;
         }
      }
      
      protected function activeTransition_onComplete() : void
      {
         this._savedOtherTarget = null;
         this._activeTransition = null;
         if(this._savedCompleteHandler != null)
         {
            this._savedCompleteHandler();
         }
      }
      
      protected function tabBar_changeHandler(param1:Event) : void
      {
         var _loc2_:int = this.tabBar.selectedIndex;
         this._isFromRight = _loc2_ > this._oldIndex;
         this._oldIndex = _loc2_;
         if(!this._isWaitingOnTransitionChange)
         {
            this.transitionNow();
         }
         else
         {
            this._isWaitingOnTabBarChange = false;
         }
      }
   }
}
