package starling.display
{
   import starling.display.materials.IMaterial;
   import flash.geom.Matrix;
   
   public class GraphicsMaterialFill implements IGraphicsData
   {
       
      protected var mMaterial:IMaterial;
      
      protected var mMatrix:Matrix;
      
      public function GraphicsMaterialFill(param1:IMaterial, param2:Matrix = null)
      {
         super();
         mMaterial = param1;
         mMatrix = param2;
      }
      
      public function get material() : IMaterial
      {
         return mMaterial;
      }
      
      public function get matrix() : Matrix
      {
         return mMatrix;
      }
   }
}
