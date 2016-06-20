package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.engine.TextBlock;
   import starling.display.Image;
   import flash.display.Sprite;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextElement;
   import flash.text.engine.ContentElement;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.TabStop;
   import flash.text.engine.TextJustifier;
   import starling.utils.getNextPowerOfTwo;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.textures.ConcreteTexture;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import flash.display.DisplayObjectContainer;
   import starling.events.Event;
   import flash.text.engine.SpaceJustifier;
   
   public class TextBlockTextRenderer extends FeathersControl implements ITextRenderer
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
      
      public static const TEXT_ALIGN_LEFT:String = "left";
      
      public static const TEXT_ALIGN_CENTER:String = "center";
      
      public static const TEXT_ALIGN_RIGHT:String = "right";
      
      protected static const MAX_TEXT_LINE_WIDTH:Number = 1000000;
      
      protected static const LINE_FEED:String = "\n";
      
      protected static const CARRIAGE_RETURN:String = "\r";
      
      protected static const FUZZY_TRUNCATION_DIFFERENCE:Number = 1.0E-6;
       
      protected var textBlock:TextBlock;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _textLineContainer:Sprite;
      
      protected var _textLines:Vector.<TextLine>;
      
      protected var _measurementTextLineContainer:Sprite;
      
      protected var _measurementTextLines:Vector.<TextLine>;
      
      protected var _previousContentWidth:Number = NaN;
      
      protected var _previousContentHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _truncationOffset:int = 0;
      
      protected var _textElement:TextElement;
      
      protected var _text:String;
      
      protected var _content:ContentElement;
      
      protected var _elementFormat:ElementFormat;
      
      protected var _disabledElementFormat:ElementFormat;
      
      protected var _leading:Number = 0;
      
      protected var _textAlign:String = "left";
      
      protected var _wordWrap:Boolean = false;
      
      protected var _applyNonLinearFontScaling:Boolean = true;
      
      protected var _baselineFontDescription:FontDescription;
      
      protected var _baselineFontSize:Number = 12;
      
      protected var _baselineZero:String = "roman";
      
      protected var _bidiLevel:int = 0;
      
      protected var _lineRotation:String = "rotate0";
      
      protected var _tabStops:Vector.<TabStop>;
      
      protected var _textJustifier:TextJustifier;
      
      protected var _userData;
      
      protected var _snapToPixels:Boolean = true;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      protected var _truncationText:String = "...";
      
      protected var _truncateToFit:Boolean = true;
      
      public function TextBlockTextRenderer()
      {
         _textLines = new Vector.<TextLine>(0);
         _measurementTextLines = new Vector.<TextLine>(0);
         _textJustifier = new SpaceJustifier();
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("addedToStage",addedToStageHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      public function get text() : String
      {
         return this._textElement?this._text:null;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         if(!this._textElement)
         {
            this._textElement = new TextElement(param1);
         }
         this._textElement.text = param1;
         this.content = this._textElement;
         this.invalidate("data");
      }
      
      public function get content() : ContentElement
      {
         return this._content;
      }
      
      public function set content(param1:ContentElement) : void
      {
         if(this._content == param1)
         {
            return;
         }
         if(param1 is TextElement)
         {
            this._textElement = TextElement(param1);
         }
         else
         {
            this._textElement = null;
         }
         this._content = param1;
         this.invalidate("data");
      }
      
      public function get elementFormat() : ElementFormat
      {
         return this._elementFormat;
      }
      
      public function set elementFormat(param1:ElementFormat) : void
      {
         if(this._elementFormat == param1)
         {
            return;
         }
         this._elementFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledElementFormat() : ElementFormat
      {
         return this._disabledElementFormat;
      }
      
      public function set disabledElementFormat(param1:ElementFormat) : void
      {
         if(this._disabledElementFormat == param1)
         {
            return;
         }
         this._disabledElementFormat = param1;
         this.invalidate("styles");
      }
      
      public function get leading() : Number
      {
         return this._leading;
      }
      
      public function set leading(param1:Number) : void
      {
         if(this._leading == param1)
         {
            return;
         }
         this._leading = param1;
         this.invalidate("styles");
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign == param1)
         {
            return;
         }
         this._textAlign = param1;
         this.invalidate("styles");
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
      
      public function get baseline() : Number
      {
         if(this._textLines.length == 0)
         {
            return 0;
         }
         return this._textLines[0].ascent;
      }
      
      public function get applyNonLinearFontScaling() : Boolean
      {
         return this._applyNonLinearFontScaling;
      }
      
      public function set applyNonLinearFontScaling(param1:Boolean) : void
      {
         if(this._applyNonLinearFontScaling == param1)
         {
            return;
         }
         this._applyNonLinearFontScaling = param1;
         this.invalidate("styles");
      }
      
      public function get baselineFontDescription() : FontDescription
      {
         return this._baselineFontDescription;
      }
      
      public function set baselineFontDescription(param1:FontDescription) : void
      {
         if(this._baselineFontDescription == param1)
         {
            return;
         }
         this._baselineFontDescription = param1;
         this.invalidate("styles");
      }
      
      public function get baselineFontSize() : Number
      {
         return this._baselineFontSize;
      }
      
      public function set baselineFontSize(param1:Number) : void
      {
         if(this._baselineFontSize == param1)
         {
            return;
         }
         this._baselineFontSize = param1;
         this.invalidate("styles");
      }
      
      public function get baselineZero() : String
      {
         return this._baselineZero;
      }
      
      public function set baselineZero(param1:String) : void
      {
         if(this._baselineZero == param1)
         {
            return;
         }
         this._baselineZero = param1;
         this.invalidate("styles");
      }
      
      public function get bidiLevel() : int
      {
         return this._bidiLevel;
      }
      
      public function set bidiLevel(param1:int) : void
      {
         if(this._bidiLevel == param1)
         {
            return;
         }
         this._bidiLevel = param1;
         this.invalidate("styles");
      }
      
      public function get lineRotation() : String
      {
         return this._lineRotation;
      }
      
      public function set lineRotation(param1:String) : void
      {
         if(this._lineRotation == param1)
         {
            return;
         }
         this._lineRotation = param1;
         this.invalidate("styles");
      }
      
      public function get tabStops() : Vector.<TabStop>
      {
         return this._tabStops;
      }
      
      public function set tabStops(param1:Vector.<TabStop>) : void
      {
         if(this._tabStops == param1)
         {
            return;
         }
         this._tabStops = param1;
         this.invalidate("styles");
      }
      
      public function get textJustifier() : TextJustifier
      {
         return this._textJustifier;
      }
      
      public function set textJustifier(param1:TextJustifier) : void
      {
         if(this._textJustifier == param1)
         {
            return;
         }
         this._textJustifier = param1;
         this.invalidate("styles");
      }
      
      public function get userData() : *
      {
         return this._userData;
      }
      
      public function set userData(param1:*) : void
      {
         if(this._userData === param1)
         {
            return;
         }
         this._userData = param1;
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
      
      public function get truncationText() : String
      {
         return _truncationText;
      }
      
      public function set truncationText(param1:String) : void
      {
         if(this._truncationText == param1)
         {
            return;
         }
         this._truncationText = param1;
         this.invalidate("data");
      }
      
      public function get truncateToFit() : Boolean
      {
         return _truncateToFit;
      }
      
      public function set truncateToFit(param1:Boolean) : void
      {
         if(this._truncateToFit == param1)
         {
            return;
         }
         this._truncateToFit = param1;
         this.invalidate("data");
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
         if(!this.textBlock)
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
         if(!this.textBlock)
         {
            this.textBlock = new TextBlock();
         }
         if(!this._textLineContainer)
         {
            this._textLineContainer = new Sprite();
         }
         if(!this._measurementTextLineContainer)
         {
            this._measurementTextLineContainer = new Sprite();
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         if(_loc1_ || _loc3_ || _loc2_)
         {
            if(this._textElement)
            {
               if(!this._isEnabled && this._disabledElementFormat)
               {
                  this._textElement.elementFormat = this._disabledElementFormat;
               }
               else if(this._elementFormat)
               {
                  this._textElement.elementFormat = this._elementFormat;
               }
            }
         }
         if(_loc3_)
         {
            this.textBlock.applyNonLinearFontScaling = this._applyNonLinearFontScaling;
            this.textBlock.baselineFontDescription = this._baselineFontDescription;
            this.textBlock.baselineFontSize = this._baselineFontSize;
            this.textBlock.baselineZero = this._baselineZero;
            this.textBlock.bidiLevel = this._bidiLevel;
            this.textBlock.lineRotation = this._lineRotation;
            this.textBlock.tabStops = this._tabStops;
            this.textBlock.textJustifier = this._textJustifier;
            this.textBlock.userData = this._userData;
         }
         if(_loc1_)
         {
            this.textBlock.content = this._content;
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            var param1:Point = new Point();
         }
         var _loc3_:Boolean = isNaN(this.explicitWidth);
         var _loc5_:Boolean = isNaN(this.explicitHeight);
         var _loc4_:Number = this.explicitWidth;
         var _loc2_:Number = this.explicitHeight;
         if(_loc3_)
         {
            _loc4_ = this._maxWidth;
            if(_loc4_ > 1000000)
            {
               _loc4_ = 1000000.0;
            }
         }
         if(_loc5_)
         {
            _loc2_ = this._maxHeight;
         }
         this.refreshTextLines(this._measurementTextLines,this._measurementTextLineContainer,_loc4_,_loc2_);
         if(_loc3_)
         {
            _loc4_ = this._measurementTextLineContainer.width;
            if(_loc4_ > this._maxWidth)
            {
               _loc4_ = this._maxWidth;
            }
         }
         if(_loc5_)
         {
            _loc2_ = this._measurementTextLineContainer.height;
         }
         param1.x = _loc4_;
         param1.y = _loc2_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc2_:* = null;
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("data");
         if(param1)
         {
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
         if(_loc6_ || _loc4_ || this._needsNewTexture || this.actualWidth != this._previousContentWidth || this.actualHeight != this._previousContentHeight)
         {
            this._previousContentWidth = this.actualWidth;
            this._previousContentHeight = this.actualHeight;
            if(this._content)
            {
               this.refreshTextLines(this._textLines,this._textLineContainer,this.actualWidth,this.actualHeight);
               this.refreshSnapshot();
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = this._content !== null;
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
         var _loc11_:* = null;
         var _loc3_:* = NaN;
         var _loc15_:* = NaN;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc13_:* = null;
         var _loc2_:* = 0;
         var _loc8_:* = 0;
         if(this._snapshotWidth == 0 || this._snapshotHeight == 0)
         {
            return;
         }
         var _loc5_:Number = Starling.contentScaleFactor;
         HELPER_MATRIX.identity();
         HELPER_MATRIX.scale(_loc5_,_loc5_);
         var _loc10_:Number = this._snapshotWidth;
         var _loc9_:Number = this._snapshotHeight;
         var _loc14_:Number = this.actualWidth * _loc5_;
         var _loc1_:Number = this.actualHeight * _loc5_;
         var _loc12_:* = 0.0;
         var _loc7_:* = 0.0;
         var _loc16_:* = -1;
         do
         {
            _loc3_ = _loc10_;
            if(_loc3_ > this._maxTextureDimensions)
            {
               _loc3_ = this._maxTextureDimensions;
            }
            do
            {
               _loc15_ = _loc9_;
               if(_loc15_ > this._maxTextureDimensions)
               {
                  _loc15_ = this._maxTextureDimensions;
               }
               if(!_loc11_ || _loc11_.width != _loc3_ || _loc11_.height != _loc15_)
               {
                  if(_loc11_)
                  {
                     _loc11_.dispose();
                  }
                  _loc11_ = new BitmapData(_loc3_,_loc15_,true,16711935);
               }
               else
               {
                  _loc11_.fillRect(_loc11_.rect,16711935);
               }
               HELPER_MATRIX.tx = -_loc12_;
               HELPER_MATRIX.ty = -_loc7_;
               HELPER_RECTANGLE.setTo(0,0,_loc14_,_loc1_);
               _loc11_.draw(this._textLineContainer,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
               if(!this.textSnapshot || this._needsNewTexture)
               {
                  _loc6_ = Texture.fromBitmapData(_loc11_,false,false,_loc5_);
                  _loc6_.root.onRestore = texture_onRestore;
               }
               _loc4_ = null;
               if(_loc16_ >= 0)
               {
                  if(!this.textSnapshots)
                  {
                     this.textSnapshots = new Vector.<Image>(0);
                  }
                  else if(this.textSnapshots.length > _loc16_)
                  {
                     _loc4_ = this.textSnapshots[_loc16_];
                  }
               }
               else
               {
                  _loc4_ = this.textSnapshot;
               }
               if(!_loc4_)
               {
                  _loc4_ = new Image(_loc6_);
                  this.addChild(_loc4_);
               }
               else if(this._needsNewTexture)
               {
                  _loc4_.texture.dispose();
                  _loc4_.texture = _loc6_;
                  _loc4_.readjustSize();
               }
               else
               {
                  _loc13_ = _loc4_.texture;
                  _loc13_.root.uploadBitmapData(_loc11_);
               }
               if(_loc16_ >= 0)
               {
                  this.textSnapshots[_loc16_] = _loc4_;
               }
               else
               {
                  this.textSnapshot = _loc4_;
               }
               _loc4_.x = _loc12_ / _loc5_;
               _loc4_.y = _loc7_ / _loc5_;
               _loc16_++;
               _loc7_ = _loc7_ + _loc15_;
               _loc9_ = _loc9_ - _loc15_;
               _loc1_ = _loc1_ - _loc15_;
            }
            while(_loc9_ > 0);
            
            _loc12_ = _loc12_ + _loc3_;
            _loc10_ = _loc10_ - _loc3_;
            _loc14_ = _loc14_ - _loc3_;
            _loc7_ = 0.0;
            _loc1_ = this.actualHeight * _loc5_;
            _loc9_ = this._snapshotHeight;
         }
         while(_loc10_ > 0);
         
         _loc11_.dispose();
         if(this.textSnapshots)
         {
            _loc2_ = this.textSnapshots.length;
            _loc8_ = _loc16_;
            while(_loc8_ < _loc2_)
            {
               _loc4_ = this.textSnapshots[_loc8_];
               _loc4_.texture.dispose();
               _loc4_.removeFromParent(true);
               _loc8_++;
            }
            if(_loc16_ == 0)
            {
               this.textSnapshots = null;
            }
            else
            {
               this.textSnapshots.length = _loc16_;
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
         this._previousContentWidth = NaN;
         this._previousContentHeight = NaN;
         this._needsNewTexture = false;
         this._snapshotWidth = 0;
         this._snapshotHeight = 0;
      }
      
      protected function refreshTextLines(param1:Vector.<TextLine>, param2:DisplayObjectContainer, param3:Number, param4:Number) : void
      {
         var _loc23_:* = undefined;
         var _loc6_:* = null;
         var _loc18_:* = 0;
         var _loc10_:* = null;
         var _loc20_:* = 0;
         var _loc14_:* = false;
         var _loc21_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:* = null;
         var _loc9_:* = NaN;
         var _loc13_:* = null;
         var _loc12_:* = 0;
         var _loc8_:* = false;
         var _loc19_:* = NaN;
         var _loc11_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         if(this._textElement)
         {
            this._textElement.text = this._text;
            this._truncationOffset = 0;
         }
         var _loc15_:* = 0.0;
         var _loc22_:int = param1.length;
         _loc18_ = 0;
         while(_loc18_ < _loc22_)
         {
            _loc10_ = param1[_loc18_];
            if(_loc10_.validity === "valid")
            {
               _loc10_.filters = this._nativeFilters;
               _loc6_ = _loc10_;
               _loc18_++;
               continue;
            }
            _loc10_ = _loc6_;
            if(_loc6_)
            {
               _loc15_ = _loc6_.y;
               _loc6_ = null;
            }
            _loc23_ = param1.splice(_loc18_,_loc22_ - _loc18_);
            break;
         }
         if(param3 >= 0)
         {
            _loc20_ = 0;
            _loc14_ = this._truncateToFit && this._textElement && !this._wordWrap;
            _loc21_ = param1.length;
            _loc16_ = _loc23_?_loc23_.length:0;
            while(true)
            {
               _loc17_ = _loc10_;
               _loc9_ = param3;
               if(!this._wordWrap)
               {
                  _loc9_ = 1000000.0;
               }
               if(_loc16_ > 0)
               {
                  _loc13_ = _loc23_[0];
                  _loc10_ = this.textBlock.recreateTextLine(_loc13_,_loc17_,_loc9_,0,true);
                  if(_loc10_)
                  {
                     _loc23_.shift();
                     _loc16_--;
                  }
               }
               else
               {
                  _loc10_ = this.textBlock.createTextLine(_loc17_,_loc9_,0,true);
                  if(_loc10_)
                  {
                     param2.addChild(_loc10_);
                  }
               }
               if(_loc10_)
               {
                  _loc12_ = _loc10_.rawTextLength;
                  _loc8_ = false;
                  _loc19_ = 0.0;
                  while(_loc14_ && _loc10_.width - param3 > 1.0E-6)
                  {
                     _loc8_ = true;
                     if(this._truncationOffset == 0)
                     {
                        _loc11_ = _loc10_.getAtomIndexAtPoint(param3,0);
                        if(_loc11_ >= 0)
                        {
                           this._truncationOffset = _loc10_.rawTextLength - _loc11_;
                        }
                     }
                     §§dup(this)._truncationOffset++;
                     _loc5_ = _loc12_ - this._truncationOffset;
                     this._textElement.text = this._text.substr(_loc20_,_loc5_) + this._truncationText;
                     _loc7_ = this._text.indexOf("\n",_loc20_);
                     if(_loc7_ < 0)
                     {
                        _loc7_ = this._text.indexOf("\r",_loc20_);
                     }
                     if(_loc7_ >= 0)
                     {
                        this._textElement.text = this._textElement.text + this._text.substr(_loc7_);
                     }
                     _loc10_ = this.textBlock.recreateTextLine(_loc10_,null,_loc9_,0,true);
                     if(_loc5_ != 0)
                     {
                        continue;
                     }
                     break;
                  }
                  if(_loc21_ > 0)
                  {
                     _loc15_ = _loc15_ + this._leading;
                  }
                  _loc15_ = _loc15_ + _loc10_.ascent;
                  _loc10_.y = _loc15_;
                  _loc15_ = _loc15_ + _loc10_.descent;
                  _loc10_.filters = this._nativeFilters;
                  param1[_loc21_] = _loc10_;
                  _loc21_++;
                  _loc20_ = _loc20_ + _loc12_;
                  continue;
               }
               break;
            }
         }
         _loc22_ = param1.length;
         _loc18_ = 0;
         while(_loc18_ < _loc22_)
         {
            _loc10_ = param1[_loc18_];
            if(this._textAlign == "center")
            {
               _loc10_.x = (param3 - _loc10_.width) / 2;
            }
            else if(this._textAlign == "right")
            {
               _loc10_.x = param3 - _loc10_.width;
            }
            else
            {
               _loc10_.x = 0;
            }
            _loc18_++;
         }
         if(!_loc23_)
         {
            return;
         }
         _loc16_ = _loc23_.length;
         _loc18_ = 0;
         while(_loc18_ < _loc16_)
         {
            _loc10_ = _loc23_.shift();
            param2.removeChild(_loc10_);
            _loc18_++;
         }
      }
      
      protected function addedToStageHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this.disposeContent();
      }
   }
}
