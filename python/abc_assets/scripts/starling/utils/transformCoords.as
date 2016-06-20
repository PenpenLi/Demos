package starling.utils
{
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   public function transformCoords(param1:Matrix, param2:Number, param3:Number, param4:Point = null) : Point
   {
      if(!deprecationNotified)
      {
         deprecationNotified = true;
         LogUtil("[Starling] The method \'transformCoords\' is deprecated. Please use \'MatrixUtil.transformCoords\' instead.");
      }
      if(param4 == null)
      {
         var param4:Point = new Point();
      }
      param4.x = param1.a * param2 + param1.c * param3 + param1.tx;
      param4.y = param1.d * param3 + param1.b * param2 + param1.ty;
      return param4;
   }
}

var deprecationNotified:Boolean = false;
