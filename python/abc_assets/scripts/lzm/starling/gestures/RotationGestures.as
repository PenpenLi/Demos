package lzm.starling.gestures
{
   import starling.events.Touch;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   
   public class RotationGestures extends Gestures
   {
       
      public function RotationGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGesturesByTouches(param1:Vector.<Touch>) : void
      {
         if(param1.length != 2)
         {
            return;
         }
         var _loc13_:Touch = param1[0];
         var _loc12_:Touch = param1[1];
         if(_loc13_.phase != "moved" || _loc12_.phase != "moved")
         {
            return;
         }
         var _loc5_:Point = _loc13_.getLocation(_target.parent);
         var _loc10_:Point = _loc13_.getPreviousLocation(_target.parent);
         var _loc4_:Point = _loc12_.getLocation(_target.parent);
         var _loc11_:Point = _loc12_.getPreviousLocation(_target.parent);
         var _loc9_:Point = _loc5_.subtract(_loc4_);
         var _loc6_:Point = _loc10_.subtract(_loc11_);
         var _loc14_:Number = Math.atan2(_loc9_.y,_loc9_.x);
         var _loc3_:Number = Math.atan2(_loc6_.y,_loc6_.x);
         var _loc2_:Number = _loc14_ - _loc3_;
         var _loc7_:Point = _loc13_.getPreviousLocation(_target);
         var _loc8_:Point = _loc12_.getPreviousLocation(_target);
         _target.pivotX = (_loc7_.x + _loc8_.x) * 0.5;
         _target.pivotY = (_loc7_.y + _loc8_.y) * 0.5;
         _target.x = (_loc5_.x + _loc4_.x) * 0.5;
         _target.y = (_loc5_.y + _loc4_.y) * 0.5;
         _target.rotation = _target.rotation + _loc2_;
      }
   }
}
