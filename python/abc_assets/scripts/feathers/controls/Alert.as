package feathers.controls
{
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   import feathers.core.PopUpManager;
   import feathers.core.ITextRenderer;
   import feathers.core.PropertyProxy;
   import feathers.layout.VerticalLayout;
   import feathers.core.IValidating;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import starling.events.Event;
   import starling.animation.Tween;
   import starling.display.DisplayObjectContainer;
   import starling.core.Starling;
   
   public class Alert extends Panel
   {
      
      public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-alert-header";
      
      public static const DEFAULT_CHILD_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";
      
      public static const DEFAULT_CHILD_NAME_MESSAGE:String = "feathers-alert-message";
      
      public static var alertFactory:Function = defaultAlertFactory;
      
      public static var overlayFactory:Function;
       
      protected var messageName:String = "feathers-alert-message";
      
      protected var headerHeader:feathers.controls.Header;
      
      protected var buttonGroupFooter:feathers.controls.ButtonGroup;
      
      protected var messageTextRenderer:ITextRenderer;
      
      protected var _title:String = null;
      
      protected var _message:String = null;
      
      protected var _icon:DisplayObject;
      
      protected var _gap:Number = 0;
      
      protected var _buttonsDataProvider:ListCollection;
      
      protected var _messageFactory:Function;
      
      protected var _messageProperties:PropertyProxy;
      
      public function Alert()
      {
         super();
         this.headerName = "feathers-alert-header";
         this.footerName = "feathers-alert-button-group";
         this.buttonGroupFactory = defaultButtonGroupFactory;
      }
      
      public static function defaultAlertFactory() : Alert
      {
         return new Alert();
      }
      
      public static function show(param1:String, param2:String = null, param3:ListCollection = null, param4:DisplayObject = null, param5:Boolean = true, param6:Boolean = true, param7:Function = null, param8:Function = null) : Alert
      {
         var _loc10_:* = param7;
         if(_loc10_ == null)
         {
            _loc10_ = alertFactory != null?alertFactory:defaultAlertFactory;
         }
         var _loc9_:Alert = Alert(_loc10_());
         _loc9_.title = param2;
         _loc9_.message = param1;
         _loc9_.buttonsDataProvider = param3;
         _loc9_.icon = param4;
         _loc10_ = param8;
         if(_loc10_ == null)
         {
            _loc10_ = overlayFactory;
         }
         PopUpManager.addPopUp(_loc9_,param5,param6,_loc10_);
         _loc9_.x = _loc9_.x;
         _loc9_.y = _loc9_.y;
         return _loc9_;
      }
      
      protected static function defaultButtonGroupFactory() : feathers.controls.ButtonGroup
      {
         return new feathers.controls.ButtonGroup();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         this.invalidate("data");
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(param1:String) : void
      {
         if(this._message == param1)
         {
            return;
         }
         this._message = param1;
         this.invalidate("data");
      }
      
      public function get icon() : DisplayObject
      {
         return this._icon;
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         if(this._icon == param1)
         {
            return;
         }
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         if(this._icon)
         {
            this.removeChild(this._icon);
         }
         this._icon = param1;
         if(this._icon)
         {
            this.addChild(this._icon);
         }
         this.displayListBypassEnabled = _loc2_;
         this.invalidate("data");
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
         this.invalidate("layout");
      }
      
      public function get buttonsDataProvider() : ListCollection
      {
         return this._buttonsDataProvider;
      }
      
      public function set buttonsDataProvider(param1:ListCollection) : void
      {
         if(this._buttonsDataProvider == param1)
         {
            return;
         }
         this._buttonsDataProvider = param1;
         this.invalidate("styles");
      }
      
      public function get messageFactory() : Function
      {
         return this._messageFactory;
      }
      
      public function set messageFactory(param1:Function) : void
      {
         if(this._messageFactory == param1)
         {
            return;
         }
         this._messageFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get messageProperties() : Object
      {
         if(!this._messageProperties)
         {
            this._messageProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._messageProperties;
      }
      
      public function set messageProperties(param1:Object) : void
      {
         if(this._messageProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._messageProperties)
         {
            this._messageProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._messageProperties = PropertyProxy(param1);
         if(this._messageProperties)
         {
            this._messageProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get buttonGroupFactory() : Function
      {
         return super.footerFactory;
      }
      
      public function set buttonGroupFactory(param1:Function) : void
      {
         .super.footerFactory = param1;
      }
      
      public function get customButtonGroupName() : String
      {
         return super.customFooterName;
      }
      
      public function set customButtonGroupName(param1:String) : void
      {
         .super.customFooterName = param1;
      }
      
      public function get buttonGroupProperties() : Object
      {
         return super.footerProperties;
      }
      
      public function set buttonGroupProperties(param1:Object) : void
      {
         .super.footerProperties = param1;
      }
      
      override protected function initialize() : void
      {
         var _loc1_:* = null;
         if(!this.layout)
         {
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = "justify";
            this.layout = _loc1_;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("textRenderer");
         if(_loc1_)
         {
            this.createMessage();
         }
         if(_loc1_ || _loc2_)
         {
            this.messageTextRenderer.text = this._message;
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshMessageStyles();
         }
         super.draw();
         if(this._icon)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            this._icon.x = this._paddingLeft;
            this._icon.y = this._topViewPortOffset + (this._viewPort.height - this._icon.height) / 2;
         }
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:* = NaN;
         var _loc8_:* = NaN;
         var _loc3_:Boolean = isNaN(this.explicitWidth);
         var _loc6_:Boolean = isNaN(this.explicitHeight);
         if(!_loc3_ && !_loc6_)
         {
            return false;
         }
         if(this._icon is IValidating)
         {
            IValidating(this._icon).validate();
         }
         var _loc7_:Number = this.header.width;
         var _loc5_:Number = this.header.height;
         this.header.width = this.explicitWidth;
         this.header.maxWidth = this._maxWidth;
         this.header.height = NaN;
         this.header.validate();
         if(this.footer)
         {
            _loc2_ = this.footer.width;
            _loc8_ = this.footer.height;
            this.footer.width = this.explicitWidth;
            this.footer.maxWidth = this._maxWidth;
            this.footer.height = NaN;
            this.footer.validate();
         }
         var _loc4_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc3_)
         {
            _loc4_ = this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset;
            if(this._icon && !isNaN(this._icon.width))
            {
               _loc4_ = _loc4_ + (this._icon.width + this._gap);
            }
            _loc4_ = Math.max(_loc4_,this.header.width);
            if(this.footer)
            {
               _loc4_ = Math.max(_loc4_,this.footer.width);
            }
            if(!isNaN(this.originalBackgroundWidth))
            {
               _loc4_ = Math.max(_loc4_,this.originalBackgroundWidth);
            }
         }
         if(_loc6_)
         {
            _loc1_ = this._viewPort.height;
            if(this._icon && !isNaN(this._icon.height))
            {
               _loc1_ = Math.max(_loc1_,this._icon.height);
            }
            _loc1_ = _loc1_ + (this._bottomViewPortOffset + this._topViewPortOffset);
            if(!isNaN(this.originalBackgroundHeight))
            {
               _loc1_ = Math.max(_loc1_,this.originalBackgroundHeight);
            }
         }
         this.header.width = _loc7_;
         this.header.height = _loc5_;
         if(this.footer)
         {
            this.footer.width = _loc2_;
            this.footer.height = _loc8_;
         }
         return this.setSizeInternal(_loc4_,_loc1_,false);
      }
      
      override protected function createHeader() : void
      {
         super.createHeader();
         this.headerHeader = feathers.controls.Header(this.header);
      }
      
      protected function createButtonGroup() : void
      {
         if(this.buttonGroupFooter)
         {
            this.buttonGroupFooter.removeEventListener("triggered",buttonsFooter_triggeredHandler);
         }
         super.createFooter();
         this.buttonGroupFooter = feathers.controls.ButtonGroup(this.footer);
         this.buttonGroupFooter.addEventListener("triggered",buttonsFooter_triggeredHandler);
      }
      
      override protected function createFooter() : void
      {
         this.createButtonGroup();
      }
      
      protected function createMessage() : void
      {
         if(this.messageTextRenderer)
         {
            this.removeChild(DisplayObject(this.messageTextRenderer),true);
            this.messageTextRenderer = null;
         }
         var _loc2_:Function = this._messageFactory != null?this._messageFactory:FeathersControl.defaultTextRendererFactory;
         this.messageTextRenderer = ITextRenderer(_loc2_());
         var _loc1_:IFeathersControl = IFeathersControl(this.messageTextRenderer);
         _loc1_.nameList.add(this.messageName);
         _loc1_.touchable = false;
         this.addChild(DisplayObject(this.messageTextRenderer));
      }
      
      override protected function refreshHeaderStyles() : void
      {
         super.refreshHeaderStyles();
         this.headerHeader.title = this._title;
      }
      
      override protected function refreshFooterStyles() : void
      {
         super.refreshFooterStyles();
         this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
      }
      
      protected function refreshMessageStyles() : void
      {
         var _loc2_:* = null;
         var _loc3_:DisplayObject = DisplayObject(this.messageTextRenderer);
         var _loc5_:* = 0;
         var _loc4_:* = this._messageProperties;
         for(var _loc1_ in this._messageProperties)
         {
            if(_loc3_.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._messageProperties[_loc1_];
               _loc3_[_loc1_] = _loc2_;
            }
         }
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.calculateViewPortOffsets(param1,param2);
         if(this._icon)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            if(!isNaN(this._icon.width))
            {
               this._leftViewPortOffset = this._leftViewPortOffset + (this._icon.width + this._gap);
            }
         }
      }
      
      protected function buttonsFooter_triggeredHandler(param1:Event, param2:Object) : void
      {
         event = param1;
         data = param2;
         if(Config.isOpenAni && (Config.starling.root as DisplayObjectContainer).numChildren <= 2)
         {
            var t:Tween = new Tween(this,0.2,"easeInBack");
            Starling.juggler.add(t);
            t.animate("scaleX",0);
            t.animate("scaleY",0);
            t.onComplete = function():void
            {
               t.target.removeFromParent();
               t.target.dispatchEventWith("close",false,data);
               t.target.dispose();
            };
         }
         else
         {
            this.removeFromParent();
            this.dispatchEventWith("close",false,data);
            this.dispose();
         }
      }
   }
}
