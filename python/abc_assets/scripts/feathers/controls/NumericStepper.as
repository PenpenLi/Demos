package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.clamp;
   import flash.utils.Timer;
   import feathers.core.PropertyProxy;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.events.KeyboardEvent;
   import flash.events.TimerEvent;
   
   public class NumericStepper extends FeathersControl implements IRange, IFocusDisplayObject
   {
      
      protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_TEXT_INPUT_FACTORY:String = "textInputFactory";
      
      public static const DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String = "feathers-numeric-stepper-decrement-button";
      
      public static const DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String = "feathers-numeric-stepper-increment-button";
      
      public static const DEFAULT_CHILD_NAME_TEXT_INPUT:String = "feathers-numeric-stepper-text-input";
      
      public static const BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL:String = "splitHorizontal";
      
      public static const BUTTON_LAYOUT_MODE_SPLIT_VERTICAL:String = "splitVertical";
      
      public static const BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL:String = "rightSideVertical";
       
      protected var decrementButtonName:String = "feathers-numeric-stepper-decrement-button";
      
      protected var incrementButtonName:String = "feathers-numeric-stepper-increment-button";
      
      protected var textInputName:String = "feathers-numeric-stepper-text-input";
      
      protected var decrementButton:feathers.controls.Button;
      
      protected var incrementButton:feathers.controls.Button;
      
      protected var textInput:feathers.controls.TextInput;
      
      protected var touchPointID:int = -1;
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var _buttonLayoutMode:String = "splitHorizontal";
      
      protected var _decrementButtonFactory:Function;
      
      protected var _customDecrementButtonName:String;
      
      protected var _decrementButtonProperties:PropertyProxy;
      
      protected var _decrementButtonLabel:String = null;
      
      protected var _incrementButtonFactory:Function;
      
      protected var _customIncrementButtonName:String;
      
      protected var _incrementButtonProperties:PropertyProxy;
      
      protected var _incrementButtonLabel:String = null;
      
      protected var _textInputFactory:Function;
      
      protected var _customTextInputName:String;
      
      protected var _textInputProperties:PropertyProxy;
      
      public function NumericStepper()
      {
         super();
         this.addEventListener("removedFromStage",numericStepper_removedFromStageHandler);
      }
      
      protected static function defaultDecrementButtonFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultIncrementButtonFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultTextInputFactory() : feathers.controls.TextInput
      {
         return new feathers.controls.TextInput();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this._step != 0 && param1 != this._maximum && param1 != this._minimum)
         {
            var param1:Number = roundToNearest(param1,this._step);
         }
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate("data");
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate("data");
      }
      
      public function get step() : Number
      {
         return this._step;
      }
      
      public function set step(param1:Number) : void
      {
         if(this._step == param1)
         {
            return;
         }
         this._step = param1;
      }
      
      public function get repeatDelay() : Number
      {
         return this._repeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         if(this._repeatDelay == param1)
         {
            return;
         }
         this._repeatDelay = param1;
         this.invalidate("styles");
      }
      
      public function get buttonLayoutMode() : String
      {
         return this._buttonLayoutMode;
      }
      
      public function set buttonLayoutMode(param1:String) : void
      {
         if(this._buttonLayoutMode == param1)
         {
            return;
         }
         this._buttonLayoutMode = param1;
         this.invalidate("styles");
      }
      
      public function get decrementButtonFactory() : Function
      {
         return this._decrementButtonFactory;
      }
      
      public function set decrementButtonFactory(param1:Function) : void
      {
         if(this._decrementButtonFactory == param1)
         {
            return;
         }
         this._decrementButtonFactory = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get customDecrementButtonName() : String
      {
         return this._customDecrementButtonName;
      }
      
      public function set customDecrementButtonName(param1:String) : void
      {
         if(this._customDecrementButtonName == param1)
         {
            return;
         }
         this._customDecrementButtonName = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get decrementButtonProperties() : Object
      {
         if(!this._decrementButtonProperties)
         {
            this._decrementButtonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._decrementButtonProperties;
      }
      
      public function set decrementButtonProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._decrementButtonProperties == param1)
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
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._decrementButtonProperties = PropertyProxy(param1);
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get decrementButtonLabel() : String
      {
         return this._decrementButtonLabel;
      }
      
      public function set decrementButtonLabel(param1:String) : void
      {
         if(this._decrementButtonLabel == param1)
         {
            return;
         }
         this._decrementButtonLabel = param1;
         this.invalidate("styles");
      }
      
      public function get incrementButtonFactory() : Function
      {
         return this._incrementButtonFactory;
      }
      
      public function set incrementButtonFactory(param1:Function) : void
      {
         if(this._incrementButtonFactory == param1)
         {
            return;
         }
         this._incrementButtonFactory = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get customIncrementButtonName() : String
      {
         return this._customIncrementButtonName;
      }
      
      public function set customIncrementButtonName(param1:String) : void
      {
         if(this._customIncrementButtonName == param1)
         {
            return;
         }
         this._customIncrementButtonName = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get incrementButtonProperties() : Object
      {
         if(!this._incrementButtonProperties)
         {
            this._incrementButtonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._incrementButtonProperties;
      }
      
      public function set incrementButtonProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._incrementButtonProperties == param1)
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
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._incrementButtonProperties = PropertyProxy(param1);
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get incrementButtonLabel() : String
      {
         return this._incrementButtonLabel;
      }
      
      public function set incrementButtonLabel(param1:String) : void
      {
         if(this._incrementButtonLabel == param1)
         {
            return;
         }
         this._incrementButtonLabel = param1;
         this.invalidate("styles");
      }
      
      public function get textInputFactory() : Function
      {
         return this._textInputFactory;
      }
      
      public function set textInputFactory(param1:Function) : void
      {
         if(this._textInputFactory == param1)
         {
            return;
         }
         this._textInputFactory = param1;
         this.invalidate("textInputFactory");
      }
      
      public function get customTextInputName() : String
      {
         return this._customTextInputName;
      }
      
      public function set customTextInputName(param1:String) : void
      {
         if(this._customTextInputName == param1)
         {
            return;
         }
         this._customTextInputName = param1;
         this.invalidate("textInputFactory");
      }
      
      public function get textInputProperties() : Object
      {
         if(!this._textInputProperties)
         {
            this._textInputProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._textInputProperties;
      }
      
      public function set textInputProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._textInputProperties == param1)
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
         if(this._textInputProperties)
         {
            this._textInputProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._textInputProperties = PropertyProxy(param1);
         if(this._textInputProperties)
         {
            this._textInputProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("size");
         var _loc7_:Boolean = this.isInvalid("state");
         var _loc6_:Boolean = this.isInvalid("decrementButtonFactory");
         var _loc1_:Boolean = this.isInvalid("incrementButtonFactory");
         var _loc2_:Boolean = this.isInvalid("textInputFactory");
         var _loc4_:Boolean = this.isInvalid("focus");
         if(_loc6_)
         {
            this.createDecrementButton();
         }
         if(_loc1_)
         {
            this.createIncrementButton();
         }
         if(_loc2_)
         {
            this.createTextInput();
         }
         if(_loc6_ || _loc8_)
         {
            this.refreshDecrementButtonStyles();
         }
         if(_loc1_ || _loc8_)
         {
            this.refreshIncrementButtonStyles();
         }
         if(_loc2_ || _loc8_)
         {
            this.refreshTextInputStyles();
         }
         if(_loc2_ || _loc5_)
         {
            this.refreshTypicalText();
            this.textInput.text = this._value.toString();
         }
         if(_loc6_ || _loc7_)
         {
            this.decrementButton.isEnabled = this._isEnabled;
         }
         if(_loc1_ || _loc7_)
         {
            this.incrementButton.isEnabled = this._isEnabled;
         }
         if(_loc2_ || _loc7_)
         {
            this.textInput.isEnabled = this._isEnabled;
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         if(_loc6_ || _loc1_ || _loc2_ || _loc5_ || _loc8_ || _loc3_)
         {
            this.layoutChildren();
         }
         if(_loc3_ || _loc4_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc7_:* = NaN;
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc6_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc6_)
         {
            return false;
         }
         var _loc5_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         this.decrementButton.validate();
         this.incrementButton.validate();
         var _loc3_:Number = this.textInput.width;
         var _loc4_:Number = this.textInput.height;
         if(this._buttonLayoutMode == "rightSideVertical")
         {
            _loc7_ = Math.max(this.decrementButton.width,this.incrementButton.width);
            this.textInput.minWidth = Math.max(0,this._minWidth - _loc7_);
            this.textInput.maxWidth = Math.max(0,this._maxWidth - _loc7_);
            this.textInput.width = Math.max(0,this.explicitWidth - _loc7_);
            this.textInput.height = this.explicitHeight;
            this.textInput.validate();
            if(_loc2_)
            {
               _loc5_ = this.textInput.width + _loc7_;
            }
            if(_loc6_)
            {
               _loc1_ = Math.max(this.textInput.height,this.decrementButton.height + this.incrementButton.height);
            }
         }
         else if(this._buttonLayoutMode == "splitVertical")
         {
            this.textInput.minHeight = Math.max(0,this._minHeight - this.decrementButton.height - this.incrementButton.height);
            this.textInput.maxHeight = Math.max(0,this._maxHeight - this.decrementButton.height - this.incrementButton.height);
            this.textInput.height = Math.max(0,this.explicitHeight - this.decrementButton.height - this.incrementButton.height);
            this.textInput.width = this.explicitWidth;
            this.textInput.validate();
            if(_loc2_)
            {
               _loc5_ = Math.max(this.decrementButton.width,this.incrementButton.width,this.textInput.width);
            }
            if(_loc6_)
            {
               _loc1_ = this.decrementButton.height + this.textInput.height + this.incrementButton.height;
            }
         }
         else
         {
            this.textInput.minWidth = Math.max(0,this._minWidth - this.decrementButton.width - this.incrementButton.width);
            this.textInput.maxWidth = Math.max(0,this._maxWidth - this.decrementButton.width - this.incrementButton.width);
            this.textInput.width = Math.max(0,this.explicitWidth - this.decrementButton.width - this.incrementButton.width);
            this.textInput.height = this.explicitHeight;
            this.textInput.validate();
            if(_loc2_)
            {
               _loc5_ = this.decrementButton.width + this.textInput.width + this.incrementButton.width;
            }
            if(_loc6_)
            {
               _loc1_ = Math.max(this.decrementButton.height,this.incrementButton.height,this.textInput.height);
            }
         }
         this.textInput.width = _loc3_;
         this.textInput.height = _loc4_;
         return this.setSizeInternal(_loc5_,_loc1_,false);
      }
      
      protected function decrement() : void
      {
         this.value = this.value - this._step;
      }
      
      protected function increment() : void
      {
         this.value = this.value + this._step;
      }
      
      protected function createDecrementButton() : void
      {
         if(this.decrementButton)
         {
            this.decrementButton.removeFromParent(true);
            this.decrementButton = null;
         }
         var _loc2_:Function = this._decrementButtonFactory != null?this._decrementButtonFactory:defaultDecrementButtonFactory;
         var _loc1_:String = this._customDecrementButtonName != null?this._customDecrementButtonName:this.decrementButtonName;
         this.decrementButton = feathers.controls.Button(_loc2_());
         this.decrementButton.nameList.add(_loc1_);
         this.decrementButton.addEventListener("touch",decrementButton_touchHandler);
         this.addChild(this.decrementButton);
      }
      
      protected function createIncrementButton() : void
      {
         if(this.incrementButton)
         {
            this.incrementButton.removeFromParent(true);
            this.incrementButton = null;
         }
         var _loc2_:Function = this._incrementButtonFactory != null?this._incrementButtonFactory:defaultIncrementButtonFactory;
         var _loc1_:String = this._customIncrementButtonName != null?this._customIncrementButtonName:this.incrementButtonName;
         this.incrementButton = feathers.controls.Button(_loc2_());
         this.incrementButton.nameList.add(_loc1_);
         this.incrementButton.addEventListener("touch",incrementButton_touchHandler);
         this.addChild(this.incrementButton);
      }
      
      protected function createTextInput() : void
      {
         if(this.textInput)
         {
            this.textInput.removeFromParent(true);
            this.textInput = null;
         }
         var _loc2_:Function = this._textInputFactory != null?this._textInputFactory:defaultTextInputFactory;
         var _loc1_:String = this._customTextInputName != null?this._customTextInputName:this.textInputName;
         this.textInput = feathers.controls.TextInput(_loc2_());
         this.textInput.nameList.add(_loc1_);
         this.textInput.addEventListener("enter",textInput_enterHandler);
         this.textInput.addEventListener("focusOut",textInput_focusOutHandler);
         this.textInput.isFocusEnabled = false;
         this.addChild(this.textInput);
      }
      
      protected function refreshDecrementButtonStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._decrementButtonProperties;
         for(var _loc1_ in this._decrementButtonProperties)
         {
            if(this.decrementButton.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._decrementButtonProperties[_loc1_];
               this.decrementButton[_loc1_] = _loc2_;
            }
         }
         this.decrementButton.label = this._decrementButtonLabel;
      }
      
      protected function refreshIncrementButtonStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._incrementButtonProperties;
         for(var _loc1_ in this._incrementButtonProperties)
         {
            if(this.incrementButton.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._incrementButtonProperties[_loc1_];
               this.incrementButton[_loc1_] = _loc2_;
            }
         }
         this.incrementButton.label = this._incrementButtonLabel;
      }
      
      protected function refreshTextInputStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._textInputProperties;
         for(var _loc1_ in this._textInputProperties)
         {
            if(this.textInput.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._textInputProperties[_loc1_];
               this.textInput[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshTypicalText() : void
      {
         var _loc3_:* = 0;
         var _loc1_:String = "";
         var _loc2_:int = Math.max(this._minimum.toString().length,this._maximum.toString().length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_ + "0";
            _loc3_++;
         }
         this.textInput.typicalText = _loc1_;
      }
      
      protected function layoutChildren() : void
      {
         var _loc3_:* = NaN;
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         if(this._buttonLayoutMode == "rightSideVertical")
         {
            _loc3_ = this.actualHeight / 2;
            this.incrementButton.y = 0;
            this.incrementButton.height = _loc3_;
            this.incrementButton.validate();
            this.decrementButton.y = _loc3_;
            this.decrementButton.height = _loc3_;
            this.decrementButton.validate();
            _loc2_ = Math.max(this.decrementButton.width,this.incrementButton.width);
            _loc1_ = this.actualWidth - _loc2_;
            this.decrementButton.x = _loc1_;
            this.incrementButton.x = _loc1_;
            this.textInput.x = 0;
            this.textInput.y = 0;
            this.textInput.width = _loc1_;
            this.textInput.height = this.actualHeight;
         }
         else if(this._buttonLayoutMode == "splitVertical")
         {
            this.incrementButton.x = 0;
            this.incrementButton.y = 0;
            this.incrementButton.width = this.actualWidth;
            this.incrementButton.validate();
            this.decrementButton.x = 0;
            this.decrementButton.width = this.actualWidth;
            this.decrementButton.validate();
            this.decrementButton.y = this.actualHeight - this.decrementButton.height;
            this.textInput.x = 0;
            this.textInput.y = this.incrementButton.height;
            this.textInput.width = this.actualWidth;
            this.textInput.height = Math.max(0,this.decrementButton.y - this.incrementButton.height - this.incrementButton.y);
         }
         else
         {
            this.decrementButton.x = 0;
            this.decrementButton.y = 0;
            this.decrementButton.height = this.actualHeight;
            this.decrementButton.validate();
            this.incrementButton.y = 0;
            this.incrementButton.height = this.actualHeight;
            this.incrementButton.validate();
            this.incrementButton.x = this.actualWidth - this.incrementButton.width;
            this.textInput.x = this.decrementButton.width;
            this.textInput.width = this.incrementButton.x - this.textInput.x;
            this.textInput.height = this.actualHeight;
         }
         this.textInput.validate();
      }
      
      protected function startRepeatTimer(param1:Function) : void
      {
         this.currentRepeatAction = param1;
         if(this._repeatDelay > 0)
         {
            if(!this._repeatTimer)
            {
               this._repeatTimer = new Timer(this._repeatDelay * 1000);
               this._repeatTimer.addEventListener("timer",repeatTimer_timerHandler);
            }
            else
            {
               this._repeatTimer.reset();
               this._repeatTimer.delay = this._repeatDelay * 1000;
            }
            this._repeatTimer.start();
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function numericStepper_removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         if(this.textInput.isEditable)
         {
            this.textInput.setFocus();
            this.textInput.selectRange(0,this.textInput.text.length);
         }
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.textInput.clearFocus();
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function textInput_enterHandler(param1:Event) : void
      {
         var _loc2_:Number = parseFloat(this.textInput.text);
         if(!isNaN(_loc2_))
         {
            this.value = _loc2_;
         }
      }
      
      protected function textInput_focusOutHandler(param1:Event) : void
      {
         var _loc2_:Number = parseFloat(this.textInput.text);
         if(!isNaN(_loc2_))
         {
            this.value = _loc2_;
         }
      }
      
      protected function decrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.decrementButton,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.decrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.decrement();
            this.startRepeatTimer(this.decrement);
         }
      }
      
      protected function incrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.incrementButton,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.incrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.increment();
            this.startRepeatTimer(this.increment);
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 36)
         {
            this.value = this._minimum;
         }
         else if(param1.keyCode == 35)
         {
            this.value = this._maximum;
         }
         else if(param1.keyCode == 38)
         {
            this.value = this.value + this._step;
         }
         else if(param1.keyCode == 40)
         {
            this.value = this.value - this._step;
         }
      }
      
      protected function repeatTimer_timerHandler(param1:TimerEvent) : void
      {
         if(this._repeatTimer.currentCount < 5)
         {
            return;
         }
         this.currentRepeatAction();
      }
   }
}
