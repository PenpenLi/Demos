package starling.display.graphics
{
   public class TriangleFan extends Graphic
   {
       
      private var numVertices:int;
      
      public function TriangleFan()
      {
         super();
         vertices.push(0,0,0,1,1,1,1,0,0);
         numVertices = numVertices + 1;
      }
      
      public function addVertex(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0, param5:Number = 1, param6:Number = 1, param7:Number = 1, param8:Number = 1) : void
      {
         vertices.push(param1,param2,0,param5,param6,param7,param8,param3,param4);
         numVertices = numVertices + 1;
         minBounds.x = param1 < minBounds.x?param1:minBounds.x;
         minBounds.y = param2 < minBounds.y?param2:minBounds.y;
         maxBounds.x = param1 > maxBounds.x?param1:maxBounds.x;
         maxBounds.y = param2 > maxBounds.y?param2:maxBounds.y;
         if(numVertices > 2)
         {
            indices.push(0,numVertices - 2,numVertices - 1);
         }
         setGeometryInvalid();
      }
      
      public function modifyVertexPosition(param1:int, param2:Number, param3:Number) : void
      {
         vertices[param1 * 9] = param2;
         vertices[param1 * 9 + 1] = param3;
         if(isInvalid == false)
         {
            setGeometryInvalid();
         }
      }
      
      public function clear() : void
      {
         vertices.length = 0;
         indices.length = 0;
         numVertices = 0;
         setGeometryInvalid();
      }
      
      override protected function buildGeometry() : void
      {
      }
   }
}
