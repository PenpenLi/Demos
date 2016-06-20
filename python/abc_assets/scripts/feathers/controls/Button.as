package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IToggle;
   import feathers.core.IFocusDisplayObject;
   import flash.geom.Point;
   import feathers.core.ITextRenderer;
   import starling.display.DisplayObject;
   import feathers.skins.StateWithToggleValueSelector;
   import feathers.core.PropertyProxy;
   import feathers.core.IValidating;
   import feathers.core.IFeathersControl;
   import starling.events.Touch;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import flash.utils.getTimer;
   import starling.events.KeyboardEvent;
   
   public class Button extends FeathersControl implements IToggle, IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const DEFAULT_CHILD_NAME_LABEL:String = "feathers-button-label";
      
      public static const ALTERNATE_NAME_CALL_TO_ACTION_BUTTON:String = "feathers-call-to-action-button";
      
      public static const ALTERNATE_NAME_QUIET_BUTTON:String = "feathers-quiet-button";
      
      public static const ALTERNATE_NAME_DANGER_BUTTON:String = "feathers-danger-button";
      
      public static const ALTERNATE_NAME_BACK_BUTTON:String = "feathers-back-button";
      
      public static const ALTERNATE_NAME_FORWARD_BUTTON:String = "feathers-forward-button";
      
      public static const STATE_UP:String = "up";
      
      public static const STATE_DOWN:String = "down";
      
      public static const STATE_HOVER:String = "hover";
      
      public static const STATE_DISABLED:String = "disabled";
      
      public static const ICON_POSITION_TOP:String = "top";
      
      public static const ICON_POSITION_RIGHT:String = "right";
      
      public static const ICON_POSITION_BOTTOM:String = "bottom";
      
      public static const ICON_POSITION_LEFT:String = "left";
      
      public static const ICON_POSITION_MANUAL:String = "manual";
      
      public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
      
      public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
       
      protected var labelName:String = "feathers-button-label";
      
      protected var labelTextRenderer:ITextRenderer;
      
      protected var currentSkin:DisplayObject;
      
      protected var currentIcon:DisplayObject;
      
      protected var touchPointID:int = -1;
      
      protected var _currentState:String = "up";
      
      protected var _label:String = null;
      
      protected var _isToggle:Boolean = false;
      
      protected var _isSelected:Boolean = false;
      
      protected var _iconPosition:String = "left";
      
      protected var _gap:Number = 0;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _labelOffsetX:Number = 0;
      
      protected var _labelOffsetY:Number = 0;
      
      protected var _iconOffsetX:Number = 0;
      
      protected var _iconOffsetY:Number = 0;
      
      public var keepDownStateOnRollOut:Boolean = false;
      
      protected var _stateNames:Vector.<String>;
      
      protected var _originalSkinWidth:Number = NaN;
      
      protected var _originalSkinHeight:Number = NaN;
      
      protected var _stateToSkinFunction:Function;
      
      protected var _stateToIconFunction:Function;
      
      protected var _stateToLabelPropertiesFunction:Function;
      
      protected var _skinSelector:StateWithToggleValueSelector;
      
      protected var _labelFactory:Function;
      
      protected var _labelPropertiesSelector:StateWithToggleValueSelector;
      
      protected var _iconSelector:StateWithToggleValueSelector;
      
      protected var _autoFlatten:Boolean = false;
      
      protected var _touchBeginTime:int;
      
      protected var _hasLongPressed:Boolean = false;
      
      protected var _longPressDuration:Number = 0.5;
      
      protected var _isLongPressEnabled:Boolean = false;
      
      public function Button()
      {
         _stateNames = new <String>["up","down","hover","disabled"];
         _skinSelector = new StateWithToggleValueSelector();
         _labelPropertiesSelector = new StateWithToggleValueSelector();
         _iconSelector = new StateWithToggleValueSelector();
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("touch",button_touchHandler);
         this.addEventListener("removedFromStage",button_removedFromStageHandler);
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled == param1)
         {
            return;
         }
         .super.isEnabled = param1;
         if(!this._isEnabled)
         {
            this.touchable = false;
            this.currentState = "disabled";
            this.touchPointID = -1;
         }
         else
         {
            if(this.currentState == "disabled")
            {
               this.currentState = "up";
            }
            this.touchable = true;
         }
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
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(this._label == param1)
         {
            return;
         }
         this._label = param1;
         this.invalidate("data");
      }
      
      public function get isToggle() : Boolean
      {
         return this._isToggle;
      }
      
      public function set isToggle(param1:Boolean) : void
      {
         this._isToggle = param1;
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected == param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get iconPosition() : String
      {
         return this._iconPosition;
      }
      
      public function set iconPosition(param1:String) : void
      {
         if(this._iconPosition == param1)
         {
            return;
         }
         this._iconPosition = param1;
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
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
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
      
      public function get labelOffsetX() : Number
      {
         return this._labelOffsetX;
      }
      
      public function set labelOffsetX(param1:Number) : void
      {
         if(this._labelOffsetX == param1)
         {
            return;
         }
         this._labelOffsetX = param1;
         this.invalidate("styles");
      }
      
      public function get labelOffsetY() : Number
      {
         return this._labelOffsetY;
      }
      
      public function set labelOffsetY(param1:Number) : void
      {
         if(this._labelOffsetY == param1)
         {
            return;
         }
         this._labelOffsetY = param1;
         this.invalidate("styles");
      }
      
      public function get iconOffsetX() : Number
      {
         return this._iconOffsetX;
      }
      
      public function set iconOffsetX(param1:Number) : void
      {
         if(this._iconOffsetX == param1)
         {
            return;
         }
         this._iconOffsetX = param1;
         this.invalidate("styles");
      }
      
      public function get iconOffsetY() : Number
      {
         return this._iconOffsetY;
      }
      
      public function set iconOffsetY(param1:Number) : void
      {
         if(this._iconOffsetY == param1)
         {
            return;
         }
         this._iconOffsetY = param1;
         this.invalidate("styles");
      }
      
      protected function get stateNames() : Vector.<String>
      {
         return this._stateNames;
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
      
      public function get stateToLabelPropertiesFunction() : Function
      {
         return this._stateToLabelPropertiesFunction;
      }
      
      public function set stateToLabelPropertiesFunction(param1:Function) : void
      {
         if(this._stateToLabelPropertiesFunction == param1)
         {
            return;
         }
         this._stateToLabelPropertiesFunction = param1;
         this.invalidate("styles");
      }
      
      public function get defaultSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.defaultValue);
      }
      
      public function set defaultSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.defaultValue == param1)
         {
            return;
         }
         this._skinSelector.defaultValue = param1;
         this.invalidate("styles");
      }
      
      public function get defaultSelectedSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.defaultSelectedValue);
      }
      
      public function set defaultSelectedSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.defaultSelectedValue == param1)
         {
            return;
         }
         this._skinSelector.defaultSelectedValue = param1;
         this.invalidate("styles");
      }
      
      public function get upSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("up",false));
      }
      
      public function set upSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("up",false) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"up",false);
         this.invalidate("styles");
      }
      
      public function get downSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("down",false));
      }
      
      public function set downSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("down",false) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"down",false);
         this.invalidate("styles");
      }
      
      public function get hoverSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("hover",false));
      }
      
      public function set hoverSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("hover",false) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"hover",false);
         this.invalidate("styles");
      }
      
      public function get disabledSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("disabled",false));
      }
      
      public function set disabledSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("disabled",false) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"disabled",false);
         this.invalidate("styles");
      }
      
      public function get selectedUpSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("up",true));
      }
      
      public function set selectedUpSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("up",true) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"up",true);
         this.invalidate("styles");
      }
      
      public function get selectedDownSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("down",true));
      }
      
      public function set selectedDownSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("down",true) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"down",true);
         this.invalidate("styles");
      }
      
      public function get selectedHoverSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("hover",true));
      }
      
      public function set selectedHoverSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("hover",true) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"hover",true);
         this.invalidate("styles");
      }
      
      public function get selectedDisabledSkin() : DisplayObject
      {
         return DisplayObject(this._skinSelector.getValueForState("disabled",true));
      }
      
      public function set selectedDisabledSkin(param1:DisplayObject) : void
      {
         if(this._skinSelector.getValueForState("disabled",true) == param1)
         {
            return;
         }
         this._skinSelector.setValueForState(param1,"disabled",true);
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
      
      public function get defaultLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultValue);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.defaultValue = _loc1_;
         }
         return _loc1_;
      }
      
      public function set defaultLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultValue);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.defaultValue = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get upLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("up",false));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"up",false);
         }
         return _loc1_;
      }
      
      public function set upLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("up",false));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"up",false);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get downLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("down",false));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"down",false);
         }
         return _loc1_;
      }
      
      public function set downLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("down",false));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"down",false);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get hoverLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("hover",false));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"hover",false);
         }
         return _loc1_;
      }
      
      public function set hoverLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("hover",false));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"hover",false);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get disabledLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("disabled",false));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"disabled",false);
         }
         return _loc1_;
      }
      
      public function set disabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("disabled",false));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"disabled",false);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get defaultSelectedLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.defaultSelectedValue = _loc1_;
         }
         return _loc1_;
      }
      
      public function set defaultSelectedLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.defaultSelectedValue = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedUpLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("up",true));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"up",true);
         }
         return _loc1_;
      }
      
      public function set selectedUpLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("up",true));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"up",true);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedDownLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("down",true));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"down",true);
         }
         return _loc1_;
      }
      
      public function set selectedDownLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("down",true));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"down",true);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedHoverLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("hover",true));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"hover",true);
         }
         return _loc1_;
      }
      
      public function set selectedHoverLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("hover",true));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"hover",true);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedDisabledLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("disabled",true));
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._labelPropertiesSelector.setValueForState(_loc1_,"disabled",true);
         }
         return _loc1_;
      }
      
      public function set selectedDisabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState("disabled",true));
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._labelPropertiesSelector.setValueForState(param1,"disabled",true);
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
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
      
      public function get defaultSelectedIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.defaultSelectedValue);
      }
      
      public function set defaultSelectedIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.defaultSelectedValue == param1)
         {
            return;
         }
         this._iconSelector.defaultSelectedValue = param1;
         this.invalidate("styles");
      }
      
      public function get upIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("up",false));
      }
      
      public function set upIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("up",false) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"up",false);
         this.invalidate("styles");
      }
      
      public function get downIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("down",false));
      }
      
      public function set downIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("down",false) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"down",false);
         this.invalidate("styles");
      }
      
      public function get hoverIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("hover",false));
      }
      
      public function set hoverIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("hover",false) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"hover",false);
         this.invalidate("styles");
      }
      
      public function get disabledIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("disabled",false));
      }
      
      public function set disabledIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("disabled",false) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"disabled",false);
         this.invalidate("styles");
      }
      
      public function get selectedUpIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("up",true));
      }
      
      public function set selectedUpIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("up",true) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"up",true);
         this.invalidate("styles");
      }
      
      public function get selectedDownIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("down",true));
      }
      
      public function set selectedDownIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("down",true) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"down",true);
         this.invalidate("styles");
      }
      
      public function get selectedHoverIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("hover",true));
      }
      
      public function set selectedHoverIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("hover",true) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"hover",true);
         this.invalidate("styles");
      }
      
      public function get selectedDisabledIcon() : DisplayObject
      {
         return DisplayObject(this._iconSelector.getValueForState("disabled",true));
      }
      
      public function set selectedDisabledIcon(param1:DisplayObject) : void
      {
         if(this._iconSelector.getValueForState("disabled",true) == param1)
         {
            return;
         }
         this._iconSelector.setValueForState(param1,"disabled",true);
         this.invalidate("styles");
      }
      
      public function get autoFlatten() : Boolean
      {
         return this._autoFlatten;
      }
      
      public function set autoFlatten(param1:Boolean) : void
      {
         if(this._autoFlatten == param1)
         {
            return;
         }
         this._autoFlatten = param1;
         this.unflatten();
         if(this._autoFlatten)
         {
            this.flatten();
         }
      }
      
      public function get longPressDuration() : Number
      {
         return this._longPressDuration;
      }
      
      public function set longPressDuration(param1:Number) : void
      {
         this._longPressDuration = param1;
      }
      
      public function get isLongPressEnabled() : Boolean
      {
         return this._isLongPressEnabled;
      }
      
      public function set isLongPressEnabled(param1:Boolean) : void
      {
         this._isLongPressEnabled = param1;
         if(!param1)
         {
            this.removeEventListener("enterFrame",longPress_enterFrameHandler);
         }
      }
      
      override protected function draw() : void
      {
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("selected");
         var _loc1_:Boolean = this.isInvalid("textRenderer");
         var _loc3_:Boolean = this.isInvalid("focus");
         if(_loc1_)
         {
            this.createLabel();
         }
         if(_loc1_ || _loc6_ || _loc5_)
         {
            this.refreshLabel();
         }
         if(_loc7_ || _loc6_ || _loc4_)
         {
            this.refreshSkin();
            this.refreshIcon();
         }
         if(_loc1_ || _loc7_ || _loc6_ || _loc4_)
         {
            this.refreshLabelStyles();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc7_ || _loc6_ || _loc4_ || _loc2_)
         {
            this.scaleSkin();
         }
         if(_loc1_ || _loc7_ || _loc6_ || _loc4_ || _loc5_ || _loc2_)
         {
            this.layoutContent();
         }
         if(_loc2_ || _loc3_)
         {
            this.refreshFocusIndicator();
         }
         if(this._autoFlatten)
         {
            this.unflatten();
            this.flatten();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc4_:* = NaN;
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc5_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc5_)
         {
            return false;
         }
         this.refreshMaxLabelWidth(true);
         this.labelTextRenderer.measureText(HELPER_POINT);
         var _loc3_:Number = this.explicitWidth;
         if(_loc2_)
         {
            if(this.currentIcon && this.label)
            {
               if(this._iconPosition != "top" && this._iconPosition != "bottom" && this._iconPosition != "manual")
               {
                  _loc4_ = this._gap == Infinity?Math.min(this._paddingLeft,this._paddingRight):this._gap;
                  _loc3_ = this.currentIcon.width + _loc4_ + HELPER_POINT.x;
               }
               else
               {
                  _loc3_ = Math.max(this.currentIcon.width,HELPER_POINT.x);
               }
            }
            else if(this.currentIcon)
            {
               _loc3_ = this.currentIcon.width;
            }
            else if(this.label)
            {
               _loc3_ = HELPER_POINT.x;
            }
            _loc3_ = _loc3_ + (this._paddingLeft + this._paddingRight);
            if(isNaN(_loc3_))
            {
               if(isNaN(this._originalSkinWidth))
               {
                  _loc3_ = 0.0;
               }
               else
               {
                  _loc3_ = this._originalSkinWidth;
               }
            }
            else if(!isNaN(this._originalSkinWidth))
            {
               _loc3_ = Math.max(_loc3_,this._originalSkinWidth);
            }
         }
         var _loc1_:Number = this.explicitHeight;
         if(_loc5_)
         {
            if(this.currentIcon && this.label)
            {
               if(this._iconPosition == "top" || this._iconPosition == "bottom")
               {
                  _loc4_ = this._gap == Infinity?Math.min(this._paddingTop,this._paddingBottom):this._gap;
                  _loc1_ = this.currentIcon.height + _loc4_ + HELPER_POINT.y;
               }
               else
               {
                  _loc1_ = Math.max(this.currentIcon.height,HELPER_POINT.y);
               }
            }
            else if(this.currentIcon)
            {
               _loc1_ = this.currentIcon.height;
            }
            else if(this.label)
            {
               _loc1_ = HELPER_POINT.y;
            }
            _loc1_ = _loc1_ + (this._paddingTop + this._paddingBottom);
            if(isNaN(_loc1_))
            {
               if(isNaN(this._originalSkinHeight))
               {
                  _loc1_ = 0.0;
               }
               else
               {
                  _loc1_ = this._originalSkinHeight;
               }
            }
            else if(!isNaN(this._originalSkinHeight))
            {
               _loc1_ = Math.max(_loc1_,this._originalSkinHeight);
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createLabel() : void
      {
         if(this.labelTextRenderer)
         {
            this.removeChild(DisplayObject(this.labelTextRenderer),true);
            this.labelTextRenderer = null;
         }
         var _loc1_:Function = this._labelFactory != null?this._labelFactory:FeathersControl.defaultTextRendererFactory;
         this.labelTextRenderer = ITextRenderer(_loc1_());
         this.labelTextRenderer.nameList.add(this.labelName);
         this.addChild(DisplayObject(this.labelTextRenderer));
      }
      
      protected function refreshLabel() : void
      {
         this.labelTextRenderer.text = this._label;
         this.labelTextRenderer.visible = this._label !== null && this._label.length > 0;
         this.labelTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshSkin() : void
      {
         var _loc1_:DisplayObject = this.currentSkin;
         if(this._stateToSkinFunction != null)
         {
            this.currentSkin = DisplayObject(this._stateToSkinFunction(this,this._currentState,_loc1_));
         }
         else
         {
            this.currentSkin = DisplayObject(this._skinSelector.updateValue(this,this._currentState,this.currentSkin));
         }
         if(this.currentSkin != _loc1_)
         {
            if(_loc1_)
            {
               this.removeChild(_loc1_,false);
            }
            if(this.currentSkin)
            {
               this.addChildAt(this.currentSkin,0);
            }
         }
         if(this.currentSkin && (isNaN(this._originalSkinWidth) || isNaN(this._originalSkinHeight)))
         {
            if(this.currentSkin is IValidating)
            {
               IValidating(this.currentSkin).validate();
            }
            this._originalSkinWidth = this.currentSkin.width;
            this._originalSkinHeight = this.currentSkin.height;
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
               _loc1_ = this.getChildIndex(DisplayObject(this.labelTextRenderer));
               this.addChildAt(this.currentIcon,_loc1_);
            }
         }
      }
      
      protected function refreshLabelStyles() : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         if(this._stateToLabelPropertiesFunction != null)
         {
            _loc4_ = this._stateToLabelPropertiesFunction(this,this._currentState);
         }
         else
         {
            _loc4_ = this._labelPropertiesSelector.updateValue(this,this._currentState);
         }
         var _loc2_:DisplayObject = DisplayObject(this.labelTextRenderer);
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
      
      protected function scaleSkin() : void
      {
         if(!this.currentSkin)
         {
            return;
         }
         this.currentSkin.x = 0;
         this.currentSkin.y = 0;
         if(this.currentSkin.width != this.actualWidth)
         {
            this.currentSkin.width = this.actualWidth;
         }
         if(this.currentSkin.height != this.actualHeight)
         {
            this.currentSkin.height = this.actualHeight;
         }
      }
      
      protected function layoutContent() : void
      {
         this.refreshMaxLabelWidth(false);
         if(this._label && this.currentIcon)
         {
            this.labelTextRenderer.validate();
            this.positionSingleChild(DisplayObject(this.labelTextRenderer));
            if(this._iconPosition != "manual")
            {
               this.positionLabelAndIcon();
            }
         }
         else if(this._label && !this.currentIcon)
         {
            this.labelTextRenderer.validate();
            this.positionSingleChild(DisplayObject(this.labelTextRenderer));
         }
         else if(!this._label && this.currentIcon && this._iconPosition != "manual")
         {
            this.positionSingleChild(this.currentIcon);
         }
         if(this.currentIcon)
         {
            if(this._iconPosition == "manual")
            {
               this.currentIcon.x = this._paddingLeft;
               this.currentIcon.y = this._paddingTop;
            }
            this.currentIcon.x = this.currentIcon.x + this._iconOffsetX;
            this.currentIcon.y = this.currentIcon.y + this._iconOffsetY;
         }
         if(this._label)
         {
            this.labelTextRenderer.x = this.labelTextRenderer.x + this._labelOffsetX;
            this.labelTextRenderer.y = this.labelTextRenderer.y + this._labelOffsetY;
         }
      }
      
      protected function refreshMaxLabelWidth(param1:Boolean) : void
      {
         var _loc3_:* = NaN;
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         var _loc2_:Number = this.actualWidth;
         if(param1)
         {
            _loc2_ = isNaN(this.explicitWidth)?this._maxWidth:this.explicitWidth;
         }
         if(this._label && this.currentIcon)
         {
            if(this._iconPosition == "left" || this._iconPosition == "leftBaseline" || this._iconPosition == "right" || this._iconPosition == "rightBaseline")
            {
               _loc3_ = this._gap == Infinity?Math.min(this._paddingLeft,this._paddingRight):this._gap;
               this.labelTextRenderer.maxWidth = _loc2_ - this._paddingLeft - this._paddingRight - this.currentIcon.width - _loc3_;
            }
            else
            {
               this.labelTextRenderer.maxWidth = _loc2_ - this._paddingLeft - this._paddingRight;
            }
         }
         else if(this._label && !this.currentIcon)
         {
            this.labelTextRenderer.maxWidth = _loc2_ - this._paddingLeft - this._paddingRight;
         }
      }
      
      protected function positionSingleChild(param1:DisplayObject) : void
      {
         if(this._horizontalAlign == "left")
         {
            param1.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == "right")
         {
            param1.x = this.actualWidth - this._paddingRight - param1.width;
         }
         else
         {
            param1.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - param1.width) / 2;
         }
         if(this._verticalAlign == "top")
         {
            param1.y = this._paddingTop;
         }
         else if(this._verticalAlign == "bottom")
         {
            param1.y = this.actualHeight - this._paddingBottom - param1.height;
         }
         else
         {
            param1.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - param1.height) / 2;
         }
      }
      
      protected function positionLabelAndIcon() : void
      {
         if(this._iconPosition == "top")
         {
            if(this._gap == Infinity)
            {
               this.currentIcon.y = this._paddingTop;
               this.labelTextRenderer.y = this.actualHeight - this._paddingBottom - this.labelTextRenderer.height;
            }
            else
            {
               if(this._verticalAlign == "top")
               {
                  this.labelTextRenderer.y = this.labelTextRenderer.y + (this.currentIcon.height + this._gap);
               }
               else if(this._verticalAlign == "middle")
               {
                  this.labelTextRenderer.y = this.labelTextRenderer.y + (this.currentIcon.height + this._gap) / 2;
               }
               this.currentIcon.y = this.labelTextRenderer.y - this.currentIcon.height - this._gap;
            }
         }
         else if(this._iconPosition == "right" || this._iconPosition == "rightBaseline")
         {
            if(this._gap == Infinity)
            {
               this.labelTextRenderer.x = this._paddingLeft;
               this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
            }
            else
            {
               if(this._horizontalAlign == "right")
               {
                  this.labelTextRenderer.x = this.labelTextRenderer.x - (this.currentIcon.width + this._gap);
               }
               else if(this._horizontalAlign == "center")
               {
                  this.labelTextRenderer.x = this.labelTextRenderer.x - (this.currentIcon.width + this._gap) / 2;
               }
               this.currentIcon.x = this.labelTextRenderer.x + this.labelTextRenderer.width + this._gap;
            }
         }
         else if(this._iconPosition == "bottom")
         {
            if(this._gap == Infinity)
            {
               this.labelTextRenderer.y = this._paddingTop;
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               if(this._verticalAlign == "bottom")
               {
                  this.labelTextRenderer.y = this.labelTextRenderer.y - (this.currentIcon.height + this._gap);
               }
               else if(this._verticalAlign == "middle")
               {
                  this.labelTextRenderer.y = this.labelTextRenderer.y - (this.currentIcon.height + this._gap) / 2;
               }
               this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.height + this._gap;
            }
         }
         else if(this._iconPosition == "left" || this._iconPosition == "leftBaseline")
         {
            if(this._gap == Infinity)
            {
               this.currentIcon.x = this._paddingLeft;
               this.labelTextRenderer.x = this.actualWidth - this._paddingRight - this.labelTextRenderer.width;
            }
            else
            {
               if(this._horizontalAlign == "left")
               {
                  this.labelTextRenderer.x = this.labelTextRenderer.x + (this._gap + this.currentIcon.width);
               }
               else if(this._horizontalAlign == "center")
               {
                  this.labelTextRenderer.x = this.labelTextRenderer.x + (this._gap + this.currentIcon.width) / 2;
               }
               this.currentIcon.x = this.labelTextRenderer.x - this._gap - this.currentIcon.width;
            }
         }
         if(this._iconPosition == "left" || this._iconPosition == "right")
         {
            if(this._verticalAlign == "top")
            {
               this.currentIcon.y = this._paddingTop;
            }
            else if(this._verticalAlign == "bottom")
            {
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               this.currentIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2;
            }
         }
         else if(this._iconPosition == "leftBaseline" || this._iconPosition == "rightBaseline")
         {
            this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.baseline - this.currentIcon.height;
         }
         else if(this._horizontalAlign == "left")
         {
            this.currentIcon.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == "right")
         {
            this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
         }
         else
         {
            this.currentIcon.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width) / 2;
         }
      }
      
      protected function resetTouchState(param1:Touch = null) : void
      {
         this.touchPointID = -1;
         this.removeEventListener("enterFrame",longPress_enterFrameHandler);
         if(this._isEnabled)
         {
            this.currentState = "up";
         }
         else
         {
            this.currentState = "disabled";
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
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
      
      protected function button_removedFromStageHandler(param1:Event) : void
      {
         this.resetTouchState();
      }
      
      protected function button_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = false;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,null,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            _loc2_.getLocation(this.stage,HELPER_POINT);
            _loc3_ = this.contains(this.stage.hitTest(HELPER_POINT,true));
            if(_loc2_.phase == "moved")
            {
               if(_loc3_ || this.keepDownStateOnRollOut)
               {
                  this.currentState = "down";
               }
               else
               {
                  this.currentState = "up";
               }
            }
            else if(_loc2_.phase == "ended")
            {
               this.resetTouchState(_loc2_);
               if(!this._hasLongPressed && _loc3_)
               {
                  this.dispatchEventWith("triggered");
                  if(this._isToggle)
                  {
                     this.isSelected = !this._isSelected;
                  }
               }
            }
            return;
         }
         _loc2_ = param1.getTouch(this,"began");
         if(_loc2_)
         {
            this.currentState = "down";
            this.touchPointID = _loc2_.id;
            if(this._isLongPressEnabled)
            {
               this._touchBeginTime = getTimer();
               this._hasLongPressed = false;
               this.addEventListener("enterFrame",longPress_enterFrameHandler);
            }
            return;
         }
         _loc2_ = param1.getTouch(this,"hover");
         if(_loc2_)
         {
            this.currentState = "hover";
            return;
         }
         this.currentState = "up";
      }
      
      protected function longPress_enterFrameHandler(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this._touchBeginTime) / 1000;
         if(_loc2_ >= this._longPressDuration)
         {
            this.removeEventListener("enterFrame",longPress_enterFrameHandler);
            this._hasLongPressed = true;
            this.dispatchEventWith("longPress");
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this.touchPointID = -1;
            this.currentState = "up";
         }
         if(this.touchPointID >= 0 || param1.keyCode != 32)
         {
            return;
         }
         this.touchPointID = 2147483647;
         this.currentState = "down";
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this.touchPointID != 2147483647 || param1.keyCode != 32)
         {
            return;
         }
         this.touchPointID = -1;
         this.currentState = "up";
         this.dispatchEventWith("triggered");
         if(this._isToggle)
         {
            this.isSelected = !this._isSelected;
         }
      }
   }
}
