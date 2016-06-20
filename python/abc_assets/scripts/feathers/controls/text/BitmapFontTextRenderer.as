package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import starling.display.Image;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.display.QuadBatch;
   import feathers.text.BitmapFontTextFormat;
   import starling.text.BitmapFont;
   import starling.core.RenderSupport;
   import starling.text.BitmapChar;
   
   public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer
   {
      
      private static var HELPER_IMAGE:Image;
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const CHARACTER_ID_SPACE:int = 32;
      
      private static const CHARACTER_ID_TAB:int = 9;
      
      private static const CHARACTER_ID_LINE_FEED:int = 10;
      
      private static const CHARACTER_ID_CARRIAGE_RETURN:int = 13;
      
      private static var CHARACTER_BUFFER:Vector.<CharLocation>;
      
      private static var CHAR_LOCATION_POOL:Vector.<CharLocation>;
      
      private static const FUZZY_MAX_WIDTH_PADDING:Number = 1.0E-6;
       
      protected var _characterBatch:QuadBatch;
      
      protected var _batchX:Number = 0;
      
      protected var currentTextFormat:BitmapFontTextFormat;
      
      protected var _textFormat:BitmapFontTextFormat;
      
      protected var _disabledTextFormat:BitmapFontTextFormat;
      
      protected var _text:String = null;
      
      protected var _smoothing:String = "bilinear";
      
      protected var _wordWrap:Boolean = false;
      
      protected var _snapToPixels:Boolean = true;
      
      protected var _truncationText:String = "...";
      
      protected var _useSeparateBatch:Boolean = true;
      
      public function BitmapFontTextRenderer()
      {
         super();
         if(!CHAR_LOCATION_POOL)
         {
            CHAR_LOCATION_POOL = new Vector.<CharLocation>(0);
         }
         if(!CHARACTER_BUFFER)
         {
            CHARACTER_BUFFER = new Vector.<CharLocation>(0);
         }
         this.isQuickHitAreaEnabled = true;
      }
      
      public function get textFormat() : BitmapFontTextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : BitmapFontTextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
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
         this._text = param1;
         this.invalidate("data");
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
         this.invalidate("styles");
      }
      
      public function get wordWrap() : Boolean
      {
         return _wordWrap;
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
         return _snapToPixels;
      }
      
      public function set snapToPixels(param1:Boolean) : void
      {
         if(this._snapToPixels == param1)
         {
            return;
         }
         this._snapToPixels = param1;
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
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this._textFormat)
         {
            return 0;
         }
         var _loc2_:BitmapFont = this._textFormat.font;
         var _loc3_:Number = this._textFormat.size;
         var _loc1_:Number = isNaN(_loc3_)?1:_loc3_ / _loc2_.size;
         if(isNaN(_loc2_.baseline))
         {
            return _loc2_.lineHeight * _loc1_;
         }
         return _loc2_.baseline * _loc1_;
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc4_:* = 0.0;
         var _loc3_:* = 0.0;
         if(this._snapToPixels)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc4_ = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
            _loc3_ = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
         }
         this._characterBatch.x = this._batchX + _loc4_;
         this._characterBatch.y = _loc3_;
         super.render(param1,param2);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         var _loc14_:* = 0;
         var _loc8_:* = 0;
         var _loc15_:* = null;
         var _loc5_:* = NaN;
         var _loc17_:* = false;
         if(this.isInvalid("styles") || this.isInvalid("state"))
         {
            this.refreshTextFormat();
         }
         if(!param1)
         {
            var param1:Point = new Point();
         }
         else
         {
            var _loc24_:* = 0;
            param1.y = _loc24_;
            param1.x = _loc24_;
         }
         if(!this.currentTextFormat || !this._text)
         {
            return param1;
         }
         var _loc6_:BitmapFont = this.currentTextFormat.font;
         var _loc16_:Number = this.currentTextFormat.size;
         var _loc20_:Number = this.currentTextFormat.letterSpacing;
         var _loc12_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc2_:Number = isNaN(_loc16_)?1:_loc16_ / _loc6_.size;
         var _loc3_:Number = _loc6_.lineHeight * _loc2_;
         var _loc4_:Number = !isNaN(this.explicitWidth)?this.explicitWidth:this._maxWidth;
         var _loc11_:* = 0.0;
         var _loc22_:* = 0.0;
         var _loc21_:* = 0.0;
         var _loc7_:* = NaN;
         var _loc13_:int = this._text.length;
         var _loc23_:* = 0.0;
         var _loc10_:* = 0.0;
         var _loc19_:* = 0;
         var _loc9_:String = "";
         var _loc18_:String = "";
         _loc14_ = 0;
         while(_loc14_ < _loc13_)
         {
            _loc8_ = this._text.charCodeAt(_loc14_);
            if(_loc8_ == 10 || _loc8_ == 13)
            {
               _loc22_ = Math.max(0,_loc22_ - _loc20_);
               _loc11_ = Math.max(_loc11_,_loc22_);
               _loc7_ = NaN;
               _loc22_ = 0.0;
               _loc21_ = _loc21_ + _loc3_;
               _loc23_ = 0.0;
               _loc19_ = 0;
               _loc10_ = 0.0;
            }
            else
            {
               _loc15_ = _loc6_.getChar(_loc8_);
               if(!_loc15_)
               {
                  LogUtil("Missing character " + String.fromCharCode(_loc8_) + " in font " + _loc6_.name + ".");
               }
               else
               {
                  if(_loc12_ && !isNaN(_loc7_))
                  {
                     _loc22_ = _loc22_ + _loc15_.getKerning(_loc7_) * _loc2_;
                  }
                  _loc5_ = _loc15_.xAdvance * _loc2_;
                  if(this._wordWrap)
                  {
                     _loc17_ = _loc7_ == 32 || _loc7_ == 9;
                     if(_loc8_ == 32 || _loc8_ == 9)
                     {
                        if(!_loc17_)
                        {
                           _loc10_ = 0.0;
                        }
                        _loc10_ = _loc10_ + _loc5_;
                     }
                     else if(_loc17_)
                     {
                        _loc23_ = _loc22_;
                        _loc19_++;
                        _loc9_ = _loc9_ + _loc18_;
                        _loc18_ = "";
                     }
                     if(_loc19_ > 0 && _loc22_ + _loc5_ > _loc4_)
                     {
                        _loc11_ = Math.max(_loc11_,_loc23_ - _loc10_);
                        _loc7_ = NaN;
                        _loc22_ = _loc22_ - _loc23_;
                        _loc21_ = _loc21_ + _loc3_;
                        _loc23_ = 0.0;
                        _loc10_ = 0.0;
                        _loc19_ = 0;
                        _loc9_ = "";
                     }
                  }
                  _loc22_ = _loc22_ + (_loc5_ + _loc20_);
                  _loc7_ = _loc8_;
                  _loc18_ = _loc18_ + String.fromCharCode(_loc8_);
               }
            }
            _loc14_++;
         }
         _loc22_ = Math.max(0,_loc22_ - _loc20_);
         _loc11_ = Math.max(_loc11_,_loc22_);
         param1.x = _loc11_;
         param1.y = _loc21_ + _loc6_.lineHeight * _loc2_;
         return param1;
      }
      
      override protected function initialize() : void
      {
         if(!this._characterBatch)
         {
            this._characterBatch = new QuadBatch();
            this._characterBatch.touchable = false;
            this.addChild(this._characterBatch);
         }
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc3_:Boolean = this.isInvalid("state");
         if(_loc4_ || _loc3_)
         {
            this.refreshTextFormat();
         }
         if(_loc2_ || _loc4_ || _loc1_)
         {
            this._characterBatch.batchable = !this._useSeparateBatch;
            this._characterBatch.reset();
            if(!this.currentTextFormat || !this._text)
            {
               this.setSizeInternal(0,0,false);
               return;
            }
            this.layoutCharacters(HELPER_POINT);
            this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
         }
      }
      
      protected function refreshBatching() : void
      {
      }
      
      protected function layoutCharacters(param1:Point = null) : Point
      {
         var _loc19_:* = 0;
         var _loc6_:* = 0;
         var _loc20_:* = null;
         var _loc5_:* = NaN;
         var _loc24_:* = false;
         var _loc22_:* = null;
         var _loc15_:* = null;
         if(!param1)
         {
            var param1:Point = new Point();
         }
         var _loc14_:BitmapFont = this.currentTextFormat.font;
         var _loc23_:Number = this.currentTextFormat.size;
         var _loc9_:Number = this.currentTextFormat.letterSpacing;
         var _loc17_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc2_:Number = isNaN(_loc23_)?1:_loc23_ / _loc14_.size;
         var _loc3_:Number = _loc14_.lineHeight * _loc2_;
         var _loc12_:* = !isNaN(this.explicitWidth);
         var _loc10_:* = this.currentTextFormat.align != "left";
         var _loc13_:Number = _loc12_?this.explicitWidth:this._maxWidth;
         if(_loc10_ && _loc13_ == Infinity)
         {
            this.measureText(HELPER_POINT);
            _loc13_ = HELPER_POINT.x;
         }
         var _loc11_:String = this.getTruncatedText(_loc13_);
         CHARACTER_BUFFER.length = 0;
         var _loc7_:* = 0.0;
         var _loc27_:* = 0.0;
         var _loc26_:* = 0.0;
         var _loc4_:* = NaN;
         var _loc21_:* = false;
         var _loc28_:* = 0.0;
         var _loc16_:* = 0.0;
         var _loc8_:* = 0;
         var _loc25_:* = 0;
         var _loc18_:int = _loc11_?_loc11_.length:0;
         _loc19_ = 0;
         while(_loc19_ < _loc18_)
         {
            _loc21_ = false;
            _loc6_ = _loc11_.charCodeAt(_loc19_);
            if(_loc6_ == 10 || _loc6_ == 13)
            {
               _loc27_ = Math.max(0,_loc27_ - _loc9_);
               if(this._wordWrap || _loc10_)
               {
                  this.alignBuffer(_loc13_,_loc27_,0);
                  this.addBufferToBatch(0);
               }
               _loc7_ = Math.max(_loc7_,_loc27_);
               _loc4_ = NaN;
               _loc27_ = 0.0;
               _loc26_ = _loc26_ + _loc3_;
               _loc28_ = 0.0;
               _loc16_ = 0.0;
               _loc8_ = 0;
               _loc25_ = 0;
            }
            else
            {
               _loc20_ = _loc14_.getChar(_loc6_);
               if(!_loc20_)
               {
                  LogUtil("Missing character " + String.fromCharCode(_loc6_) + " in font " + _loc14_.name + ".");
               }
               else
               {
                  if(_loc17_ && !isNaN(_loc4_))
                  {
                     _loc27_ = _loc27_ + _loc20_.getKerning(_loc4_) * _loc2_;
                  }
                  _loc5_ = _loc20_.xAdvance * _loc2_;
                  if(this._wordWrap)
                  {
                     _loc24_ = _loc4_ == 32 || _loc4_ == 9;
                     if(_loc6_ == 32 || _loc6_ == 9)
                     {
                        if(!_loc24_)
                        {
                           _loc16_ = 0.0;
                        }
                        _loc16_ = _loc16_ + _loc5_;
                     }
                     else if(_loc24_)
                     {
                        _loc28_ = _loc27_;
                        _loc8_ = 0;
                        _loc25_++;
                        _loc21_ = true;
                     }
                     if(_loc21_ && !_loc10_)
                     {
                        this.addBufferToBatch(0);
                     }
                     if(_loc25_ > 0 && _loc27_ + _loc5_ > _loc13_)
                     {
                        if(_loc10_)
                        {
                           this.trimBuffer(_loc8_);
                           this.alignBuffer(_loc13_,_loc28_ - _loc16_,_loc8_);
                           this.addBufferToBatch(_loc8_);
                        }
                        this.moveBufferedCharacters(-_loc28_,_loc3_,0);
                        _loc7_ = Math.max(_loc7_,_loc28_ - _loc16_);
                        _loc4_ = NaN;
                        _loc27_ = _loc27_ - _loc28_;
                        _loc26_ = _loc26_ + _loc3_;
                        _loc28_ = 0.0;
                        _loc16_ = 0.0;
                        _loc8_ = 0;
                        _loc21_ = false;
                        _loc25_ = 0;
                     }
                  }
                  if(this._wordWrap || _loc10_)
                  {
                     _loc22_ = CHAR_LOCATION_POOL.length > 0?CHAR_LOCATION_POOL.shift():new CharLocation();
                     _loc22_.char = _loc20_;
                     _loc22_.x = _loc27_ + _loc20_.xOffset * _loc2_;
                     _loc22_.y = _loc26_ + _loc20_.yOffset * _loc2_;
                     _loc22_.scale = _loc2_;
                     CHARACTER_BUFFER[CHARACTER_BUFFER.length] = _loc22_;
                     _loc8_++;
                  }
                  else
                  {
                     this.addCharacterToBatch(_loc20_,_loc27_ + _loc20_.xOffset * _loc2_,_loc26_ + _loc20_.yOffset * _loc2_,_loc2_);
                  }
                  _loc27_ = _loc27_ + (_loc5_ + _loc9_);
                  _loc4_ = _loc6_;
               }
            }
            _loc19_++;
         }
         _loc27_ = Math.max(0,_loc27_ - _loc9_);
         if(this._wordWrap || _loc10_)
         {
            this.alignBuffer(_loc13_,_loc27_,0);
            this.addBufferToBatch(0);
         }
         _loc7_ = Math.max(_loc7_,_loc27_);
         if(_loc10_ && !_loc12_)
         {
            _loc15_ = this._textFormat.align;
            if(_loc15_ == "center")
            {
               this._batchX = (_loc7_ - _loc13_) / 2;
            }
            else if(_loc15_ == "right")
            {
               this._batchX = _loc7_ - _loc13_;
            }
         }
         else
         {
            this._batchX = 0;
         }
         this._characterBatch.x = this._batchX;
         param1.x = _loc7_;
         param1.y = _loc26_ + _loc14_.lineHeight * _loc2_;
         return param1;
      }
      
      protected function trimBuffer(param1:int) : void
      {
         var _loc7_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:int = CHARACTER_BUFFER.length - param1;
         _loc7_ = _loc6_ - 1;
         while(_loc7_ >= 0)
         {
            _loc4_ = CHARACTER_BUFFER[_loc7_];
            _loc2_ = _loc4_.char;
            _loc5_ = _loc2_.charID;
            if(_loc5_ == 32 || _loc5_ == 9)
            {
               _loc3_++;
               _loc7_--;
               continue;
            }
            break;
         }
         if(_loc3_ > 0)
         {
            CHARACTER_BUFFER.splice(_loc7_ + 1,_loc3_);
         }
      }
      
      protected function alignBuffer(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:String = this.currentTextFormat.align;
         if(_loc4_ == "center")
         {
            this.moveBufferedCharacters(Math.round((param1 - param2) / 2),0,param3);
         }
         else if(_loc4_ == "right")
         {
            this.moveBufferedCharacters(param1 - param2,0,param3);
         }
      }
      
      protected function addBufferToBatch(param1:int) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc4_:int = CHARACTER_BUFFER.length - param1;
         var _loc2_:int = CHAR_LOCATION_POOL.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = CHARACTER_BUFFER.shift();
            this.addCharacterToBatch(_loc3_.char,_loc3_.x,_loc3_.y,_loc3_.scale);
            _loc3_.char = null;
            CHAR_LOCATION_POOL[_loc2_] = _loc3_;
            _loc2_++;
            _loc5_++;
         }
      }
      
      protected function moveBufferedCharacters(param1:Number, param2:Number, param3:int) : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc5_:int = CHARACTER_BUFFER.length - param3;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = CHARACTER_BUFFER[_loc6_];
            _loc4_.x = _loc4_.x + param1;
            _loc4_.y = _loc4_.y + param2;
            _loc6_++;
         }
      }
      
      protected function addCharacterToBatch(param1:BitmapChar, param2:Number, param3:Number, param4:Number, param5:RenderSupport = null, param6:Number = 1) : void
      {
         if(!HELPER_IMAGE)
         {
            HELPER_IMAGE = new Image(param1.texture);
         }
         else
         {
            HELPER_IMAGE.texture = param1.texture;
            HELPER_IMAGE.readjustSize();
         }
         var _loc7_:* = param4;
         HELPER_IMAGE.scaleY = _loc7_;
         HELPER_IMAGE.scaleX = _loc7_;
         HELPER_IMAGE.x = param2;
         HELPER_IMAGE.y = param3;
         HELPER_IMAGE.color = this.currentTextFormat.color;
         HELPER_IMAGE.smoothing = this._smoothing;
         if(param5)
         {
            param5.pushMatrix();
            param5.transformMatrix(HELPER_IMAGE);
            param5.batchQuad(HELPER_IMAGE,param6,HELPER_IMAGE.texture,this._smoothing);
            param5.popMatrix();
         }
         else
         {
            this._characterBatch.addImage(HELPER_IMAGE);
         }
      }
      
      protected function refreshTextFormat() : void
      {
         if(!this._isEnabled && this._disabledTextFormat)
         {
            this.currentTextFormat = this._disabledTextFormat;
         }
         else
         {
            this.currentTextFormat = this._textFormat;
         }
      }
      
      protected function getTruncatedText(param1:Number) : String
      {
         var _loc9_:* = 0;
         var _loc6_:* = 0;
         var _loc11_:* = null;
         var _loc3_:* = NaN;
         var _loc10_:* = NaN;
         if(!this._text)
         {
            return "";
         }
         if(param1 == Infinity || this._wordWrap || this._text.indexOf(String.fromCharCode(10)) >= 0 || this._text.indexOf(String.fromCharCode(13)) >= 0)
         {
            return this._text;
         }
         var _loc4_:BitmapFont = this.currentTextFormat.font;
         var _loc13_:Number = this.currentTextFormat.size;
         var _loc14_:Number = this.currentTextFormat.letterSpacing;
         var _loc7_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc2_:Number = isNaN(_loc13_)?1:_loc13_ / _loc4_.size;
         var _loc15_:* = 0.0;
         var _loc5_:* = NaN;
         var _loc8_:int = this._text.length;
         var _loc12_:* = -1;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc6_ = this._text.charCodeAt(_loc9_);
            _loc11_ = _loc4_.getChar(_loc6_);
            if(_loc11_)
            {
               _loc3_ = 0.0;
               if(_loc7_ && !isNaN(_loc5_))
               {
                  _loc3_ = _loc11_.getKerning(_loc5_) * _loc2_;
               }
               _loc15_ = _loc15_ + (_loc3_ + _loc11_.xAdvance * _loc2_);
               if(_loc15_ > param1)
               {
                  _loc10_ = Math.abs(_loc15_ - param1);
                  if(_loc10_ > 1.0E-6)
                  {
                     _loc12_ = _loc9_;
                     break;
                  }
               }
               _loc15_ = _loc15_ + _loc14_;
               _loc5_ = _loc6_;
            }
            _loc9_++;
         }
         if(_loc12_ >= 0)
         {
            _loc8_ = this._truncationText.length;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc6_ = this._truncationText.charCodeAt(_loc9_);
               _loc11_ = _loc4_.getChar(_loc6_);
               if(_loc11_)
               {
                  _loc3_ = 0.0;
                  if(_loc7_ && !isNaN(_loc5_))
                  {
                     _loc3_ = _loc11_.getKerning(_loc5_) * _loc2_;
                  }
                  _loc15_ = _loc15_ + (_loc3_ + _loc11_.xAdvance * _loc2_ + _loc14_);
                  _loc5_ = _loc6_;
               }
               _loc9_++;
            }
            _loc15_ = _loc15_ - _loc14_;
            _loc9_ = _loc12_;
            while(_loc9_ >= 0)
            {
               _loc6_ = this._text.charCodeAt(_loc9_);
               _loc5_ = _loc9_ > 0?this._text.charCodeAt(_loc9_ - 1):NaN;
               _loc11_ = _loc4_.getChar(_loc6_);
               if(_loc11_)
               {
                  _loc3_ = 0.0;
                  if(_loc7_ && !isNaN(_loc5_))
                  {
                     _loc3_ = _loc11_.getKerning(_loc5_) * _loc2_;
                  }
                  _loc15_ = _loc15_ - (_loc3_ + _loc11_.xAdvance * _loc2_ + _loc14_);
                  if(_loc15_ <= param1)
                  {
                     return this._text.substr(0,_loc9_) + this._truncationText;
                  }
               }
               _loc9_--;
            }
            return this._truncationText;
         }
         return this._text;
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
    
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   function CharLocation()
   {
      super();
   }
}
