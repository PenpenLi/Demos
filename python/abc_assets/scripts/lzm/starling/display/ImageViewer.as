package lzm.starling.display
{
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import lzm.util.DoScale;
   import feathers.layout.HorizontalLayout;
   import lzm.starling.gestures.MoveOverGestures;
   
   public class ImageViewer extends ScrollContainer
   {
       
      private var _tempHorizontalPosition:Number = 0;
      
      private var _tempIndex:int = 0;
      
      public function ImageViewer(param1:Number, param2:Number)
      {
         super();
         this.width = param1;
         this.height = param2;
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.gap = 0;
         this.layout = _loc3_;
         this.scrollBarDisplayMode = "none";
      }
      
      private function stopMove() : void
      {
         stopScrolling();
         if(_tempHorizontalPosition > horizontalScrollPosition)
         {
            _tempIndex = _tempIndex - 1;
         }
         else if(_tempHorizontalPosition < horizontalScrollPosition)
         {
            _tempIndex = _tempIndex + 1;
         }
         var _loc1_:int = maxHorizontalScrollPosition / width;
         _tempIndex = _tempIndex < 0?0:_tempIndex;
         _tempIndex = _tempIndex > _loc1_?_loc1_:_tempIndex;
         _tempHorizontalPosition = _tempIndex * width;
         Starling.juggler.tween(this,0.1,{"horizontalScrollPosition":_tempHorizontalPosition});
      }
      
      public function addImage(param1:DisplayObject) : void
      {
         var _loc3_:Object = DoScale.doScale(param1.width,param1.height,width,height);
         param1.scaleX = _loc3_.sx;
         param1.scaleY = _loc3_.sy;
         var _loc2_:ScrollContainerItem = new ScrollContainerItem();
         _loc2_.addChild(param1);
         addScrollContainerItem(_loc2_);
      }
   }
}
