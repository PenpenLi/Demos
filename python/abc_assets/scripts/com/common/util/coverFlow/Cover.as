package com.common.util.coverFlow
{
   import starling.display.Sprite;
   import starling.display.DisplayObject;
   
   public class Cover extends Sprite
   {
       
      private var _startX:Number;
      
      private var _endX:Number;
      
      private var _startRotationY:Number;
      
      private var _endRotationY:Number;
      
      private var _startZ:Number;
      
      private var _endZ:Number;
      
      private var _startScale:Number;
      
      private var _endScale:Number;
      
      private var _centerMargin:Number;
      
      private var _distanceFromCenter:Number;
      
      public function Cover()
      {
         super();
      }
      
      private static function ExponentialEaseOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 == param4?param2 + param3:param3 * (-Math.pow(2,-10 * param1 / param4) + 1) + param2;
      }
      
      public function addContent(param1:DisplayObject) : void
      {
         param1.x = param1.x - (param1.width >> 1);
         param1.y = param1.y - (param1.height >> 1);
         this.addChild(param1);
      }
      
      public function get endScale() : Number
      {
         return _endScale;
      }
      
      public function set endScale(param1:Number) : void
      {
         _startScale = this.scaleX;
         _endScale = param1;
      }
      
      public function get endX() : Number
      {
         return _endX;
      }
      
      public function set endX(param1:Number) : void
      {
         _startX = this.x;
         _endX = param1;
      }
      
      public function set endRotationY(param1:Number) : void
      {
      }
      
      public function set endZ(param1:Number) : void
      {
      }
      
      public function updateTween(param1:Number, param2:Number) : void
      {
         this.x = ExponentialEaseOut(param1,_startX,_endX - _startX,param2);
         var _loc3_:* = ExponentialEaseOut(param1,_startScale,_endScale - _startScale,param2);
         this.scaleY = _loc3_;
         this.scaleX = _loc3_;
      }
   }
}
