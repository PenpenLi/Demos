package lzm.util
{
   import flash.geom.Point;
   
   public class Bezier
   {
       
      private var p0:Point;
      
      private var p1:Point;
      
      private var p2:Point;
      
      private var step:uint;
      
      private var ax:int;
      
      private var ay:int;
      
      private var bx:int;
      
      private var by:int;
      
      private var A:Number;
      
      private var B:Number;
      
      private var C:Number;
      
      private var total_length:Number;
      
      public function Bezier(param1:Point, param2:Point, param3:Point, param4:Number)
      {
         super();
         this.p0 = param1;
         this.p1 = param2;
         this.p2 = param3;
         ax = param1.x - 2 * param2.x + param3.x;
         ay = param1.y - 2 * param2.y + param3.y;
         bx = 2 * param2.x - 2 * param1.x;
         by = 2 * param2.y - 2 * param1.y;
         A = 4 * (ax * ax + ay * ay);
         B = 4 * (ax * bx + ay * by);
         C = bx * bx + by * by;
         total_length = L(1);
         step = Math.floor(total_length / param4);
         if(total_length % param4 > param4 / 2)
         {
            step = step + 1;
         }
      }
      
      private function s(param1:Number) : Number
      {
         return Math.sqrt(A * param1 * param1 + B * param1 + C);
      }
      
      private function L(param1:Number) : Number
      {
         var _loc2_:Number = Math.sqrt(C + param1 * (B + A * param1));
         var _loc3_:Number = 2 * A * param1 * _loc2_ + B * (_loc2_ - Math.sqrt(C));
         var _loc4_:Number = Math.log(B + 2 * Math.sqrt(A) * Math.sqrt(C));
         var _loc7_:Number = Math.log(B + 2 * A * param1 + 2 * Math.sqrt(A) * _loc2_);
         var _loc6_:Number = 2 * Math.sqrt(A) * _loc3_;
         var _loc5_:Number = (B * B - 4 * A * C) * (_loc4_ - _loc7_);
         return (_loc6_ + _loc5_) / (8 * Math.pow(A,1.5));
      }
      
      private function InvertL(param1:Number, param2:Number) : Number
      {
         var _loc3_:* = NaN;
         var _loc4_:* = param1;
         while(true)
         {
            _loc3_ = _loc4_ - (L(_loc4_) - param2) / s(_loc4_);
            if(Math.abs(_loc4_ - _loc3_) >= 1.0E-6)
            {
               _loc4_ = _loc3_;
               continue;
            }
            break;
         }
         return _loc3_;
      }
      
      public function getAnchorPoint(param1:Number) : Array
      {
         var _loc4_:* = NaN;
         var _loc8_:* = NaN;
         var _loc11_:* = NaN;
         var _loc10_:* = NaN;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = NaN;
         var _loc7_:* = NaN;
         var _loc2_:* = NaN;
         var _loc9_:* = NaN;
         if(param1 >= 0 && param1 <= step)
         {
            _loc4_ = param1 / step;
            _loc8_ = _loc4_ * total_length;
            _loc4_ = InvertL(_loc4_,_loc8_);
            _loc11_ = (1 - _loc4_) * (1 - _loc4_) * p0.x + 2 * (1 - _loc4_) * _loc4_ * p1.x + _loc4_ * _loc4_ * p2.x;
            _loc10_ = (1 - _loc4_) * (1 - _loc4_) * p0.y + 2 * (1 - _loc4_) * _loc4_ * p1.y + _loc4_ * _loc4_ * p2.y;
            _loc3_ = new Point((1 - _loc4_) * p0.x + _loc4_ * p1.x,(1 - _loc4_) * p0.y + _loc4_ * p1.y);
            _loc6_ = new Point((1 - _loc4_) * p1.x + _loc4_ * p2.x,(1 - _loc4_) * p1.y + _loc4_ * p2.y);
            _loc5_ = _loc6_.x - _loc3_.x;
            _loc7_ = _loc6_.y - _loc3_.y;
            _loc2_ = Math.atan2(_loc7_,_loc5_);
            _loc9_ = _loc2_ * 180 / 3.141592653589793;
            return new Array(_loc11_,_loc10_,_loc9_);
         }
         return [];
      }
      
      public function get bezierStep() : int
      {
         return step;
      }
   }
}
