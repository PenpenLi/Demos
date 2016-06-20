package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import starling.display.Image;
   import flash.text.TextFormat;
   import flash.text.StyleSheet;
   import starling.utils.getNextPowerOfTwo;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.textures.ConcreteTexture;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import starling.events.Event;
   
   public class TextFieldTextRenderer extends FeathersControl implements ITextRenderer
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
       
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _previousTextFieldWidth:Number = NaN;
      
      protected var _previousTextFieldHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _hasMeasured:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _isHTML:Boolean = false;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _snapToPixels:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      public function TextFieldTextRenderer()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("addedToStage",addedToStageHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         if(param1 === null)
         {
            var param1:String = "";
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate("data");
      }
      
      public function get textFormat() : TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         if(this._styleSheet == param1)
         {
            return;
         }
         this._styleSheet = param1;
         this.invalidate("styles");
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         return 2 + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get snapToPixels() : Boolean
      {
         return this._snapToPixels;
      }
      
      public function set snapToPixels(param1:Boolean) : void
      {
         this._snapToPixels = param1;
      }
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate("styles");
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate("styles");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate("styles");
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate("styles");
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(this._condenseWhite == param1)
         {
            return;
         }
         this._condenseWhite = param1;
         this.invalidate("styles");
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate("styles");
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate("styles");
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate("data");
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate("data");
      }
      
      public function get maxTextureDimensions() : int
      {
         return this._maxTextureDimensions;
      }
      
      public function set maxTextureDimensions(param1:int) : void
      {
         var param1:int = getNextPowerOfTwo(param1);
         if(this._maxTextureDimensions == param1)
         {
            return;
         }
         this._maxTextureDimensions = param1;
         this._needsNewTexture = true;
         this.invalidate("size");
      }
      
      public function get nativeFilters() : Array
      {
         return this._nativeFilters;
      }
      
      public function set nativeFilters(param1:Array) : void
      {
         if(this._nativeFilters == param1)
         {
            return;
         }
         this._nativeFilters = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         this.disposeContent();
         super.dispose();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(this.textSnapshot)
         {
            if(this._snapToPixels)
            {
               this.getTransformationMatrix(this.stage,HELPER_MATRIX);
               this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
               this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
            }
            else
            {
               var _loc3_:* = 0;
               this.textSnapshot.y = _loc3_;
               this.textSnapshot.x = _loc3_;
            }
         }
         super.render(param1,param2);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            var param1:Point = new Point();
         }
         if(!this.textField)
         {
            var _loc4_:* = 0;
            param1.y = _loc4_;
            param1.x = _loc4_;
            return param1;
         }
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc3_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         this.commit();
         param1 = this.measure(param1);
         return param1;
      }
      
      override protected function initialize() : void
      {
         if(!this.textField)
         {
            this.textField = new TextField();
            var _loc1_:* = false;
            this.textField.mouseWheelEnabled = _loc1_;
            this.textField.mouseEnabled = _loc1_;
            this.textField.selectable = false;
            this.textField.multiline = true;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         this._hasMeasured = false;
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         if(_loc3_)
         {
            this.textField.antiAliasType = this._antiAliasType;
            this.textField.background = this._background;
            this.textField.backgroundColor = this._backgroundColor;
            this.textField.border = this._border;
            this.textField.borderColor = this._borderColor;
            this.textField.condenseWhite = this._condenseWhite;
            this.textField.displayAsPassword = this._displayAsPassword;
            this.textField.gridFitType = this._gridFitType;
            this.textField.sharpness = this._sharpness;
            this.textField.thickness = this._thickness;
            this.textField.filters = this._nativeFilters;
         }
         if(_loc1_ || _loc3_ || _loc2_)
         {
            this.textField.wordWrap = this._wordWrap;
            this.textField.embedFonts = this._embedFonts;
            if(this._styleSheet)
            {
               this.textField.styleSheet = this._styleSheet;
            }
            else
            {
               this.textField.styleSheet = null;
               if(!this._isEnabled && this._disabledTextFormat)
               {
                  this.textField.defaultTextFormat = this._disabledTextFormat;
               }
               else if(this._textFormat)
               {
                  this.textField.defaultTextFormat = this._textFormat;
               }
            }
            if(this._isHTML)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         var _loc4_:* = NaN;
         if(!param1)
         {
            var param1:Point = new Point();
         }
         var _loc3_:Boolean = isNaN(this.explicitWidth);
         var _loc6_:Boolean = isNaN(this.explicitHeight);
         this.textField.autoSize = "left";
         this.textField.wordWrap = false;
         var _loc5_:Number = this.explicitWidth;
         if(_loc3_)
         {
            _loc4_ = this.textField.width;
            _loc5_ = Math.ceil(this.textField.width);
            if(_loc5_ < this._minWidth)
            {
               _loc5_ = this._minWidth;
            }
            else if(_loc5_ > this._maxWidth)
            {
               _loc5_ = this._maxWidth;
            }
         }
         if(!_loc3_ || this.textField.width > _loc5_)
         {
            this.textField.width = _loc5_;
            this.textField.wordWrap = this._wordWrap;
         }
         var _loc2_:Number = this.explicitHeight;
         if(_loc6_)
         {
            _loc2_ = Math.ceil(this.textField.height);
            if(_loc2_ < this._minHeight)
            {
               _loc2_ = this._minHeight;
            }
            else if(_loc2_ > this._maxHeight)
            {
               _loc2_ = this._maxHeight;
            }
         }
         this.textField.autoSize = "none";
         this.textField.width = this.actualWidth;
         this.textField.height = this.actualHeight;
         param1.x = _loc5_;
         param1.y = _loc2_;
         this._hasMeasured = true;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc2_:* = null;
         var _loc7_:* = false;
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("data");
         if(!this._hasMeasured && this._wordWrap && this.explicitWidth != this.explicitWidth)
         {
            this.textField.autoSize = "left";
            this.textField.wordWrap = false;
            if(this.textField.width > this.actualWidth)
            {
               this.textField.wordWrap = true;
            }
            this.textField.autoSize = "none";
            this.textField.width = this.actualWidth;
         }
         if(param1)
         {
            this.textField.width = this.actualWidth;
            this.textField.height = this.actualHeight;
            _loc3_ = this.actualWidth * Starling.contentScaleFactor;
            if(_loc3_ > this._maxTextureDimensions)
            {
               this._snapshotWidth = _loc3_ / this._maxTextureDimensions * this._maxTextureDimensions + getNextPowerOfTwo(_loc3_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotWidth = getNextPowerOfTwo(_loc3_);
            }
            _loc5_ = this.actualHeight * Starling.contentScaleFactor;
            if(_loc5_ > this._maxTextureDimensions)
            {
               this._snapshotHeight = _loc5_ / this._maxTextureDimensions * this._maxTextureDimensions + getNextPowerOfTwo(_loc5_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotHeight = getNextPowerOfTwo(_loc5_);
            }
            _loc2_ = this.textSnapshot?this.textSnapshot.texture.root:null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != _loc2_.width || this._snapshotHeight != _loc2_.height;
         }
         if(_loc6_ || _loc4_ || this._needsNewTexture || this.actualWidth != this._previousTextFieldWidth || this.actualHeight != this._previousTextFieldHeight)
         {
            this._previousTextFieldWidth = this.actualWidth;
            this._previousTextFieldHeight = this.actualHeight;
            _loc7_ = this._text.length > 0;
            if(_loc7_)
            {
               this.addEventListener("enterFrame",enterFrameHandler);
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = _loc7_;
            }
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = isNaN(this.explicitWidth);
         var _loc2_:Boolean = isNaN(this.explicitHeight);
         if(!_loc1_ && !_loc2_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function texture_onRestore() : void
      {
         this.refreshSnapshot();
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc10_:* = null;
         var _loc1_:* = NaN;
         var _loc12_:* = NaN;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc13_:* = null;
         var _loc2_:* = 0;
         var _loc7_:* = 0;
         if(this._snapshotWidth == 0 || this._snapshotHeight == 0)
         {
            return;
         }
         var _loc4_:Number = Starling.contentScaleFactor;
         HELPER_MATRIX.identity();
         HELPER_MATRIX.scale(_loc4_,_loc4_);
         var _loc9_:Number = this._snapshotWidth;
         var _loc8_:Number = this._snapshotHeight;
         var _loc11_:* = 0.0;
         var _loc6_:* = 0.0;
         var _loc14_:* = -1;
         do
         {
            _loc1_ = _loc9_;
            if(_loc1_ > this._maxTextureDimensions)
            {
               _loc1_ = this._maxTextureDimensions;
            }
            do
            {
               _loc12_ = _loc8_;
               if(_loc12_ > this._maxTextureDimensions)
               {
                  _loc12_ = this._maxTextureDimensions;
               }
               if(!_loc10_ || _loc10_.width != _loc1_ || _loc10_.height != _loc12_)
               {
                  if(_loc10_)
                  {
                     _loc10_.dispose();
                  }
                  _loc10_ = new BitmapData(_loc1_,_loc12_,true,16711935);
               }
               else
               {
                  _loc10_.fillRect(_loc10_.rect,16711935);
               }
               HELPER_MATRIX.tx = -_loc11_;
               HELPER_MATRIX.ty = -_loc6_;
               _loc10_.draw(this.textField,HELPER_MATRIX);
               if(!this.textSnapshot || this._needsNewTexture)
               {
                  _loc5_ = Texture.fromBitmapData(_loc10_,false,false,_loc4_);
                  _loc5_.root.onRestore = texture_onRestore;
               }
               _loc3_ = null;
               if(_loc14_ >= 0)
               {
                  if(!this.textSnapshots)
                  {
                     this.textSnapshots = new Vector.<Image>(0);
                  }
                  else if(this.textSnapshots.length > _loc14_)
                  {
                     _loc3_ = this.textSnapshots[_loc14_];
                  }
               }
               else
               {
                  _loc3_ = this.textSnapshot;
               }
               if(!_loc3_)
               {
                  _loc3_ = new Image(_loc5_);
                  this.addChild(_loc3_);
               }
               else if(this._needsNewTexture)
               {
                  _loc3_.texture.dispose();
                  _loc3_.texture = _loc5_;
                  _loc3_.readjustSize();
               }
               else
               {
                  _loc13_ = _loc3_.texture;
                  _loc13_.root.uploadBitmapData(_loc10_);
               }
               if(_loc14_ >= 0)
               {
                  this.textSnapshots[_loc14_] = _loc3_;
               }
               else
               {
                  this.textSnapshot = _loc3_;
               }
               _loc3_.x = _loc11_ / _loc4_;
               _loc3_.y = _loc6_ / _loc4_;
               _loc14_++;
               _loc6_ = _loc6_ + _loc12_;
               _loc8_ = _loc8_ - _loc12_;
            }
            while(_loc8_ > 0);
            
            _loc11_ = _loc11_ + _loc1_;
            _loc9_ = _loc9_ - _loc1_;
            _loc6_ = 0.0;
            _loc8_ = this._snapshotHeight;
         }
         while(_loc9_ > 0);
         
         _loc10_.dispose();
         if(this.textSnapshots)
         {
            _loc2_ = this.textSnapshots.length;
            _loc7_ = _loc14_;
            while(_loc7_ < _loc2_)
            {
               _loc3_ = this.textSnapshots[_loc7_];
               _loc3_.texture.dispose();
               _loc3_.removeFromParent(true);
               _loc7_++;
            }
            if(_loc14_ == 0)
            {
               this.textSnapshots = null;
            }
            else
            {
               this.textSnapshots.length = _loc14_;
            }
         }
         this._needsNewTexture = false;
      }
      
      protected function disposeContent() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textSnapshots)
         {
            _loc1_ = this.textSnapshots.length;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this.textSnapshots[_loc3_];
               _loc2_.texture.dispose();
               this.removeChild(_loc2_,true);
               _loc3_++;
            }
            this.textSnapshots = null;
         }
         this._previousTextFieldWidth = NaN;
         this._previousTextFieldHeight = NaN;
         this._needsNewTexture = false;
         this._snapshotWidth = 0;
         this._snapshotHeight = 0;
      }
      
      protected function addedToStageHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.disposeContent();
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.refreshSnapshot();
      }
   }
}
