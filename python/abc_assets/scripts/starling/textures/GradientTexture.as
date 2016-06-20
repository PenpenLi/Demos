package starling.textures
{
   import flash.geom.Matrix;
   import flash.display.Shape;
   import flash.display.BitmapData;
   
   public class GradientTexture
   {
       
      public function GradientTexture()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Number, param3:String, param4:Array, param5:Array, param6:Array, param7:Matrix = null, param8:String = "pad", param9:String = "rgb", param10:Number = 0) : Texture
      {
         var _loc12_:Shape = new Shape();
         _loc12_.graphics.beginGradientFill(param3,param4,param5,param6,param7,param8,param9,param10);
         _loc12_.graphics.drawRect(0,0,param1,param2);
         var _loc11_:BitmapData = new BitmapData(param1,param2,true);
         _loc11_.draw(_loc12_);
         return Texture.fromBitmapData(_loc11_);
      }
   }
}
