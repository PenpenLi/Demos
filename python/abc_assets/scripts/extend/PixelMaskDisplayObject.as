package extend
{
   import starling.display.DisplayObjectContainer;
   import starling.display.DisplayObject;
   import starling.textures.RenderTexture;
   import starling.display.Image;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.core.RenderSupport;
   import flash.geom.Matrix;
   import starling.display.BlendMode;
   
   public class PixelMaskDisplayObject extends DisplayObjectContainer
   {
      
      private static const MASK_MODE_NORMAL:String = "mask";
      
      private static const MASK_MODE_INVERTED:String = "maskinverted";
      
      private static var _a:Number;
      
      private static var _b:Number;
      
      private static var _c:Number;
      
      private static var _d:Number;
      
      private static var _tx:Number;
      
      private static var _ty:Number;
       
      private var _mask:DisplayObject;
      
      private var _renderTexture:RenderTexture;
      
      private var _maskRenderTexture:RenderTexture;
      
      private var _image:Image;
      
      private var _maskImage:Image;
      
      private var _superRenderFlag:Boolean = false;
      
      private var _inverted:Boolean = false;
      
      private var _scaleFactor:Number;
      
      private var _isAnimated:Boolean = true;
      
      private var _maskRendered:Boolean = false;
      
      public function PixelMaskDisplayObject(param1:Number = -1, param2:Boolean = true)
      {
         super();
         _isAnimated = param2;
         _scaleFactor = param1;
         BlendMode.register("mask","zero","sourceAlpha");
         BlendMode.register("maskinverted","zero","oneMinusSourceAlpha");
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,0,true);
      }
      
      public function get isAnimated() : Boolean
      {
         return _isAnimated;
      }
      
      public function set isAnimated(param1:Boolean) : void
      {
         _isAnimated = param1;
      }
      
      override public function dispose() : void
      {
         clearRenderTextures();
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         super.dispose();
      }
      
      private function onContextCreated(param1:Object) : void
      {
         refreshRenderTextures();
      }
      
      public function get inverted() : Boolean
      {
         return _inverted;
      }
      
      public function set inverted(param1:Boolean) : void
      {
         _inverted = param1;
         refreshRenderTextures(null);
      }
      
      public function set mask(param1:DisplayObject) : void
      {
         if(_mask)
         {
            _mask = null;
         }
         if(param1)
         {
            _mask = param1;
            if(_mask.width == 0 || _mask.height == 0)
            {
               throw new Error("Mask must have dimensions. Current dimensions are " + _mask.width + "x" + _mask.height + ".");
            }
            refreshRenderTextures(null);
         }
         else
         {
            clearRenderTextures();
         }
      }
      
      private function clearRenderTextures() : void
      {
         if(_maskRenderTexture)
         {
            _maskRenderTexture.dispose();
         }
         if(_renderTexture)
         {
            _renderTexture.dispose();
         }
         if(_image)
         {
            _image.dispose();
         }
         if(_maskImage)
         {
            _maskImage.dispose();
         }
      }
      
      private function refreshRenderTextures(param1:Event = null) : void
      {
         if(_mask)
         {
            clearRenderTextures();
            _maskRenderTexture = new RenderTexture(_mask.width,_mask.height,false,_scaleFactor);
            _renderTexture = new RenderTexture(_mask.width,_mask.height,false,_scaleFactor);
            _image = new Image(_renderTexture);
            _maskImage = new Image(_maskRenderTexture);
            if(_inverted)
            {
               _maskImage.blendMode = "maskinverted";
            }
            else
            {
               _maskImage.blendMode = "mask";
            }
         }
         _maskRendered = false;
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(_isAnimated || !_isAnimated && !_maskRendered)
         {
            if(_superRenderFlag || !_mask)
            {
               super.render(param1,param2);
            }
            else if(_mask)
            {
               _maskRenderTexture.draw(_mask);
               _renderTexture.drawBundled(drawRenderTextures);
               _image.render(param1,param2);
               _maskRendered = true;
            }
         }
         else
         {
            _image.render(param1,param2);
         }
      }
      
      private function drawRenderTextures(param1:DisplayObject = null, param2:Matrix = null, param3:Number = 1.0) : void
      {
         _a = this.transformationMatrix.a;
         _b = this.transformationMatrix.b;
         _c = this.transformationMatrix.c;
         _d = this.transformationMatrix.d;
         _tx = this.transformationMatrix.tx;
         _ty = this.transformationMatrix.ty;
         this.transformationMatrix.a = 1;
         this.transformationMatrix.b = 0;
         this.transformationMatrix.c = 0;
         this.transformationMatrix.d = 1;
         this.transformationMatrix.tx = 0;
         this.transformationMatrix.ty = 0;
         _superRenderFlag = true;
         _renderTexture.draw(this);
         _superRenderFlag = false;
         this.transformationMatrix.a = _a;
         this.transformationMatrix.b = _b;
         this.transformationMatrix.c = _c;
         this.transformationMatrix.d = _d;
         this.transformationMatrix.tx = _tx;
         this.transformationMatrix.ty = _ty;
         _renderTexture.draw(_maskImage);
      }
   }
}
