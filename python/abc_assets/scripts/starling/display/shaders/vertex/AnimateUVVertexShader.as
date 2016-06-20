package starling.display.shaders.vertex
{
   import starling.display.shaders.AbstractShader;
   import flash.display3D.Context3D;
   import flash.utils.getTimer;
   
   public class AnimateUVVertexShader extends AbstractShader
   {
       
      public var uSpeed:Number = 1;
      
      public var vSpeed:Number = 1;
      
      public function AnimateUVVertexShader(param1:Number = 1, param2:Number = 1)
      {
         super();
         this.uSpeed = param1;
         this.vSpeed = param2;
         var _loc3_:String = "m44 op, va0, vc0 \nmov v0, va1 \nsub vt0, va2, vc4 \nmov v1, vt0 \n";
         compileAGAL("vertex",_loc3_);
      }
      
      override public function setConstants(param1:Context3D, param2:int) : void
      {
         var _loc4_:Number = getTimer() / 1000;
         var _loc5_:Number = _loc4_ * uSpeed;
         var _loc3_:Number = _loc4_ * vSpeed;
         param1.setProgramConstantsFromVector("vertex",param2,Vector.<Number>([_loc5_,_loc3_,0,0]));
      }
   }
}
