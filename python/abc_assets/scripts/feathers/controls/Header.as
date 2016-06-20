package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.layout.ViewPortBounds;
   import feathers.layout.LayoutBoundsResult;
   import flash.geom.Point;
   import feathers.layout.HorizontalLayout;
   import feathers.core.ITextRenderer;
   import starling.display.DisplayObject;
   import feathers.core.IFeathersControl;
   import feathers.core.PropertyProxy;
   import feathers.core.IValidating;
   import starling.events.Event;
   
   public class Header extends FeathersControl
   {
      
      protected static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";
      
      protected static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";
      
      protected static const INVALIDATION_FLAG_CENTER_CONTENT:String = "centerContent";
      
      public static const TITLE_ALIGN_CENTER:String = "center";
      
      public static const TITLE_ALIGN_PREFER_LEFT:String = "preferLeft";
      
      public static const TITLE_ALIGN_PREFER_RIGHT:String = "preferRight";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const DEFAULT_CHILD_NAME_ITEM:String = "feathers-header-item";
      
      public static const DEFAULT_CHILD_NAME_TITLE:String = "feathers-header-title";
      
      private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      private static const HELPER_POINT:Point = new Point();
       
      protected var titleName:String = "feathers-header-title";
      
      protected var itemName:String = "feathers-header-item";
      
      protected var leftItemsWidth:Number = 0;
      
      protected var rightItemsWidth:Number = 0;
      
      protected var _layout:HorizontalLayout;
      
      protected var _title:String = "";
      
      protected var _titleFactory:Function;
      
      protected var titleTextRenderer:ITextRenderer;
      
      protected var _leftItems:Vector.<DisplayObject>;
      
      protected var _centerItems:Vector.<DisplayObject>;
      
      protected var _rightItems:Vector.<DisplayObject>;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _gap:Number = 0;
      
      protected var _titleGap:Number = NaN;
      
      protected var _verticalAlign:String = "middle";
      
      protected var originalBackgroundWidth:Number = NaN;
      
      protected var originalBackgroundHeight:Number = NaN;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _titleProperties:PropertyProxy;
      
      protected var _titleAlign:String = "center";
      
      public function Header()
      {
         super();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(param1 === null)
         {
            var param1:String = "";
         }
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         this.invalidate("data");
      }
      
      public function get titleFactory() : Function
      {
         return this._titleFactory;
      }
      
      public function set titleFactory(param1:Function) : void
      {
         if(this._titleFactory == param1)
         {
            return;
         }
         this._titleFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get leftItems() : Vector.<DisplayObject>
      {
         return this._leftItems.concat();
      }
      
      public function set leftItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._leftItems == param1)
         {
            return;
         }
         if(this._leftItems)
         {
            var _loc4_:* = 0;
            var _loc3_:* = this._leftItems;
            for each(var _loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).nameList.remove(this.itemName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._leftItems = param1;
         if(this._leftItems)
         {
            var _loc6_:* = 0;
            var _loc5_:* = this._leftItems;
            for each(_loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("leftContent");
      }
      
      public function get centerItems() : Vector.<DisplayObject>
      {
         return this._centerItems.concat();
      }
      
      public function set centerItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._centerItems == param1)
         {
            return;
         }
         if(this._centerItems)
         {
            var _loc4_:* = 0;
            var _loc3_:* = this._centerItems;
            for each(var _loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).nameList.remove(this.itemName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._centerItems = param1;
         if(this._centerItems)
         {
            var _loc6_:* = 0;
            var _loc5_:* = this._centerItems;
            for each(_loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("centerContent");
      }
      
      public function get rightItems() : Vector.<DisplayObject>
      {
         return this._rightItems.concat();
      }
      
      public function set rightItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._rightItems == param1)
         {
            return;
         }
         if(this._rightItems)
         {
            var _loc4_:* = 0;
            var _loc3_:* = this._rightItems;
            for each(var _loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).nameList.remove(this.itemName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._rightItems = param1;
         if(this._rightItems)
         {
            var _loc6_:* = 0;
            var _loc5_:* = this._rightItems;
            for each(_loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("rightContent");
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
      
      public function get gap() : Number
      {
         return _gap;
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
      
      public function get titleGap() : Number
      {
         return _titleGap;
      }
      
      public function set titleGap(param1:Number) : void
      {
         if(this._titleGap == param1)
         {
            return;
         }
         this._titleGap = param1;
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
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
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
         {
            this.removeChild(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin && this._backgroundSkin.parent != this)
         {
            this._backgroundSkin.visible = false;
            this._backgroundSkin.touchable = false;
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
         {
            this.removeChild(this._backgroundDisabledSkin);
         }
         this._backgroundDisabledSkin = param1;
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
         {
            this._backgroundDisabledSkin.visible = false;
            this._backgroundDisabledSkin.touchable = false;
            this.addChildAt(this._backgroundDisabledSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get titleProperties() : Object
      {
         if(!this._titleProperties)
         {
            this._titleProperties = new PropertyProxy(titleProperties_onChange);
         }
         return this._titleProperties;
      }
      
      public function set titleProperties(param1:Object) : void
      {
         if(this._titleProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            var param1:Object = PropertyProxy.fromObject(param1);
         }
         if(this._titleProperties)
         {
            this._titleProperties.removeOnChangeCallback(titleProperties_onChange);
         }
         this._titleProperties = PropertyProxy(param1);
         if(this._titleProperties)
         {
            this._titleProperties.addOnChangeCallback(titleProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get titleAlign() : String
      {
         return this._titleAlign;
      }
      
      public function set titleAlign(param1:String) : void
      {
         if(this._titleAlign == param1)
         {
            return;
         }
         this._titleAlign = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         this.leftItems = null;
         this.rightItems = null;
         this.centerItems = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         if(!this._layout)
         {
            this._layout = new HorizontalLayout();
            this._layout.useVirtualLayout = false;
            this._layout.verticalAlign = "middle";
         }
      }
      
      override protected function draw() : void
      {
         var _loc4_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc7_:Boolean = this.isInvalid("state");
         var _loc9_:Boolean = this.isInvalid("leftContent");
         var _loc1_:Boolean = this.isInvalid("rightContent");
         var _loc3_:Boolean = this.isInvalid("centerContent");
         var _loc2_:Boolean = this.isInvalid("textRenderer");
         if(_loc2_)
         {
            this.createTitle();
         }
         if(_loc2_ || _loc6_)
         {
            this.titleTextRenderer.text = this._title;
         }
         if(_loc7_ || _loc8_)
         {
            this.refreshBackground();
         }
         if(_loc2_ || _loc8_)
         {
            this.refreshLayout();
            this.refreshTitleStyles();
         }
         if(_loc9_)
         {
            if(this._leftItems)
            {
               var _loc11_:* = 0;
               var _loc10_:* = this._leftItems;
               for each(var _loc5_ in this._leftItems)
               {
                  if(_loc5_ is IFeathersControl)
                  {
                     IFeathersControl(_loc5_).nameList.add(this.itemName);
                  }
                  this.addChild(_loc5_);
               }
            }
         }
         if(_loc1_)
         {
            if(this._rightItems)
            {
               var _loc13_:* = 0;
               var _loc12_:* = this._rightItems;
               for each(_loc5_ in this._rightItems)
               {
                  if(_loc5_ is IFeathersControl)
                  {
                     IFeathersControl(_loc5_).nameList.add(this.itemName);
                  }
                  this.addChild(_loc5_);
               }
            }
         }
         if(_loc3_)
         {
            if(this._centerItems)
            {
               var _loc15_:* = 0;
               var _loc14_:* = this._centerItems;
               for each(_loc5_ in this._centerItems)
               {
                  if(_loc5_ is IFeathersControl)
                  {
                     IFeathersControl(_loc5_).nameList.add(this.itemName);
                  }
                  this.addChild(_loc5_);
               }
            }
         }
         _loc4_ = this.autoSizeIfNeeded() || _loc4_;
         if(_loc4_ || _loc8_)
         {
            this.layoutBackground();
         }
         if(_loc4_ || _loc9_ || _loc1_ || _loc3_ || _loc8_)
         {
            this.leftItemsWidth = 0;
            this.rightItemsWidth = 0;
            if(this._leftItems)
            {
               this.layoutLeftItems();
            }
            if(this._rightItems)
            {
               this.layoutRightItems();
            }
            if(this._centerItems)
            {
               this.layoutCenterItems();
            }
         }
         if(_loc2_ || _loc4_ || _loc8_ || _loc6_ || _loc9_ || _loc1_ || _loc3_)
         {
            this.layoutTitle();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc8_:* = 0;
         var _loc10_:* = null;
         var _loc6_:* = NaN;
         var _loc15_:* = NaN;
         var _loc14_:* = NaN;
         var _loc13_:* = NaN;
         var _loc4_:* = NaN;
         var _loc9_:Boolean = isNaN(this.explicitWidth);
         var _loc12_:Boolean = isNaN(this.explicitHeight);
         if(!_loc9_ && !_loc12_)
         {
            return false;
         }
         var _loc3_:Number = _loc9_?this._paddingLeft + this._paddingRight:this.explicitWidth;
         var _loc1_:Number = _loc12_?0:this.explicitHeight;
         var _loc2_:* = 0.0;
         var _loc11_:int = this._leftItems?this._leftItems.length:0;
         _loc8_ = 0;
         while(_loc8_ < _loc11_)
         {
            _loc10_ = this._leftItems[_loc8_];
            if(_loc10_ is IValidating)
            {
               IValidating(_loc10_).validate();
            }
            if(_loc9_ && !isNaN(_loc10_.width))
            {
               _loc2_ = _loc2_ + _loc10_.width;
               if(_loc8_ > 0)
               {
                  _loc2_ = _loc2_ + this._gap;
               }
            }
            if(_loc12_ && !isNaN(_loc10_.height))
            {
               _loc6_ = _loc10_.height;
               if(_loc6_ > _loc1_)
               {
                  _loc1_ = _loc6_;
               }
            }
            _loc8_++;
         }
         var _loc7_:int = this._centerItems?this._centerItems.length:0;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc10_ = this._centerItems[_loc8_];
            if(_loc10_ is IValidating)
            {
               IValidating(_loc10_).validate();
            }
            if(_loc9_ && !isNaN(_loc10_.width))
            {
               _loc2_ = _loc2_ + _loc10_.width;
               if(_loc8_ > 0)
               {
                  _loc2_ = _loc2_ + this._gap;
               }
            }
            if(_loc12_ && !isNaN(_loc10_.height))
            {
               _loc6_ = _loc10_.height;
               if(_loc6_ > _loc1_)
               {
                  _loc1_ = _loc6_;
               }
            }
            _loc8_++;
         }
         var _loc5_:int = this._rightItems?this._rightItems.length:0;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc10_ = this._rightItems[_loc8_];
            if(_loc10_ is IValidating)
            {
               IValidating(_loc10_).validate();
            }
            if(_loc9_ && !isNaN(_loc10_.width))
            {
               _loc2_ = _loc2_ + _loc10_.width;
               if(_loc8_ > 0)
               {
                  _loc2_ = _loc2_ + this._gap;
               }
            }
            if(_loc12_ && !isNaN(_loc10_.height))
            {
               _loc6_ = _loc10_.height;
               if(_loc6_ > _loc1_)
               {
                  _loc1_ = _loc6_;
               }
            }
            _loc8_++;
         }
         _loc3_ = _loc3_ + _loc2_;
         if(this._title && !(this._titleAlign == "center" && this._centerItems))
         {
            _loc15_ = isNaN(this._titleGap)?this._gap:this._titleGap;
            _loc3_ = _loc3_ + 2 * _loc15_;
            _loc14_ = (_loc9_?this._maxWidth:this.explicitWidth) - _loc2_;
            if(_loc11_ > 0)
            {
               _loc14_ = _loc14_ - _loc15_;
            }
            if(_loc7_ > 0)
            {
               _loc14_ = _loc14_ - _loc15_;
            }
            if(_loc5_ > 0)
            {
               _loc14_ = _loc14_ - _loc15_;
            }
            this.titleTextRenderer.maxWidth = _loc14_;
            this.titleTextRenderer.measureText(HELPER_POINT);
            _loc13_ = HELPER_POINT.x;
            _loc4_ = HELPER_POINT.y;
            if(_loc9_ && !isNaN(_loc13_))
            {
               _loc3_ = _loc3_ + _loc13_;
               if(_loc11_ > 0)
               {
                  _loc3_ = _loc3_ + _loc15_;
               }
               if(_loc5_ > 0)
               {
                  _loc3_ = _loc3_ + _loc15_;
               }
            }
            if(_loc12_ && !isNaN(_loc4_))
            {
               if(_loc4_ > _loc1_)
               {
                  _loc1_ = _loc4_;
               }
            }
         }
         if(_loc12_)
         {
            _loc1_ = _loc1_ + (this._paddingTop + this._paddingBottom);
         }
         if(_loc9_ && !isNaN(this.originalBackgroundWidth))
         {
            if(this.originalBackgroundWidth > _loc3_)
            {
               _loc3_ = this.originalBackgroundWidth;
            }
         }
         if(_loc12_ && !isNaN(this.originalBackgroundHeight))
         {
            if(this.originalBackgroundHeight > _loc1_)
            {
               _loc1_ = this.originalBackgroundHeight;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createTitle() : void
      {
         if(this.titleTextRenderer)
         {
            this.removeChild(DisplayObject(this.titleTextRenderer),true);
            this.titleTextRenderer = null;
         }
         var _loc1_:Function = this._titleFactory != null?this._titleFactory:FeathersControl.defaultTextRendererFactory;
         this.titleTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:IFeathersControl = IFeathersControl(this.titleTextRenderer);
         _loc2_.nameList.add(this.titleName);
         _loc2_.touchable = false;
         this.addChild(DisplayObject(_loc2_));
      }
      
      protected function refreshBackground() : void
      {
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin)
         {
            if(this._backgroundSkin)
            {
               this._backgroundSkin.visible = false;
            }
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else if(this._backgroundDisabledSkin)
         {
            this._backgroundDisabledSkin.visible = false;
         }
         if(this.currentBackgroundSkin)
         {
            this.currentBackgroundSkin.visible = true;
            if(isNaN(this.originalBackgroundWidth))
            {
               this.originalBackgroundWidth = this.currentBackgroundSkin.width;
            }
            if(isNaN(this.originalBackgroundHeight))
            {
               this.originalBackgroundHeight = this.currentBackgroundSkin.height;
            }
         }
      }
      
      protected function refreshLayout() : void
      {
         this._layout.gap = this._gap;
         this._layout.paddingTop = this._paddingTop;
         this._layout.paddingBottom = this._paddingBottom;
         this._layout.verticalAlign = this._verticalAlign;
      }
      
      protected function refreshTitleStyles() : void
      {
         var _loc2_:* = null;
         var _loc3_:DisplayObject = DisplayObject(this.titleTextRenderer);
         var _loc5_:* = 0;
         var _loc4_:* = this._titleProperties;
         for(var _loc1_ in this._titleProperties)
         {
            if(_loc3_.hasOwnProperty(_loc1_))
            {
               _loc2_ = this._titleProperties[_loc1_];
               _loc3_[_loc1_] = _loc2_;
            }
         }
      }
      
      protected function layoutBackground() : void
      {
         if(!this.currentBackgroundSkin)
         {
            return;
         }
         this.currentBackgroundSkin.width = this.actualWidth;
         this.currentBackgroundSkin.height = this.actualHeight;
      }
      
      protected function layoutLeftItems() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = this._leftItems;
         for each(var _loc1_ in this._leftItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         _loc3_ = 0;
         HELPER_BOUNDS.y = _loc3_;
         HELPER_BOUNDS.x = _loc3_;
         _loc2_ = 0;
         HELPER_BOUNDS.scrollY = _loc2_;
         HELPER_BOUNDS.scrollX = _loc2_;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "left";
         this._layout.paddingRight = 0;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._leftItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(isNaN(this.leftItemsWidth))
         {
            this.leftItemsWidth = 0;
         }
      }
      
      protected function layoutRightItems() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = this._rightItems;
         for each(var _loc1_ in this._rightItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         _loc3_ = 0;
         HELPER_BOUNDS.y = _loc3_;
         HELPER_BOUNDS.x = _loc3_;
         _loc2_ = 0;
         HELPER_BOUNDS.scrollY = _loc2_;
         HELPER_BOUNDS.scrollX = _loc2_;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "right";
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = 0;
         this._layout.layout(this._rightItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(isNaN(this.rightItemsWidth))
         {
            this.rightItemsWidth = 0;
         }
      }
      
      protected function layoutCenterItems() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = this._centerItems;
         for each(var _loc1_ in this._centerItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         _loc3_ = 0;
         HELPER_BOUNDS.y = _loc3_;
         HELPER_BOUNDS.x = _loc3_;
         _loc2_ = 0;
         HELPER_BOUNDS.scrollY = _loc2_;
         HELPER_BOUNDS.scrollX = _loc2_;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "center";
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._centerItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
      }
      
      protected function layoutTitle() : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:* = NaN;
         if(this._titleAlign == "center" && this._centerItems || this._title.length == 0)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         this.titleTextRenderer.visible = true;
         var _loc6_:Number = isNaN(this._titleGap)?this._gap:this._titleGap;
         var _loc5_:Number = this._leftItems && this._leftItems.length > 0?this.leftItemsWidth + _loc6_:0.0;
         var _loc1_:Number = this._rightItems && this._rightItems.length > 0?this.rightItemsWidth + _loc6_:0.0;
         if(this._titleAlign == "preferLeft" && (!this._leftItems || this._leftItems.length == 0))
         {
            this.titleTextRenderer.maxWidth = this.actualWidth - this._paddingLeft - _loc1_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = this._paddingLeft;
         }
         else if(this._titleAlign == "preferRight" && (!this._rightItems || this._rightItems.length == 0))
         {
            this.titleTextRenderer.maxWidth = this.actualWidth - this._paddingRight - _loc5_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = this.actualWidth - this._paddingRight - this.titleTextRenderer.width;
         }
         else
         {
            _loc3_ = this.actualWidth - this._paddingLeft - this._paddingRight;
            _loc4_ = this.actualWidth - _loc5_ - _loc1_;
            this.titleTextRenderer.maxWidth = _loc4_;
            this.titleTextRenderer.validate();
            _loc2_ = this._paddingLeft + (_loc3_ - this.titleTextRenderer.width) / 2;
            if(_loc5_ > _loc2_ || _loc2_ + this.titleTextRenderer.width > this.actualWidth - _loc1_)
            {
               this.titleTextRenderer.x = _loc5_ + (_loc4_ - this.titleTextRenderer.width) / 2;
            }
            else
            {
               this.titleTextRenderer.x = _loc2_;
            }
         }
         if(this._verticalAlign == "top")
         {
            this.titleTextRenderer.y = this._paddingTop;
         }
         else if(this._verticalAlign == "bottom")
         {
            this.titleTextRenderer.y = this.actualHeight - this._paddingBottom - this.titleTextRenderer.height;
         }
         else
         {
            this.titleTextRenderer.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.titleTextRenderer.height) / 2;
         }
      }
      
      protected function titleProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function item_resizeHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
   }
}
