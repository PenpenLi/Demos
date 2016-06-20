package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.geom.Point;
   import starling.display.Quad;
   import starling.display.DisplayObject;
   import feathers.layout.ILayout;
   import feathers.core.IValidating;
   import feathers.layout.VerticalLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.HorizontalLayout;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class PageIndicator extends FeathersControl
   {
      
      private static const LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      private static const SUGGESTED_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
       
      protected var selectedSymbol:DisplayObject;
      
      protected var cache:Vector.<DisplayObject>;
      
      protected var unselectedSymbols:Vector.<DisplayObject>;
      
      protected var symbols:Vector.<DisplayObject>;
      
      protected var touchPointID:int = -1;
      
      protected var _pageCount:int = 1;
      
      protected var _selectedIndex:int = 0;
      
      protected var _layout:ILayout;
      
      protected var _direction:String = "horizontal";
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _normalSymbolFactory:Function;
      
      protected var _selectedSymbolFactory:Function;
      
      public function PageIndicator()
      {
         cache = new Vector.<DisplayObject>(0);
         unselectedSymbols = new Vector.<DisplayObject>(0);
         symbols = new Vector.<DisplayObject>(0);
         _normalSymbolFactory = defaultNormalSymbolFactory;
         _selectedSymbolFactory = defaultSelectedSymbolFactory;
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("touch",touchHandler);
      }
      
      protected static function defaultSelectedSymbolFactory() : Quad
      {
         return new Quad(25,25,16777215);
      }
      
      protected static function defaultNormalSymbolFactory() : Quad
      {
         return new Quad(25,25,13421772);
      }
      
      public function get pageCount() : int
      {
         return this._pageCount;
      }
      
      public function set pageCount(param1:int) : void
      {
         if(this._pageCount == param1)
         {
            return;
         }
         this._pageCount = param1;
         this.invalidate("data");
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var param1:int = Math.max(0,Math.min(param1,this._pageCount - 1));
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
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
         this.invalidate("layout");
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
         this.invalidate("layout");
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
         this.invalidate("layout");
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
      
      public function get normalSymbolFactory() : Function
      {
         return this._normalSymbolFactory;
      }
      
      public function set normalSymbolFactory(param1:Function) : void
      {
         if(this._normalSymbolFactory == param1)
         {
            return;
         }
         this._normalSymbolFactory = param1;
         this.invalidate("styles");
      }
      
      public function get selectedSymbolFactory() : Function
      {
         return this._selectedSymbolFactory;
      }
      
      public function set selectedSymbolFactory(param1:Function) : void
      {
         if(this._selectedSymbolFactory == param1)
         {
            return;
         }
         this._selectedSymbolFactory = param1;
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("layout");
         if(_loc2_ || _loc1_ || _loc3_)
         {
            this.refreshSymbols(_loc3_);
         }
         this.layoutSymbols(_loc4_);
      }
      
      protected function refreshSymbols(param1:Boolean) : void
      {
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         this.symbols.length = 0;
         var _loc4_:Vector.<DisplayObject> = this.cache;
         if(param1)
         {
            _loc2_ = this.unselectedSymbols.length;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc3_ = this.unselectedSymbols.shift();
               this.removeChild(_loc3_,true);
               _loc5_++;
            }
            if(this.selectedSymbol)
            {
               this.removeChild(this.selectedSymbol,true);
               this.selectedSymbol = null;
            }
         }
         this.cache = this.unselectedSymbols;
         this.unselectedSymbols = _loc4_;
         _loc5_ = 0;
         while(_loc5_ < this._pageCount)
         {
            if(_loc5_ == this._selectedIndex)
            {
               if(!this.selectedSymbol)
               {
                  this.selectedSymbol = this._selectedSymbolFactory();
                  this.addChild(this.selectedSymbol);
               }
               this.symbols.push(this.selectedSymbol);
               if(this.selectedSymbol is IValidating)
               {
                  IValidating(this.selectedSymbol).validate();
               }
            }
            else
            {
               if(this.cache.length > 0)
               {
                  _loc3_ = this.cache.shift();
               }
               else
               {
                  _loc3_ = this._normalSymbolFactory();
                  this.addChild(_loc3_);
               }
               this.unselectedSymbols.push(_loc3_);
               this.symbols.push(_loc3_);
               if(_loc3_ is IValidating)
               {
                  IValidating(_loc3_).validate();
               }
            }
            _loc5_++;
         }
         _loc2_ = this.cache.length;
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = this.cache.shift();
            this.removeChild(_loc3_,true);
            _loc5_++;
         }
      }
      
      protected function layoutSymbols(param1:Boolean) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1)
         {
            if(this._direction == "vertical" && !(this._layout is VerticalLayout))
            {
               this._layout = new VerticalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            else if(this._direction != "vertical" && !(this._layout is HorizontalLayout))
            {
               this._layout = new HorizontalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            if(this._layout is VerticalLayout)
            {
               _loc2_ = VerticalLayout(this._layout);
               _loc2_.paddingTop = this._paddingTop;
               _loc2_.paddingRight = this._paddingRight;
               _loc2_.paddingBottom = this._paddingBottom;
               _loc2_.paddingLeft = this._paddingLeft;
               _loc2_.gap = this._gap;
               _loc2_.horizontalAlign = this._horizontalAlign;
               _loc2_.verticalAlign = this._verticalAlign;
            }
            if(this._layout is HorizontalLayout)
            {
               _loc3_ = HorizontalLayout(this._layout);
               _loc3_.paddingTop = this._paddingTop;
               _loc3_.paddingRight = this._paddingRight;
               _loc3_.paddingBottom = this._paddingBottom;
               _loc3_.paddingLeft = this._paddingLeft;
               _loc3_.gap = this._gap;
               _loc3_.horizontalAlign = this._horizontalAlign;
               _loc3_.verticalAlign = this._verticalAlign;
            }
         }
         var _loc4_:* = 0;
         SUGGESTED_BOUNDS.y = _loc4_;
         SUGGESTED_BOUNDS.x = _loc4_;
         _loc4_ = 0;
         SUGGESTED_BOUNDS.scrollY = _loc4_;
         SUGGESTED_BOUNDS.scrollX = _loc4_;
         SUGGESTED_BOUNDS.explicitWidth = this.explicitWidth;
         SUGGESTED_BOUNDS.explicitHeight = this.explicitHeight;
         SUGGESTED_BOUNDS.maxWidth = this._maxWidth;
         SUGGESTED_BOUNDS.maxHeight = this._maxHeight;
         SUGGESTED_BOUNDS.minWidth = this._minWidth;
         SUGGESTED_BOUNDS.minHeight = this._minHeight;
         this._layout.layout(this.symbols,SUGGESTED_BOUNDS,LAYOUT_RESULT);
         this.setSizeInternal(LAYOUT_RESULT.contentWidth,LAYOUT_RESULT.contentHeight,false);
      }
      
      protected function touchHandler(param1:TouchEvent) : void
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
            _loc2_ = param1.getTouch(this,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            _loc2_.getLocation(this.stage,HELPER_POINT);
            _loc3_ = this.contains(this.stage.hitTest(HELPER_POINT,true));
            if(_loc3_)
            {
               this.globalToLocal(HELPER_POINT,HELPER_POINT);
               if(this._direction == "vertical")
               {
                  if(HELPER_POINT.y < this.selectedSymbol.y)
                  {
                     this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                  }
                  if(HELPER_POINT.y > this.selectedSymbol.y + this.selectedSymbol.height)
                  {
                     this.selectedIndex = Math.min(this._pageCount - 1,this._selectedIndex + 1);
                  }
               }
               else
               {
                  if(HELPER_POINT.x < this.selectedSymbol.x)
                  {
                     this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                  }
                  if(HELPER_POINT.x > this.selectedSymbol.x + this.selectedSymbol.width)
                  {
                     this.selectedIndex = Math.min(this._pageCount - 1,this._selectedIndex + 1);
                  }
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
         }
      }
   }
}
