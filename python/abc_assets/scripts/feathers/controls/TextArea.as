package feathers.controls
{
   import feathers.core.IFocusDisplayObject;
   import flash.geom.Point;
   import feathers.controls.text.ITextEditorViewPort;
   import starling.display.DisplayObject;
   import feathers.core.PropertyProxy;
   import flash.ui.Mouse;
   import feathers.controls.text.TextFieldTextEditorViewPort;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.Event;
   
   public class TextArea extends Scroller implements IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const SCROLL_POLICY_AUTO:String = "auto";
      
      public static const SCROLL_POLICY_ON:String = "on";
      
      public static const SCROLL_POLICY_OFF:String = "off";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
      
      public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";
      
      public static const INTERACTION_MODE_TOUCH:String = "touch";
      
      public static const INTERACTION_MODE_MOUSE:String = "mouse";
      
      public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
       
      protected var textEditorViewPort:ITextEditorViewPort;
      
      protected var _textEditorHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionStartIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _textAreaTouchPointID:int = -1;
      
      protected var _oldMouseCursor:String = null;
      
      protected var _ignoreTextChanges:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _backgroundFocusedSkin:DisplayObject;
      
      protected var _textEditorFactory:Function;
      
      protected var _textEditorProperties:PropertyProxy;
      
      public function TextArea()
      {
         super();
         this.addEventListener("touch",textArea_touchHandler);
         this.addEventListener("removedFromStage",textArea_removedFromStageHandler);
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return this._isEditable && this._isFocusEnabled;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            var param1:String = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate("styles");
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate("styles");
      }
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundFocusedSkin() : DisplayObject
      {
         return this._backgroundFocusedSkin;
      }
      
      public function set backgroundFocusedSkin(param1:DisplayObject) : void
      {
         if(this._backgroundFocusedSkin == param1)
         {
            return;
         }
         if(this._backgroundFocusedSkin && this._backgroundFocusedSkin != this._backgroundSkin && this._backgroundFocusedSkin != this._backgroundDisabledSkin)
         {
            this.removeChild(this._backgroundFocusedSkin);
         }
         this._backgroundFocusedSkin = param1;
         if(this._backgroundFocusedSkin && this._backgroundFocusedSkin.parent != this)
         {
            this._backgroundFocusedSkin.visible = false;
            this._backgroundFocusedSkin.touchable = false;
            this.addChildAt(this._backgroundFocusedSkin,0);
         }
         this.invalidate("skin");
      }
      
      public function get textEditorFactory() : Function
      {
         return this._textEditorFactory;
      }
      
      public function set textEditorFactory(param1:Function) : void
      {
         if(this._textEditorFactory == param1)
         {
            return;
         }
         this._textEditorFactory = param1;
         this.invalidate("textEditor");
      }
      
      public function get textEditorProperties() : Object
      {
         if(!this._textEditorProperties)
         {
            this._textEditorProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._textEditorProperties;
      }
      
      public function set textEditorProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._textEditorProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            var param1:Object = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
         }
         if(this._textEditorProperties)
         {
            this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._textEditorProperties = PropertyProxy(param1);
         if(this._textEditorProperties)
         {
            this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      override public function showFocus() : void
      {
         if(!this._focusManager || this._focusManager.focus != this)
         {
            return;
         }
         this.selectRange(0,this._text.length);
         super.showFocus();
      }
      
      public function setFocus() : void
      {
         if(this._textEditorHasFocus)
         {
            return;
         }
         if(this.textEditorViewPort)
         {
            this._isWaitingToSetFocus = false;
            this.textEditorViewPort.setFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
            this.invalidate("selected");
         }
      }
      
      public function selectRange(param1:int, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            var param2:* = param1;
         }
         if(param1 < 0)
         {
            throw new RangeError("Expected start index greater than or equal to 0. Received " + param1 + ".");
         }
         if(param2 > this._text.length)
         {
            throw new RangeError("Expected start index less than " + this._text.length + ". Received " + param2 + ".");
         }
         if(this.textEditorViewPort)
         {
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.textEditorViewPort.selectRange(param1,param2);
         }
         else
         {
            this._pendingSelectionStartIndex = param1;
            this._pendingSelectionEndIndex = param2;
            this.invalidate("selected");
         }
      }
      
      override protected function draw() : void
      {
         var _loc5_:* = false;
         var _loc1_:Boolean = this.isInvalid("textEditor");
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         if(_loc1_)
         {
            this.createTextEditor();
         }
         if(_loc1_ || _loc4_)
         {
            this.refreshTextEditorProperties();
         }
         if(_loc1_ || _loc2_)
         {
            _loc5_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditorViewPort.text = this._text;
            this._ignoreTextChanges = _loc5_;
         }
         if(_loc1_ || _loc3_)
         {
            this.textEditorViewPort.isEnabled = this._isEnabled;
            if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
         super.draw();
         this.refreshFocusIndicator();
         this.doPendingActions();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         var _loc3_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            if(!isNaN(this.originalBackgroundWidth))
            {
               _loc3_ = this.originalBackgroundWidth;
            }
            else
            {
               _loc3_ = 0.0;
            }
         }
         if(_loc4_)
         {
            if(!isNaN(this.originalBackgroundHeight))
            {
               _loc1_ = this.originalBackgroundHeight;
            }
            else
            {
               _loc1_ = 0.0;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createTextEditor() : void
      {
         if(this.textEditorViewPort)
         {
            this.textEditorViewPort.removeEventListener("change",textEditor_changeHandler);
            this.textEditorViewPort.removeEventListener("focusIn",textEditor_focusInHandler);
            this.textEditorViewPort.removeEventListener("focusOut",textEditor_focusOutHandler);
            this.textEditorViewPort = null;
         }
         if(this._textEditorFactory != null)
         {
            this.textEditorViewPort = ITextEditorViewPort(this._textEditorFactory());
         }
         else
         {
            this.textEditorViewPort = new TextFieldTextEditorViewPort();
         }
         this.textEditorViewPort.addEventListener("change",textEditor_changeHandler);
         this.textEditorViewPort.addEventListener("focusIn",textEditor_focusInHandler);
         this.textEditorViewPort.addEventListener("focusOut",textEditor_focusOutHandler);
         var _loc1_:ITextEditorViewPort = ITextEditorViewPort(this._viewPort);
         this.viewPort = this.textEditorViewPort;
         if(_loc1_)
         {
            _loc1_.dispose();
         }
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(this._isWaitingToSetFocus || this._focusManager && this._focusManager.focus == this)
         {
            this._isWaitingToSetFocus = false;
            if(!this._textEditorHasFocus)
            {
               this.textEditorViewPort.setFocus();
            }
         }
         if(this._pendingSelectionStartIndex >= 0)
         {
            _loc1_ = this._pendingSelectionStartIndex;
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function refreshTextEditorProperties() : void
      {
         var _loc3_:* = null;
         this.textEditorViewPort.maxChars = this._maxChars;
         this.textEditorViewPort.restrict = this._restrict;
         this.textEditorViewPort.isEditable = this._isEditable;
         var _loc2_:DisplayObject = DisplayObject(this.textEditorViewPort);
         var _loc5_:* = 0;
         var _loc4_:* = this._textEditorProperties;
         for(var _loc1_ in this._textEditorProperties)
         {
            if(_loc2_.hasOwnProperty(_loc1_))
            {
               _loc3_ = this._textEditorProperties[_loc1_];
               this.textEditorViewPort[_loc1_] = _loc3_;
            }
         }
      }
      
      override protected function refreshBackgroundSkin() : void
      {
         if(this._hasFocus && this._backgroundFocusedSkin)
         {
            this.currentBackgroundSkin = this._backgroundFocusedSkin;
            this.setChildIndex(this.currentBackgroundSkin,0);
            this.currentBackgroundSkin.visible = true;
            if(isNaN(this.originalBackgroundWidth))
            {
               this.originalBackgroundWidth = this.currentBackgroundSkin.width;
            }
            if(isNaN(this.originalBackgroundHeight))
            {
               this.originalBackgroundHeight = this.currentBackgroundSkin.height;
            }
            return;
         }
         super.refreshBackgroundSkin();
      }
      
      protected function setFocusOnTextEditorWithTouch(param1:Touch) : void
      {
         if(!this.isFocusEnabled)
         {
            return;
         }
         param1.getLocation(this.stage,HELPER_POINT);
         var _loc2_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT,true));
         if(!this._textEditorHasFocus && _loc2_)
         {
            this.globalToLocal(HELPER_POINT,HELPER_POINT);
            HELPER_POINT.x = HELPER_POINT.x - this._paddingLeft;
            HELPER_POINT.y = HELPER_POINT.y - this._paddingTop;
            this._isWaitingToSetFocus = false;
            this.textEditorViewPort.setFocus(HELPER_POINT);
         }
      }
      
      protected function textArea_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled)
         {
            this._textAreaTouchPointID = -1;
            return;
         }
         var _loc3_:DisplayObject = DisplayObject(this.horizontalScrollBar);
         var _loc4_:DisplayObject = DisplayObject(this.verticalScrollBar);
         if(this._textAreaTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,"ended",this._textAreaTouchPointID);
            if(!_loc2_ || _loc2_.isTouching(_loc4_) || _loc2_.isTouching(_loc3_))
            {
               return;
            }
            this.removeEventListener("scroll",textArea_scrollHandler);
            this._textAreaTouchPointID = -1;
            if(this.textEditorViewPort.setTouchFocusOnEndedPhase)
            {
               this.setFocusOnTextEditorWithTouch(_loc2_);
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(_loc2_)
            {
               if(_loc2_.isTouching(_loc4_) || _loc2_.isTouching(_loc3_))
               {
                  return;
               }
               this._textAreaTouchPointID = _loc2_.id;
               if(!this.textEditorViewPort.setTouchFocusOnEndedPhase)
               {
                  this.setFocusOnTextEditorWithTouch(_loc2_);
               }
               this.addEventListener("scroll",textArea_scrollHandler);
               return;
            }
            _loc2_ = param1.getTouch(this,"hover");
            if(_loc2_)
            {
               if(_loc2_.isTouching(_loc4_) || _loc2_.isTouching(_loc3_))
               {
                  return;
               }
               if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
               {
                  this._oldMouseCursor = Mouse.cursor;
                  Mouse.cursor = "ibeam";
               }
               return;
            }
            if(Mouse.supportsNativeCursor && this._oldMouseCursor)
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
      }
      
      protected function textArea_scrollHandler(param1:Event) : void
      {
         this.removeEventListener("scroll",textArea_scrollHandler);
         this._textAreaTouchPointID = -1;
      }
      
      protected function textArea_removedFromStageHandler(param1:Event) : void
      {
         this._isWaitingToSetFocus = false;
         this._textEditorHasFocus = false;
         this._textAreaTouchPointID = -1;
         this.removeEventListener("scroll",textArea_scrollHandler);
         if(Mouse.supportsNativeCursor && this._oldMouseCursor)
         {
            Mouse.cursor = this._oldMouseCursor;
            this._oldMouseCursor = null;
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusInHandler(param1);
         this.setFocus();
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusOutHandler(param1);
         this.textEditorViewPort.clearFocus();
         this.invalidate("state");
      }
      
      protected function textEditor_changeHandler(param1:Event) : void
      {
         if(this._ignoreTextChanges)
         {
            return;
         }
         this.text = this.textEditorViewPort.text;
      }
      
      protected function textEditor_focusInHandler(param1:Event) : void
      {
         this._textEditorHasFocus = true;
         this._touchPointID = -1;
         this.invalidate("state");
         if(this._focusManager)
         {
            this._focusManager.focus = this;
         }
         else
         {
            this.dispatchEventWith("focusIn");
         }
      }
      
      protected function textEditor_focusOutHandler(param1:Event) : void
      {
         this._textEditorHasFocus = false;
         this.invalidate("state");
         if(this._focusManager)
         {
            return;
         }
         this.dispatchEventWith("focusOut");
      }
   }
}
