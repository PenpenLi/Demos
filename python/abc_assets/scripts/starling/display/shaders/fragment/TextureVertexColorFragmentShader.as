package starling.display.shaders.fragment
{
   import starling.display.shaders.AbstractShader;
   
   public class TextureVertexColorFragmentShader extends AbstractShader
   {
       
      public function TextureVertexColorFragmentShader()
      {
         super();
         var _loc1_:String = "tex ft1, v1, fs0 <2d, repeat, linear> \nmul ft2, v0, fc0 \nmul oc, ft1, ft2";
         compileAGAL("fragment",_loc1_);
      }
   }
}
