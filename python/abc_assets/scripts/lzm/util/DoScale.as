package lzm.util
{
   public class DoScale
   {
       
      public function DoScale()
      {
         super();
      }
      
      public static function doScale(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         if(param1 > 0 && param2 > 0)
         {
            if(param1 / param2 >= param3 / param4)
            {
               _loc6_ = param3;
               _loc5_ = param2 * param3 / param1;
            }
            else
            {
               _loc5_ = param4;
               _loc6_ = param1 * param4 / param2;
            }
         }
         else
         {
            _loc6_ = 0.0;
            _loc5_ = 0.0;
         }
         var _loc7_:Object = {};
         _loc7_.sx = _loc6_ / param1;
         _loc7_.sy = _loc5_ / param2;
         return _loc7_;
      }
      
      public static function doMaxScale(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc6_:Number = param3 / param1;
         var _loc5_:Number = param4 / param2;
         return _loc6_ > _loc5_?_loc6_:_loc5_;
      }
      
      public static function doMinScale(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc6_:Number = param3 / param1;
         var _loc5_:Number = param4 / param2;
         return _loc6_ < _loc5_?_loc6_:_loc5_;
      }
   }
}
