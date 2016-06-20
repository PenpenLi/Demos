package feathers.utils.display
{
   public function calculateScaleRatioToFit(param1:Number, param2:Number, param3:Number, param4:Number) : Number
   {
      var _loc5_:Number = param3 / param1;
      var _loc6_:Number = param4 / param2;
      return Math.min(_loc5_,_loc6_);
   }
}
