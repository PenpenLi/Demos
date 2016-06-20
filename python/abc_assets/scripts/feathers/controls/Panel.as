package feathers.controls
{
   import feathers.core.IFocusExtras;
   import feathers.core.IFeathersControl;
   import feathers.core.PropertyProxy;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class Panel extends ScrollContainer implements IFocusExtras
   {
      
      public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-header";
      
      public static const DEFAULT_CHILD_NAME_FOOTER:String = "feathers-panel-footer";
      
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
      
      protected static const INVALIDATION_FLAG_HEADER_FACTORY:String = "headerFactory";
      
      protected static const INVALIDATION_FLAG_FOOTER_FACTORY:String = "footerFactory";
       
      protected var header:IFeathersControl;
      
      protected var footer:IFeathersControl;
      
      protected var headerName:String = "feathers-panel-header";
      
      protected var footerName:String = "feathers-panel-footer";
      
      protected var _headerFactory:Function;
      
      protected var _customHeaderName:String;
      
      protected var _headerProperties:PropertyProxy;
      
      protected var _footerFactory:Function;
      
      protected var _customFooterName:String;
      
      protected var _footerProperties:PropertyProxy;
      
      private var _focusExtrasBefore:Vector.<DisplayObject>;
      
      private var _focusExtrasAfter:Vector.<DisplayObject>;
      
      protected var _ignoreHeaderResizing:Boolean = false;
      
      protected var _ignoreFooterResizing:Boolean = false;
      
      public function Panel()
      {
         _focusExtrasBefore = new Vector.<DisplayObject>(0);
         _focusExtrasAfter = new Vector.<DisplayObject>(0);
         super();
      }
      
      protected static function defaultHeaderFactory() : IFeathersControl
      {
         return new Header();
      }
      
      public function get headerFactory() : Function
      {
         return this._headerFactory;
      }
      
      public function set headerFactory(param1:Function) : void
      {
         if(this._headerFactory == param1)
         {
            return;
         }
         this._headerFactory = param1;
         this.invalidate("headerFactory");
         this.invalidate("size");
      }
      
      public function get customHeaderName() : String
      {
         return this._customHeaderName;
      }
      
      public function set customHeaderName(param1:String) : void
      {
         if(this._customHeaderName == param1)
         {
            return;
         }
         this._customHeaderName = param1;
         this.invalidate("headerFactory");
         this.invalidate("size");
      }
      
      public function get headerProperties() : Object
      {
         if(!this._headerProperties)
         {
            this._headerProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._headerProperties;
      }
      
      public function set headerProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._headerProperties == param1)
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
         if(this._headerProperties)
         {
            this._headerProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._headerProperties = PropertyProxy(param1);
         if(this._headerProperties)
         {
            this._headerProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get footerFactory() : Function
      {
         return this._footerFactory;
      }
      
      public function set footerFactory(param1:Function) : void
      {
         if(this._footerFactory == param1)
         {
            return;
         }
         this._footerFactory = param1;
         this.invalidate("footerFactory");
         this.invalidate("size");
      }
      
      public function get customFooterName() : String
      {
         return this._customFooterName;
      }
      
      public function set customFooterName(param1:String) : void
      {
         if(this._customFooterName == param1)
         {
            return;
         }
         this._customFooterName = param1;
         this.invalidate("footerFactory");
         this.invalidate("size");
      }
      
      public function get footerProperties() : Object
      {
         if(!this._footerProperties)
         {
            this._footerProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._footerProperties;
      }
      
      public function set footerProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._footerProperties == param1)
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
         if(this._footerProperties)
         {
            this._footerProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._footerProperties = PropertyProxy(param1);
         if(this._footerProperties)
         {
            this._footerProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get focusExtrasBefore() : Vector.<DisplayObject>
      {
         return this._focusExtrasBefore;
      }
      
      public function get focusExtrasAfter() : Vector.<DisplayObject>
      {
         return this._focusExtrasAfter;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("headerFactory");
         var _loc3_:Boolean = this.isInvalid("footerFactory");
         var _loc2_:Boolean = this.isInvalid("styles");
         if(_loc1_)
         {
            this.createHeader();
         }
         if(_loc3_)
         {
            this.createFooter();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshHeaderStyles();
         }
         if(_loc3_ || _loc2_)
         {
            this.refreshFooterStyles();
         }
         super.draw();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:* = NaN;
         var _loc10_:* = NaN;
         var _loc4_:Boolean = isNaN(this.explicitWidth);
         var _loc8_:Boolean = isNaN(this.explicitHeight);
         if(!_loc4_ && !_loc8_)
         {
            return false;
         }
         var _loc3_:Boolean = this._ignoreHeaderResizing;
         this._ignoreHeaderResizing = true;
         var _loc5_:Boolean = this._ignoreFooterResizing;
         this._ignoreFooterResizing = true;
         var _loc9_:Number = this.header.width;
         var _loc7_:Number = this.header.height;
         this.header.width = this.explicitWidth;
         this.header.maxWidth = this._maxWidth;
         this.header.height = NaN;
         this.header.validate();
         if(this.footer)
         {
            _loc2_ = this.footer.width;
            _loc10_ = this.footer.height;
            this.footer.width = this.explicitWidth;
            this.footer.maxWidth = this._maxWidth;
            this.footer.height = NaN;
            this.footer.validate();
         }
         var _loc6_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc4_)
         {
            _loc6_ = Math.max(this.header.width,this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset);
            if(this.footer)
            {
               _loc6_ = Math.max(_loc6_,this.footer.width);
            }
            if(!isNaN(this.originalBackgroundWidth))
            {
               _loc6_ = Math.max(_loc6_,this.originalBackgroundWidth);
            }
         }
         if(_loc8_)
         {
            _loc1_ = this._viewPort.height + this._bottomViewPortOffset + this._topViewPortOffset;
            if(!isNaN(this.originalBackgroundHeight))
            {
               _loc1_ = Math.max(_loc1_,this.originalBackgroundHeight);
            }
         }
         this.header.width = _loc9_;
         this.header.height = _loc7_;
         if(this.footer)
         {
            this.footer.width = _loc2_;
            this.footer.height = _loc10_;
         }
         this._ignoreFooterResizing = _loc5_;
         return this.setSizeInternal(_loc6_,_loc1_,false);
      }
      
      protected function createHeader() : void
      {
         var _loc2_:* = null;
         if(this.header)
         {
            this.header.removeEventListener("resize",header_resizeHandler);
            _loc2_ = DisplayObject(this.header);
            this._focusExtrasBefore.splice(this._focusExtrasBefore.indexOf(_loc2_),1);
            this.removeRawChild(_loc2_,true);
            this.header = null;
         }
         var _loc1_:Function = this._headerFactory != null?this._headerFactory:defaultHeaderFactory;
         var _loc3_:String = this._customHeaderName != null?this._customHeaderName:this.headerName;
         this.header = IFeathersControl(_loc1_());
         this.header.nameList.add(_loc3_);
         this.header.addEventListener("resize",header_resizeHandler);
         _loc2_ = DisplayObject(this.header);
         this.addRawChild(_loc2_);
         this._focusExtrasBefore.push(_loc2_);
      }
      
      protected function createFooter() : void
      {
         var _loc2_:* = null;
         if(this.footer)
         {
            this.footer.removeEventListener("resize",footer_resizeHandler);
            _loc2_ = DisplayObject(this.footer);
            this._focusExtrasAfter.splice(this._focusExtrasAfter.indexOf(_loc2_),1);
            this.removeRawChild(_loc2_,true);
            this.footer = null;
         }
         if(this._footerFactory == null)
         {
            return;
         }
         var _loc1_:String = this._customFooterName != null?this._customFooterName:this.footerName;
         this.footer = IFeathersControl(this._footerFactory());
         this.footer.nameList.add(_loc1_);
         this.footer.addEventListener("resize",footer_resizeHandler);
         _loc2_ = DisplayObject(this.footer);
         this.addRawChild(_loc2_);
         this._focusExtrasAfter.push(_loc2_);
      }
      
      protected function refreshHeaderStyles() : void
      {
         var _loc3_:* = null;
         var _loc2_:Object = this.header;
         var _loc5_:* = 0;
         var _loc4_:* = this._headerProperties;
         for(var _loc1_ in this._headerProperties)
         {
            if(_loc2_.hasOwnProperty(_loc1_))
            {
               _loc3_ = this._headerProperties[_loc1_];
               this.header[_loc1_] = _loc3_;
            }
         }
      }
      
      protected function refreshFooterStyles() : void
      {
         var _loc3_:* = null;
         var _loc2_:Object = this.footer;
         var _loc5_:* = 0;
         var _loc4_:* = this._footerProperties;
         for(var _loc1_ in this._footerProperties)
         {
            if(_loc2_.hasOwnProperty(_loc1_))
            {
               _loc3_ = this._footerProperties[_loc1_];
               this.footer[_loc1_] = _loc3_;
            }
         }
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc5_:* = false;
         var _loc3_:* = NaN;
         var _loc8_:* = NaN;
         super.calculateViewPortOffsets(param1);
         var _loc4_:Boolean = this._ignoreHeaderResizing;
         this._ignoreHeaderResizing = true;
         var _loc7_:Number = this.header.width;
         var _loc6_:Number = this.header.height;
         this.header.width = param2?this.actualWidth:this.explicitWidth;
         this.header.maxWidth = this._maxWidth;
         this.header.height = NaN;
         this.header.validate();
         this._topViewPortOffset = this._topViewPortOffset + this.header.height;
         this.header.width = _loc7_;
         this.header.height = _loc6_;
         this._ignoreHeaderResizing = _loc4_;
         if(this.footer)
         {
            _loc5_ = this._ignoreFooterResizing;
            this._ignoreFooterResizing = true;
            _loc3_ = this.footer.width;
            _loc8_ = this.footer.height;
            this.footer.width = param2?this.actualWidth:this.explicitWidth;
            this.footer.maxWidth = this._maxWidth;
            this.footer.height = NaN;
            this.footer.validate();
            this._bottomViewPortOffset = this._bottomViewPortOffset + this.footer.height;
            this.footer.width = _loc3_;
            this.footer.height = _loc8_;
            this._ignoreFooterResizing = _loc5_;
         }
      }
      
      override protected function layoutChildren() : void
      {
         var _loc2_:* = false;
         super.layoutChildren();
         var _loc1_:Boolean = this._ignoreHeaderResizing;
         this._ignoreHeaderResizing = true;
         this.header.width = this.actualWidth;
         this.header.height = NaN;
         this.header.validate();
         this._ignoreHeaderResizing = _loc1_;
         if(this.footer)
         {
            _loc2_ = this._ignoreFooterResizing;
            this._ignoreFooterResizing = true;
            this.footer.width = this.actualWidth;
            this.footer.height = NaN;
            this.footer.validate();
            this.footer.y = this.actualHeight - this.footer.height;
            this._ignoreFooterResizing = _loc2_;
         }
      }
      
      protected function header_resizeHandler(param1:Event) : void
      {
         if(this._ignoreHeaderResizing)
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function footer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreFooterResizing)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}
