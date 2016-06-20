package starling.display.shaders.vertex
{
   import starling.display.shaders.AbstractShader;
   import flash.display3D.Context3D;
   import flash.utils.getTimer;
   
   public class RippleVertexShader extends AbstractShader
   {
       
      public function RippleVertexShader()
      {
         super();
         var _loc1_:String = "mul vt0, va0.x, vc4.y \nadd vt1, vc4.x, vt0 \nsin vt2, vt1 \nmul vt3, vt2, vc4.z \nadd vt4, va0.y, vt3 \nmov vt5, va0 \nmov vt5.y, vt4 \nm44 op, vt5, vc0 \nmov v0, va1 \nmov v1, va2 \n";
         compileAGAL("vertex",_loc1_);
      }
      
      override public function setConstants(param1:Context3D, param2:int) : void
      {
         var _loc4_:Number = getTimer() / 200;
         var _loc3_:* = 0.02;
         var _loc5_:* = 5.0;
         param1.setProgramConstantsFromVector("vertex",param2,Vector.<Number>([_loc4_,_loc3_,_loc5_,1]));
      }
   }
}
