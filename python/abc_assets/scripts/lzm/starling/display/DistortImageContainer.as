package lzm.starling.display
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import flash.geom.Point;
   
   public class DistortImageContainer extends Sprite
   {
       
      private var _distortPostions:Array;
      
      private var _image:lzm.starling.display.DistortImage;
      
      private var _quads:Vector.<Quad>;
      
      public function DistortImageContainer(param1:lzm.starling.display.DistortImage)
      {
         super();
         _image = param1;
         addChild(_image);
         _distortPostions = [new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0)];
         init();
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         _quads = new Vector.<Quad>();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = createQuad();
            _loc1_.addEventListener("touch",distortFunction(_loc2_));
            addChild(_loc1_);
            _quads.push(_loc1_);
            switch(_loc2_)
            {
               case 0:
                  _loc1_.x = -_image.pivotX;
                  _loc1_.y = -_image.pivotY;
                  break;
               case 1:
                  _loc1_.x = _image.width - _image.pivotX;
                  _loc1_.y = -_image.pivotY;
                  break;
               case 2:
                  _loc1_.x = -_image.pivotX;
                  _loc1_.y = _image.height - _image.pivotY;
                  break;
               case 3:
                  _loc1_.x = _image.width - _image.pivotX;
                  _loc1_.y = _image.height - _image.pivotY;
                  break;
            }
            _loc2_++;
         }
      }
      
      private function distortFunction(param1:int) : Function
      {
         vertexID = param1;
         var thisObject:DistortImageContainer = this;
         return function(param1:TouchEvent):void
         {
            var _loc3_:* = null;
            var _loc4_:* = null;
            var _loc2_:* = null;
            var _loc5_:Vector.<Touch> = param1.getTouches(thisObject,"moved");
            if(_loc5_.length == 1)
            {
               _loc3_ = _loc5_[0].getLocation(thisObject);
               _loc4_ = _loc5_[0].getMovement(parent);
               _loc2_ = _distortPostions[vertexID];
               _loc2_.x = _loc2_.x + _loc4_.x;
               _loc2_.y = _loc2_.y + _loc4_.y;
               (param1.target as Quad).x = _loc3_.x;
               (param1.target as Quad).y = _loc3_.y;
               _distortPostions[vertexID] = _loc2_;
               _image.setVertextDataPostion(vertexID,_loc2_.x,_loc2_.y);
            }
         };
      }
      
      private function createQuad() : Quad
      {
         var _loc1_:Quad = new Quad(10,10,0);
         var _loc2_:* = 5;
         _loc1_.pivotY = _loc2_;
         _loc1_.pivotX = _loc2_;
         return _loc1_;
      }
      
      public function get distortValues() : Array
      {
         return _distortPostions;
      }
   }
}
