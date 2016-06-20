package starling.display.graphicsEx
{
   import starling.display.graphics.Stroke;
   import starling.display.graphics.StrokeVertex;
   
   public class StrokeEx extends Stroke
   {
       
      protected var _lineLength:Number = 0;
      
      public function StrokeEx()
      {
         super();
      }
      
      public function get strokeVertices() : Vector.<StrokeVertex>
      {
         return _line;
      }
      
      override public function clear() : void
      {
         super.clear();
         _lineLength = 0;
      }
      
      public function invalidate() : void
      {
         isInvalid = true;
      }
      
      public function strokeLength() : Number
      {
         if(_lineLength == 0)
         {
            if(_line == null || _line.length < 2)
            {
               return 0;
            }
            return calcStrokeLength();
         }
         return _lineLength;
      }
      
      protected function calcStrokeLength() : Number
      {
         var _loc6_:* = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc1_:* = NaN;
         if(_line == null || _line.length < 2)
         {
            _lineLength = 0;
         }
         else
         {
            _loc6_ = 1;
            _loc5_ = _line[0];
            _loc4_ = null;
            _loc6_ = 1;
            while(_loc6_ < _numVertices)
            {
               _loc4_ = _line[_loc6_];
               _loc2_ = _loc4_.x - _loc5_.x;
               _loc3_ = _loc4_.y - _loc5_.y;
               _loc1_ = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
               _lineLength = §§dup()._lineLength + _loc1_;
               _loc5_ = _loc4_;
               _loc6_++;
            }
         }
         return _lineLength;
      }
   }
}
