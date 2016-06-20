package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IToggle;
   import feathers.core.IFocusDisplayObject;
   import flash.geom.Point;
   import feathers.core.ITextRenderer;
   import feathers.core.PropertyProxy;
   import starling.animation.Tween;
   import starling.display.DisplayObject;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import feathers.system.DeviceCapabilities;
   import starling.events.KeyboardEvent;
   
   public class ToggleSwitch extends FeathersControl implements IToggle, IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_ON_TRACK_FACTORY:String = "onTrackFactory";
      
      protected static const INVALIDATION_FLAG_OFF_TRACK_FACTORY:String = "offTrackFactory";
      
      public static const LABEL_ALIGN_MIDDLE:String = "middle";
      
      public static const LABEL_ALIGN_BASELINE:String = "baseline";
      
      public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";
      
      public static const TRACK_LAYOUT_MODE_ON_OFF:String = "onOff";
      
      public static const DEFAULT_CHILD_NAME_OFF_LABEL:String = "feathers-toggle-switch-off-label";
      
      public static const DEFAULT_CHILD_NAME_ON_LABEL:String = "feathers-toggle-switch-on-label";
      
      public static const DEFAULT_CHILD_NAME_OFF_TRACK:String = "feathers-toggle-switch-off-track";
      
      public static const DEFAULT_CHILD_NAME_ON_TRACK:String = "feathers-toggle-switch-on-track";
      
      public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-toggle-switch-thumb";
       
      protected var onLabelName:String = "feathers-toggle-switch-on-label";
      
      protected var offLabelName:String = "feathers-toggle-switch-off-label";
      
      protected var onTrackName:String = "feathers-toggle-switch-on-track";
      
      protected var offTrackName:String = "feathers-toggle-switch-off-track";
      
      protected var thumbName:String = "feathers-toggle-switch-thumb";
      
      protected var thumb:feathers.controls.Button;
      
      protected var onTextRenderer:ITextRenderer;
      
      protected var offTextRenderer:ITextRenderer;
      
      protected var onTrack:feathers.controls.Button;
      
      protected var offTrack:feathers.controls.Button;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _showLabels:Boolean = true;
      
      protected var _showThumb:Boolean = true;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _defaultLabelProperties:PropertyProxy;
      
      protected var _disabledLabelProperties:PropertyProxy;
      
      protected var _onLabelProperties:PropertyProxy;
      
      protected var _offLabelProperties:PropertyProxy;
      
      protected var _labelAlign:String = "baseline";
      
      protected var _labelFactory:Function;
      
      protected var _onLabelFactory:Function;
      
      protected var _offLabelFactory:Function;
      
      protected var onTrackSkinOriginalWidth:Number = NaN;
      
      protected var onTrackSkinOriginalHeight:Number = NaN;
      
      protected var offTrackSkinOriginalWidth:Number = NaN;
      
      protected var offTrackSkinOriginalHeight:Number = NaN;
      
      protected var _isSelected:Boolean = false;
      
      protected var _toggleDuration:Number = 0.15;
      
      protected var _toggleEase:Object = "easeOut";
      
      protected var _onText:String = "ON";
      
      protected var _offText:String = "OFF";
      
      protected var _toggleTween:Tween;
      
      protected var _ignoreTapHandler:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _thumbStartX:Number;
      
      protected var _touchStartX:Number;
      
      protected var _isSelectionChangedByUser:Boolean = false;
      
      protected var _onTrackFactory:Function;
      
      protected var _customOnTrackName:String;
      
      protected var _onTrackProperties:PropertyProxy;
      
      protected var _offTrackFactory:Function;
      
      protected var _customOffTrackName:String;
      
      protected var _offTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      public function ToggleSwitch()
      {
         super();
         this.addEventListener("touch",toggleSwitch_touchHandler);
         this.addEventListener("removedFromStage",toggleSwitch_removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultOnTrackFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
      }
      
      protected static function defaultOffTrackFactory() : feathers.controls.Button
      {
         return new feathers.controls.Button();
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
      
      public function get showLabels() : Boolean
      {
         return _showLabels;
      }
      
      public function set showLabels(param1:Boolean) : void
      {
         if(this._showLabels == param1)
         {
            return;
         }
         this._showLabels = param1;
         this.invalidate("styles");
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
         this.invalidate("layout");
      }
      
      public function get defaultLabelProperties() : Object
      {
         if(!this._defaultLabelProperties)
         {
            this._defaultLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._defaultLabelProperties;
      }
      
      public function set defaultLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._defaultLabelProperties = PropertyProxy(param1);
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get disabledLabelProperties() : Object
      {
         if(!this._disabledLabelProperties)
         {
            this._disabledLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._disabledLabelProperties;
      }
      
      public function set disabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._disabledLabelProperties = PropertyProxy(param1);
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get onLabelProperties() : Object
      {
         if(!this._onLabelProperties)
         {
            this._onLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._onLabelProperties;
      }
      
      public function set onLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._onLabelProperties)
         {
            this._onLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._onLabelProperties = PropertyProxy(param1);
         if(this._onLabelProperties)
         {
            this._onLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get offLabelProperties() : Object
      {
         if(!this._offLabelProperties)
         {
            this._offLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._offLabelProperties;
      }
      
      public function set offLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._offLabelProperties)
         {
            this._offLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._offLabelProperties = PropertyProxy(param1);
         if(this._offLabelProperties)
         {
            this._offLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get labelAlign() : String
      {
         return this._labelAlign;
      }
      
      public function set labelAlign(param1:String) : void
      {
         if(this._labelAlign == param1)
         {
            return;
         }
         this._labelAlign = param1;
         this.invalidate("styles");
      }
      
      public function get labelFactory() : Function
      {
         return this._labelFactory;
      }
      
      public function set labelFactory(param1:Function) : void
      {
         if(this._labelFactory == param1)
         {
            return;
         }
         this._labelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get onLabelFactory() : Function
      {
         return this._onLabelFactory;
      }
      
      public function set onLabelFactory(param1:Function) : void
      {
         if(this._onLabelFactory == param1)
         {
            return;
         }
         this._onLabelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get offLabelFactory() : Function
      {
         return this._offLabelFactory;
      }
      
      public function set offLabelFactory(param1:Function) : void
      {
         if(this._offLabelFactory == param1)
         {
            return;
         }
         this._offLabelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._isSelected;
         this._isSelected = param1;
         this._isSelectionChangedByUser = false;
         this.invalidate("selected");
         if(this._isSelected != _loc2_)
         {
            this.dispatchEventWith("change");
         }
      }
      
      public function get toggleDuration() : Number
      {
         return this._toggleDuration;
      }
      
      public function set toggleDuration(param1:Number) : void
      {
         this._toggleDuration = param1;
      }
      
      public function get toggleEase() : Object
      {
         return this._toggleEase;
      }
      
      public function set toggleEase(param1:Object) : void
      {
         this._toggleEase = param1;
      }
      
      public function get onText() : String
      {
         return this._onText;
      }
      
      public function set onText(param1:String) : void
      {
         if(param1 === null)
         {
            var param1:String = "";
         }
         if(this._onText == param1)
         {
            return;
         }
         this._onText = param1;
         this.invalidate("styles");
      }
      
      public function get offText() : String
      {
         return this._offText;
      }
      
      public function set offText(param1:String) : void
      {
         if(param1 === null)
         {
            var param1:String = "";
         }
         if(this._offText == param1)
         {
            return;
         }
         this._offText = param1;
         this.invalidate("styles");
      }
      
      public function get onTrackFactory() : Function
      {
         return this._onTrackFactory;
      }
      
      public function set onTrackFactory(param1:Function) : void
      {
         if(this._onTrackFactory == param1)
         {
            return;
         }
         this._onTrackFactory = param1;
         this.invalidate("onTrackFactory");
      }
      
      public function get customOnTrackName() : String
      {
         return this._customOnTrackName;
      }
      
      public function set customOnTrackName(param1:String) : void
      {
         if(this._customOnTrackName == param1)
         {
            return;
         }
         this._customOnTrackName = param1;
         this.invalidate("onTrackFactory");
      }
      
      public function get onTrackProperties() : Object
      {
         if(!this._onTrackProperties)
         {
            this._onTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._onTrackProperties;
      }
      
      public function set onTrackProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._onTrackProperties == param1)
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
         if(this._onTrackProperties)
         {
            this._onTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._onTrackProperties = PropertyProxy(param1);
         if(this._onTrackProperties)
         {
            this._onTrackProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get offTrackFactory() : Function
      {
         return this._offTrackFactory;
      }
      
      public function set offTrackFactory(param1:Function) : void
      {
         if(this._offTrackFactory == param1)
         {
            return;
         }
         this._offTrackFactory = param1;
         this.invalidate("offTrackFactory");
      }
      
      public function get customOffTrackName() : String
      {
         return this._customOffTrackName;
      }
      
      public function set customOffTrackName(param1:String) : void
      {
         if(this._customOffTrackName == param1)
         {
            return;
         }
         this._customOffTrackName = param1;
         this.invalidate("offTrackFactory");
      }
      
      public function get offTrackProperties() : Object
      {
         if(!this._offTrackProperties)
         {
            this._offTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._offTrackProperties;
      }
      
      public function set offTrackProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._offTrackProperties == param1)
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
         if(this._offTrackProperties)
         {
            this._offTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._offTrackProperties = PropertyProxy(param1);
         if(this._offTrackProperties)
         {
            this._offTrackProperties.addOnChangeCallback(childProperties_onChange);
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
         var _loc3_:Boolean = this.isInvalid("selected");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("size");
         var _loc7_:Boolean = this.isInvalid("state");
         var _loc6_:Boolean = this.isInvalid("focus");
         var _loc10_:Boolean = this.isInvalid("layout");
         var _loc2_:Boolean = this.isInvalid("textRenderer");
         var _loc1_:Boolean = this.isInvalid("thumbFactory");
         var _loc9_:Boolean = this.isInvalid("onTrackFactory");
         var _loc4_:Boolean = this.isInvalid("offTrackFactory");
         if(_loc1_)
         {
            this.createThumb();
         }
         if(_loc9_)
         {
            this.createOnTrack();
         }
         if(_loc4_ || _loc10_)
         {
            this.createOffTrack();
         }
         if(_loc2_)
         {
            this.createLabels();
         }
         if(_loc8_)
         {
            this.refreshOnLabelStyles();
            this.refreshOffLabelStyles();
         }
         if(_loc1_ || _loc8_)
         {
            this.refreshThumbStyles();
         }
         if(_loc9_ || _loc8_)
         {
            this.refreshOnTrackStyles();
         }
         if((_loc4_ || _loc10_ || _loc8_) && this.offTrack)
         {
            this.refreshOffTrackStyles();
         }
         if(_loc1_ || _loc7_)
         {
            this.thumb.isEnabled = this._isEnabled;
         }
         if(_loc9_ || _loc7_)
         {
            this.onTrack.isEnabled = this._isEnabled;
         }
         if((_loc4_ || _loc10_ || _loc7_) && this.offTrack)
         {
            this.offTrack.isEnabled = this._isEnabled;
         }
         _loc5_ = this.autoSizeIfNeeded() || _loc5_;
         if(_loc5_ || _loc8_ || _loc3_)
         {
            this.updateSelection();
         }
         this.layoutChildren();
         if(_loc5_ || _loc6_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         if(isNaN(this.onTrackSkinOriginalWidth) || isNaN(this.onTrackSkinOriginalHeight))
         {
            this.onTrack.validate();
            this.onTrackSkinOriginalWidth = this.onTrack.width;
            this.onTrackSkinOriginalHeight = this.onTrack.height;
         }
         if(this.offTrack)
         {
            if(isNaN(this.offTrackSkinOriginalWidth) || isNaN(this.offTrackSkinOriginalHeight))
            {
               this.offTrack.validate();
               this.offTrackSkinOriginalWidth = this.offTrack.width;
               this.offTrackSkinOriginalHeight = this.offTrack.height;
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
            if(this.offTrack)
            {
               _loc3_ = Math.min(this.onTrackSkinOriginalWidth,this.offTrackSkinOriginalWidth) + this.thumb.width / 2;
            }
            else
            {
               _loc3_ = this.onTrackSkinOriginalWidth;
            }
         }
         if(_loc4_)
         {
            if(this.offTrack)
            {
               _loc1_ = Math.max(this.onTrackSkinOriginalHeight,this.offTrackSkinOriginalHeight);
            }
            else
            {
               _loc1_ = this.onTrackSkinOriginalHeight;
            }
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
      
      protected function createOnTrack() : void
      {
         if(this.onTrack)
         {
            this.onTrack.removeFromParent(true);
            this.onTrack = null;
         }
         var _loc1_:Function = this._onTrackFactory != null?this._onTrackFactory:defaultOnTrackFactory;
         var _loc2_:String = this._customOnTrackName != null?this._customOnTrackName:this.onTrackName;
         this.onTrack = feathers.controls.Button(_loc1_());
         this.onTrack.nameList.add(_loc2_);
         this.onTrack.keepDownStateOnRollOut = true;
         this.addChildAt(this.onTrack,0);
      }
      
      protected function createOffTrack() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(this._trackLayoutMode == "onOff")
         {
            if(this.offTrack)
            {
               this.offTrack.removeFromParent(true);
               this.offTrack = null;
            }
            _loc1_ = this._offTrackFactory != null?this._offTrackFactory:defaultOffTrackFactory;
            _loc2_ = this._customOffTrackName != null?this._customOffTrackName:this.offTrackName;
            this.offTrack = feathers.controls.Button(_loc1_());
            this.offTrack.nameList.add(_loc2_);
            this.offTrack.keepDownStateOnRollOut = true;
            this.addChildAt(this.offTrack,1);
         }
         else if(this.offTrack)
         {
            this.offTrack.removeFromParent(true);
            this.offTrack = null;
         }
      }
      
      protected function createLabels() : void
      {
         if(this.offTextRenderer)
         {
            this.removeChild(DisplayObject(this.offTextRenderer),true);
            this.offTextRenderer = null;
         }
         if(this.onTextRenderer)
         {
            this.removeChild(DisplayObject(this.onTextRenderer),true);
            this.onTextRenderer = null;
         }
         var _loc1_:int = this.getChildIndex(this.thumb);
         var _loc2_:Function = this._offLabelFactory;
         if(_loc2_ == null)
         {
            _loc2_ = this._labelFactory;
         }
         if(_loc2_ == null)
         {
            _loc2_ = FeathersControl.defaultTextRendererFactory;
         }
         this.offTextRenderer = ITextRenderer(_loc2_());
         this.offTextRenderer.nameList.add(this.offLabelName);
         this.offTextRenderer.clipRect = new Rectangle();
         this.addChildAt(DisplayObject(this.offTextRenderer),_loc1_);
         var _loc3_:Function = this._onLabelFactory;
         if(_loc3_ == null)
         {
            _loc3_ = this._labelFactory;
         }
         if(_loc3_ == null)
         {
            _loc3_ = FeathersControl.defaultTextRendererFactory;
         }
         this.onTextRenderer = ITextRenderer(_loc3_());
         this.onTextRenderer.nameList.add(this.onLabelName);
         this.onTextRenderer.clipRect = new Rectangle();
         this.addChildAt(DisplayObject(this.onTextRenderer),_loc1_);
      }
      
      protected function layoutChildren() : void
      {
         var _loc2_:* = NaN;
         this.thumb.validate();
         this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
         var _loc1_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc4_:Number = Math.max(this.onTextRenderer.height,this.offTextRenderer.height);
         if(this._labelAlign == "middle")
         {
            _loc2_ = _loc4_;
         }
         else
         {
            _loc2_ = Math.max(this.onTextRenderer.baseline,this.offTextRenderer.baseline);
         }
         var _loc3_:Rectangle = this.onTextRenderer.clipRect;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc4_;
         this.onTextRenderer.clipRect = _loc3_;
         this.onTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         _loc3_ = this.offTextRenderer.clipRect;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc4_;
         this.offTextRenderer.clipRect = _loc3_;
         this.offTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         this.layoutTracks();
      }
      
      protected function layoutTracks() : void
      {
         var _loc2_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc4_:Number = this.thumb.x - this._paddingLeft;
         var _loc3_:Number = _loc2_ - _loc4_ - (_loc2_ - this.onTextRenderer.width) / 2;
         var _loc1_:Rectangle = this.onTextRenderer.clipRect;
         _loc1_.x = _loc3_;
         this.onTextRenderer.clipRect = _loc1_;
         this.onTextRenderer.x = this._paddingLeft - _loc3_;
         var _loc5_:Number = -_loc4_ - (_loc2_ - this.offTextRenderer.width) / 2;
         _loc1_ = this.offTextRenderer.clipRect;
         _loc1_.x = _loc5_;
         this.offTextRenderer.clipRect = _loc1_;
         this.offTextRenderer.x = this.actualWidth - this._paddingRight - _loc2_ - _loc5_;
         if(this._trackLayoutMode == "onOff")
         {
            this.layoutTrackWithOnOff();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function updateSelection() : void
      {
         this.thumb.validate();
         var _loc1_:Number = this._paddingLeft;
         if(this._isSelected)
         {
            _loc1_ = this.actualWidth - this.thumb.width - this._paddingRight;
         }
         if(this._toggleTween)
         {
            Starling.juggler.remove(this._toggleTween);
            this._toggleTween = null;
         }
         if(this._isSelectionChangedByUser)
         {
            this._toggleTween = new Tween(this.thumb,this._toggleDuration,this._toggleEase);
            this._toggleTween.animate("x",_loc1_);
            this._toggleTween.onUpdate = selectionTween_onUpdate;
            this._toggleTween.onComplete = selectionTween_onComplete;
            Starling.juggler.add(this._toggleTween);
         }
         else
         {
            this.thumb.x = _loc1_;
         }
         this._isSelectionChangedByUser = false;
      }
      
      protected function refreshOnLabelStyles() : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.onTextRenderer.visible = false;
            return;
         }
         if(!this._isEnabled)
         {
            _loc4_ = this._disabledLabelProperties;
         }
         if(!_loc4_ && this._onLabelProperties)
         {
            _loc4_ = this._onLabelProperties;
         }
         if(!_loc4_)
         {
            _loc4_ = this._defaultLabelProperties;
         }
         this.onTextRenderer.text = this._onText;
         if(_loc4_)
         {
            _loc2_ = DisplayObject(this.onTextRenderer);
            var _loc6_:* = 0;
            var _loc5_:* = _loc4_;
            for(var _loc1_ in _loc4_)
            {
               if(_loc2_.hasOwnProperty(_loc1_))
               {
                  _loc3_ = _loc4_[_loc1_];
                  _loc2_[_loc1_] = _loc3_;
               }
            }
         }
         this.onTextRenderer.validate();
         this.onTextRenderer.visible = true;
      }
      
      protected function refreshOffLabelStyles() : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.offTextRenderer.visible = false;
            return;
         }
         if(!this._isEnabled)
         {
            _loc4_ = this._disabledLabelProperties;
         }
         if(!_loc4_ && this._offLabelProperties)
         {
            _loc4_ = this._offLabelProperties;
         }
         if(!_loc4_)
         {
            _loc4_ = this._defaultLabelProperties;
         }
         this.offTextRenderer.text = this._offText;
         if(_loc4_)
         {
            _loc2_ = DisplayObject(this.offTextRenderer);
            var _loc6_:* = 0;
            var _loc5_:* = _loc4_;
            for(var _loc1_ in _loc4_)
            {
               if(_loc2_.hasOwnProperty(_loc1_))
               {
                  _loc3_ = _loc4_[_loc1_];
                  _loc2_[_loc1_] = _loc3_;
               }
            }
         }
         this.offTextRenderer.validate();
         this.offTextRenderer.visible = true;
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
      
      protected function refreshOnTrackStyles() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = this._onTrackProperties;
         for(var _loc1_ in this._onTrackProperties)
         {
            if(this.onTrack.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._onTrackProperties[_loc1_];
               this.onTrack[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function refreshOffTrackStyles() : void
      {
         var _loc2_:* = null;
         if(!this.offTrack)
         {
            return;
         }
         var _loc4_:* = 0;
         var _loc3_:* = this._offTrackProperties;
         for(var _loc1_ in this._offTrackProperties)
         {
            if(this.offTrack.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._offTrackProperties[_loc1_];
               this.offTrack[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function layoutTrackWithOnOff() : void
      {
         this.onTrack.x = 0;
         this.onTrack.y = 0;
         this.onTrack.width = this.thumb.x + this.thumb.width / 2;
         this.onTrack.height = this.actualHeight;
         this.offTrack.x = this.onTrack.width;
         this.offTrack.y = 0;
         this.offTrack.width = this.actualWidth - this.offTrack.x;
         this.offTrack.height = this.actualHeight;
         this.onTrack.validate();
         this.offTrack.validate();
      }
      
      protected function layoutTrackWithSingle() : void
      {
         this.onTrack.x = 0;
         this.onTrack.y = 0;
         this.onTrack.width = this.actualWidth;
         this.onTrack.height = this.actualHeight;
         this.onTrack.validate();
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function toggleSwitch_removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
         this.stage.addEventListener("keyUp",stage_keyUpHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
         this.stage.removeEventListener("keyUp",stage_keyUpHandler);
      }
      
      protected function toggleSwitch_touchHandler(param1:TouchEvent) : void
      {
         if(this._ignoreTapHandler)
         {
            this._ignoreTapHandler = false;
            return;
         }
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc2_:Touch = param1.getTouch(this,"ended");
         if(!_loc2_)
         {
            return;
         }
         this._touchPointID = -1;
         _loc2_.getLocation(this.stage,HELPER_POINT);
         var _loc3_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT,true));
         if(_loc3_)
         {
            this.isSelected = !this._isSelected;
            this._isSelectionChangedByUser = true;
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc4_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(!_loc4_)
            {
               return;
            }
            _loc4_.getLocation(this,HELPER_POINT);
            _loc2_ = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
            if(_loc4_.phase == "moved")
            {
               _loc3_ = HELPER_POINT.x - this._touchStartX;
               _loc6_ = Math.min(Math.max(this._paddingLeft,this._thumbStartX + _loc3_),this._paddingLeft + _loc2_);
               this.thumb.x = _loc6_;
               this.layoutTracks();
            }
            else if(_loc4_.phase == "ended")
            {
               _loc5_ = Math.abs(HELPER_POINT.x - this._touchStartX) / DeviceCapabilities.dpi;
               if(_loc5_ > 0.04)
               {
                  this._touchPointID = -1;
                  this.isSelected = this.thumb.x > this._paddingLeft + _loc2_ / 2;
                  this._isSelectionChangedByUser = true;
                  this._ignoreTapHandler = true;
               }
            }
         }
         else
         {
            _loc4_ = param1.getTouch(this.thumb,"began");
            if(!_loc4_)
            {
               return;
            }
            _loc4_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc4_.id;
            this._thumbStartX = this.thumb.x;
            this._touchStartX = HELPER_POINT.x;
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this._touchPointID = -1;
         }
         if(this._touchPointID >= 0 || param1.keyCode != 32)
         {
            return;
         }
         this._touchPointID = 2147483647;
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this._touchPointID != 2147483647 || param1.keyCode != 32)
         {
            return;
         }
         this._touchPointID = -1;
         this.isSelected = !this._isSelected;
      }
      
      protected function selectionTween_onUpdate() : void
      {
         this.layoutTracks();
      }
      
      protected function selectionTween_onComplete() : void
      {
         this._toggleTween = null;
      }
   }
}
