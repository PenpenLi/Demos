package starling.display
{
   import starling.textures.Texture;
   import flash.geom.Matrix;
   
   public class GraphicsTextureFill implements IGraphicsData
   {
       
      protected var mTexture:Texture;
      
      protected var mMatrix:Matrix;
      
      public function GraphicsTextureFill(param1:Texture, param2:Matrix = null)
      {
         super();
         mTexture = param1;
         mMatrix = param2;
      }
      
      public function get texture() : Texture
      {
         return mTexture;
      }
      
      public function get matrix() : Matrix
      {
         return mMatrix;
      }
   }
}
