package lzm.starling.display
{
   import lzm.starling.gestures.TapGestures;
   
   public class ContentList extends ScrollContainer
   {
       
      private var _items:Vector.<lzm.starling.display.ContentListItem>;
      
      private var __itemCount:int = 0;
      
      private var _contentTitleHeight:int;
      
      private var _contentHeight:int;
      
      private var _currentIndex:int = -1;
      
      public function ContentList(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this.width = param1;
         this.height = param2;
         _contentTitleHeight = param3;
         _contentHeight = param4;
         _items = new Vector.<lzm.starling.display.ContentListItem>();
      }
      
      public function addContentListItem(param1:lzm.starling.display.ContentListItem) : void
      {
         param1.index = __itemCount;
         param1.normalY = __itemCount * (_contentTitleHeight + 3);
         param1.otherOpenY = param1.normalY + this._contentHeight;
         param1.content.width = this.width;
         param1.content.height = this._contentHeight;
         new TapGestures(param1,change(param1.index));
         if(_currentIndex != -1 && _currentIndex > __itemCount)
         {
            param1.y = param1.otherOpenY;
         }
         else
         {
            param1.y = param1.normalY;
         }
         addChild(param1);
         _items.push(param1);
         __itemCount = __itemCount + 1;
      }
      
      public function set currentIndex(param1:int) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         if(_currentIndex != -1)
         {
            _items[_currentIndex].content.removeFromParent();
         }
         _currentIndex = param1 == _currentIndex?-1:param1;
         var _loc2_:int = _items.length;
         _loc4_ = 0;
         while(_loc4_ < __itemCount)
         {
            _loc3_ = _items[_loc4_];
            if(_currentIndex == -1)
            {
               _loc3_.y = _loc3_.normalY;
            }
            else if(_loc4_ < _currentIndex)
            {
               _loc3_.y = _loc3_.normalY;
            }
            else if(_loc4_ > _currentIndex)
            {
               _loc3_.y = _loc3_.otherOpenY;
            }
            else
            {
               _loc3_.y = _loc3_.normalY;
               _loc3_.content.alpha = 1;
               _loc3_.content.y = _loc3_.y + _contentTitleHeight;
               addChildAt(_loc3_.content,0);
            }
            _loc4_++;
         }
      }
      
      private function change(param1:int) : Function
      {
         index = param1;
         return function():void
         {
            currentIndex = index;
         };
      }
      
      public function get currentIndex() : int
      {
         return _currentIndex;
      }
   }
}
