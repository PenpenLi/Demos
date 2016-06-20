package lzm.starling.display
{
   import starling.display.Sprite;
   import flash.geom.Rectangle;
   import starling.events.Event;
   import starling.display.DisplayObject;
   
   public class ScrollContainerItem extends Sprite
   {
       
      var _viewPort:Rectangle;
      
      var _isInView:Boolean = false;
      
      var _scrollContainer:ScrollContainer;
      
      public function ScrollContainerItem()
      {
         super();
         _viewPort = new Rectangle();
         addEventListener("addedToStage",addToStage);
      }
      
      protected function addToStage(param1:Event) : void
      {
         var _loc2_:Rectangle = getBounds(parent);
         _viewPort.width = _loc2_.width;
         _viewPort.height = _loc2_.height;
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         super.addChildAt(param1,param2);
         if(parent)
         {
            addToStage(null);
         }
         return param1;
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:DisplayObject = super.removeChildAt(param1,param2);
         if(parent)
         {
            addToStage(null);
         }
         return _loc3_;
      }
      
      override public function set x(param1:Number) : void
      {
         .super.x = param1;
         _viewPort.x = param1;
         if(_scrollContainer)
         {
            _scrollContainer.updateShowItems();
         }
      }
      
      override public function set y(param1:Number) : void
      {
         .super.y = param1;
         _viewPort.y = param1;
         if(_scrollContainer)
         {
            _scrollContainer.updateShowItems();
         }
      }
      
      public function inView() : void
      {
      }
      
      public function outView() : void
      {
      }
      
      public function get isInView() : Boolean
      {
         return _isInView;
      }
      
      public function get scrollContainer() : ScrollContainer
      {
         return _scrollContainer;
      }
      
      override public function dispose() : void
      {
         _scrollContainer = null;
         super.dispose();
      }
   }
}
