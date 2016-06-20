package starling.display.graphics
{
   public final class VertexList
   {
      
      private static var nodePool:Vector.<starling.display.graphics.VertexList> = new Vector.<starling.display.graphics.VertexList>();
      
      private static var nodePoolLength:int = 0;
       
      public var vertex:Vector.<Number>;
      
      public var next:starling.display.graphics.VertexList;
      
      public var prev:starling.display.graphics.VertexList;
      
      public var index:int;
      
      public var head:starling.display.graphics.VertexList;
      
      public function VertexList()
      {
         super();
      }
      
      public static function insertAfter(param1:starling.display.graphics.VertexList, param2:starling.display.graphics.VertexList) : starling.display.graphics.VertexList
      {
         var _loc3_:starling.display.graphics.VertexList = param1.next;
         param1.next = param2;
         param2.next = _loc3_;
         param2.prev = param1;
         param2.head = param1.head;
         return param2;
      }
      
      public static function clone(param1:starling.display.graphics.VertexList) : starling.display.graphics.VertexList
      {
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:starling.display.graphics.VertexList = param1.head;
         do
         {
            if(_loc5_ == null)
            {
               _loc5_ = §§dup(getNode());
               _loc2_ = getNode();
            }
            else
            {
               _loc2_ = getNode();
            }
            _loc2_.head = _loc5_;
            _loc2_.index = _loc4_.index;
            _loc2_.vertex = _loc4_.vertex;
            _loc2_.prev = _loc3_;
            if(_loc3_)
            {
               _loc3_.next = _loc2_;
            }
            _loc3_ = _loc2_;
            _loc4_ = _loc4_.next;
         }
         while(_loc4_ != _loc4_.head);
         
         _loc3_.next = _loc5_;
         _loc5_.prev = _loc3_;
         return _loc5_;
      }
      
      public static function reverse(param1:starling.display.graphics.VertexList) : void
      {
         var _loc3_:* = null;
         var _loc2_:starling.display.graphics.VertexList = param1.head;
         do
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = _loc2_.prev;
            _loc2_.prev = _loc3_;
            _loc2_ = _loc3_;
         }
         while(_loc2_ != param1.head);
         
      }
      
      public static function dispose(param1:starling.display.graphics.VertexList) : void
      {
         var _loc2_:* = null;
         while(param1 && param1.head)
         {
            releaseNode(param1);
            _loc2_ = param1.next;
            param1.next = null;
            param1.prev = null;
            param1.head = null;
            param1.vertex = null;
            var param1:starling.display.graphics.VertexList = param1.next;
         }
      }
      
      public static function getNode() : starling.display.graphics.VertexList
      {
         if(nodePoolLength > 0)
         {
            nodePoolLength = nodePoolLength - 1;
            return nodePool.pop();
         }
         return new starling.display.graphics.VertexList();
      }
      
      public static function releaseNode(param1:starling.display.graphics.VertexList) : void
      {
         var _loc2_:* = null;
         param1.head = _loc2_;
         _loc2_ = _loc2_;
         param1.next = _loc2_;
         param1.prev = _loc2_;
         param1.vertex = null;
         param1.index = -1;
         nodePoolLength = §§dup(nodePoolLength) + 1;
         nodePool[nodePoolLength] = param1;
      }
   }
}
