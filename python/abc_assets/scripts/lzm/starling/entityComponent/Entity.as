package lzm.starling.entityComponent
{
   import starling.display.Sprite;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.DisplayObjectContainer;
   
   public class Entity extends Sprite
   {
       
      private var _parentEntity:lzm.starling.entityComponent.Entity;
      
      private var _childEntitys:Vector.<lzm.starling.entityComponent.Entity>;
      
      private var _components:Vector.<lzm.starling.entityComponent.EntityComponent>;
      
      protected var _color:uint;
      
      public function Entity()
      {
         super();
         _components = new Vector.<lzm.starling.entityComponent.EntityComponent>();
         _childEntitys = new Vector.<lzm.starling.entityComponent.Entity>();
      }
      
      public function update() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = _components;
         for each(var _loc1_ in _components)
         {
            _loc1_.update();
         }
         var _loc6_:* = 0;
         var _loc5_:* = _childEntitys;
         for each(var _loc2_ in _childEntitys)
         {
            if(_loc2_.visible)
            {
               _loc2_.update();
            }
         }
      }
      
      public function addChildEntity(param1:lzm.starling.entityComponent.Entity) : lzm.starling.entityComponent.Entity
      {
         addChildEntityAt(param1,numChildren);
         return param1;
      }
      
      public function addChildEntityAt(param1:lzm.starling.entityComponent.Entity, param2:int) : lzm.starling.entityComponent.Entity
      {
         if(param1._parentEntity)
         {
            if(param1._parentEntity == this)
            {
               return param1;
            }
            param1._parentEntity.removeChildEntity(param1);
         }
         param1._parentEntity = this;
         _childEntitys.push(param1);
         addChildAt(param1,param2);
         param1.onAddToParentEntity();
         return param1;
      }
      
      public function onAddToParentEntity() : void
      {
      }
      
      public function removeChildEntity(param1:lzm.starling.entityComponent.Entity) : lzm.starling.entityComponent.Entity
      {
         if(param1._parentEntity != this)
         {
            return param1;
         }
         param1._parentEntity = null;
         var _loc2_:int = _childEntitys.indexOf(param1);
         _childEntitys.splice(_loc2_,1);
         removeChild(param1);
         param1.onRemoveFromParentEntity();
         return param1;
      }
      
      public function onRemoveFromParentEntity() : void
      {
      }
      
      public function removeFromParentEntity() : lzm.starling.entityComponent.Entity
      {
         if(_parentEntity)
         {
            _parentEntity.removeChildEntity(this);
         }
         return this;
      }
      
      public function addComponentByType(param1:Class, param2:* = null) : lzm.starling.entityComponent.EntityComponent
      {
         var _loc3_:lzm.starling.entityComponent.EntityComponent = param2 == null?new param1():new param1(param2);
         return addComponent(_loc3_);
      }
      
      public function addComponent(param1:lzm.starling.entityComponent.EntityComponent) : lzm.starling.entityComponent.EntityComponent
      {
         if(param1._entity)
         {
            throw Error("组件已经被赋予了实体");
         }
         if(param1._entity == this)
         {
            return param1;
         }
         _components.push(param1);
         param1._entity = this;
         param1.start();
         return param1;
      }
      
      public function removeComponent(param1:lzm.starling.entityComponent.EntityComponent) : lzm.starling.entityComponent.EntityComponent
      {
         var _loc2_:int = _components.indexOf(param1);
         if(_loc2_ != -1)
         {
            param1.stop();
            _components.splice(_loc2_,1);
         }
         param1._entity = null;
         return param1;
      }
      
      public function clearComponent() : void
      {
         var _loc1_:* = null;
         var _loc3_:* = 0;
         var _loc2_:int = _components.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _components.pop();
            _loc1_.stop();
            _loc1_.dispose();
            _loc3_++;
         }
      }
      
      public function getComponentByType(param1:Class) : lzm.starling.entityComponent.EntityComponent
      {
         var _loc2_:lzm.starling.entityComponent.EntityComponent = null;
         var _loc3_:Vector.<lzm.starling.entityComponent.EntityComponent> = getComponentsByType(param1);
         if(_loc3_.length != 0)
         {
            _loc2_ = _loc3_[0];
         }
         return _loc2_;
      }
      
      public function getComponentsByType(param1:Class) : Vector.<lzm.starling.entityComponent.EntityComponent>
      {
         componentType = param1;
         var filteredComponents:Vector.<lzm.starling.entityComponent.EntityComponent> = _components.filter(function(param1:EntityComponent, param2:int, param3:Vector.<EntityComponent>):Boolean
         {
            return param1 is componentType;
         });
         return filteredComponents;
      }
      
      public function getComponentByName(param1:String) : lzm.starling.entityComponent.EntityComponent
      {
         name = param1;
         var component:lzm.starling.entityComponent.EntityComponent = null;
         var filteredComponents:Vector.<lzm.starling.entityComponent.EntityComponent> = _components.filter(function(param1:EntityComponent, param2:int, param3:Vector.<EntityComponent>):Boolean
         {
            return param1.name == name;
         });
         if(filteredComponents.length != 0)
         {
            component = filteredComponents[0];
         }
         return component;
      }
      
      public function get parentEntity() : lzm.starling.entityComponent.Entity
      {
         return _parentEntity;
      }
      
      public function get childEntitys() : Vector.<lzm.starling.entityComponent.Entity>
      {
         return _childEntitys;
      }
      
      override public function dispose() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = _components;
         for each(var _loc1_ in _components)
         {
            removeComponent(_loc1_).dispose();
         }
         _components = null;
         var _loc6_:* = 0;
         var _loc5_:* = _childEntitys;
         for each(var _loc2_ in _childEntitys)
         {
            _loc2_.removeFromParentEntity();
            _loc2_.dispose();
         }
         _childEntitys = null;
         removeFromParentEntity();
         super.dispose();
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         setDisplayColor(this,_color);
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      protected function setDisplayColor(param1:DisplayObject, param2:uint) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         if(param1 is Image)
         {
            (param1 as Image).color = param2;
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc4_ = param1 as DisplayObjectContainer;
            _loc3_ = _loc4_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               var param1:DisplayObject = _loc4_.getChildAt(_loc5_);
               if(param1 is DisplayObjectContainer)
               {
                  setDisplayColor(param1 as DisplayObjectContainer,param2);
               }
               else if(param1 is Image)
               {
                  (param1 as Image).color = param2;
               }
               _loc5_++;
            }
         }
      }
   }
}
