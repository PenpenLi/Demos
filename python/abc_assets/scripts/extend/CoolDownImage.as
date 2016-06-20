package extend
{
   import starling.display.DisplayObject;
   import flash.geom.Matrix;
   import starling.core.Starling;
   import com.adobe.utils.AGALMiniAssembler;
   import starling.textures.Texture;
   import starling.utils.VertexData;
   import flash.display3D.VertexBuffer3D;
   import flash.display3D.IndexBuffer3D;
   import starling.events.Event;
   import flash.geom.Rectangle;
   import flash.display3D.Context3D;
   import starling.errors.MissingContextError;
   import starling.core.RenderSupport;
   
   public class CoolDownImage extends DisplayObject
   {
      
      private static var PROGRAM_NAME:String = "CoolDown";
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sRenderAlpha:Vector.<Number> = new <Number>[1,1,1,1];
       
      private var mProgress:Number = 0;
      
      private var mTexture:Texture;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var radiansW2H:Number;
      
      private var mVertexData:VertexData;
      
      private var mVertexBuffer:VertexBuffer3D;
      
      private var mIndexData:Vector.<uint>;
      
      private var mIndexBuffer:IndexBuffer3D;
      
      public function CoolDownImage(param1:Texture, param2:Number = 0)
      {
         super();
         mTexture = param1;
         var _loc3_:Rectangle = param1.frame;
         mWidth = _loc3_?_loc3_.width:param1.width;
         mHeight = _loc3_?_loc3_.height:param1.height;
         radiansW2H = Math.atan2(mWidth,mHeight);
         setupVertices();
         this.progress = param2;
         registerPrograms();
         Starling.current.addEventListener("context3DCreate",onContextCreated);
      }
      
      private static function registerPrograms() : void
      {
         var _loc4_:Starling = Starling.current;
         if(_loc4_.hasProgram(PROGRAM_NAME))
         {
            return;
         }
         var _loc2_:String = "m44 op, va0, vc0 \nmul v0, va1, vc4 \nmov v6, va2 \n";
         var _loc5_:String = "tex ft0, v6, fs0 <2d,linear,nomip> \nmov oc, ft0 \n";
         var _loc1_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc1_.assemble("vertex",_loc2_);
         var _loc3_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc3_.assemble("fragment",_loc5_);
         _loc4_.registerProgram(PROGRAM_NAME,_loc1_.agalcode,_loc3_.agalcode);
      }
      
      override public function dispose() : void
      {
         Starling.current.removeEventListener("context3DCreate",onContextCreated);
         if(mVertexBuffer)
         {
            mVertexBuffer.dispose();
         }
         if(mIndexBuffer)
         {
            mIndexBuffer.dispose();
         }
         super.dispose();
      }
      
      private function onContextCreated(param1:Event) : void
      {
         createBuffers();
         registerPrograms();
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(param2 == null)
         {
            var param2:Rectangle = new Rectangle();
         }
         var _loc3_:Matrix = param1 == this?null:getTransformationMatrix(param1,sHelperMatrix);
         return mVertexData.getBounds(_loc3_,0,-1,param2);
      }
      
      private function setupVertices() : void
      {
         var _loc1_:* = 0;
         mVertexData = new VertexData(7);
         mVertexData.setUniformColor(16711680);
         mVertexData.setPosition(0,mWidth * 0.5,mHeight * 0.5);
         mVertexData.setPosition(1,mWidth * 0.5,0);
         mVertexData.setPosition(2,0,0);
         mVertexData.setPosition(3,0,0);
         mVertexData.setPosition(4,0,0);
         mVertexData.setPosition(5,0,0);
         mVertexData.setPosition(6,0,0);
         mVertexData.setTexCoords(0,0.5,0.5);
         mVertexData.setTexCoords(1,0.5,0);
         mVertexData.setTexCoords(2,0,0);
         mVertexData.setTexCoords(3,0,1);
         mVertexData.setTexCoords(4,1,1);
         mVertexData.setTexCoords(5,1,0);
         mVertexData.setTexCoords(6,0.5,0);
         mIndexData = new Vector.<uint>(0);
         mIndexData.push(0,1,2);
         mIndexData.push(0,2,3);
         mIndexData.push(0,3,4);
         mIndexData.push(0,4,5);
         mIndexData.push(0,5,6);
      }
      
      private function createBuffers() : void
      {
         var _loc1_:Context3D = Starling.context;
         if(_loc1_ == null)
         {
            throw new MissingContextError();
         }
         if(mVertexBuffer)
         {
            mVertexBuffer.dispose();
         }
         if(mIndexBuffer)
         {
            mIndexBuffer.dispose();
         }
         mVertexBuffer = _loc1_.createVertexBuffer(mVertexData.numVertices,8);
         mVertexBuffer.uploadFromVector(mVertexData.rawData,0,mVertexData.numVertices);
         mIndexBuffer = _loc1_.createIndexBuffer(mIndexData.length);
         mIndexBuffer.uploadFromVector(mIndexData,0,mIndexData.length);
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         param1.finishQuadBatch();
         param1.raiseDrawCount();
         var param2:Number = param2 * this.alpha;
         var _loc4_:* = mTexture.premultipliedAlpha?param2:1.0;
         sRenderAlpha[2] = _loc4_;
         _loc4_ = _loc4_;
         sRenderAlpha[1] = _loc4_;
         sRenderAlpha[0] = _loc4_;
         sRenderAlpha[3] = param2;
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         param1.applyBlendMode(false);
         _loc3_.setTextureAt(0,mTexture.base);
         _loc3_.setProgram(Starling.current.getProgram(PROGRAM_NAME));
         _loc3_.setVertexBufferAt(0,mVertexBuffer,0,"float2");
         _loc3_.setVertexBufferAt(1,mVertexBuffer,2,"float4");
         _loc3_.setVertexBufferAt(2,mVertexBuffer,6,"float2");
         _loc3_.setProgramConstantsFromMatrix("vertex",0,param1.mvpMatrix3D,true);
         _loc3_.setProgramConstantsFromVector("vertex",4,sRenderAlpha,1);
         _loc3_.drawTriangles(mIndexBuffer,0,5);
         _loc3_.setTextureAt(0,null);
         _loc3_.setVertexBufferAt(0,null);
         _loc3_.setVertexBufferAt(1,null);
         _loc3_.setVertexBufferAt(2,null);
      }
      
      public function get progress() : Number
      {
         return mProgress;
      }
      
      public function set progress(param1:Number) : void
      {
         var _loc5_:* = NaN;
         var _loc4_:* = NaN;
         if(param1 > 1)
         {
            mProgress = 1;
         }
         else if(param1 < 0)
         {
            mProgress = 0;
         }
         else
         {
            mProgress = param1;
         }
         var _loc2_:Number = 3.141592653589793 * 2 * mProgress;
         var _loc6_:Number = mWidth * 0.5;
         var _loc3_:Number = mHeight * 0.5;
         if(_loc2_ < radiansW2H)
         {
            _loc5_ = _loc6_ + _loc3_ * Math.tan(_loc2_);
            mVertexData.setPosition(6,_loc5_,0);
            mVertexData.setPosition(2,0,0);
            mVertexData.setPosition(3,0,mHeight);
            mVertexData.setPosition(4,mWidth,mHeight);
            mVertexData.setPosition(5,mWidth,0);
            mVertexData.setTexCoords(6,_loc5_ / mWidth,0);
            mVertexData.setTexCoords(2,0,0);
            mVertexData.setTexCoords(3,0,1);
            mVertexData.setTexCoords(4,1,1);
            mVertexData.setTexCoords(5,1,0);
         }
         else if(_loc2_ < 3.141592653589793 - radiansW2H)
         {
            mVertexData.setPosition(6,_loc6_,_loc3_);
            _loc4_ = _loc6_ - _loc6_ / Math.tan(_loc2_);
            mVertexData.setPosition(5,mWidth,_loc4_);
            mVertexData.setPosition(2,0,0);
            mVertexData.setPosition(3,0,mHeight);
            mVertexData.setPosition(4,mWidth,mHeight);
            mVertexData.setTexCoords(5,1,_loc4_ / mHeight);
            mVertexData.setTexCoords(2,0,0);
            mVertexData.setTexCoords(3,0,1);
            mVertexData.setTexCoords(4,1,1);
         }
         else if(_loc2_ < 3.141592653589793 + radiansW2H)
         {
            mVertexData.setPosition(6,_loc6_,_loc3_);
            mVertexData.setPosition(5,_loc6_,_loc3_);
            _loc5_ = _loc6_ + _loc3_ * Math.tan(3.141592653589793 - _loc2_);
            mVertexData.setPosition(4,_loc5_,mHeight);
            mVertexData.setPosition(2,0,0);
            mVertexData.setPosition(3,0,mHeight);
            mVertexData.setTexCoords(4,_loc5_ / mWidth,1);
            mVertexData.setTexCoords(2,0,0);
            mVertexData.setTexCoords(3,0,1);
         }
         else if(_loc2_ < 2 * 3.141592653589793 - radiansW2H)
         {
            mVertexData.setPosition(6,_loc6_,_loc3_);
            mVertexData.setPosition(5,_loc6_,_loc3_);
            mVertexData.setPosition(4,_loc6_,_loc3_);
            _loc4_ = _loc3_ + _loc6_ / Math.tan(_loc2_ - 3.141592653589793);
            mVertexData.setPosition(3,0,_loc4_);
            mVertexData.setPosition(2,0,0);
            mVertexData.setTexCoords(3,0,_loc4_ / mHeight);
            mVertexData.setTexCoords(2,0,0);
         }
         else
         {
            mVertexData.setPosition(6,_loc6_,_loc3_);
            mVertexData.setPosition(5,_loc6_,_loc3_);
            mVertexData.setPosition(4,_loc6_,_loc3_);
            mVertexData.setPosition(3,_loc6_,_loc3_);
            _loc5_ = _loc6_ - _loc3_ * Math.tan(2 * 3.141592653589793 - _loc2_);
            mVertexData.setPosition(2,_loc5_,0);
            mVertexData.setTexCoords(2,_loc5_ / mWidth,0);
         }
         createBuffers();
      }
   }
}
