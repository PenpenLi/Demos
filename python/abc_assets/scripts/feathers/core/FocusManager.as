package feathers.core
{
   import flash.display.Sprite;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import flash.display.Stage;
   import starling.display.DisplayObject;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.events.FocusEvent;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class FocusManager implements feathers.core.IFocusManager
   {
      
      protected static const stack:Vector.<feathers.core.IFocusManager> = new Vector.<feathers.core.IFocusManager>(0);
      
      protected static var _defaultFocusManager:feathers.core.IFocusManager;
      
      protected static var _nativeFocusTarget:Sprite;
       
      protected var _topLevelContainer:DisplayObjectContainer;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _savedFocus:feathers.core.IFocusDisplayObject;
      
      protected var _focus:feathers.core.IFocusDisplayObject;
      
      public function FocusManager(param1:DisplayObjectContainer = null, param2:Boolean = true)
      {
         super();
         if(!param1)
         {
            var param1:DisplayObjectContainer = Starling.current.stage;
         }
         this._topLevelContainer = param1;
         this.setFocusManager(this._topLevelContainer);
         this.isEnabled = param2;
      }
      
      public static function get isEnabled() : Boolean
      {
         return _defaultFocusManager != null;
      }
      
      public static function set isEnabled(param1:Boolean) : void
      {
         if(param1 && _defaultFocusManager != null || !param1 && !_defaultFocusManager)
         {
            return;
         }
         if(param1)
         {
            _defaultFocusManager = pushFocusManager();
            _nativeFocusTarget = new Sprite();
            _nativeFocusTarget.tabEnabled = true;
            _nativeFocusTarget.mouseEnabled = false;
            _nativeFocusTarget.mouseChildren = false;
            _nativeFocusTarget.alpha = 0;
            Starling.current.nativeOverlay.addChild(_nativeFocusTarget);
         }
         else
         {
            if(_nativeFocusTarget)
            {
               _nativeFocusTarget.parent.removeChild(_nativeFocusTarget);
               _nativeFocusTarget = null;
            }
            if(_defaultFocusManager)
            {
               removeFocusManager(_defaultFocusManager);
               _defaultFocusManager = null;
            }
         }
      }
      
      public static function pushFocusManager(param1:feathers.core.IFocusManager = null) : feathers.core.IFocusManager
      {
         var _loc2_:* = null;
         if(!param1)
         {
            var param1:feathers.core.IFocusManager = new FocusManager(null,false);
         }
         if(stack.length > 0)
         {
            _loc2_ = stack[stack.length - 1];
            _loc2_.isEnabled = false;
         }
         stack.push(param1);
         param1.isEnabled = true;
         return param1;
      }
      
      public static function removeFocusManager(param1:feathers.core.IFocusManager) : void
      {
         var _loc2_:int = stack.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         param1.isEnabled = false;
         stack.splice(_loc2_,1);
         if(_loc2_ > 0 && _loc2_ == stack.length)
         {
            var param1:feathers.core.IFocusManager = stack[stack.length - 1];
            param1.isEnabled = true;
         }
      }
      
      public static function popFocusManager() : void
      {
         if(stack.length == 0)
         {
            return;
         }
         var _loc1_:feathers.core.IFocusManager = stack[stack.length - 1];
         removeFocusManager(_loc1_);
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(this._isEnabled)
         {
            if(stack.indexOf(this) < 0)
            {
               pushFocusManager(this);
            }
            this._topLevelContainer.addEventListener("added",topLevelContainer_addedHandler);
            this._topLevelContainer.addEventListener("removed",topLevelContainer_removedHandler);
            this._topLevelContainer.addEventListener("touch",topLevelContainer_touchHandler);
            Starling.current.nativeStage.addEventListener("keyFocusChange",stage_keyFocusChangeHandler,false,0,true);
            Starling.current.nativeStage.addEventListener("mouseFocusChange",stage_mouseFocusChangeHandler,false,0,true);
            this.focus = this._savedFocus;
            this._savedFocus = null;
         }
         else
         {
            this._topLevelContainer.removeEventListener("added",topLevelContainer_addedHandler);
            this._topLevelContainer.removeEventListener("removed",topLevelContainer_removedHandler);
            this._topLevelContainer.removeEventListener("touch",topLevelContainer_touchHandler);
            Starling.current.nativeStage.removeEventListener("keyFocusChange",stage_keyFocusChangeHandler);
            Starling.current.nativeStage.addEventListener("mouseFocusChange",stage_mouseFocusChangeHandler);
            _loc2_ = this.focus;
            this.focus = null;
            this._savedFocus = _loc2_;
         }
      }
      
      public function get focus() : feathers.core.IFocusDisplayObject
      {
         return this._focus;
      }
      
      public function set focus(param1:feathers.core.IFocusDisplayObject) : void
      {
         var _loc2_:* = null;
         if(this._focus == param1)
         {
            return;
         }
         if(this._focus)
         {
            this._focus.removeEventListener("removedFromStage",focus_removedFromStageHandler);
            this._focus.dispatchEventWith("focusOut");
            this._focus = null;
         }
         if(!param1 || !param1.isFocusEnabled)
         {
            this._focus = null;
            return;
         }
         if(this._isEnabled)
         {
            this._focus = param1;
            if(this._focus)
            {
               _loc2_ = Starling.current.nativeStage;
               if(!_loc2_.focus)
               {
                  _loc2_.focus = _nativeFocusTarget;
               }
               this._focus.addEventListener("removedFromStage",focus_removedFromStageHandler);
               this._focus.dispatchEventWith("focusIn");
            }
            else
            {
               Starling.current.nativeStage.focus = null;
            }
         }
         else
         {
            this._savedFocus = param1;
         }
      }
      
      protected function setFocusManager(param1:DisplayObject) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         if(param1 is feathers.core.IFocusDisplayObject)
         {
            _loc5_ = feathers.core.IFocusDisplayObject(param1);
            _loc5_.focusManager = this;
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc4_ = DisplayObjectContainer(param1);
            _loc3_ = _loc4_.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc2_ = _loc4_.getChildAt(_loc6_);
               this.setFocusManager(_loc2_);
               _loc6_++;
            }
         }
      }
      
      protected function clearFocusManager(param1:DisplayObject) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         if(param1 is feathers.core.IFocusDisplayObject)
         {
            _loc5_ = feathers.core.IFocusDisplayObject(param1);
            _loc5_.focusManager = null;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc4_ = DisplayObjectContainer(param1);
            _loc3_ = _loc4_.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc2_ = _loc4_.getChildAt(_loc6_);
               this.clearFocusManager(_loc2_);
               _loc6_++;
            }
         }
      }
      
      protected function findPreviousFocus(param1:DisplayObjectContainer, param2:DisplayObject = null) : feathers.core.IFocusDisplayObject
      {
         var _loc6_:* = null;
         var _loc10_:* = undefined;
         var _loc7_:* = false;
         var _loc4_:* = 0;
         var _loc9_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         if(param1 is LayoutViewPort)
         {
            var param1:DisplayObjectContainer = param1.parent;
         }
         var _loc8_:* = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc6_ = IFocusExtras(param1);
            _loc10_ = _loc6_.focusExtrasAfter;
            if(_loc10_)
            {
               _loc7_ = false;
               if(param2)
               {
                  _loc4_ = _loc10_.indexOf(param2) - 1;
                  _loc8_ = _loc4_ >= -1;
                  _loc7_ = !_loc8_;
               }
               else
               {
                  _loc4_ = _loc10_.length - 1;
               }
               if(!_loc7_)
               {
                  _loc9_ = _loc4_;
                  while(_loc9_ >= 0)
                  {
                     _loc3_ = _loc10_[_loc9_];
                     _loc5_ = this.findPreviousChildFocus(_loc3_);
                     if(_loc5_)
                     {
                        return _loc5_;
                     }
                     _loc9_--;
                  }
               }
            }
         }
         if(param2 && !_loc8_)
         {
            _loc4_ = param1.getChildIndex(param2) - 1;
            _loc8_ = _loc4_ >= -1;
         }
         else
         {
            _loc4_ = param1.numChildren - 1;
         }
         _loc9_ = _loc4_;
         while(_loc9_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc9_);
            _loc5_ = this.findPreviousChildFocus(_loc3_);
            if(_loc5_)
            {
               return _loc5_;
            }
            _loc9_--;
         }
         if(param1 is IFocusExtras)
         {
            _loc10_ = _loc6_.focusExtrasBefore;
            if(_loc10_)
            {
               _loc7_ = false;
               if(param2 && !_loc8_)
               {
                  _loc4_ = _loc10_.indexOf(param2) - 1;
                  _loc8_ = _loc4_ >= -1;
                  _loc7_ = !_loc8_;
               }
               else
               {
                  _loc4_ = _loc10_.length - 1;
               }
               if(!_loc7_)
               {
                  _loc9_ = _loc4_;
                  while(_loc9_ >= 0)
                  {
                     _loc3_ = _loc10_[_loc9_];
                     _loc5_ = this.findPreviousChildFocus(_loc3_);
                     if(_loc5_)
                     {
                        return _loc5_;
                     }
                     _loc9_--;
                  }
               }
            }
         }
         if(param2 && param1 != this._topLevelContainer)
         {
            return this.findPreviousFocus(param1.parent,param1);
         }
         return null;
      }
      
      protected function findNextFocus(param1:DisplayObjectContainer, param2:DisplayObject = null) : feathers.core.IFocusDisplayObject
      {
         var _loc7_:* = null;
         var _loc10_:* = undefined;
         var _loc8_:* = false;
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc9_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         if(param1 is LayoutViewPort)
         {
            var param1:DisplayObjectContainer = param1.parent;
         }
         var _loc11_:* = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc7_ = IFocusExtras(param1);
            _loc10_ = _loc7_.focusExtrasBefore;
            if(_loc10_)
            {
               _loc8_ = false;
               if(param2)
               {
                  _loc4_ = _loc10_.indexOf(param2) + 1;
                  _loc11_ = _loc4_ > 0;
                  _loc8_ = !_loc11_;
               }
               else
               {
                  _loc4_ = 0;
               }
               if(!_loc8_)
               {
                  _loc6_ = _loc10_.length;
                  _loc9_ = _loc4_;
                  while(_loc9_ < _loc6_)
                  {
                     _loc3_ = _loc10_[_loc9_];
                     _loc5_ = this.findNextChildFocus(_loc3_);
                     if(_loc5_)
                     {
                        return _loc5_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(param2 && !_loc11_)
         {
            _loc4_ = param1.getChildIndex(param2) + 1;
            _loc11_ = _loc4_ > 0;
         }
         else
         {
            _loc4_ = 0;
         }
         _loc6_ = param1.numChildren;
         _loc9_ = _loc4_;
         while(_loc9_ < _loc6_)
         {
            _loc3_ = param1.getChildAt(_loc9_);
            _loc5_ = this.findNextChildFocus(_loc3_);
            if(_loc5_)
            {
               return _loc5_;
            }
            _loc9_++;
         }
         if(param1 is IFocusExtras)
         {
            _loc10_ = _loc7_.focusExtrasAfter;
            if(_loc10_)
            {
               _loc8_ = false;
               if(param2 && !_loc11_)
               {
                  _loc4_ = _loc10_.indexOf(param2) + 1;
                  _loc11_ = _loc4_ > 0;
                  _loc8_ = !_loc11_;
               }
               else
               {
                  _loc4_ = 0;
               }
               if(!_loc8_)
               {
                  _loc6_ = _loc10_.length;
                  _loc9_ = _loc4_;
                  while(_loc9_ < _loc6_)
                  {
                     _loc3_ = _loc10_[_loc9_];
                     _loc5_ = this.findNextChildFocus(_loc3_);
                     if(_loc5_)
                     {
                        return _loc5_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(param2 && param1 != this._topLevelContainer)
         {
            return this.findNextFocus(param1.parent,param1);
         }
         return null;
      }
      
      protected function findPreviousChildFocus(param1:DisplayObject) : feathers.core.IFocusDisplayObject
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(param1 is feathers.core.IFocusDisplayObject)
         {
            _loc4_ = feathers.core.IFocusDisplayObject(param1);
            if(_loc4_.isFocusEnabled)
            {
               return _loc4_;
            }
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc2_ = this.findPreviousFocus(_loc3_);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function findNextChildFocus(param1:DisplayObject) : feathers.core.IFocusDisplayObject
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(param1 is feathers.core.IFocusDisplayObject)
         {
            _loc4_ = feathers.core.IFocusDisplayObject(param1);
            if(_loc4_.isFocusEnabled)
            {
               return _loc4_;
            }
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc2_ = this.findNextFocus(_loc3_);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function stage_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         param1.preventDefault();
      }
      
      protected function stage_keyFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc3_:* = null;
         if(param1.keyCode != 9 && param1.keyCode != 0)
         {
            return;
         }
         var _loc2_:feathers.core.IFocusDisplayObject = this._focus;
         if(param1.shiftKey)
         {
            if(_loc2_)
            {
               if(_loc2_.previousTabFocus)
               {
                  _loc3_ = _loc2_.previousTabFocus;
               }
               else
               {
                  _loc3_ = this.findPreviousFocus(_loc2_.parent,DisplayObject(_loc2_));
               }
            }
            if(!_loc3_)
            {
               _loc3_ = this.findPreviousFocus(this._topLevelContainer);
            }
         }
         else
         {
            if(_loc2_)
            {
               if(_loc2_.nextTabFocus)
               {
                  _loc3_ = _loc2_.nextTabFocus;
               }
               else
               {
                  _loc3_ = this.findNextFocus(_loc2_.parent,DisplayObject(_loc2_));
               }
            }
            if(!_loc3_)
            {
               _loc3_ = this.findNextFocus(this._topLevelContainer);
            }
         }
         if(_loc3_)
         {
            param1.preventDefault();
         }
         this.focus = _loc3_;
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function topLevelContainer_addedHandler(param1:Event) : void
      {
         this.setFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_removedHandler(param1:Event) : void
      {
         this.clearFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this._topLevelContainer,"began");
         if(!_loc2_)
         {
            return;
         }
         var _loc4_:feathers.core.IFocusDisplayObject = null;
         var _loc3_:DisplayObject = _loc2_.target;
         do
         {
            if(_loc3_ is feathers.core.IFocusDisplayObject)
            {
               _loc4_ = feathers.core.IFocusDisplayObject(_loc3_);
            }
            _loc3_ = _loc3_.parent;
         }
         while(_loc3_);
         
         this.focus = _loc4_;
      }
      
      protected function focus_removedFromStageHandler(param1:Event) : void
      {
         this.focus = null;
      }
   }
}
