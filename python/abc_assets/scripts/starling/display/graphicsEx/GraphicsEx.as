package starling.display.graphicsEx
{
   import starling.display.Graphics;
   import flash.display.IGraphicsData;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsGradientFill;
   import starling.textures.GradientTexture;
   import starling.textures.Texture;
   import flash.display.GraphicsStroke;
   import flash.display.GraphicsBitmapFill;
   import starling.display.GraphicsTextureFill;
   import starling.display.GraphicsMaterialFill;
   import starling.display.GraphicsLine;
   import starling.display.graphics.StrokeVertex;
   import starling.display.graphics.Stroke;
   import starling.display.DisplayObjectContainer;
   
   public class GraphicsEx extends Graphics
   {
       
      protected var _currentStrokeEx:starling.display.graphicsEx.StrokeEx;
      
      public function GraphicsEx(param1:DisplayObjectContainer)
      {
         super(param1);
      }
      
      override protected function endStroke() : void
      {
         super.endStroke();
         _currentStrokeEx = null;
      }
      
      public function get currentLineIndex() : int
      {
         if(_currentStroke != null)
         {
            return _currentStroke.numVertices;
         }
         return 0;
      }
      
      public function currentLineLength() : Number
      {
         if(_currentStrokeEx)
         {
            return _currentStrokeEx.strokeLength();
         }
         return 0;
      }
      
      public function drawGraphicsData(param1:Vector.<flash.display.IGraphicsData>) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1[_loc4_];
            handleGraphicsDataType(_loc3_);
            _loc4_++;
         }
      }
      
      protected function handleGraphicsDataType(param1:flash.display.IGraphicsData) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = undefined;
         var _loc9_:* = undefined;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc8_:* = null;
         var _loc11_:* = null;
         var _loc10_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(param1 is flash.display.GraphicsPath)
         {
            _loc5_ = param1 as flash.display.GraphicsPath;
            if(_loc5_ != null)
            {
               _loc4_ = _loc5_.commands as Vector.<int>;
               _loc9_ = _loc5_.data as Vector.<Number>;
               _loc7_ = _loc5_.winding as String;
               if(_loc4_ != null && _loc9_ != null && _loc7_ != null)
               {
                  drawPath(_loc4_,_loc9_,_loc7_);
               }
            }
         }
         else if(param1 is flash.display.GraphicsEndFill)
         {
            endFill();
         }
         else if(param1 is GraphicsSolidFill)
         {
            beginFill(GraphicsSolidFill(param1).color,GraphicsSolidFill(param1).alpha);
         }
         else if(param1 is GraphicsGradientFill)
         {
            _loc6_ = param1 as GraphicsGradientFill;
            _loc8_ = GradientTexture.create(128,128,_loc6_.type,_loc6_.colors,_loc6_.alphas,_loc6_.ratios,_loc6_.matrix,_loc6_.spreadMethod,_loc6_.interpolationMethod,_loc6_.focalPointRatio);
            beginTextureFill(_loc8_);
         }
         else if(param1 is GraphicsStroke)
         {
            _loc11_ = GraphicsStroke(param1).fill as GraphicsSolidFill;
            _loc10_ = GraphicsStroke(param1).fill as GraphicsBitmapFill;
            _loc3_ = GraphicsStroke(param1).fill as GraphicsGradientFill;
            if(_loc11_ != null)
            {
               lineStyle(GraphicsStroke(param1).thickness,_loc11_.color,_loc11_.alpha);
            }
            else if(_loc10_ != null)
            {
               lineTexture(GraphicsStroke(param1).thickness,Texture.fromBitmapData(_loc10_.bitmapData,false));
            }
            else if(_loc3_)
            {
               _loc2_ = GradientTexture.create(128,128,_loc3_.type,_loc3_.colors,_loc3_.alphas,_loc3_.ratios,_loc3_.matrix,_loc3_.spreadMethod,_loc3_.interpolationMethod,_loc3_.focalPointRatio);
               lineTexture(GraphicsStroke(param1).thickness,_loc2_);
            }
         }
      }
      
      public function drawGraphicsDataEx(param1:Vector.<starling.display.IGraphicsData>) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1[_loc4_];
            handleGraphicsDataTypeEx(_loc3_);
            _loc4_++;
         }
      }
      
      protected function handleGraphicsDataTypeEx(param1:starling.display.IGraphicsData) : void
      {
         if(param1 is GraphicsNaturalSpline)
         {
            naturalCubicSplineTo(GraphicsNaturalSpline(param1).controlPoints,GraphicsNaturalSpline(param1).closed,GraphicsNaturalSpline(param1).steps);
         }
         else if(param1 is starling.display.GraphicsPath)
         {
            drawPath(starling.display.GraphicsPath(param1).commands,starling.display.GraphicsPath(param1).data,starling.display.GraphicsPath(param1).winding);
         }
         else if(param1 is starling.display.GraphicsEndFill)
         {
            endFill();
         }
         else if(param1 is GraphicsTextureFill)
         {
            beginTextureFill(GraphicsTextureFill(param1).texture,GraphicsTextureFill(param1).matrix);
         }
         else if(param1 is GraphicsMaterialFill)
         {
            beginMaterialFill(GraphicsMaterialFill(param1).material,GraphicsMaterialFill(param1).matrix);
         }
         else if(param1 is GraphicsLine)
         {
            lineStyle(GraphicsLine(param1).thickness,GraphicsLine(param1).color,GraphicsLine(param1).alpha);
         }
      }
      
      protected function drawCommandInternal(param1:int, param2:Vector.<Number>, param3:int, param4:String) : int
      {
         if(param1 == 0)
         {
            return 0;
         }
         if(param1 == 1)
         {
            moveTo(param2[param3],param2[param3 + 1]);
            return 2;
         }
         if(param1 == 2)
         {
            lineTo(param2[param3],param2[param3 + 1]);
            return 2;
         }
         if(param1 == 3)
         {
            curveTo(param2[param3],param2[param3 + 1],param2[param3 + 2],param2[param3 + 3]);
            return 4;
         }
         if(param1 == 6)
         {
            cubicCurveTo(param2[param3],param2[param3 + 1],param2[param3 + 2],param2[param3 + 3],param2[param3 + 4],param2[param3 + 5]);
            return 6;
         }
         if(param1 == 4)
         {
            moveTo(param2[param3 + 2],param2[param3 + 3]);
            return 4;
         }
         if(param1 == 5)
         {
            lineTo(param2[param3 + 2],param2[param3 + 3]);
            return 4;
         }
         return 0;
      }
      
      public function drawPath(param1:Vector.<int>, param2:Vector.<Number>, param3:String = "evenOdd") : void
      {
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:int = param1.length;
         var _loc5_:* = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = param1[_loc7_];
            _loc5_ = _loc5_ + drawCommandInternal(_loc4_,param2,_loc5_,param3);
            _loc7_++;
         }
      }
      
      public function naturalCubicSplineTo(param1:Array, param2:Boolean, param3:int = 4) : void
      {
         var _loc15_:* = undefined;
         var _loc14_:* = undefined;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         var _loc7_:* = 0;
         var _loc6_:* = 0.0;
         var _loc4_:int = param1.length;
         var _loc8_:Vector.<Number> = new Vector.<Number>(_loc4_,true);
         var _loc5_:Vector.<Number> = new Vector.<Number>(_loc4_,true);
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_[_loc7_] = param1[_loc7_].x;
            _loc5_[_loc7_] = param1[_loc7_].y;
            _loc7_++;
         }
         if(param2)
         {
            _loc15_ = calcClosedNaturalCubic(_loc4_ - 1,_loc8_);
            _loc14_ = calcClosedNaturalCubic(_loc4_ - 1,_loc5_);
         }
         else
         {
            _loc15_ = calcNaturalCubic(_loc4_ - 1,_loc8_);
            _loc14_ = calcNaturalCubic(_loc4_ - 1,_loc5_);
         }
         var _loc13_:Vector.<Number> = new Vector.<Number>(2 * param3,true);
         var _loc9_:Number = 1 / param3;
         _loc7_ = 0;
         while(_loc7_ < _loc15_.length)
         {
            _loc6_ = 0.0;
            while(_loc6_ < param3)
            {
               _loc10_ = _loc6_ * _loc9_;
               _loc11_ = _loc15_[_loc7_].eval(_loc10_);
               _loc12_ = _loc14_[_loc7_].eval(_loc10_);
               _loc13_[_loc6_ * 2] = _loc11_;
               _loc13_[_loc6_ * 2 + 1] = _loc12_;
               _loc6_++;
            }
            drawPointsInternal(_loc13_);
            _loc7_++;
         }
      }
      
      public function postProcess(param1:int, param2:int, param3:GraphicsExThicknessData = null, param4:GraphicsExColorData = null) : Boolean
      {
         if(_currentStrokeEx == null)
         {
            return false;
         }
         var _loc7_:Vector.<StrokeVertex> = _currentStrokeEx.strokeVertices;
         var _loc6_:int = _currentStrokeEx.numVertices;
         if(param1 >= _loc6_ || param1 < 0)
         {
            return false;
         }
         if(param2 >= _loc6_ || param2 < 0)
         {
            return false;
         }
         if(param1 == param2)
         {
            return false;
         }
         var _loc5_:int = param2 - param1;
         if(param4)
         {
            if(param3)
            {
               postProcessThicknessColorInternal(_loc5_,param1,param2,_loc7_,param3,param4);
            }
            else
            {
               postProcessColorInternal(_loc5_,param1,param2,_loc7_,param4);
            }
         }
         else if(param3)
         {
            postProcessThicknessInternal(_loc5_,param1,param2,_loc7_,param3);
         }
         _currentStrokeEx.invalidate();
         return true;
      }
      
      private function postProcessThicknessColorInternal(param1:int, param2:int, param3:int, param4:Vector.<StrokeVertex>, param5:GraphicsExThicknessData, param6:GraphicsExColorData) : void
      {
         var _loc13_:* = NaN;
         var _loc14_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var param1:int = param3 - param2;
         var _loc7_:Number = 1 / param1;
         var _loc15_:* = 0.0;
         var _loc12_:* = 0.00392156862745098;
         _loc11_ = param2;
         while(_loc11_ <= param3)
         {
            _loc13_ = param5.startThickness * (1 - _loc15_) + param5.endThickness * _loc15_;
            _loc14_ = _loc12_ * (param6.startRed * (1 - _loc15_) + param6.endRed * _loc15_);
            _loc8_ = _loc12_ * (param6.startGreen * (1 - _loc15_) + param6.endGreen * _loc15_);
            _loc9_ = _loc12_ * (param6.startBlue * (1 - _loc15_) + param6.endBlue * _loc15_);
            _loc10_ = param6.startAlpha * (1 - _loc15_) + param6.endAlpha * _loc15_;
            param4[_loc11_].thickness = _loc13_;
            param4[_loc11_].r1 = _loc14_;
            param4[_loc11_].r2 = _loc14_;
            param4[_loc11_].g1 = _loc8_;
            param4[_loc11_].g2 = _loc8_;
            param4[_loc11_].b1 = _loc9_;
            param4[_loc11_].b2 = _loc9_;
            param4[_loc11_].a1 = _loc10_;
            param4[_loc11_].a2 = _loc10_;
            _loc15_ = _loc15_ + _loc7_;
            _loc11_++;
         }
      }
      
      private function postProcessColorInternal(param1:int, param2:int, param3:int, param4:Vector.<StrokeVertex>, param5:GraphicsExColorData) : void
      {
         var _loc12_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc11_:* = NaN;
         var _loc6_:Number = 1 / param1;
         var _loc13_:* = 0.0;
         var _loc10_:* = 0.00392156862745098;
         _loc11_ = param2;
         while(_loc11_ <= param3)
         {
            _loc12_ = _loc10_ * (param5.startRed * (1 - _loc13_) + param5.endRed * _loc13_);
            _loc7_ = _loc10_ * (param5.startGreen * (1 - _loc13_) + param5.endGreen * _loc13_);
            _loc8_ = _loc10_ * (param5.startBlue * (1 - _loc13_) + param5.endBlue * _loc13_);
            _loc9_ = param5.startAlpha * (1 - _loc13_) + param5.endAlpha * _loc13_;
            param4[_loc11_].r1 = _loc12_;
            param4[_loc11_].r2 = _loc12_;
            param4[_loc11_].g1 = _loc7_;
            param4[_loc11_].g2 = _loc7_;
            param4[_loc11_].b1 = _loc8_;
            param4[_loc11_].b2 = _loc8_;
            param4[_loc11_].a1 = _loc9_;
            param4[_loc11_].a2 = _loc9_;
            _loc13_ = _loc13_ + _loc6_;
            _loc11_++;
         }
      }
      
      protected function postProcessThicknessInternal(param1:int, param2:int, param3:int, param4:Vector.<StrokeVertex>, param5:GraphicsExThicknessData) : void
      {
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var param1:int = param3 - param2;
         var _loc6_:Number = 1 / param1;
         var _loc10_:* = 0.0;
         var _loc9_:* = 0.00392156862745098;
         _loc8_ = param2;
         while(_loc8_ <= param3)
         {
            _loc7_ = param5.startThickness * (1 - _loc10_) + param5.endThickness * _loc10_;
            param4[_loc8_].thickness = _loc7_;
            _loc10_ = _loc10_ + _loc6_;
            _loc8_++;
         }
      }
      
      override protected function getStrokeInstance() : Stroke
      {
         _currentStrokeEx = new starling.display.graphicsEx.StrokeEx();
         return _currentStrokeEx as Stroke;
      }
      
      protected function drawPointsInternal(param1:Vector.<Number>) : void
      {
         var _loc3_:* = NaN;
         var _loc6_:* = 0;
         var _loc5_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:int = param1.length;
         if(_loc2_ > 0)
         {
            _loc3_ = 1 / (0.5 * _loc2_);
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               _loc5_ = param1[_loc6_];
               _loc4_ = param1[_loc6_ + 1];
               if(_loc6_ == 0 && _penPosX != _penPosX)
               {
                  moveTo(_loc5_,_loc4_);
               }
               else
               {
                  lineTo(_loc5_,_loc4_);
               }
               _loc6_ = _loc6_ + 2;
            }
         }
      }
      
      private function calcNaturalCubic(param1:int, param2:Vector.<Number>) : Vector.<Cubic>
      {
         var _loc7_:* = 0;
         var _loc4_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         var _loc6_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         var _loc3_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         _loc4_[0] = 0.5;
         _loc7_ = 1;
         while(_loc7_ < param1)
         {
            _loc4_[_loc7_] = 1 / (4 - _loc4_[_loc7_ - 1]);
            _loc7_++;
         }
         _loc4_[param1] = 1 / (2 - _loc4_[param1 - 1]);
         _loc6_[0] = 3 * (param2[1] - param2[0]) * _loc4_[0];
         _loc7_ = 1;
         while(_loc7_ < param1)
         {
            _loc6_[_loc7_] = (3 * (param2[_loc7_ + 1] - param2[_loc7_ - 1]) - _loc6_[_loc7_ - 1]) * _loc4_[_loc7_];
            _loc7_++;
         }
         _loc6_[param1] = (3 * (param2[param1] - param2[param1 - 1]) - _loc6_[param1 - 1]) * _loc4_[param1];
         _loc3_[param1] = _loc6_[param1];
         _loc7_ = param1 - 1;
         while(_loc7_ >= 0)
         {
            _loc3_[_loc7_] = _loc6_[_loc7_] - _loc4_[_loc7_] * _loc3_[_loc7_ + 1];
            _loc7_--;
         }
         var _loc5_:Vector.<Cubic> = new Vector.<Cubic>(param1);
         _loc7_ = 0;
         while(_loc7_ < param1)
         {
            _loc5_[_loc7_] = new Cubic(param2[_loc7_],_loc3_[_loc7_],3 * (param2[_loc7_ + 1] - param2[_loc7_]) - 2 * _loc3_[_loc7_] - _loc3_[_loc7_ + 1],2 * (param2[_loc7_] - param2[_loc7_ + 1]) + _loc3_[_loc7_] + _loc3_[_loc7_ + 1]);
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function calcClosedNaturalCubic(param1:int, param2:Vector.<Number>) : Vector.<Cubic>
      {
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc9_:* = NaN;
         var _loc11_:* = NaN;
         var _loc10_:* = 0;
         var _loc4_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         var _loc5_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         var _loc12_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         var _loc3_:Vector.<Number> = new Vector.<Number>(param1 + 1);
         _loc11_ = 0.25;
         var _loc13_:* = 0.25;
         _loc5_[1] = _loc13_;
         _loc4_[1] = _loc13_;
         _loc12_[0] = _loc11_ * 3 * (param2[1] - param2[param1]);
         _loc9_ = 4.0;
         _loc6_ = 3 * (param2[0] - param2[param1 - 1]);
         _loc7_ = 1.0;
         _loc10_ = 1;
         while(_loc10_ < param1)
         {
            _loc11_ = §§dup(1 / (4 - _loc5_[_loc10_]));
            _loc5_[_loc10_ + 1] = 1 / (4 - _loc5_[_loc10_]);
            _loc4_[_loc10_ + 1] = -_loc11_ * _loc4_[_loc10_];
            _loc12_[_loc10_] = _loc11_ * (3 * (param2[_loc10_ + 1] - param2[_loc10_ - 1]) - _loc12_[_loc10_ - 1]);
            _loc9_ = _loc9_ - _loc7_ * _loc4_[_loc10_];
            _loc6_ = _loc6_ - _loc7_ * _loc12_[_loc10_ - 1];
            _loc7_ = -_loc5_[_loc10_] * _loc7_;
            _loc10_++;
         }
         _loc9_ = _loc9_ - (_loc7_ + 1) * (_loc5_[param1] + _loc4_[param1]);
         _loc12_[param1] = _loc6_ - (_loc7_ + 1) * _loc12_[param1 - 1];
         _loc3_[param1] = _loc12_[param1] / _loc9_;
         _loc3_[param1 - 1] = _loc12_[param1 - 1] - (_loc5_[param1] + _loc4_[param1]) * _loc3_[param1];
         _loc10_ = param1 - 2;
         while(_loc10_ >= 0)
         {
            _loc3_[_loc10_] = _loc12_[_loc10_] - _loc5_[_loc10_ + 1] * _loc3_[_loc10_ + 1] - _loc4_[_loc10_ + 1] * _loc3_[param1];
            _loc10_--;
         }
         var _loc8_:Vector.<Cubic> = new Vector.<Cubic>(param1 + 1);
         _loc10_ = 0;
         while(_loc10_ < param1)
         {
            _loc8_[_loc10_] = new Cubic(param2[_loc10_],_loc3_[_loc10_],3 * (param2[_loc10_ + 1] - param2[_loc10_]) - 2 * _loc3_[_loc10_] - _loc3_[_loc10_ + 1],2 * (param2[_loc10_] - param2[_loc10_ + 1]) + _loc3_[_loc10_] + _loc3_[_loc10_ + 1]);
            _loc10_++;
         }
         _loc8_[param1] = new Cubic(param2[param1],_loc3_[param1],3 * (param2[0] - param2[param1]) - 2 * _loc3_[param1] - _loc3_[0],2 * (param2[param1] - param2[0]) + _loc3_[param1] + _loc3_[0]);
         return _loc8_;
      }
   }
}

class Cubic
{
    
   private var a:Number;
   
   private var b:Number;
   
   private var c:Number;
   
   private var d:Number;
   
   function Cubic(param1:Number, param2:Number, param3:Number, param4:Number)
   {
      super();
      this.a = param1;
      this.b = param2;
      this.c = param3;
      this.d = param4;
   }
   
   public function eval(param1:Number) : Number
   {
      return ((d * param1 + c) * param1 + b) * param1 + a;
   }
}
