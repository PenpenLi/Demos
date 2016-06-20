package lzm.starling.entityComponent
{
   import starling.events.EnterFrameEvent;
   
   public class EntityWorld extends Entity
   {
       
      public function EntityWorld()
      {
         super();
      }
      
      protected function enterFrame(param1:EnterFrameEvent) : void
      {
         update();
      }
      
      public function start() : void
      {
         addEventListener("enterFrame",enterFrame);
      }
      
      public function stop() : void
      {
         removeEventListener("enterFrame",enterFrame);
      }
      
      override public function dispose() : void
      {
         stop();
         super.dispose();
      }
   }
}
