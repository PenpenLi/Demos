package feathers.controls.supportClasses
{
   import feathers.controls.LayoutGroup;
   import starling.display.DisplayObject;
   import feathers.core.IValidating;
   
   public class LayoutViewPort extends LayoutGroup implements IViewPort
   {
       
      private var _minVisibleWidth:Number = 0;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _visibleWidth:Number = NaN;
      
      private var _minVisibleHeight:Number = 0;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _visibleHeight:Number = NaN;
      
      private var _contentX:Number = 0;
      
      private var _contentY:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      public function LayoutViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         return this._minVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._minVisibleWidth == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("minVisibleWidth cannot be NaN");
         }
         this._minVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         this._maxVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get visibleWidth() : Number
      {
         return this._visibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._visibleWidth == param1 || isNaN(param1) && isNaN(this._visibleWidth))
         {
            return;
         }
         this._visibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get minVisibleHeight() : Number
      {
         return this._minVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._minVisibleHeight == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("minVisibleHeight cannot be NaN");
         }
         this._minVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         this._maxVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get visibleHeight() : Number
      {
         return this._visibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._visibleHeight == param1 || isNaN(param1) && isNaN(this._visibleHeight))
         {
            return;
         }
         this._visibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         return Math.min(this.actualWidth,this.actualHeight) / 10;
      }
      
      public function get verticalScrollStep() : Number
      {
         return Math.min(this.actualWidth,this.actualHeight) / 10;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      override public function dispose() : void
      {
         this.layout = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("layout");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc1_:Boolean = this.isInvalid("scroll");
         super.draw();
         if(_loc1_ || _loc2_ || _loc3_)
         {
            if(this._layout)
            {
               this._contentX = this._layoutResult.contentX;
               this._contentY = this._layoutResult.contentY;
            }
         }
      }
      
      override protected function refreshViewPortBounds() : void
      {
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = this._horizontalScrollPosition;
         this.viewPortBounds.scrollY = this._verticalScrollPosition;
         this.viewPortBounds.explicitWidth = this._visibleWidth;
         this.viewPortBounds.explicitHeight = this._visibleHeight;
         this.viewPortBounds.minWidth = this._minVisibleWidth;
         this.viewPortBounds.minHeight = this._minVisibleHeight;
         this.viewPortBounds.maxWidth = this._maxVisibleWidth;
         this.viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      override protected function handleManualLayout() : Boolean
      {
         var _loc7_:* = 0;
         var _loc13_:* = null;
         var _loc11_:* = NaN;
         var _loc9_:* = NaN;
         var _loc16_:* = NaN;
         var _loc12_:* = NaN;
         var _loc5_:* = 0.0;
         var _loc6_:* = 0.0;
         var _loc4_:Number = isNaN(this.viewPortBounds.explicitWidth)?0:this.viewPortBounds.explicitWidth;
         var _loc3_:Number = isNaN(this.viewPortBounds.explicitHeight)?0:this.viewPortBounds.explicitHeight;
         this._ignoreChildChanges = true;
         var _loc17_:int = this.items.length;
         _loc7_ = 0;
         while(_loc7_ < _loc17_)
         {
            _loc13_ = this.items[_loc7_];
            if(_loc13_ is IValidating)
            {
               IValidating(_loc13_).validate();
            }
            _loc11_ = _loc13_.x;
            _loc9_ = _loc13_.y;
            _loc16_ = _loc11_ + _loc13_.width;
            _loc12_ = _loc9_ + _loc13_.height;
            if(!isNaN(_loc11_) && _loc11_ < _loc5_)
            {
               _loc5_ = _loc11_;
            }
            if(!isNaN(_loc9_) && _loc9_ < _loc6_)
            {
               _loc6_ = _loc9_;
            }
            if(!isNaN(_loc16_) && _loc16_ > _loc4_)
            {
               _loc4_ = _loc16_;
            }
            if(!isNaN(_loc12_) && _loc12_ > _loc3_)
            {
               _loc3_ = _loc12_;
            }
            _loc7_++;
         }
         this._contentX = _loc5_;
         this._contentY = _loc6_;
         var _loc1_:Number = this.viewPortBounds.minWidth;
         var _loc15_:Number = this.viewPortBounds.maxWidth;
         var _loc8_:Number = this.viewPortBounds.minHeight;
         var _loc14_:Number = this.viewPortBounds.maxHeight;
         var _loc10_:* = _loc4_;
         if(_loc10_ < _loc1_)
         {
            _loc10_ = _loc1_;
         }
         else if(_loc10_ > _loc15_)
         {
            _loc10_ = _loc15_;
         }
         var _loc2_:* = _loc3_;
         if(_loc2_ < _loc8_)
         {
            _loc2_ = _loc8_;
         }
         else if(_loc2_ > _loc14_)
         {
            _loc2_ = _loc14_;
         }
         this._ignoreChildChanges = false;
         return this.setSizeInternal(_loc10_,_loc2_,false);
      }
   }
}
