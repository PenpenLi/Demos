package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import flash.geom.Point;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.clamp;
   import flash.utils.Timer;
   import feathers.core.PropertyProxy;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.display.DisplayObject;
   import starling.events.Touch;
   import starling.events.KeyboardEvent;
   import flash.events.TimerEvent;
   
   public class Slider extends FeathersControl implements IScrollBar, IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY:String = "minimumTrackFactory";
      
      protected static const INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY:String = "maximumTrackFactory";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";
      
      public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";
      
      public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";
      
      public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";
      
      public static const DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";
      
      public static const DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";
      
      public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-slider-thumb";
       
      protected var minimumTrackName:String = "feathers-slider-minimum-track";
      
      protected var maximumTrackName:String = "feathers-slider-maximum-track";
      
      protected var thumbName:String = "feathers-slider-thumb";
      
      protected var thumb:feathers.controls.Button;
      
      protected var minimumTrack:feathers.controls.Button;
      
      protected var maximumTrack:feathers.controls.Button;
      
      protected var minimumTrackOriginalWidth:Number = NaN;
      
      protected var minimumTrackOriginalHeight:Number = NaN;
      
      protected var maximumTrackOriginalWidth:Number = NaN;
      
      protected var maximumTrackOriginalHeight:Number = NaN;
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _page:Number = NaN;
      
      protected var isDragging:Boolean = false;
      
      public var liveDragging:Boolean = true;
      
      protected var _showThumb:Boolean = true;
      
      protected var _minimumPadding:Number = 0;
      
      protected var _maximumPadding:Number = 0;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _trackScaleMode:String = "directional";
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var _minimumTrackFactory:Function;
      
      protected var _customMinimumTrackName:String;
      
      protected var _minimumTrackProperties:PropertyProxy;
      
      protected var _maximumTrackFactory:Function;
      
      protected var _customMaximumTrackName:String;
      
      protected var _maximumTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      protected var _touchPointID:int = -1;
      
      protected var _touchStartX:Number = NaN;
      
      protected var _touchStartY:Number = NaN;
      
      protected var _thumbStartX:Number = NaN;
      
      protected var _thumbStartY:Number = NaN;
      
      protected var _touchValue:Number;
      
      public function Slider()
      {
         super();
         this.addEventListener("removedFromStage",slider_removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultMinimumTrackFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultMaximumTrackFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate("data");
         this.invalidate("minimumTrackFactory");
         this.invalidate("maximumTrackFactory");
         this.invalidate("thumbFactory");
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
         if(this.liveDragging || !this.isDragging)
         {
            this.dispatchEventWith("change");
         }
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
      
      public function get page() : Number
      {
         return this._page;
      }
      
      public function set page(param1:Number) : void
      {
         if(this._page == param1)
         {
            return;
         }
         this._page = param1;
      }
      
      public function get showThumb() : Boolean
      {
         return this._showThumb;
      }
      
      public function set showThumb(param1:Boolean) : void
      {
         if(this._showThumb == param1)
         {
            return;
         }
         this._showThumb = param1;
         this.invalidate("styles");
      }
      
      public function get minimumPadding() : Number
      {
         return this._minimumPadding;
      }
      
      public function set minimumPadding(param1:Number) : void
      {
         if(this._minimumPadding == param1)
         {
            return;
         }
         this._minimumPadding = param1;
         this.invalidate("styles");
      }
      
      public function get maximumPadding() : Number
      {
         return this._maximumPadding;
      }
      
      public function set maximumPadding(param1:Number) : void
      {
         if(this._maximumPadding == param1)
         {
            return;
         }
         this._maximumPadding = param1;
         this.invalidate("styles");
      }
      
      public function get trackLayoutMode() : String
      {
         return this._trackLayoutMode;
      }
      
      public function set trackLayoutMode(param1:String) : void
      {
         if(this._trackLayoutMode == param1)
         {
            return;
         }
         this._trackLayoutMode = param1;
         this.invalidate("styles");
      }
      
      public function get trackScaleMode() : String
      {
         return this._trackScaleMode;
      }
      
      public function set trackScaleMode(param1:String) : void
      {
         if(this._trackScaleMode == param1)
         {
            return;
         }
         this._trackScaleMode = param1;
         this.invalidate("styles");
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
      
      public function get minimumTrackFactory() : Function
      {
         return this._minimumTrackFactory;
      }
      
      public function set minimumTrackFactory(param1:Function) : void
      {
         if(this._minimumTrackFactory == param1)
         {
            return;
         }
         this._minimumTrackFactory = param1;
         this.invalidate("minimumTrackFactory");
      }
      
      public function get customMinimumTrackName() : String
      {
         return this._customMinimumTrackName;
      }
      
      public function set customMinimumTrackName(param1:String) : void
      {
         if(this._customMinimumTrackName == param1)
         {
            return;
         }
         this._customMinimumTrackName = param1;
         this.invalidate("minimumTrackFactory");
      }
      
      public function get minimumTrackProperties() : Object
      {
         if(!this._minimumTrackProperties)
         {
            this._minimumTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._minimumTrackProperties;
      }
      
      public function set minimumTrackProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._minimumTrackProperties == param1)
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
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._minimumTrackProperties = PropertyProxy(param1);
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get maximumTrackFactory() : Function
      {
         return this._maximumTrackFactory;
      }
      
      public function set maximumTrackFactory(param1:Function) : void
      {
         if(this._maximumTrackFactory == param1)
         {
            return;
         }
         this._maximumTrackFactory = param1;
         this.invalidate("maximumTrackFactory");
      }
      
      public function get customMaximumTrackName() : String
      {
         return this._customMaximumTrackName;
      }
      
      public function set customMaximumTrackName(param1:String) : void
      {
         if(this._customMaximumTrackName == param1)
         {
            return;
         }
         this._customMaximumTrackName = param1;
         this.invalidate("maximumTrackFactory");
      }
      
      public function get maximumTrackProperties() : Object
      {
         if(!this._maximumTrackProperties)
         {
            this._maximumTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._maximumTrackProperties;
      }
      
      public function set maximumTrackProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._maximumTrackProperties == param1)
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
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._maximumTrackProperties = PropertyProxy(param1);
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get thumbFactory() : Function
      {
         return this._thumbFactory;
      }
      
      public function set thumbFactory(param1:Function) : void
      {
         if(this._thumbFactory == param1)
         {
            return;
         }
         this._thumbFactory = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get customThumbName() : String
      {
         return this._customThumbName;
      }
      
      public function set customThumbName(param1:String) : void
      {
         if(this._customThumbName == param1)
         {
            return;
         }
         this._customThumbName = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get thumbProperties() : Object
      {
         if(!this._thumbProperties)
         {
            this._thumbProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._thumbProperties;
      }
      
      public function set thumbProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._thumbProperties == param1)
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
         if(this._thumbProperties)
         {
            this._thumbProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._thumbProperties = PropertyProxy(param1);
         if(this._thumbProperties)
         {
            this._thumbProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("size");
         var _loc5_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("focus");
         var _loc8_:Boolean = this.isInvalid("layout");
         var _loc1_:Boolean = this.isInvalid("thumbFactory");
         var _loc7_:Boolean = this.isInvalid("minimumTrackFactory");
         var _loc2_:Boolean = this.isInvalid("maximumTrackFactory");
         if(_loc1_)
         {
            this.createThumb();
         }
         if(_loc7_)
         {
            this.createMinimumTrack();
         }
         if(_loc2_ || _loc8_)
         {
            this.createMaximumTrack();
         }
         if(_loc1_ || _loc6_)
         {
            this.refreshThumbStyles();
         }
         if(_loc7_ || _loc6_)
         {
            this.refreshMinimumTrackStyles();
         }
         if((_loc2_ || _loc8_ || _loc6_) && this.maximumTrack)
         {
            this.refreshMaximumTrackStyles();
         }
         if(_loc1_ || _loc5_)
         {
            this.thumb.isEnabled = this._isEnabled;
         }
         if(_loc7_ || _loc5_)
         {
            this.minimumTrack.isEnabled = this._isEnabled;
         }
         if((_loc2_ || _loc8_ || _loc5_) && this.maximumTrack)
         {
            this.maximumTrack.isEnabled = this._isEnabled;
         }
         _loc3_ = this.autoSizeIfNeeded() || _loc3_;
         this.layoutChildren();
         if(_loc3_ || _loc4_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         if(isNaN(this.minimumTrackOriginalWidth) || isNaN(this.minimumTrackOriginalHeight))
         {
            this.minimumTrack.validate();
            this.minimumTrackOriginalWidth = this.minimumTrack.width;
            this.minimumTrackOriginalHeight = this.minimumTrack.height;
         }
         if(this.maximumTrack)
         {
            if(isNaN(this.maximumTrackOriginalWidth) || isNaN(this.maximumTrackOriginalHeight))
            {
               this.maximumTrack.validate();
               this.maximumTrackOriginalWidth = this.maximumTrack.width;
               this.maximumTrackOriginalHeight = this.maximumTrack.height;
            }
         }
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         this.thumb.validate();
         var _loc3_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            if(this._direction == "vertical")
            {
               if(this.maximumTrack)
               {
                  _loc3_ = Math.max(this.minimumTrackOriginalWidth,this.maximumTrackOriginalWidth);
               }
               else
               {
                  _loc3_ = this.minimumTrackOriginalWidth;
               }
            }
            else if(this.maximumTrack)
            {
               _loc3_ = Math.min(this.minimumTrackOriginalWidth,this.maximumTrackOriginalWidth) + this.thumb.width / 2;
            }
            else
            {
               _loc3_ = this.minimumTrackOriginalWidth;
            }
            _loc3_ = Math.max(_loc3_,this.thumb.width);
         }
         if(_loc4_)
         {
            if(this._direction == "vertical")
            {
               if(this.maximumTrack)
               {
                  _loc1_ = Math.min(this.minimumTrackOriginalHeight,this.maximumTrackOriginalHeight) + this.thumb.height / 2;
               }
               else
               {
                  _loc1_ = this.minimumTrackOriginalHeight;
               }
            }
            else if(this.maximumTrack)
            {
               _loc1_ = Math.max(this.minimumTrackOriginalHeight,this.maximumTrackOriginalHeight);
            }
            else
            {
               _loc1_ = this.minimumTrackOriginalHeight;
            }
            _loc1_ = Math.max(_loc1_,this.thumb.height);
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createThumb() : void
      {
         if(this.thumb)
         {
            this.thumb.removeFromParent(true);
            this.thumb = null;
         }
         var _loc2_:Function = this._thumbFactory != null?this._thumbFactory:defaultThumbFactory;
         var _loc1_:String = this._customThumbName != null?this._customThumbName:this.thumbName;
         this.thumb = feathers.controls.Button(_loc2_());
         this.thumb.nameList.add(_loc1_);
         this.thumb.keepDownStateOnRollOut = true;
         this.thumb.addEventListener("touch",thumb_touchHandler);
         this.addChild(this.thumb);
      }
      
      protected function createMinimumTrack() : void
      {
         if(this.minimumTrack)
         {
            this.minimumTrack.removeFromParent(true);
            this.minimumTrack = null;
         }
         var _loc1_:Function = this._minimumTrackFactory != null?this._minimumTrackFactory:defaultMinimumTrackFactory;
         var _loc2_:String = this._customMinimumTrackName != null?this._customMinimumTrackName:this.minimumTrackName;
         this.minimumTrack = feathers.controls.Button(_loc1_());
         this.minimumTrack.nameList.add(_loc2_);
         this.minimumTrack.keepDownStateOnRollOut = true;
         this.minimumTrack.addEventListener("touch",track_touchHandler);
         this.addChildAt(this.minimumTrack,0);
      }
      
      protected function createMaximumTrack() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(this._trackLayoutMode == "minMax")
         {
            if(this.maximumTrack)
            {
               this.maximumTrack.removeFromParent(true);
               this.maximumTrack = null;
            }
            _loc1_ = this._maximumTrackFactory != null?this._maximumTrackFactory:defaultMaximumTrackFactory;
            _loc2_ = this._customMaximumTrackName != null?this._customMaximumTrackName:this.maximumTrackName;
            this.maximumTrack = feathers.controls.Button(_loc1_());
            this.maximumTrack.nameList.add(_loc2_);
            this.maximumTrack.keepDownStateOnRollOut = true;
            this.maximumTrack.addEventListener("touch",track_touchHandler);
            this.addChildAt(this.maximumTrack,1);
         }
         else if(this.maximumTrack)
         {
            this.maximumTrack.removeFromParent(true);
            this.maximumTrack = null;
         }
      }
      
      protected function refreshThumbStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._thumbProperties;
         for(var _loc1_ in this._thumbProperties)
         {
            if(this.thumb.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._thumbProperties[_loc1_];
               this.thumb[_loc1_] = _loc2_;
            }
         }
         this.thumb.visible = this._showThumb;
      }
      
      protected function refreshMinimumTrackStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._minimumTrackProperties;
         for(var _loc1_ in this._minimumTrackProperties)
         {
            if(this.minimumTrack.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._minimumTrackProperties[_loc1_];
               this.minimumTrack[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshMaximumTrackStyles() : void
      {
         var _loc2_:* = null;
         if(!this.maximumTrack)
         {
            return;
         }
         var _loc4_:* = 0;
         var _loc3_:* = this._maximumTrackProperties;
         for(var _loc1_ in this._maximumTrackProperties)
         {
            if(this.maximumTrack.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._maximumTrackProperties[_loc1_];
               this.maximumTrack[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function layoutChildren() : void
      {
         this.layoutThumb();
         if(this._trackLayoutMode == "minMax")
         {
            this.layoutTrackWithMinMax();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function layoutThumb() : void
      {
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         this.thumb.validate();
         if(this._direction == "vertical")
         {
            _loc2_ = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
            this.thumb.x = (this.actualWidth - this.thumb.width) / 2;
            this.thumb.y = this._minimumPadding + _loc2_ * (1 - (this._value - this._minimum) / (this._maximum - this._minimum));
         }
         else
         {
            _loc1_ = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
            this.thumb.x = this._minimumPadding + _loc1_ * (this._value - this._minimum) / (this._maximum - this._minimum);
            this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
         }
      }
      
      protected function layoutTrackWithMinMax() : void
      {
         if(this._direction == "vertical")
         {
            this.maximumTrack.y = 0;
            this.maximumTrack.height = this.thumb.y + this.thumb.height / 2;
            this.minimumTrack.y = this.maximumTrack.height;
            this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
            if(this._trackScaleMode == "directional")
            {
               this.maximumTrack.width = NaN;
               this.maximumTrack.validate();
               this.maximumTrack.x = (this.actualWidth - this.maximumTrack.width) / 2;
               this.minimumTrack.width = NaN;
               this.minimumTrack.validate();
               this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
            }
            else
            {
               this.maximumTrack.x = 0;
               this.maximumTrack.width = this.actualWidth;
               this.minimumTrack.x = 0;
               this.minimumTrack.width = this.actualWidth;
               this.minimumTrack.validate();
               this.maximumTrack.validate();
            }
         }
         else
         {
            this.minimumTrack.x = 0;
            this.minimumTrack.width = this.thumb.x + this.thumb.width / 2;
            this.maximumTrack.x = this.minimumTrack.width;
            this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
            if(this._trackScaleMode == "directional")
            {
               this.minimumTrack.height = NaN;
               this.minimumTrack.validate();
               this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
               this.maximumTrack.height = NaN;
               this.maximumTrack.validate();
               this.maximumTrack.y = (this.actualHeight - this.maximumTrack.height) / 2;
            }
            else
            {
               this.minimumTrack.y = 0;
               this.minimumTrack.height = this.actualHeight;
               this.maximumTrack.y = 0;
               this.maximumTrack.height = this.actualHeight;
               this.minimumTrack.validate();
               this.maximumTrack.validate();
            }
         }
      }
      
      protected function layoutTrackWithSingle() : void
      {
         if(this._trackScaleMode == "directional")
         {
            if(this._direction == "vertical")
            {
               this.minimumTrack.y = 0;
               this.minimumTrack.width = NaN;
               this.minimumTrack.height = this.actualHeight;
               this.minimumTrack.validate();
               this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
            }
            else
            {
               this.minimumTrack.x = 0;
               this.minimumTrack.width = this.actualWidth;
               this.minimumTrack.height = NaN;
               this.minimumTrack.validate();
               this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
            }
         }
         else
         {
            this.minimumTrack.x = 0;
            this.minimumTrack.y = 0;
            this.minimumTrack.width = this.actualWidth;
            this.minimumTrack.height = this.actualHeight;
            this.minimumTrack.validate();
         }
      }
      
      protected function locationToValue(param1:Point) : Number
      {
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc3_:* = NaN;
         var _loc8_:* = NaN;
         var _loc2_:* = NaN;
         var _loc4_:* = NaN;
         var _loc7_:* = NaN;
         if(this._direction == "vertical")
         {
            _loc5_ = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
            _loc3_ = param1.y - this._touchStartY - this._maximumPadding;
            _loc8_ = Math.min(Math.max(0,this._thumbStartY + _loc3_),_loc5_);
            _loc6_ = 1 - _loc8_ / _loc5_;
         }
         else
         {
            _loc2_ = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
            _loc4_ = param1.x - this._touchStartX - this._minimumPadding;
            _loc7_ = Math.min(Math.max(0,this._thumbStartX + _loc4_),_loc2_);
            _loc6_ = _loc7_ / _loc2_;
         }
         return this._minimum + _loc6_ * (this._maximum - this._minimum);
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
      
      protected function adjustPage() : void
      {
         var _loc1_:Number = isNaN(this._page)?this._step:this._page;
         if(this._touchValue < this._value)
         {
            this.value = Math.max(this._touchValue,this._value - _loc1_);
         }
         else if(this._touchValue > this._value)
         {
            this.value = Math.min(this._touchValue,this._value + _loc1_);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function slider_removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
         var _loc2_:Boolean = this.isDragging;
         this.isDragging = false;
         if(_loc2_ && !this.liveDragging)
         {
            this.dispatchEventWith("change");
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function track_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc3_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(_loc3_,null,this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(!this._showThumb && _loc2_.phase == "moved")
            {
               _loc2_.getLocation(this,HELPER_POINT);
               this.value = this.locationToValue(HELPER_POINT);
            }
            else if(_loc2_.phase == "ended")
            {
               if(this._repeatTimer)
               {
                  this._repeatTimer.stop();
               }
               this._touchPointID = -1;
               this.isDragging = false;
               if(!this.liveDragging)
               {
                  this.dispatchEventWith("change");
               }
               this.dispatchEventWith("endInteraction");
            }
         }
         else
         {
            _loc2_ = param1.getTouch(_loc3_,"began");
            if(!_loc2_)
            {
               return;
            }
            _loc2_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc2_.id;
            if(this._direction == "vertical")
            {
               this._thumbStartX = HELPER_POINT.x;
               this._thumbStartY = Math.min(this.actualHeight - this.thumb.height,Math.max(0,HELPER_POINT.y - this.thumb.height / 2));
            }
            else
            {
               this._thumbStartX = Math.min(this.actualWidth - this.thumb.width,Math.max(0,HELPER_POINT.x - this.thumb.width / 2));
               this._thumbStartY = HELPER_POINT.y;
            }
            this._touchStartX = HELPER_POINT.x;
            this._touchStartY = HELPER_POINT.y;
            this._touchValue = this.locationToValue(HELPER_POINT);
            this.isDragging = true;
            this.dispatchEventWith("beginInteraction");
            if(this._showThumb)
            {
               this.adjustPage();
               this.startRepeatTimer(this.adjustPage);
            }
            else
            {
               this.value = this._touchValue;
            }
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == "moved")
            {
               _loc2_.getLocation(this,HELPER_POINT);
               this.value = this.locationToValue(HELPER_POINT);
            }
            else if(_loc2_.phase == "ended")
            {
               this._touchPointID = -1;
               this.isDragging = false;
               if(!this.liveDragging)
               {
                  this.dispatchEventWith("change");
               }
               this.dispatchEventWith("endInteraction");
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this.thumb,"began");
            if(!_loc2_)
            {
               return;
            }
            _loc2_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc2_.id;
            this._thumbStartX = this.thumb.x;
            this._thumbStartY = this.thumb.y;
            this._touchStartX = HELPER_POINT.x;
            this._touchStartY = HELPER_POINT.y;
            this.isDragging = true;
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 36)
         {
            this.value = this._minimum;
            return;
         }
         if(param1.keyCode == 35)
         {
            this.value = this._maximum;
            return;
         }
         var _loc2_:Number = isNaN(this._page)?this._step:this._page;
         if(this._direction == "vertical")
         {
            if(param1.keyCode == 38)
            {
               if(param1.shiftKey)
               {
                  this.value = this.value + _loc2_;
               }
               else
               {
                  this.value = this.value + this._step;
               }
            }
            else if(param1.keyCode == 40)
            {
               if(param1.shiftKey)
               {
                  this.value = this.value - _loc2_;
               }
               else
               {
                  this.value = this.value - this._step;
               }
            }
         }
         else if(param1.keyCode == 37)
         {
            if(param1.shiftKey)
            {
               this.value = this.value - _loc2_;
            }
            else
            {
               this.value = this.value - this._step;
            }
         }
         else if(param1.keyCode == 39)
         {
            if(param1.shiftKey)
            {
               this.value = this.value + _loc2_;
            }
            else
            {
               this.value = this.value + this._step;
            }
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
