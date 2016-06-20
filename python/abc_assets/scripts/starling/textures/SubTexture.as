package starling.textures
{
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import starling.utils.VertexData;
   import starling.utils.MatrixUtil;
   import starling.utils.RectangleUtil;
   import flash.display3D.textures.TextureBase;
   
   public class SubTexture extends starling.textures.Texture
   {
      
      private static var sTexCoords:Point = new Point();
      
      private static var sMatrix:Matrix = new Matrix();
       
      private var mParent:starling.textures.Texture;
      
      private var mOwnsParent:Boolean;
      
      private var mFrame:Rectangle;
      
      private var mRotated:Boolean;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mTransformationMatrix:Matrix;
      
      public function SubTexture(param1:starling.textures.Texture, param2:Rectangle, param3:Boolean = false, param4:Rectangle = null, param5:Boolean = false)
      {
         super();
         if(param2 == null)
         {
            var param2:Rectangle = new Rectangle(0,0,param1.width,param1.height);
         }
         mParent = param1;
         mFrame = param4?param4.clone():null;
         mOwnsParent = param3;
         mRotated = param5;
         mWidth = param5?param2.height:param2.width;
         mHeight = param5?param2.width:param2.height;
         mTransformationMatrix = new Matrix();
         if(param5)
         {
            mTransformationMatrix.translate(0,-1);
            mTransformationMatrix.rotate(3.141592653589793 / 2);
         }
         mTransformationMatrix.scale(param2.width / mParent.width,param2.height / mParent.height);
         mTransformationMatrix.translate(param2.x / mParent.width,param2.y / mParent.height);
      }
      
      override public function dispose() : void
      {
         if(mOwnsParent)
         {
            mParent.dispose();
         }
         super.dispose();
      }
      
      override public function adjustVertexData(param1:VertexData, param2:int, param3:int) : void
      {
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc4_:int = param2 * 8 + 6;
         var _loc7_:* = 6;
         adjustTexCoords(param1.rawData,_loc4_,_loc7_,param3);
         if(mFrame)
         {
            if(param3 != 4)
            {
               throw new ArgumentError("Textures with a frame can only be used on quads");
            }
            _loc6_ = mFrame.width + mFrame.x - mWidth;
            _loc5_ = mFrame.height + mFrame.y - mHeight;
            param1.translateVertex(param2,-mFrame.x,-mFrame.y);
            param1.translateVertex(param2 + 1,-_loc6_,-mFrame.y);
            param1.translateVertex(param2 + 2,-mFrame.x,-_loc5_);
            param1.translateVertex(param2 + 3,-_loc6_,-_loc5_);
         }
      }
      
      override public function adjustTexCoords(param1:Vector.<Number>, param2:int = 0, param3:int = 0, param4:int = -1) : void
      {
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc9_:* = 0;
         if(param4 < 0)
         {
            var param4:int = (param1.length - param2 - 2) / (param3 + 2) + 1;
         }
         var _loc8_:int = param2 + param4 * (2 + param3);
         var _loc7_:* = this;
         sMatrix.identity();
         while(_loc7_)
         {
            sMatrix.concat(_loc7_.mTransformationMatrix);
            _loc7_ = _loc7_.parent as SubTexture;
         }
         _loc9_ = param2;
         while(_loc9_ < _loc8_)
         {
            _loc6_ = param1[_loc9_];
            _loc5_ = param1[_loc9_ + 1];
            MatrixUtil.transformCoords(sMatrix,_loc6_,_loc5_,sTexCoords);
            param1[_loc9_] = sTexCoords.x;
            param1[_loc9_ + 1] = sTexCoords.y;
            _loc9_ = _loc9_ + (2 + param3);
         }
      }
      
      public function get parent() : starling.textures.Texture
      {
         return mParent;
      }
      
      public function get ownsParent() : Boolean
      {
         return mOwnsParent;
      }
      
      public function get rotated() : Boolean
      {
         return mRotated;
      }
      
      public function get clipping() : Rectangle
      {
         var _loc2_:Point = new Point();
         var _loc1_:Point = new Point();
         MatrixUtil.transformCoords(mTransformationMatrix,0,0,_loc2_);
         MatrixUtil.transformCoords(mTransformationMatrix,1,1,_loc1_);
         var _loc3_:Rectangle = new Rectangle(_loc2_.x,_loc2_.y,_loc1_.x - _loc2_.x,_loc1_.y - _loc2_.y);
         RectangleUtil.normalize(_loc3_);
         return _loc3_;
      }
      
      public function get transformationMatrix() : Matrix
      {
         return mTransformationMatrix;
      }
      
      override public function get base() : TextureBase
      {
         return mParent.base;
      }
      
      override public function get root() : ConcreteTexture
      {
         return mParent.root;
      }
      
      override public function get format() : String
      {
         return mParent.format;
      }
      
      override public function get width() : Number
      {
         return mWidth;
      }
      
      override public function get height() : Number
      {
         return mHeight;
      }
      
      override public function get nativeWidth() : Number
      {
         return mWidth * scale;
      }
      
      override public function get nativeHeight() : Number
      {
         return mHeight * scale;
      }
      
      override public function get mipMapping() : Boolean
      {
         return mParent.mipMapping;
      }
      
      override public function get premultipliedAlpha() : Boolean
      {
         return mParent.premultipliedAlpha;
      }
      
      override public function get scale() : Number
      {
         return mParent.scale;
      }
      
      override public function get repeat() : Boolean
      {
         return mParent.repeat;
      }
      
      override public function get frame() : Rectangle
      {
         return mFrame;
      }
   }
}
