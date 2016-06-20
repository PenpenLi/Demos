package lzm.starling.display
{
   import flash.geom.Rectangle;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import flash.geom.Point;
   import starling.events.Event;
   import lzm.util.CollisionUtils;
   import starling.display.DisplayObject;
   
   public class ScrollContainer extends feathers.controls.ScrollContainer
   {
       
      protected var _scrolling:Boolean = false;
      
      protected var _scrolled:Boolean = false;
      
      protected var _viewPort2:Rectangle;
      
      protected var _itemList:Vector.<lzm.starling.display.ScrollContainerItem>;
      
      protected var _itemCount:int = 0;
      
      public function ScrollContainer()
      {
         super();
         _viewPort2 = new Rectangle();
         _itemList = new Vector.<lzm.starling.display.ScrollContainerItem>();
         addEventListener("scroll",onScroll);
         addEventListener("scrollComplete",onScrollComplete);
         addEventListener("touch",onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc4_:Vector.<Touch> = param1.touches;
         var _loc6_:* = 0;
         var _loc5_:* = _loc4_;
         for each(var _loc3_ in _loc4_)
         {
            _loc2_ = _loc3_.getLocation(this);
            if(_loc3_.phase == "began")
            {
               _scrolled = false;
            }
            else if(_loc3_.phase == "moved")
            {
               if(_scrolled)
               {
                  _scrolling = true;
               }
            }
            else if(_loc3_.phase == "ended")
            {
            }
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         _scrolled = true;
         updateShowItems();
      }
      
      private function onScrollComplete(param1:Event) : void
      {
         _scrolling = false;
      }
      
      public function updateShowItems() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         var _loc3_:* = 0;
         _viewPort2.x = _horizontalScrollPosition;
         _viewPort2.y = _verticalScrollPosition;
         _viewPort2.width = width;
         _viewPort2.height = height;
         _loc3_ = 0;
         while(_loc3_ < _itemCount)
         {
            _loc1_ = _itemList[_loc3_];
            _loc2_ = _loc1_._viewPort;
            if(CollisionUtils.isIntersectingRect(_viewPort2,_loc2_))
            {
               if(!_loc1_._isInView)
               {
                  _loc1_.inView();
               }
               var _loc4_:* = true;
               _loc1_._isInView = _loc4_;
               _loc1_.visible = _loc4_;
            }
            else
            {
               if(_loc1_._isInView)
               {
                  _loc1_.outView();
               }
               _loc4_ = false;
               _loc1_._isInView = _loc4_;
               _loc1_.visible = _loc4_;
            }
            _loc3_++;
         }
      }
      
      public function addScrollContainerItem(param1:lzm.starling.display.ScrollContainerItem) : void
      {
         addChild(param1);
         _itemList.push(param1);
         _itemCount = _itemCount + 1;
         param1._scrollContainer = this;
      }
      
      public function removeScrollContainerItem(param1:lzm.starling.display.ScrollContainerItem, param2:Boolean = false) : void
      {
         var _loc3_:int = _itemList.indexOf(param1);
         if(_loc3_ != -1)
         {
            _itemList.splice(_loc3_,1);
            _itemCount = _itemCount - 1;
            param1.removeFromParent(param2);
            param1._scrollContainer = null;
         }
      }
      
      public function reset(param1:Boolean = false) : void
      {
         while(_itemList.length != 0)
         {
            removeScrollContainerItem(_itemList[0],param1);
         }
      }
      
      public function get scrolling() : Boolean
      {
         return _scrolling;
      }
      
      public function get inViewItem() : Vector.<lzm.starling.display.ScrollContainerItem>
      {
         var _loc1_:Vector.<lzm.starling.display.ScrollContainerItem> = new Vector.<lzm.starling.display.ScrollContainerItem>();
         var _loc4_:* = 0;
         var _loc3_:* = _itemList;
         for each(var _loc2_ in _itemList)
         {
            if(_loc2_.visible)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get items() : Vector.<DisplayObject>
      {
         var _loc2_:* = 0;
         var _loc1_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         _loc2_ = 0;
         while(_loc2_ < _itemCount)
         {
            _loc1_.push(_itemList[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
