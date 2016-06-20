package lzm.starling.entityComponent
{
   import starling.events.EventDispatcher;
   
   public class EntityComponent extends EventDispatcher
   {
       
      var _entity:Entity;
      
      public var name:String;
      
      public function EntityComponent()
      {
         super();
      }
      
      public function get entity() : Entity
      {
         return _entity;
      }
      
      public function start() : void
      {
      }
      
      public function update() : void
      {
      }
      
      public function stop() : void
      {
      }
      
      public function dispose() : void
      {
         _entity = null;
         removeEventListeners();
      }
   }
}
