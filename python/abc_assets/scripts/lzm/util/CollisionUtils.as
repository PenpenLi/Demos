package lzm.util
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CollisionUtils
   {
       
      public function CollisionUtils()
      {
         super();
      }
      
      public static function hitPoint(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         var _loc8_:int = hitTrianglePoint(param1,param2,param3);
         var _loc6_:int = hitTrianglePoint(param4,param2,param3);
         var _loc7_:int = hitTrianglePoint(param1,param2,param4);
         var _loc5_:int = hitTrianglePoint(param1,param4,param3);
         if(_loc6_ == _loc8_ && _loc7_ == _loc8_ && _loc5_ == _loc8_)
         {
            return true;
         }
         return false;
      }
      
      public static function hitTrianglePoint(param1:Point, param2:Point, param3:Point) : int
      {
         if((param2.x - param1.x) * (param2.y + param1.y) + (param3.x - param2.x) * (param3.y + param2.y) + (param1.x - param3.x) * (param1.y + param3.y) < 0)
         {
            return 1;
         }
         return 0;
      }
      
      public static function trianglePointByAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Array
      {
         var _loc7_:Point = new Point();
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         _loc7_.x = param2 * Math.cos(param1);
         _loc7_.y = param2 * Math.sin(param1);
         var _loc6_:Number = param1 - param3 / 180 * 3.141592653589793;
         _loc8_.x = param2 * Math.cos(_loc6_);
         _loc8_.y = param2 * Math.sin(_loc6_);
         var _loc5_:Number = param1 + param4 / 180 * 3.141592653589793;
         _loc9_.x = param2 * Math.cos(_loc5_);
         _loc9_.y = param2 * Math.sin(_loc5_);
         return [_loc7_,_loc8_,_loc9_];
      }
      
      public static function pointHitTriangle(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : Boolean
      {
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         if(param1 < param3 && param1 < param5 && param1 < param7 || param1 > param3 && param1 > param5 && param1 > param7 || param2 < param4 && param2 < param6 && param2 < param8 || param2 > param4 && param2 > param6 && param2 > param8)
         {
            return false;
         }
         _loc9_ = quadrantJudging(param1,param2,param3,param4,param5,param6);
         _loc10_ = quadrantJudging(param1,param2,param5,param6,param7,param8);
         _loc11_ = quadrantJudging(param1,param2,param7,param8,param3,param4);
         if(_loc9_ > 0 && _loc10_ > 0 && _loc11_ > 0 || _loc9_ < 0 && _loc10_ < 0 && _loc11_ < 0)
         {
            return true;
         }
         return false;
      }
      
      public static function quadrantJudging(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : int
      {
         return (param1 - param3) * (param6 - param4) - (param2 - param4) * (param5 - param3);
      }
      
      public static function corssJudging(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : int
      {
         return (param1 - param3) * (param2 - param6) - (param2 - param4) * (param1 - param5);
      }
      
      public static function isIntersectingRect(param1:Rectangle, param2:Rectangle) : Boolean
      {
         var _loc8_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc10_:Number = param1.width;
         var _loc9_:Number = param1.height;
         var _loc7_:Number = param2.x;
         var _loc6_:Number = param2.y;
         var _loc4_:Number = param2.width;
         var _loc5_:Number = param2.height;
         if(_loc6_ + _loc5_ < _loc3_ || _loc6_ > _loc3_ + _loc9_ || _loc7_ + _loc4_ < _loc8_ || _loc7_ > _loc8_ + _loc10_)
         {
            return false;
         }
         return true;
      }
   }
}
