package starling.display.graphics
{
   import starling.display.graphics.util.TriangleUtil;
   
   public class TriangleStrip extends Graphic
   {
       
      private var numVertices:int;
      
      public function TriangleStrip()
      {
         super();
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
            indices.push(numVertices - 3,numVertices - 2,numVertices - 1);
         }
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
      
      override protected function shapeHitTestLocalInternal(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc13_:* = 0;
         var _loc12_:* = 0;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc11_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc3_:int = indices.length;
         if(_loc3_ < 2)
         {
            return false;
         }
         _loc4_ = 2;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = indices[_loc4_ - 2];
            _loc13_ = indices[_loc4_ - 1];
            _loc12_ = indices[_loc4_ - 0];
            _loc6_ = vertices[9 * _loc5_ + 0];
            _loc7_ = vertices[9 * _loc5_ + 1];
            _loc11_ = vertices[9 * _loc13_ + 0];
            _loc8_ = vertices[9 * _loc13_ + 1];
            _loc9_ = vertices[9 * _loc12_ + 0];
            _loc10_ = vertices[9 * _loc12_ + 1];
            if(TriangleUtil.isPointInTriangleBarycentric(_loc6_,_loc7_,_loc11_,_loc8_,_loc9_,_loc10_,param1,param2))
            {
               return true;
            }
            if(_precisionHitTestDistance > 0)
            {
               if(TriangleUtil.isPointOnLine(_loc6_,_loc7_,_loc11_,_loc8_,param1,param2,_precisionHitTestDistance))
               {
                  return true;
               }
               if(TriangleUtil.isPointOnLine(_loc6_,_loc7_,_loc9_,_loc10_,param1,param2,_precisionHitTestDistance))
               {
                  return true;
               }
               if(TriangleUtil.isPointOnLine(_loc11_,_loc8_,_loc9_,_loc10_,param1,param2,_precisionHitTestDistance))
               {
                  return true;
               }
            }
            _loc4_ = _loc4_ + 3;
         }
         return false;
      }
      
      override protected function buildGeometry() : void
      {
      }
   }
}
