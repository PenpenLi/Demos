package extend
{
   import starling.display.DisplayObjectContainer;
   import starling.display.QuadBatch;
   import starling.textures.Texture;
   import starling.display.Image;
   import flash.geom.Point;
   import starling.events.EnterFrameEvent;
   
   public class MultidirectionalTileScroller extends DisplayObjectContainer
   {
       
      private var m_Canvas:QuadBatch;
      
      private var m_Width:uint;
      
      private var m_Height:uint;
      
      private var m_Texture:Texture;
      
      private var m_Image:Image;
      
      private var m_TextureNativeWidth:Number;
      
      private var m_TextureNativeHeight:Number;
      
      private var m_TextureScaleX:Number;
      
      private var m_TextureScaleY:Number;
      
      private var m_TextureWidth:Number;
      
      private var m_TextureHeight:Number;
      
      private var m_PivotPoint:Point;
      
      private var m_IsAnimating:Boolean;
      
      private var m_Speed:Number = 0;
      
      private var m_Angle:Number = 0;
      
      public function MultidirectionalTileScroller(param1:uint, param2:uint, param3:Texture, param4:Number = 1.0, param5:Number = 1.0)
      {
         super();
         m_Width = param1;
         m_Height = param2;
         m_Texture = param3;
         m_TextureScaleX = param4;
         m_TextureScaleY = param5;
         init();
      }
      
      private function init() : void
      {
         touchable = false;
         drawTexture();
      }
      
      private function drawTexture() : void
      {
         m_TextureNativeWidth = m_Texture.width;
         m_TextureNativeHeight = m_Texture.height;
         m_Image = new Image(m_Texture);
         m_Image.scaleX = m_TextureScaleX;
         m_Image.scaleY = m_TextureScaleY;
         drawCanvas();
      }
      
      private function drawCanvas() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(numChildren)
         {
            removeChildren();
         }
         m_Canvas = new QuadBatch();
         _loc1_ = 0;
         while(_loc1_ <= Math.ceil(m_Width / (m_TextureNativeWidth * m_TextureScaleX)) + 1)
         {
            _loc2_ = 0;
            while(_loc2_ <= Math.ceil(m_Height / (m_TextureNativeHeight * m_TextureScaleY)) + 1)
            {
               m_Image.x = m_TextureNativeWidth * m_TextureScaleX * _loc1_;
               m_Image.y = m_TextureNativeHeight * m_TextureScaleY * _loc2_;
               m_Canvas.addImage(m_Image);
               _loc2_++;
            }
            _loc1_++;
         }
         m_TextureWidth = m_TextureNativeWidth * m_TextureScaleX;
         m_TextureHeight = m_TextureNativeHeight * m_TextureScaleY;
         m_PivotPoint = new Point(m_Width / 2,m_Height / 2);
         m_Canvas.alignPivot();
         m_Canvas.x = m_PivotPoint.x;
         m_Canvas.y = m_PivotPoint.y;
         addChild(m_Canvas);
      }
      
      public function play(param1:Number = NaN, param2:Number = NaN) : void
      {
         this.speed = isNaN(param1)?this.speed:param1;
         this.angle = isNaN(param1)?this.angle:param2;
         m_IsAnimating = true;
         if(!m_Canvas.hasEventListener("enterFrame"))
         {
            m_Canvas.addEventListener("enterFrame",enterFrameEventHandler);
         }
      }
      
      public function stop() : void
      {
         m_IsAnimating = false;
         if(m_Canvas.hasEventListener("enterFrame"))
         {
            m_Canvas.removeEventListener("enterFrame",enterFrameEventHandler);
         }
      }
      
      private function enterFrameEventHandler(param1:EnterFrameEvent) : void
      {
         m_Canvas.x = m_Canvas.x + Math.cos(m_Angle) * m_Speed;
         m_Canvas.y = m_Canvas.y + Math.sin(m_Angle) * m_Speed;
         if(m_Canvas.x < m_PivotPoint.x - m_TextureWidth)
         {
            m_Canvas.x = m_Canvas.x + m_TextureWidth;
         }
         if(m_Canvas.x > m_PivotPoint.x + m_TextureWidth)
         {
            m_Canvas.x = m_Canvas.x - m_TextureWidth;
         }
         if(m_Canvas.y < m_PivotPoint.y - m_TextureHeight)
         {
            m_Canvas.y = m_Canvas.y + m_TextureHeight;
         }
         if(m_Canvas.y > m_PivotPoint.y + m_TextureHeight)
         {
            m_Canvas.y = m_Canvas.y - m_TextureHeight;
         }
      }
      
      override public function dispose() : void
      {
         stop();
         super.dispose();
      }
      
      public function setTexture(param1:Texture, param2:Number = 1.0, param3:Number = 1.0) : void
      {
         if(isAnimating)
         {
            stop();
         }
         if(m_Texture)
         {
            m_Texture.dispose();
         }
         m_Texture = param1;
         m_TextureScaleX = param2;
         m_TextureScaleY = m_TextureScaleY;
         drawTexture();
      }
      
      public function setSize(param1:uint, param2:uint) : void
      {
         m_Width = param1;
         m_Height = param2;
         drawCanvas();
      }
      
      public function set speed(param1:Number) : void
      {
         m_Speed = isNaN(param1) || param1 <= 0?0:Math.min(param1,Math.min(m_TextureWidth,m_TextureHeight));
      }
      
      public function get speed() : Number
      {
         return m_Speed;
      }
      
      public function set angle(param1:Number) : void
      {
         m_Angle = (isNaN(param1)?180:180 - param1) * 3.141592653589793 / 180;
      }
      
      public function get angle() : Number
      {
         return 180 - m_Angle * 180 / 3.141592653589793;
      }
      
      public function get isAnimating() : Boolean
      {
         return m_IsAnimating;
      }
      
      public function set canvasX(param1:Number) : void
      {
         m_Canvas.x = param1;
      }
      
      public function get canvasX() : Number
      {
         return m_Canvas.x;
      }
      
      public function set canvasY(param1:Number) : void
      {
         m_Canvas.y = param1;
      }
      
      public function get canvasY() : Number
      {
         return m_Canvas.y;
      }
   }
}
