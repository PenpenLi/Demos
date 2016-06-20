package lzm.starling.display
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import starling.display.Shape;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   
   public class GridMask extends Sprite
   {
       
      private var _quads:Vector.<Quad>;
      
      private var _borderShape:Shape;
      
      private var _color:uint;
      
      private var _alpha:Number;
      
      private var _border:Boolean;
      
      private var _borderColor:uint;
      
      public function GridMask(param1:uint, param2:Number, param3:Boolean, param4:uint)
      {
         super();
         _color = param1;
         _alpha = param2;
         _border = param3;
         _borderColor = param4;
      }
      
      private function createQuads() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         _quads = new Vector.<Quad>();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = new Quad(10,10,_color);
            _loc1_.alpha = _alpha;
            addChild(_loc1_);
            _quads.push(_loc1_);
            _loc2_++;
         }
         _borderShape = new Shape();
         _borderShape.touchable = false;
         addChild(_borderShape);
      }
      
      private function drawGridRect(param1:Rectangle) : void
      {
         _borderShape.graphics.clear();
         if(_border)
         {
            _borderShape.graphics.lineStyle(1,_borderColor);
            _borderShape.graphics.moveTo(param1.x,param1.y);
            _borderShape.graphics.lineTo(param1.x + param1.width,param1.y);
            _borderShape.graphics.lineTo(param1.x + param1.width,param1.y + param1.height);
            _borderShape.graphics.lineTo(param1.x,param1.y + param1.height);
            _borderShape.graphics.lineTo(param1.x,param1.y);
            _borderShape.graphics.endFill();
         }
      }
      
      private function tweenQuads(param1:Rectangle) : void
      {
         gridRect = param1;
         var tmpX:Number = _quads[0].x;
         var tmpY:Number = _quads[0].y;
         _quads[0].y = -_quads[0].height;
         Starling.current.juggler.tween(_quads[0],0.3,{
            "x":tmpX,
            "y":tmpY,
            "transition":"easeInOut"
         });
         tmpX = _quads[1].x;
         tmpY = _quads[1].y;
         _quads[1].x = -_quads[1].width;
         Starling.current.juggler.tween(_quads[1],0.3,{
            "x":tmpX,
            "y":tmpY,
            "transition":"easeInOut"
         });
         tmpX = _quads[2].x;
         tmpY = _quads[2].y;
         _quads[2].x = _quads[2].x + _quads[2].width;
         Starling.current.juggler.tween(_quads[2],0.3,{
            "x":tmpX,
            "y":tmpY,
            "transition":"easeInOut"
         });
         tmpX = _quads[3].x;
         tmpY = _quads[3].y;
         _quads[3].y = _quads[3].y + _quads[3].height;
         Starling.current.juggler.tween(_quads[3],0.3,{
            "x":tmpX,
            "y":tmpY,
            "transition":"easeInOut",
            "onComplete":function():void
            {
               drawGridRect(gridRect);
            }
         });
      }
      
      public function show(param1:DisplayObjectContainer, param2:Rectangle, param3:Rectangle, param4:Boolean) : void
      {
         if(_quads == null)
         {
            createQuads();
         }
         _borderShape.graphics.clear();
         _quads[0].x = 0;
         _quads[0].y = 0;
         _quads[0].width = param2.width;
         _quads[0].height = param3.y;
         _quads[1].x = 0;
         _quads[1].y = param3.y;
         _quads[1].width = param3.x;
         _quads[1].height = param2.height - param3.y;
         _quads[2].x = param3.x;
         _quads[2].y = param3.y + param3.height;
         _quads[2].width = param2.width - param3.x;
         _quads[2].height = param2.height - (param3.y + param3.height);
         _quads[3].x = param3.x + param3.width;
         _quads[3].y = param3.y;
         _quads[3].width = param2.width - (param3.x + param3.width);
         _quads[3].height = param3.height;
         if(param4)
         {
            tweenQuads(param3);
         }
         else
         {
            drawGridRect(param3);
         }
         param1.addChildAt(this,0);
      }
   }
}
