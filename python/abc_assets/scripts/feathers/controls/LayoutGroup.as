package feathers.controls
{
   import feathers.core.FeathersControl;
   import starling.display.DisplayObject;
   import feathers.layout.ViewPortBounds;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ILayout;
   import feathers.layout.IVirtualLayout;
   import feathers.core.IFeathersControl;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.core.IValidating;
   import flash.geom.Rectangle;
   import starling.events.Event;
   
   public class LayoutGroup extends FeathersControl
   {
      
      protected static const INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
       
      protected var items:Vector.<DisplayObject>;
      
      protected var viewPortBounds:ViewPortBounds;
      
      protected var _layoutResult:LayoutBoundsResult;
      
      protected var _layout:ILayout;
      
      protected var _mxmlContentIsReady:Boolean = false;
      
      protected var _mxmlContent:Array;
      
      protected var _clipContent:Boolean = false;
      
      protected var _ignoreChildChanges:Boolean = false;
      
      public function LayoutGroup()
      {
         items = new Vector.<DisplayObject>(0);
         viewPortBounds = new ViewPortBounds();
         _layoutResult = new LayoutBoundsResult();
         super();
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener("change",layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this._layout.addEventListener("change",layout_changeHandler);
            this.invalidate("layout");
         }
         this.invalidate("layout");
      }
      
      public function get mxmlContent() : Array
      {
         return this._mxmlContent;
      }
      
      public function set mxmlContent(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         if(this._mxmlContent == param1)
         {
            return;
         }
         if(this._mxmlContent && this._mxmlContentIsReady)
         {
            _loc3_ = this._mxmlContent.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = DisplayObject(this._mxmlContent[_loc4_]);
               this.removeChild(_loc2_,true);
               _loc4_++;
            }
         }
         this._mxmlContent = param1;
         this._mxmlContentIsReady = false;
         this.invalidate("mxmlContent");
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         this.invalidate("clipping");
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(param1 is IFeathersControl)
         {
            param1.addEventListener("resize",child_resizeHandler);
         }
         if(param1 is ILayoutDisplayObject)
         {
            param1.addEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return param1;
         }
         if(_loc3_ >= 0)
         {
            this.items.splice(_loc3_,1);
         }
         var _loc4_:int = this.items.length;
         if(param2 == _loc4_)
         {
            this.items[param2] = param1;
         }
         else
         {
            this.items.splice(param2,0,param1);
         }
         this.invalidate("layout");
         return super.addChildAt(param1,param2);
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:DisplayObject = super.removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener("resize",child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         this.items.splice(param1,1);
         this.invalidate("layout");
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return;
         }
         this.items.splice(_loc3_,1);
         this.items.splice(param2,0,param1);
         this.invalidate("layout");
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         super.swapChildrenAt(param1,param2);
         var _loc3_:DisplayObject = this.items[param1];
         var _loc4_:DisplayObject = this.items[param2];
         this.items[param1] = _loc4_;
         this.items[param2] = _loc3_;
         this.invalidate("layout");
      }
      
      override public function sortChildren(param1:Function) : void
      {
         super.sortChildren(param1);
         this.items.sort(param1);
         this.invalidate("layout");
      }
      
      override public function dispose() : void
      {
         this.layout = null;
         super.dispose();
      }
      
      public function readjustLayout() : void
      {
         this.invalidate("layout");
      }
      
      override protected function initialize() : void
      {
         this.refreshMXMLContent();
      }
      
      override protected function draw() : void
      {
         var _loc4_:Boolean = this.isInvalid("layout");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc3_:Boolean = this.isInvalid("clipping");
         var _loc1_:Boolean = this.isInvalid("scroll");
         if(!_loc4_ && _loc1_ && this._layout && this._layout.requiresLayoutOnScroll)
         {
            _loc4_ = true;
         }
         if(_loc2_ || _loc4_)
         {
            this.refreshViewPortBounds();
            if(this._layout)
            {
               this._ignoreChildChanges = true;
               this._layout.layout(this.items,this.viewPortBounds,this._layoutResult);
               this._ignoreChildChanges = false;
               _loc2_ = this.setSizeInternal(this._layoutResult.contentWidth,this._layoutResult.contentHeight,false) || _loc2_;
            }
            else
            {
               _loc2_ = this.handleManualLayout() || _loc2_;
            }
            this.validateChildren();
         }
         if(_loc2_ || _loc3_)
         {
            this.refreshClipRect();
         }
      }
      
      protected function refreshViewPortBounds() : void
      {
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = 0;
         this.viewPortBounds.scrollY = 0;
         this.viewPortBounds.explicitWidth = this.explicitWidth;
         this.viewPortBounds.explicitHeight = this.explicitHeight;
         this.viewPortBounds.minWidth = this._minWidth;
         this.viewPortBounds.minHeight = this._minHeight;
         this.viewPortBounds.maxWidth = this._maxWidth;
         this.viewPortBounds.maxHeight = this._maxHeight;
      }
      
      protected function handleManualLayout() : Boolean
      {
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = NaN;
         var _loc1_:* = NaN;
         var _loc5_:Number = isNaN(this.viewPortBounds.explicitWidth)?0:this.viewPortBounds.explicitWidth;
         var _loc4_:Number = isNaN(this.viewPortBounds.explicitHeight)?0:this.viewPortBounds.explicitHeight;
         this._ignoreChildChanges = true;
         var _loc6_:int = this.items.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = this.items[_loc7_];
            if(_loc2_ is IValidating)
            {
               IValidating(_loc2_).validate();
            }
            _loc3_ = _loc2_.x + _loc2_.width;
            _loc1_ = _loc2_.y + _loc2_.height;
            if(!isNaN(_loc3_) && _loc3_ > _loc5_)
            {
               _loc5_ = _loc3_;
            }
            if(!isNaN(_loc1_) && _loc1_ > _loc4_)
            {
               _loc4_ = _loc1_;
            }
            _loc7_++;
         }
         this._ignoreChildChanges = false;
         return this.setSizeInternal(_loc5_,_loc4_,false);
      }
      
      protected function validateChildren() : void
      {
         var _loc3_:* = 0;
         var _loc1_:* = null;
         var _loc2_:int = this.items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.items[_loc3_];
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
            _loc3_++;
         }
      }
      
      protected function refreshMXMLContent() : void
      {
         var _loc3_:* = 0;
         var _loc1_:* = null;
         if(!this._mxmlContent || this._mxmlContentIsReady)
         {
            return;
         }
         var _loc2_:int = this._mxmlContent.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = DisplayObject(this._mxmlContent[_loc3_]);
            this.addChild(_loc1_);
            _loc3_++;
         }
         this._mxmlContentIsReady = true;
      }
      
      protected function refreshClipRect() : void
      {
         var _loc1_:* = null;
         if(this._clipContent)
         {
            if(!this.clipRect)
            {
               this.clipRect = new Rectangle();
            }
            _loc1_ = this.clipRect;
            _loc1_.x = 0;
            _loc1_.y = 0;
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
            this.clipRect = _loc1_;
         }
         else
         {
            this.clipRect = null;
         }
      }
      
      protected function layout_changeHandler(param1:Event) : void
      {
         this.invalidate("layout");
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("layout");
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("layout");
      }
   }
}
