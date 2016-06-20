package starling.textures
{
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.core.RenderSupport;
   import starling.display.DisplayObject;
   import flash.geom.Matrix;
   import starling.core.Starling;
   import flash.display3D.Context3D;
   import starling.errors.MissingContextError;
   import starling.utils.execute;
   import flash.display3D.textures.TextureBase;
   import starling.utils.getNextPowerOfTwo;
   
   public class RenderTexture extends SubTexture
   {
      
      private static var sClipRect:Rectangle = new Rectangle();
       
      private const CONTEXT_POT_SUPPORT_KEY:String = "RenderTexture.supportsNonPotDimensions";
      
      private const PMA:Boolean = true;
      
      private var mActiveTexture:starling.textures.Texture;
      
      private var mBufferTexture:starling.textures.Texture;
      
      private var mHelperImage:Image;
      
      private var mDrawing:Boolean;
      
      private var mBufferReady:Boolean;
      
      private var mSupport:RenderSupport;
      
      public function RenderTexture(param1:int, param2:int, param3:Boolean = true, param4:Number = -1)
      {
         if(param4 <= 0)
         {
            var param4:Number = Starling.contentScaleFactor;
         }
         var _loc5_:Number = param1;
         var _loc8_:Number = param2;
         if(!supportsNonPotDimensions)
         {
            _loc5_ = getNextPowerOfTwo(param1 * param4) / param4;
            _loc8_ = getNextPowerOfTwo(param2 * param4) / param4;
         }
         mActiveTexture = starling.textures.Texture.empty(_loc5_,_loc8_,true,false,true,param4);
         mActiveTexture.root.onRestore = mActiveTexture.root.clear;
         super(mActiveTexture,new Rectangle(0,0,param1,param2),true,null,false);
         var _loc6_:Number = mActiveTexture.root.width;
         var _loc7_:Number = mActiveTexture.root.height;
         mSupport = new RenderSupport();
         mSupport.setOrthographicProjection(0,0,_loc6_,_loc7_);
         if(param3)
         {
            mBufferTexture = starling.textures.Texture.empty(_loc5_,_loc8_,true,false,true,param4);
            mBufferTexture.root.onRestore = mBufferTexture.root.clear;
            mHelperImage = new Image(mBufferTexture);
            mHelperImage.smoothing = "none";
         }
      }
      
      override public function dispose() : void
      {
         mSupport.dispose();
         mActiveTexture.dispose();
         if(isPersistent)
         {
            mBufferTexture.dispose();
            mHelperImage.dispose();
         }
         super.dispose();
      }
      
      public function draw(param1:DisplayObject, param2:Matrix = null, param3:Number = 1.0, param4:int = 0) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(mDrawing)
         {
            render(param1,param2,param3);
         }
         else
         {
            renderBundled(render,param1,param2,param3,param4);
         }
      }
      
      public function drawBundled(param1:Function, param2:int = 0) : void
      {
         renderBundled(param1,null,null,1,param2);
      }
      
      private function render(param1:DisplayObject, param2:Matrix = null, param3:Number = 1.0) : void
      {
         mSupport.loadIdentity();
         mSupport.blendMode = param1.blendMode;
         if(param2)
         {
            mSupport.prependMatrix(param2);
         }
         else
         {
            mSupport.transformMatrix(param1);
         }
         param1.render(mSupport,param3);
      }
      
      private function renderBundled(param1:Function, param2:DisplayObject = null, param3:Matrix = null, param4:Number = 1.0, param5:int = 0) : void
      {
         var _loc6_:* = null;
         var _loc7_:Context3D = Starling.context;
         if(_loc7_ == null)
         {
            throw new MissingContextError();
         }
         if(isPersistent)
         {
            _loc6_ = mActiveTexture;
            mActiveTexture = mBufferTexture;
            mBufferTexture = _loc6_;
            mHelperImage.texture = mBufferTexture;
         }
         sClipRect.setTo(0,0,mActiveTexture.width,mActiveTexture.height);
         mSupport.pushClipRect(sClipRect);
         mSupport.setRenderTarget(mActiveTexture,param5);
         mSupport.clear();
         if(isPersistent && mBufferReady)
         {
            mHelperImage.render(mSupport,1);
         }
         else
         {
            mBufferReady = true;
         }
         var _loc8_:* = 0;
         try
         {
            mDrawing = true;
            execute(param1,param2,param3,param4);
         }
         catch(_loc9_:*)
         {
            _loc8_ = 1;
         }
         mDrawing = false;
         mSupport.finishQuadBatch();
         mSupport.nextFrame();
         mSupport.renderTarget = null;
         mSupport.popClipRect();
         if(!_loc8_)
         {
            return;
         }
         throw _loc9_;
      }
      
      public function clear(param1:uint = 0, param2:Number = 0.0) : void
      {
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         mSupport.renderTarget = mActiveTexture;
         mSupport.clear(param1,param2);
         mSupport.renderTarget = null;
      }
      
      private function get supportsNonPotDimensions() : Boolean
      {
         var _loc3_:* = null;
         var _loc1_:* = null;
         var _loc5_:Starling = Starling.current;
         var _loc4_:Context3D = Starling.context;
         var _loc2_:Object = _loc5_.contextData["RenderTexture.supportsNonPotDimensions"];
         if(_loc2_ == null)
         {
            if(_loc5_.profile != "baselineConstrained" && "createRectangleTexture" in _loc4_)
            {
               var _loc6_:* = 0;
               try
               {
                  _loc3_ = §§dup(_loc4_)["createRectangleTexture"](2,3,"bgra",true);
                  _loc4_.setRenderToTexture(_loc3_);
                  _loc4_.clear();
                  _loc4_.setRenderToBackBuffer();
                  _loc4_.createVertexBuffer(1,1);
                  _loc2_ = true;
               }
               catch(e:Error)
               {
                  _loc2_ = false;
                  _loc6_ = 0;
               }
            }
            else
            {
               _loc2_ = false;
            }
            _loc5_.contextData["RenderTexture.supportsNonPotDimensions"] = _loc2_;
         }
         return _loc2_;
      }
      
      public function get isPersistent() : Boolean
      {
         return mBufferTexture != null;
      }
      
      override public function get base() : TextureBase
      {
         return mActiveTexture.base;
      }
      
      override public function get root() : ConcreteTexture
      {
         return mActiveTexture.root;
      }
   }
}
