package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import flash.geom.Point;
   import feathers.core.ITextEditor;
   import feathers.core.ITextRenderer;
   import starling.display.DisplayObject;
   import feathers.core.PropertyProxy;
   import feathers.skins.StateValueSelector;
   import flash.ui.Mouse;
   import feathers.core.IValidating;
   import feathers.core.IFeathersControl;
   import starling.events.Touch;
   import starling.events.Event;
   import starling.events.TouchEvent;
   
   public class TextInput extends FeathersControl implements IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const STATE_ENABLED:String = "enabled";
      
      public static const STATE_DISABLED:String = "disabled";
      
      public static const STATE_FOCUSED:String = "focused";
      
      public static const ALTERNATE_NAME_SEARCH_TEXT_INPUT:String = "feathers-search-text-input";
      
      protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";
       
      protected var textEditor:ITextEditor;
      
      protected var promptTextRenderer:ITextRenderer;
      
      protected var currentBackground:DisplayObject;
      
      protected var currentIcon:DisplayObject;
      
      protected var _textEditorHasFocus:Boolean = false;
      
      protected var _ignoreTextChanges:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _stateNames:Vector.<String>;
      
      protected var _currentState:String = "enabled";
      
      protected var _text:String = "";
      
      protected var _prompt:String;
      
      protected var _typicalText:String;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _textEditorFactory:Function;
      
      protected var _promptFactory:Function;
      
      protected var _promptProperties:PropertyProxy;
      
      protected var _originalSkinWidth:Number = NaN;
      
      protected var _originalSkinHeight:Number = NaN;
      
      protected var _skinSelector:StateValueSelector;
      
      protected var _stateToSkinFunction:Function;
      
      protected var _iconSelector:StateValueSelector;
      
      protected var _stateToIconFunction:Function;
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionStartIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _oldMouseCursor:String = null;
      
      protected var _textEditorProperties:PropertyProxy;
      
      public function TextInput()
      {
         _stateNames = new <String>["enabled","disabled","focused"];
         _skinSelector = new StateValueSelector();
         _iconSelector = new StateValueSelector();
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("touch",textInput_touchHandler);
         this.addEventListener("removedFromStage",textInput_removedFromStageHandler);
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return this._isEditable && this._isFocusEnabled;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         .super.isEnabled = param1;
         if(this._isEnabled)
         {
            this.currentState = this._hasFocus?"focused":"enabled";
         }
         else
         {
            this.currentState = "disabled";
         }
      }
      
      protected function get stateNames() : Vector.<String>
      {
         return this._stateNames;
      }
      
      protected function get currentState() : String
      {
         return this._currentState;
      }
      
      protected function set currentState(param1:String) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         if(this.stateNames.indexOf(param1) < 0)
         {
            throw new ArgumentError("Invalid state: " + param1 + ".");
         }
         this._currentState = param1;
         this.invalidate("state");
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
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate("styles");
      }
      
      public function get typicalText() : String
      {
         return this._typicalText;
      }
      
      public function set typicalText(param1:String) : void
      {
         if(this._typicalText == param1)
         {
            return;
         }
         this._typicalText = param1;
         this.invalidate("data");
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
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
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
      
      public function get promptFactory() : Function
      {
         return this._promptFactory;
      }
      
      public function set promptFactory(param1:Function) : void
      {
         if(this._promptFactory == param1)
         {
            return;
         }
         this._promptFactory = param1;
         this.invalidate("promptFactory");
      }
      
      public function get promptProperties() : Object
      {
         if(!this._promptProperties)
         {
            this._promptProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._promptProperties;
      }
      
      public function set promptProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._promptProperties == param1)
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
         if(this._promptProperties)
         {
            this._promptProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._promptProperties = PropertyProxy(param1);
         if(this._promptProperties)
         {
            this._promptProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.defaultValue);
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.defaultValue == param1)
         {
            return;
         }
         this._skinSelector.defaultValue = param1;
         this.invalidate("skin");
      }
      
      public function get backgroundEnabledSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("enabled"));
      }
      
      public function set backgroundEnabledSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("enabled") == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"enabled");
         this.invalidate("skin");
      }
      
      public function get backgroundFocusedSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("focused"));
      }
      
      public function set backgroundFocusedSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("focused") == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"focused");
         this.invalidate("skin");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("disabled"));
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("disabled") == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"disabled");
         this.invalidate("skin");
      }
      
      public function get stateToSkinFunction() : Function
      {
         return this._stateToSkinFunction;
      }
      
      public function set stateToSkinFunction(param1:Function) : void
      {
         if(this._stateToSkinFunction == param1)
         {
            return;
         }
         this._stateToSkinFunction = param1;
         this.invalidate("skin");
      }
      
      public function get defaultIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.defaultValue);
      }
      
      public function set defaultIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.defaultValue == param1)
         {
            return;
         }
         this._iconSelector.defaultValue = param1;
         this.invalidate("styles");
      }
      
      public function get enabledIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("enabled"));
      }
      
      public function set enabledIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("enabled") == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"enabled");
         this.invalidate("styles");
      }
      
      public function get disabledIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("disabled"));
      }
      
      public function set disabledIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("disabled") == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"disabled");
         this.invalidate("styles");
      }
      
      public function get focusedIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("focused"));
      }
      
      public function set focusedIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("focused") == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"focused");
         this.invalidate("styles");
      }
      
      public function get stateToIconFunction() : Function
      {
         return this._stateToIconFunction;
      }
      
      public function set stateToIconFunction(param1:Function) : void
      {
         if(this._stateToIconFunction == param1)
         {
            return;
         }
         this._stateToIconFunction = param1;
         this.invalidate("styles");
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate("styles");
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate("styles");
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate("styles");
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate("styles");
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate("styles");
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
      
      override public function set visible(param1:Boolean) : void
      {
         if(!param1)
         {
            this._isWaitingToSetFocus = false;
            if(this._textEditorHasFocus)
            {
               this.textEditor.clearFocus();
            }
         }
         .super.visible = param1;
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
         if(this._textEditorHasFocus || !this.visible)
         {
            return;
         }
         if(this.textEditor)
         {
            this._isWaitingToSetFocus = false;
            this.textEditor.setFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
            this.invalidate("selected");
         }
      }
      
      public function clearFocus() : void
      {
         this._isWaitingToSetFocus = false;
         if(!this.textEditor || !this._textEditorHasFocus)
         {
            return;
         }
         this.textEditor.clearFocus();
      }
      
      public function selectRange(param1:int, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            var param2:* = param1;
         }
         if(param1 < 0)
         {
            throw new RangeError("Expected start index >= 0. Received " + param1 + ".");
         }
         if(param2 > this._text.length)
         {
            throw new RangeError("Expected end index <= " + this._text.length + ". Received " + param2 + ".");
         }
         if(this.textEditor && (this._isValidating || !this.isInvalid()))
         {
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.textEditor.selectRange(param1,param2);
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
         var _loc9_:* = false;
         var _loc6_:Boolean = this.isInvalid("state");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("skin");
         var _loc3_:Boolean = this.isInvalid("size");
         var _loc1_:Boolean = this.isInvalid("textEditor");
         var _loc7_:Boolean = this.isInvalid("promptFactory");
         var _loc4_:Boolean = this.isInvalid("focus");
         if(_loc1_)
         {
            this.createTextEditor();
         }
         if(_loc7_)
         {
            this.createPrompt();
         }
         if(_loc1_ || _loc8_)
         {
            this.refreshTextEditorProperties();
         }
         if(_loc7_ || _loc8_)
         {
            this.refreshPromptProperties();
         }
         if(_loc1_ || _loc5_)
         {
            _loc9_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditor.text = this._text;
            this._ignoreTextChanges = _loc9_;
         }
         if(_loc7_ || _loc5_ || _loc8_)
         {
            this.promptTextRenderer.visible = this._prompt && this._text.length == 0;
         }
         if(_loc1_ || _loc6_)
         {
            this.textEditor.isEnabled = this._isEnabled;
            if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
         if(_loc6_ || _loc2_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc6_ || _loc8_)
         {
            this.refreshIcon();
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         this.layoutChildren();
         if(_loc3_ || _loc4_)
         {
            this.refreshFocusIndicator();
         }
         this.doPendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc7_:* = false;
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc6_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc6_)
         {
            return false;
         }
         var _loc3_:* = 0.0;
         var _loc5_:* = 0.0;
         if(this._typicalText)
         {
            _loc7_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditor.setSize(NaN,NaN);
            this.textEditor.text = this._typicalText;
            this.textEditor.measureText(HELPER_POINT);
            this.textEditor.text = this._text;
            this._ignoreTextChanges = _loc7_;
            _loc3_ = HELPER_POINT.x;
            _loc5_ = HELPER_POINT.y;
         }
         if(this._prompt)
         {
            this.promptTextRenderer.setSize(NaN,NaN);
            this.promptTextRenderer.measureText(HELPER_POINT);
            _loc3_ = Math.max(_loc3_,HELPER_POINT.x);
            _loc5_ = Math.max(_loc5_,HELPER_POINT.y);
         }
         var _loc4_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            _loc4_ = Math.max(this._originalSkinWidth,_loc3_ + this._paddingLeft + this._paddingRight);
         }
         if(_loc6_)
         {
            _loc1_ = Math.max(this._originalSkinHeight,_loc5_ + this._paddingTop + this._paddingBottom);
         }
         if(this._typicalText)
         {
            this.textEditor.width = this.actualWidth - this._paddingLeft - this._paddingRight;
            this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         }
         return this.setSizeInternal(_loc4_,_loc1_,false);
      }
      
      protected function createTextEditor() : void
      {
         if(this.textEditor)
         {
            this.removeChild(DisplayObject(this.textEditor),true);
            this.textEditor.removeEventListener("change",textEditor_changeHandler);
            this.textEditor.removeEventListener("enter",textEditor_enterHandler);
            this.textEditor.removeEventListener("focusIn",textEditor_focusInHandler);
            this.textEditor.removeEventListener("focusOut",textEditor_focusOutHandler);
            this.textEditor = null;
         }
         var _loc1_:Function = this._textEditorFactory != null?this._textEditorFactory:FeathersControl.defaultTextEditorFactory;
         this.textEditor = ITextEditor(_loc1_());
         this.textEditor.addEventListener("change",textEditor_changeHandler);
         this.textEditor.addEventListener("enter",textEditor_enterHandler);
         this.textEditor.addEventListener("focusIn",textEditor_focusInHandler);
         this.textEditor.addEventListener("focusOut",textEditor_focusOutHandler);
         this.addChild(DisplayObject(this.textEditor));
      }
      
      protected function createPrompt() : void
      {
         if(this.promptTextRenderer)
         {
            this.removeChild(DisplayObject(this.promptTextRenderer),true);
            this.promptTextRenderer = null;
         }
         var _loc1_:Function = this._promptFactory != null?this._promptFactory:FeathersControl.defaultTextRendererFactory;
         this.promptTextRenderer = ITextRenderer(_loc1_());
         this.addChild(DisplayObject(this.promptTextRenderer));
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            if(!this._textEditorHasFocus)
            {
               this.textEditor.setFocus();
            }
         }
         if(this._pendingSelectionStartIndex >= 0)
         {
            _loc1_ = this._pendingSelectionStartIndex;
            _loc3_ = this._pendingSelectionEndIndex;
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            if(_loc3_ >= 0)
            {
               _loc2_ = this._text.length;
               if(_loc3_ > _loc2_)
               {
                  _loc3_ = _loc2_;
               }
            }
            this.selectRange(_loc1_,_loc3_);
         }
      }
      
      protected function refreshTextEditorProperties() : void
      {
         var _loc3_:* = null;
         this.textEditor.displayAsPassword = this._displayAsPassword;
         this.textEditor.maxChars = this._maxChars;
         this.textEditor.restrict = this._restrict;
         this.textEditor.isEditable = this._isEditable;
         var _loc2_:DisplayObject = DisplayObject(this.textEditor);
         var _loc5_:* = 0;
         var _loc4_:* = this._textEditorProperties;
         for(var _loc1_ in this._textEditorProperties)
         {
            if(_loc2_.hasOwnProperty(_loc1_))
            {
               _loc3_ = this._textEditorProperties[_loc1_];
               this.textEditor[_loc1_] = _loc3_;
            }
         }
      }
      
      protected function refreshPromptProperties() : void
      {
         var _loc3_:* = null;
         this.promptTextRenderer.text = this._prompt;
         var _loc2_:DisplayObject = DisplayObject(this.promptTextRenderer);
         var _loc5_:* = 0;
         var _loc4_:* = this._promptProperties;
         for(var _loc1_ in this._promptProperties)
         {
            if(_loc2_.hasOwnProperty(_loc1_))
            {
               _loc3_ = this._promptProperties[_loc1_];
               this.promptTextRenderer[_loc1_] = _loc3_;
            }
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc1_:DisplayObject = this.currentBackground;
         if(this._stateToSkinFunction != null)
         {
            this.currentBackground = DisplayObject(this._stateToSkinFunction(this,this._currentState,_loc1_));
         }
         else
         {
            this.currentBackground = DisplayObject(this._skinSelector.updateValue(this,this._currentState,this.currentBackground));
         }
         if(this.currentBackground != _loc1_)
         {
            if(_loc1_)
            {
               this.removeChild(_loc1_,false);
            }
            if(this.currentBackground)
            {
               this.addChildAt(this.currentBackground,0);
            }
         }
         if(this.currentBackground && (isNaN(this._originalSkinWidth) || isNaN(this._originalSkinHeight)))
         {
            if(this.currentBackground is IValidating)
            {
               IValidating(this.currentBackground).validate();
            }
            this._originalSkinWidth = this.currentBackground.width;
            this._originalSkinHeight = this.currentBackground.height;
         }
      }
      
      protected function refreshIcon() : void
      {
         var _loc1_:* = 0;
         var _loc2_:DisplayObject = this.currentIcon;
         if(this._stateToIconFunction != null)
         {
            this.currentIcon = DisplayObject(this._stateToIconFunction(this,this._currentState,_loc2_));
         }
         else
         {
            this.currentIcon = DisplayObject(this._iconSelector.updateValue(this,this._currentState,this.currentIcon));
         }
         if(this.currentIcon is IFeathersControl)
         {
            IFeathersControl(this.currentIcon).isEnabled = this._isEnabled;
         }
         if(this.currentIcon != _loc2_)
         {
            if(_loc2_)
            {
               this.removeChild(_loc2_,false);
            }
            if(this.currentIcon)
            {
               _loc1_ = this.getChildIndex(DisplayObject(this.textEditor));
               this.addChildAt(this.currentIcon,_loc1_);
            }
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackground)
         {
            this.currentBackground.visible = true;
            this.currentBackground.touchable = true;
            this.currentBackground.width = this.actualWidth;
            this.currentBackground.height = this.actualHeight;
         }
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         if(this.currentIcon)
         {
            this.currentIcon.x = this._paddingLeft;
            this.currentIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2;
            this.textEditor.x = this.currentIcon.x + this.currentIcon.width + this._gap;
            this.promptTextRenderer.x = this.currentIcon.x + this.currentIcon.width + this._gap;
         }
         else
         {
            this.textEditor.x = this._paddingLeft;
            this.promptTextRenderer.x = this._paddingLeft;
         }
         this.textEditor.y = this._paddingTop;
         this.textEditor.width = this.actualWidth - this._paddingRight - this.textEditor.x;
         this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         this.promptTextRenderer.y = this._paddingTop;
         this.promptTextRenderer.width = this.actualWidth - this._paddingRight - this.promptTextRenderer.x;
         this.promptTextRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
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
            this.textEditor.setFocus(HELPER_POINT);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function textInput_removedFromStageHandler(param1:Event) : void
      {
         this._textEditorHasFocus = false;
         this._isWaitingToSetFocus = false;
         this._touchPointID = -1;
         if(Mouse.supportsNativeCursor && this._oldMouseCursor)
         {
            Mouse.cursor = this._oldMouseCursor;
            this._oldMouseCursor = null;
         }
      }
      
      protected function textInput_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled || !this._isEditable)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,"ended",this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = -1;
            if(this.textEditor.setTouchFocusOnEndedPhase)
            {
               this.setFocusOnTextEditorWithTouch(_loc2_);
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(_loc2_)
            {
               this._touchPointID = _loc2_.id;
               if(!this.textEditor.setTouchFocusOnEndedPhase)
               {
                  this.setFocusOnTextEditorWithTouch(_loc2_);
               }
               return;
            }
            _loc2_ = param1.getTouch(this,"hover");
            if(_loc2_)
            {
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
         this.textEditor.clearFocus();
      }
      
      protected function textEditor_changeHandler(param1:Event) : void
      {
         if(this._ignoreTextChanges)
         {
            return;
         }
         this.text = this.textEditor.text;
      }
      
      protected function textEditor_enterHandler(param1:Event) : void
      {
         this.dispatchEventWith("enter");
      }
      
      protected function textEditor_focusInHandler(param1:Event) : void
      {
         this._touchPointID = -1;
         if(!this.visible)
         {
            this.textEditor.clearFocus();
            return;
         }
         this._textEditorHasFocus = true;
         this.currentState = "focused";
         if(this._focusManager && this._isFocusEnabled)
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
         this.currentState = this._isEnabled?"enabled":"disabled";
         if(this._focusManager)
         {
            if(this._focusManager.focus == this)
            {
               this._focusManager.focus = null;
            }
         }
         else
         {
            this.dispatchEventWith("focusOut");
         }
      }
   }
}
