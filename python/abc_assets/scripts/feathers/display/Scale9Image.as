package feathers.display
{
   import starling.display.Sprite;
   import feathers.core.IValidating;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.display.Image;
   import flash.geom.Rectangle;
   import feathers.textures.Scale9Textures;
   import flash.errors.IllegalOperationError;
   import starling.textures.Texture;
   import starling.display.QuadBatch;
   import feathers.core.ValidationQueue;
   import starling.display.DisplayObject;
   import starling.utils.MatrixUtil;
   import starling.events.Event;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import starling.core.Starling;
   
   public class Scale9Image extends Sprite implements IValidating
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      private static var helperImage:Image;
       
      private var _propertiesChanged:Boolean = true;
      
      private var _layoutChanged:Boolean = true;
      
      private var _renderingChanged:Boolean = true;
      
      private var _frame:Rectangle;
      
      private var _textures:Scale9Textures;
      
      private var _width:Number = NaN;
      
      private var _height:Number = NaN;
      
      private var _textureScale:Number = 1;
      
      private var _smoothing:String = "bilinear";
      
      private var _color:uint = 16777215;
      
      private var _useSeparateBatch:Boolean = true;
      
      private var _hitArea:Rectangle;
      
      private var _batch:QuadBatch;
      
      private var _isValidating:Boolean = false;
      
      private var _isInvalid:Boolean = false;
      
      private var _validationQueue:ValidationQueue;
      
      private var _depth:int = -1;
      
      public function Scale9Image(param1:Scale9Textures, param2:Number = 1)
      {
         super();
         this.textures = param1;
         this._textureScale = param2;
         this._hitArea = new Rectangle();
         this.readjustSize();
         this._batch = new QuadBatch();
         this._batch.touchable = false;
         this.addChild(this._batch);
         this.addEventListener("flatten",flattenHandler);
         this.addEventListener("addedToStage",addedToStageHandler);
      }
      
      public function get textures() : Scale9Textures
      {
         return this._textures;
      }
      
      public function set textures(param1:Scale9Textures) : void
      {
         if(!param1)
         {
            throw new IllegalOperationError("Scale9Image textures cannot be null.");
         }
         if(this._textures == param1)
         {
            return;
         }
         this._textures = param1;
         var _loc2_:Texture = this._textures.texture;
         this._frame = _loc2_.frame;
         if(!this._frame)
         {
            this._frame = new Rectangle(0,0,_loc2_.width,_loc2_.height);
         }
         this._layoutChanged = true;
         this._renderingChanged = true;
         this.invalidate();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         var _loc2_:* = param1;
         this._hitArea.width = _loc2_;
         this._width = _loc2_;
         this._layoutChanged = true;
         this.invalidate();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         var _loc2_:* = param1;
         this._hitArea.height = _loc2_;
         this._height = _loc2_;
         this._layoutChanged = true;
         this.invalidate();
      }
      
      public function get textureScale() : Number
      {
         return this._textureScale;
      }
      
      public function set textureScale(param1:Number) : void
      {
         if(this._textureScale == param1)
         {
            return;
         }
         this._textureScale = param1;
         this._layoutChanged = true;
         this.invalidate();
      }
      
      public function get smoothing() : String
      {
         return this._smoothing;
      }
      
      public function set smoothing(param1:String) : void
      {
         if(this._smoothing == param1)
         {
            return;
         }
         this._smoothing = param1;
         this._propertiesChanged = true;
         this.invalidate();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         this._propertiesChanged = true;
         this.invalidate();
      }
      
      public function get useSeparateBatch() : Boolean
      {
         return this._useSeparateBatch;
      }
      
      public function set useSeparateBatch(param1:Boolean) : void
      {
         if(this._useSeparateBatch == param1)
         {
            return;
         }
         this._useSeparateBatch = param1;
         this._renderingChanged = true;
         this.invalidate();
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(!param2)
         {
            var param2:Rectangle = new Rectangle();
         }
         var _loc5_:* = 1.7976931348623157E308;
         var _loc4_:* = -1.7976931348623157E308;
         var _loc6_:* = 1.7976931348623157E308;
         var _loc3_:* = -1.7976931348623157E308;
         if(param1 == this)
         {
            _loc5_ = this._hitArea.x;
            _loc6_ = this._hitArea.y;
            _loc4_ = this._hitArea.x + this._hitArea.width;
            _loc3_ = this._hitArea.y + this._hitArea.height;
         }
         else
         {
            this.getTransformationMatrix(param1,HELPER_MATRIX);
            MatrixUtil.transformCoords(HELPER_MATRIX,this._hitArea.x,this._hitArea.y,HELPER_POINT);
            _loc5_ = _loc5_ < HELPER_POINT.x?_loc5_:HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x?_loc4_:HELPER_POINT.x;
            _loc6_ = _loc6_ < HELPER_POINT.y?_loc6_:HELPER_POINT.y;
            _loc3_ = _loc3_ > HELPER_POINT.y?_loc3_:HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,this._hitArea.x,this._hitArea.y + this._hitArea.height,HELPER_POINT);
            _loc5_ = _loc5_ < HELPER_POINT.x?_loc5_:HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x?_loc4_:HELPER_POINT.x;
            _loc6_ = _loc6_ < HELPER_POINT.y?_loc6_:HELPER_POINT.y;
            _loc3_ = _loc3_ > HELPER_POINT.y?_loc3_:HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,this._hitArea.x + this._hitArea.width,this._hitArea.y,HELPER_POINT);
            _loc5_ = _loc5_ < HELPER_POINT.x?_loc5_:HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x?_loc4_:HELPER_POINT.x;
            _loc6_ = _loc6_ < HELPER_POINT.y?_loc6_:HELPER_POINT.y;
            _loc3_ = _loc3_ > HELPER_POINT.y?_loc3_:HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,this._hitArea.x + this._hitArea.width,this._hitArea.y + this._hitArea.height,HELPER_POINT);
            _loc5_ = _loc5_ < HELPER_POINT.x?_loc5_:HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x?_loc4_:HELPER_POINT.x;
            _loc6_ = _loc6_ < HELPER_POINT.y?_loc6_:HELPER_POINT.y;
            _loc3_ = _loc3_ > HELPER_POINT.y?_loc3_:HELPER_POINT.y;
         }
         param2.x = _loc5_;
         param2.y = _loc6_;
         param2.width = _loc4_ - _loc5_;
         param2.height = _loc3_ - _loc6_;
         return param2;
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : DisplayObject
      {
         if(param2 && (!this.visible || !this.touchable))
         {
            return null;
         }
         return this._hitArea.containsPoint(param1)?this:null;
      }
      
      override public function flatten() : void
      {
         this.validate();
         super.flatten();
      }
      
      public function validate() : void
      {
         var _loc5_:* = null;
         var _loc3_:* = NaN;
         var _loc8_:* = NaN;
         var _loc4_:* = NaN;
         var _loc6_:* = NaN;
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         var _loc7_:* = NaN;
         if(!this._validationQueue || !this.stage || !this._isInvalid)
         {
            return;
         }
         if(this._isValidating)
         {
            this._validationQueue.addControl(this,true);
            return;
         }
         this._isValidating = true;
         if(this._propertiesChanged || this._layoutChanged || this._renderingChanged)
         {
            this._batch.batchable = !this._useSeparateBatch;
            this._batch.reset();
            if(!helperImage)
            {
               helperImage = new Image(this._textures.middleCenter);
            }
            helperImage.smoothing = this._smoothing;
            helperImage.color = this._color;
            _loc5_ = this._textures.scale9Grid;
            _loc3_ = _loc5_.x * this._textureScale;
            _loc8_ = _loc5_.y * this._textureScale;
            _loc4_ = (this._frame.width - _loc5_.x - _loc5_.width) * this._textureScale;
            _loc6_ = (this._frame.height - _loc5_.y - _loc5_.height) * this._textureScale;
            _loc1_ = this._width - _loc3_ - _loc4_;
            _loc2_ = this._height - _loc8_ - _loc6_;
            if(_loc1_ < 0)
            {
               _loc7_ = _loc1_ / 2;
               _loc3_ = _loc3_ + _loc7_;
               _loc4_ = _loc4_ + _loc7_;
            }
            if(_loc2_ < 0)
            {
               _loc7_ = _loc2_ / 2;
               _loc8_ = _loc8_ + _loc7_;
               _loc6_ = _loc6_ + _loc7_;
            }
            if(_loc8_ > 0)
            {
               if(_loc3_ > 0)
               {
                  helperImage.texture = this._textures.topLeft;
                  helperImage.readjustSize();
                  helperImage.width = _loc3_;
                  helperImage.height = _loc8_;
                  helperImage.x = _loc3_ - helperImage.width;
                  helperImage.y = _loc8_ - helperImage.height;
                  this._batch.addImage(helperImage);
               }
               if(_loc1_ > 0)
               {
                  helperImage.texture = this._textures.topCenter;
                  helperImage.readjustSize();
                  helperImage.width = _loc1_;
                  helperImage.height = _loc8_;
                  helperImage.x = _loc3_;
                  helperImage.y = _loc8_ - helperImage.height;
                  this._batch.addImage(helperImage);
               }
               if(_loc4_ > 0)
               {
                  helperImage.texture = this._textures.topRight;
                  helperImage.readjustSize();
                  helperImage.width = _loc4_;
                  helperImage.height = _loc8_;
                  helperImage.x = this._width - _loc4_;
                  helperImage.y = _loc8_ - helperImage.height;
                  this._batch.addImage(helperImage);
               }
            }
            if(_loc2_ > 0)
            {
               if(_loc3_ > 0)
               {
                  helperImage.texture = this._textures.middleLeft;
                  helperImage.readjustSize();
                  helperImage.width = _loc3_;
                  helperImage.height = _loc2_;
                  helperImage.x = _loc3_ - helperImage.width;
                  helperImage.y = _loc8_;
                  this._batch.addImage(helperImage);
               }
               if(_loc1_ > 0)
               {
                  helperImage.texture = this._textures.middleCenter;
                  helperImage.readjustSize();
                  helperImage.width = _loc1_;
                  helperImage.height = _loc2_;
                  helperImage.x = _loc3_;
                  helperImage.y = _loc8_;
                  this._batch.addImage(helperImage);
               }
               if(_loc4_ > 0)
               {
                  helperImage.texture = this._textures.middleRight;
                  helperImage.readjustSize();
                  helperImage.width = _loc4_;
                  helperImage.height = _loc2_;
                  helperImage.x = this._width - _loc4_;
                  helperImage.y = _loc8_;
                  this._batch.addImage(helperImage);
               }
            }
            if(_loc6_ > 0)
            {
               if(_loc3_ > 0)
               {
                  helperImage.texture = this._textures.bottomLeft;
                  helperImage.readjustSize();
                  helperImage.width = _loc3_;
                  helperImage.height = _loc6_;
                  helperImage.x = _loc3_ - helperImage.width;
                  helperImage.y = this._height - _loc6_;
                  this._batch.addImage(helperImage);
               }
               if(_loc1_ > 0)
               {
                  helperImage.texture = this._textures.bottomCenter;
                  helperImage.readjustSize();
                  helperImage.width = _loc1_;
                  helperImage.height = _loc6_;
                  helperImage.x = _loc3_;
                  helperImage.y = this._height - _loc6_;
                  this._batch.addImage(helperImage);
               }
               if(_loc4_ > 0)
               {
                  helperImage.texture = this._textures.bottomRight;
                  helperImage.readjustSize();
                  helperImage.width = _loc4_;
                  helperImage.height = _loc6_;
                  helperImage.x = this._width - _loc4_;
                  helperImage.y = this._height - _loc6_;
                  this._batch.addImage(helperImage);
               }
            }
         }
         this._propertiesChanged = false;
         this._layoutChanged = false;
         this._renderingChanged = false;
         this._isInvalid = false;
         this._isValidating = false;
      }
      
      public function readjustSize() : void
      {
         this.width = this._frame.width * this._textureScale;
         this.height = this._frame.height * this._textureScale;
      }
      
      protected function invalidate() : void
      {
         if(this._isInvalid)
         {
            return;
         }
         this._isInvalid = true;
         if(!this._validationQueue)
         {
            return;
         }
         this._validationQueue.addControl(this,false);
      }
      
      private function flattenHandler(param1:Event) : void
      {
         this.validate();
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         this._depth = getDisplayObjectDepthFromStage(this);
         this._validationQueue = ValidationQueue.forStarling(Starling.current);
         if(this._isInvalid)
         {
            this._validationQueue.addControl(this,false);
         }
      }
   }
}
