package lzm.util
{
   public class LzmPoint
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public function LzmPoint(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function distance(param1:LzmPoint, param2:LzmPoint) : Number
      {
         var _loc4_:Number = param1.x - param2.x;
         var _loc3_:Number = param1.y - param2.y;
         return Math.sqrt(_loc4_ * _loc4_ + _loc3_ * _loc3_);
      }
      
      public static function angleABC(param1:LzmPoint, param2:LzmPoint, param3:LzmPoint) : Number
      {
         var _loc6_:Number = distance(param1,param3);
         var _loc4_:Number = distance(param2,param3);
         var _loc5_:Number = distance(param1,param2);
         return Math.acos(-(_loc6_ * _loc6_ - _loc4_ * _loc4_ - _loc5_ * _loc5_) / 2 / _loc4_ / _loc5_) / 3.141592653589793 * 180;
      }
      
      public static function rotation(param1:LzmPoint, param2:LzmPoint) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x) / 0.017453292519943295;
      }
      
      public static function angle(param1:LzmPoint, param2:LzmPoint) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x);
      }
      
      public static function FLrotation(param1:LzmPoint, param2:LzmPoint) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x) / 0.017453292519943295;
      }
      
      public static function lineCenter(param1:LzmPoint, param2:LzmPoint) : LzmPoint
      {
         return new LzmPoint(param1.x - (param1.x - param2.x) / 2,param1.y - (param1.y - param2.y) / 2);
      }
      
      public function equals(param1:LzmPoint) : Boolean
      {
         var _loc2_:* = false;
         if(param1.x == this.x && param1.y == this.y)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function get length() : Number
      {
         return distance(new LzmPoint(),this);
      }
      
      public function get point() : LzmPoint
      {
         return new LzmPoint(x,y);
      }
      
      public function set point(param1:LzmPoint) : void
      {
         x = param1.x;
         y = param1.y;
      }
      
      public function clone() : *
      {
         return new LzmPoint(x,y);
      }
      
      public function toString() : String
      {
         return "[ LzmPoint ](x=" + x + ",y=" + y + ")";
      }
   }
}
