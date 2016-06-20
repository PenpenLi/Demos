package starling.display.graphics
{
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import flash.display3D.Context3D;
   import starling.errors.MissingContextError;
   
   public class FastStroke extends Graphic
   {
       
      protected var _line:Vector.<starling.display.graphics.StrokeVertex>;
      
      protected var _lastX:Number;
      
      protected var _lastY:Number;
      
      protected var _lastR:Number;
      
      protected var _lastG:Number;
      
      protected var _lastB:Number;
      
      protected var _lastA:Number;
      
      protected var _lastThickness:Number;
      
      protected var _numControlPoints:int;
      
      protected var _capacity:int = -1;
      
      protected var _numVertIndex:int = 0;
      
      protected var _numVerts:int = 0;
      
      protected var _verticesBufferAllocLen:int = 0;
      
      protected var _indicesBufferAllocLen:int = 0;
      
      protected const INDEX_STRIDE_FOR_QUAD:int = 6;
      
      public function FastStroke()
      {
         super();
         clear();
      }
      
      protected static function pushVerts(param1:Vector.<Number>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number) : void
      {
         var _loc11_:* = 0.0;
         var _loc12_:int = param2 * 18;
         _loc12_++;
         param1[_loc12_] = param3;
         _loc12_++;
         param1[_loc12_] = param4;
         _loc12_++;
         param1[_loc12_] = 0;
         _loc12_++;
         param1[_loc12_] = param7;
         _loc12_++;
         param1[_loc12_] = param8;
         _loc12_++;
         param1[_loc12_] = param9;
         _loc12_++;
         param1[_loc12_] = param10;
         _loc12_++;
         param1[_loc12_] = _loc11_;
         _loc12_++;
         param1[_loc12_] = 0;
         _loc12_++;
         param1[_loc12_] = param5;
         _loc12_++;
         param1[_loc12_] = param6;
         _loc12_++;
         param1[_loc12_] = 0;
         _loc12_++;
         param1[_loc12_] = param7;
         _loc12_++;
         param1[_loc12_] = param8;
         _loc12_++;
         param1[_loc12_] = param9;
         _loc12_++;
         param1[_loc12_] = param10;
         _loc12_++;
         param1[_loc12_] = _loc11_;
         _loc12_++;
         param1[_loc12_] = 1;
      }
      
      public function setCapacity(param1:int) : void
      {
         if(param1 > _capacity)
         {
            clear();
            vertices = new Vector.<Number>(param1 * 18 * 2,true);
            indices = new Vector.<uint>(param1 * 6 * 2,true);
            _capacity = param1;
         }
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1) : void
      {
         setCurrentPosition(param1,param2);
         setCurrentColor(param4,param5);
         setCurrentThickness(param3);
      }
      
      public function lineTo(param1:Number, param2:Number, param3:Number = 1.0, param4:uint = 16777215, param5:Number = 1.0) : void
      {
         var _loc18_:* = NaN;
         var _loc12_:* = NaN;
         var _loc11_:* = NaN;
         var _loc16_:* = NaN;
         var _loc19_:* = NaN;
         var _loc26_:* = NaN;
         var _loc21_:* = NaN;
         var _loc13_:* = NaN;
         var _loc10_:* = NaN;
         var _loc14_:* = NaN;
         var _loc9_:* = NaN;
         var _loc23_:* = 0;
         var _loc25_:* = 0;
         var _loc22_:* = 0;
         var _loc24_:Number = (param4 >> 16) / 255;
         var _loc17_:Number = ((param4 & 65280) >> 8) / 255;
         var _loc20_:Number = (param4 & 255) / 255;
         var _loc6_:Number = 0.5 * param3;
         var _loc7_:Number = param1 - _lastX;
         var _loc8_:Number = param2 - _lastY;
         var _loc15_:Number = _lastThickness * 0.5;
         if(_loc8_ == 0)
         {
            pushVerts(vertices,_numControlPoints,_lastX,_lastY + _loc15_,_lastX,_lastY - _loc15_,_lastR,_lastG,_lastB,_lastA);
            pushVerts(vertices,_numControlPoints + 1,param1,param2 + _loc6_,param1,param2 - _loc6_,_loc24_,_loc17_,_loc20_,param5);
         }
         else if(_loc7_ == 0)
         {
            pushVerts(vertices,_numControlPoints,_lastX + _loc15_,_lastY,_lastX - _loc15_,_lastY,_lastR,_lastG,_lastB,_lastA);
            pushVerts(vertices,_numControlPoints + 1,param1 + _loc6_,param2,param1 - _loc6_,param2,_loc24_,_loc17_,_loc20_,param5);
         }
         else
         {
            _loc18_ = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
            _loc12_ = -_loc8_ / _loc18_;
            _loc11_ = _loc7_ / _loc18_;
            _loc16_ = _loc12_;
            _loc19_ = _loc11_;
            _loc26_ = 1 / Math.sqrt(_loc16_ * _loc16_ + _loc19_ * _loc19_);
            _loc21_ = _loc26_ * _loc15_;
            _loc16_ = _loc12_ * _loc21_;
            _loc19_ = _loc11_ * _loc21_;
            _loc13_ = _lastX + _loc16_;
            _loc10_ = _lastY + _loc19_;
            _loc14_ = _lastX - _loc16_;
            _loc9_ = _lastY - _loc19_;
            pushVerts(vertices,_numControlPoints,_loc13_,_loc10_,_loc14_,_loc9_,_lastR,_lastG,_lastB,_lastA);
            _loc21_ = _loc26_ * _loc6_;
            _loc16_ = _loc12_ * _loc21_;
            _loc19_ = _loc11_ * _loc21_;
            _loc13_ = param1 + _loc16_;
            _loc10_ = param2 + _loc19_;
            _loc14_ = param1 - _loc16_;
            _loc9_ = param2 - _loc19_;
            pushVerts(vertices,_numControlPoints + 1,_loc13_,_loc10_,_loc14_,_loc9_,_loc24_,_loc17_,_loc20_,param5);
         }
         _lastX = param1;
         _lastY = param2;
         _lastR = _loc24_;
         _lastG = _loc17_;
         _lastB = _loc20_;
         _lastA = param5;
         _lastThickness = param3;
         minBounds.x = param1 < minBounds.x?param1:minBounds.x;
         minBounds.y = param2 < minBounds.y?param2:minBounds.y;
         maxBounds.x = param1 > maxBounds.x?param1:maxBounds.x;
         maxBounds.y = param2 > maxBounds.y?param2:maxBounds.y;
         if(_numControlPoints < _capacity * 2)
         {
            _loc23_ = _numControlPoints;
            _loc25_ = _loc23_ << 1;
            _loc22_ = _loc23_ * 6;
            _loc22_++;
            indices[_loc22_] = _loc25_;
            _loc22_++;
            indices[_loc22_] = _loc25_ + 2;
            _loc22_++;
            indices[_loc22_] = _loc25_ + 1;
            _loc22_++;
            indices[_loc22_] = _loc25_ + 1;
            _loc22_++;
            indices[_loc22_] = _loc25_ + 2;
            _loc22_++;
            indices[_loc22_] = _loc25_ + 3;
            _numVertIndex = §§dup()._numVertIndex + 6 * 2;
         }
         _numControlPoints = §§dup()._numControlPoints + 2;
         _numVerts = §§dup()._numVerts + 36;
         if(isInvalid == false)
         {
            setGeometryInvalid();
         }
      }
      
      override public function dispose() : void
      {
         clear();
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         super.dispose();
         _capacity = -1;
      }
      
      public function clear() : void
      {
         _numControlPoints = 0;
         _numVerts = 0;
         _numVertIndex = 0;
         _lastX = 0;
         _lastY = 0;
         _lastThickness = 1;
         _lastA = 1;
         _lastB = 1;
         _lastG = 1;
         _lastR = 1;
         setGeometryInvalid();
      }
      
      override protected function buildGeometry() : void
      {
      }
      
      protected function setCurrentPosition(param1:Number, param2:Number) : void
      {
         _lastX = param1;
         _lastY = param2;
      }
      
      protected function setCurrentColor(param1:uint, param2:Number = 1) : void
      {
         _lastR = (param1 >> 16) / 255;
         _lastG = ((param1 & 65280) >> 8) / 255;
         _lastB = (param1 & 255) / 255;
         _lastA = param2;
      }
      
      protected function setCurrentThickness(param1:Number) : void
      {
         _lastThickness = param1;
      }
      
      override protected function shapeHitTestLocalInternal(param1:Number, param2:Number) : Boolean
      {
         var _loc12_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = NaN;
         var _loc10_:* = NaN;
         var _loc9_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc11_:* = NaN;
         if(_line == null)
         {
            return false;
         }
         if(_line.length < 2)
         {
            return false;
         }
         var _loc5_:int = _line.length;
         _loc12_ = 1;
         while(_loc12_ < _loc5_)
         {
            _loc4_ = _line[_loc12_ - 1];
            _loc3_ = _line[_loc12_];
            _loc6_ = (_loc3_.x - _loc4_.x) * (_loc3_.x - _loc4_.x) + (_loc3_.y - _loc4_.y) * (_loc3_.y - _loc4_.y);
            _loc10_ = ((param1 - _loc4_.x) * (_loc3_.x - _loc4_.x) + (param2 - _loc4_.y) * (_loc3_.y - _loc4_.y)) / _loc6_;
            if(!(_loc10_ < 0 || _loc10_ > 1))
            {
               _loc9_ = _loc4_.x + _loc10_ * (_loc3_.x - _loc4_.x);
               _loc7_ = _loc4_.y + _loc10_ * (_loc3_.y - _loc4_.y);
               _loc8_ = (param1 - _loc9_) * (param1 - _loc9_) + (param2 - _loc7_) * (param2 - _loc7_);
               _loc11_ = _loc4_.thickness * (1 - _loc10_) + _loc3_.thickness * _loc10_;
               _loc11_ = _loc11_ + _precisionHitTestDistance;
               if(_loc8_ <= _loc11_ * _loc11_)
               {
                  return true;
               }
            }
            _loc12_++;
         }
         return false;
      }
      
      override public function validateNow() : void
      {
         if(hasValidatedGeometry)
         {
            return;
         }
         hasValidatedGeometry = true;
         if(vertexBuffer && (isInvalid || uvsInvalid))
         {
         }
         if(isInvalid)
         {
            buildGeometry();
            applyUVMatrix();
         }
         else if(uvsInvalid)
         {
            applyUVMatrix();
         }
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc5_:* = 0;
         validateNow();
         if(indices.length < 3)
         {
            return;
         }
         var _loc3_:int = _numVertIndex;
         if(isInvalid || uvsInvalid)
         {
            _loc5_ = _numControlPoints * 2;
            if(_loc5_ > _verticesBufferAllocLen)
            {
               if(vertexBuffer != null)
               {
                  vertexBuffer.dispose();
               }
               vertexBuffer = Starling.context.createVertexBuffer(_loc5_,9);
               _verticesBufferAllocLen = _loc5_;
            }
            vertexBuffer.uploadFromVector(vertices,0,_loc5_);
            if(_loc3_ > _indicesBufferAllocLen)
            {
               if(indexBuffer != null)
               {
                  indexBuffer.dispose();
               }
               indexBuffer = Starling.context.createIndexBuffer(_loc3_);
               _indicesBufferAllocLen = _loc3_;
            }
            indexBuffer.uploadFromVector(indices,0,_loc3_);
            uvsInvalid = false;
            isInvalid = false;
         }
         param1.finishQuadBatch();
         var _loc4_:Context3D = Starling.context;
         if(_loc4_ == null)
         {
            throw new MissingContextError();
         }
         RenderSupport.setBlendFactors(false,this.blendMode == "auto"?param1.blendMode:this.blendMode);
         _material.drawTriangles(Starling.context,param1.mvpMatrix3D,vertexBuffer,indexBuffer,param2 * this.alpha,_numVertIndex / 3);
         _loc4_.setTextureAt(0,null);
         _loc4_.setTextureAt(1,null);
         _loc4_.setVertexBufferAt(0,null);
         _loc4_.setVertexBufferAt(1,null);
         _loc4_.setVertexBufferAt(2,null);
      }
   }
}
