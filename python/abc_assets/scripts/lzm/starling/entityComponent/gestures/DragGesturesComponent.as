package lzm.starling.entityComponent.gestures
{
   import lzm.starling.entityComponent.EntityComponent;
   import lzm.starling.gestures.DragGestures;
   
   public class DragGesturesComponent extends EntityComponent
   {
       
      private var _dragGestures:DragGestures;
      
      public function DragGesturesComponent()
      {
         super();
      }
      
      override public function start() : void
      {
         _dragGestures = new DragGestures(entity);
      }
      
      override public function stop() : void
      {
         _dragGestures.dispose();
         _dragGestures = null;
      }
      
      override public function dispose() : void
      {
         if(_dragGestures)
         {
            _dragGestures.dispose();
         }
         super.dispose();
      }
      
      public function get gestures() : DragGestures
      {
         return _dragGestures;
      }
   }
}
