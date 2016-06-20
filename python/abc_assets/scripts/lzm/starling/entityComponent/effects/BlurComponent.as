package lzm.starling.entityComponent.effects
{
   import lzm.starling.entityComponent.EntityComponent;
   import starling.display.Sprite;
   import starling.display.DisplayObject;
   import starling.display.Image;
   
   public class BlurComponent extends EntityComponent
   {
       
      private var showObjects:Vector.<Sprite>;
      
      private var entityLastX:int;
      
      private var entityLastY:int;
      
      public var alphaSpeed:Number = 0.05;
      
      public var updateSpeed:int = 3;
      
      private var currentUpdateTime:int = 0;
      
      public function BlurComponent()
      {
         super();
      }
      
      override public function start() : void
      {
         showObjects = new Vector.<Sprite>();
         entityLastX = entity.x;
         entityLastY = entity.y;
      }
      
      override public function update() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = 0;
         var _loc3_:int = showObjects.length;
         if(entity.parent == null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = showObjects.pop();
               _loc2_.removeFromParent(true);
               _loc4_++;
            }
            return;
         }
         var _loc6_:* = 0;
         var _loc5_:* = showObjects;
         for each(_loc2_ in showObjects)
         {
            _loc2_.alpha = _loc2_.alpha - alphaSpeed;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = showObjects[_loc4_];
            if(_loc2_.alpha <= 0)
            {
               _loc2_.removeFromParent(true);
               showObjects.splice(_loc4_,1);
               _loc4_--;
               _loc3_--;
            }
            _loc4_++;
         }
         currentUpdateTime = currentUpdateTime + 1;
         if(currentUpdateTime < updateSpeed)
         {
            return;
         }
         currentUpdateTime = 0;
         _loc2_ = cloneSprite(entity);
         _loc2_.alpha = 1;
         _loc2_.x = entityLastX;
         _loc2_.y = entityLastY;
         showObjects.push(_loc2_);
         _loc1_ = entity.parent.getChildIndex(entity);
         entity.parent.addQuickChildAt(_loc2_,_loc1_);
         entityLastX = entity.x;
         entityLastY = entity.y;
      }
      
      override public function stop() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = showObjects.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            showObjects.pop().removeFromParent(true);
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         stop();
         super.dispose();
      }
      
      private function cloneSprite(param1:Sprite) : Sprite
      {
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc4_:Number = param1.numChildren;
         var _loc3_:Sprite = new Sprite();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.getChildAt(_loc5_);
            if(_loc2_ is Sprite)
            {
               _loc3_.addQuickChild(cloneSprite(_loc2_ as Sprite));
            }
            else if(_loc2_ is Image)
            {
               _loc3_.addQuickChild(cloneImage(_loc2_ as Image));
            }
            _loc5_++;
         }
         _loc3_.transformationMatrix = param1.transformationMatrix;
         return _loc3_;
      }
      
      private function cloneImage(param1:Image) : Image
      {
         var _loc2_:Image = new Image(param1.texture);
         _loc2_.transformationMatrix = param1.transformationMatrix;
         return _loc2_;
      }
   }
}
