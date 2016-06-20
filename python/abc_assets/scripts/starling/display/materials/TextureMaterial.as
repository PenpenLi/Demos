package starling.display.materials
{
   import starling.textures.Texture;
   import starling.display.shaders.vertex.StandardVertexShader;
   import starling.display.shaders.fragment.TextureVertexColorFragmentShader;
   
   public class TextureMaterial extends StandardMaterial
   {
       
      public function TextureMaterial(param1:Texture, param2:uint = 16777215)
      {
         super(new StandardVertexShader(),new TextureVertexColorFragmentShader());
         textures[0] = param1;
         this.color = param2;
      }
   }
}
