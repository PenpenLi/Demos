package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextEditor;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.display.Image;
   import flash.text.TextField;
   import starling.core.RenderSupport;
   import starling.utils.MatrixUtil;
   import starling.core.Starling;
   import flash.geom.Rectangle;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import starling.textures.ConcreteTexture;
   import flash.text.TextFormat;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import flash.utils.getDefinitionByName;
   import feathers.text.StageTextField;
   import starling.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   
   public class StageTextTextEditor extends FeathersControl implements ITextEditor
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_POSITION:String = "position";
       
      protected var stageText:Object;
      
      protected var textSnapshot:Image;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _ignoreStageTextChanges:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _measureTextField:TextField;
      
      protected var _stageTextHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionStartIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _stageTextIsComplete:Boolean = false;
      
      protected var _autoCapitalize:String = "none";
      
      protected var _autoCorrect:Boolean = false;
      
      protected var _color:uint = 0;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _fontFamily:String = null;
      
      protected var _fontPosture:String = "normal";
      
      protected var _fontSize:int = 12;
      
      protected var _fontWeight:String = "normal";
      
      protected var _locale:String = "en";
      
      protected var _maxChars:int = 0;
      
      protected var _multiline:Boolean = false;
      
      protected var _restrict:String;
      
      protected var _returnKeyLabel:String = "default";
      
      protected var _softKeyboardType:String = "default";
      
      protected var _textAlign:String = "start";
      
      public function StageTextTextEditor()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("addedToStage",addedToStageHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      override public function set x(param1:Number) : void
      {
         .super.x = param1;
         this.invalidate("position");
      }
      
      override public function set y(param1:Number) : void
      {
         .super.y = param1;
         this.invalidate("position");
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            var param1:String = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get autoCapitalize() : String
      {
         return this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         if(this._autoCapitalize == param1)
         {
            return;
         }
         this._autoCapitalize = param1;
         this.invalidate("styles");
      }
      
      public function get autoCorrect() : Boolean
      {
         return this._autoCorrect;
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         if(this._autoCorrect == param1)
         {
            return;
         }
         this._autoCorrect = param1;
         this.invalidate("styles");
      }
      
      public function get color() : uint
      {
         return this._color as uint;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
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
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate("styles");
      }
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return true;
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(param1:String) : void
      {
         if(this._fontFamily == param1)
         {
            return;
         }
         this._fontFamily = param1;
         this.invalidate("styles");
      }
      
      public function get fontPosture() : String
      {
         return this._fontPosture;
      }
      
      public function set fontPosture(param1:String) : void
      {
         if(this._fontPosture == param1)
         {
            return;
         }
         this._fontPosture = param1;
         this.invalidate("styles");
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(this._fontSize == param1)
         {
            return;
         }
         this._fontSize = param1;
         this.invalidate("styles");
      }
      
      public function get fontWeight() : String
      {
         return this._fontWeight;
      }
      
      public function set fontWeight(param1:String) : void
      {
         if(this._fontWeight == param1)
         {
            return;
         }
         this._fontWeight = param1;
         this.invalidate("styles");
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
         this.invalidate("styles");
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate("styles");
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         if(this._multiline == param1)
         {
            return;
         }
         this._multiline = param1;
         this.invalidate("styles");
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate("styles");
      }
      
      public function get returnKeyLabel() : String
      {
         return this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         if(this._returnKeyLabel == param1)
         {
            return;
         }
         this._returnKeyLabel = param1;
         this.invalidate("styles");
      }
      
      public function get softKeyboardType() : String
      {
         return this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         if(this._softKeyboardType == param1)
         {
            return;
         }
         this._softKeyboardType = param1;
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
      
      override public function dispose() : void
      {
         this.disposeContent();
         super.dispose();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc4_:* = NaN;
         var _loc3_:* = NaN;
         var _loc7_:* = NaN;
         var _loc10_:* = 0;
         HELPER_POINT.y = _loc10_;
         HELPER_POINT.x = _loc10_;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc5_:Rectangle = Starling.current.viewPort;
         var _loc9_:Rectangle = this.stageText.viewPort;
         if(!_loc9_)
         {
            _loc9_ = new Rectangle();
         }
         var _loc6_:* = 1.0;
         if(Starling.current.supportHighResolutions)
         {
            _loc6_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc8_:Number = Starling.contentScaleFactor / _loc6_;
         _loc9_.x = Math.round(_loc5_.x + HELPER_POINT.x * _loc8_);
         _loc9_.y = Math.round(_loc5_.y + HELPER_POINT.y * _loc8_);
         this.stageText.viewPort = _loc9_;
         if(this.stageText.visible)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc4_ = matrixToScaleX(HELPER_MATRIX);
            _loc3_ = matrixToScaleY(HELPER_MATRIX);
            _loc7_ = _loc4_;
            if(_loc3_ < _loc4_)
            {
               _loc7_ = _loc3_;
            }
            _loc8_ = Starling.contentScaleFactor;
            this.stageText.fontSize = this._fontSize * _loc8_ * _loc7_;
         }
         if(this.textSnapshot)
         {
            this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
            this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
         }
         super.render(param1,param2);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = NaN;
         if(this.stageText && this._stageTextIsComplete)
         {
            if(param1)
            {
               _loc3_ = param1.x;
               _loc5_ = param1.y;
               if(_loc3_ < 0)
               {
                  var _loc7_:* = 0;
                  this._pendingSelectionEndIndex = _loc7_;
                  this._pendingSelectionStartIndex = _loc7_;
               }
               else
               {
                  this._pendingSelectionStartIndex = this._measureTextField.getCharIndexAtPoint(_loc3_,_loc5_);
                  if(this._pendingSelectionStartIndex < 0)
                  {
                     if(this._multiline)
                     {
                        _loc6_ = _loc5_ / this._measureTextField.getLineMetrics(0).height;
                        try
                        {
                           this._pendingSelectionStartIndex = this._measureTextField.getLineOffset(_loc6_) + this._measureTextField.getLineLength(_loc6_);
                           if(this._pendingSelectionStartIndex != this._text.length)
                           {
                              §§dup(this)._pendingSelectionStartIndex--;
                           }
                        }
                        catch(error:Error)
                        {
                           this._pendingSelectionStartIndex = this._text.length;
                        }
                     }
                     else
                     {
                        this._pendingSelectionStartIndex = this._text.length;
                     }
                  }
                  else
                  {
                     _loc2_ = this._measureTextField.getCharBoundaries(this._pendingSelectionStartIndex);
                     _loc4_ = _loc2_.x;
                     if(_loc2_ && _loc4_ + _loc2_.width - _loc3_ < _loc3_ - _loc4_)
                     {
                        §§dup(this)._pendingSelectionStartIndex++;
                     }
                  }
                  this._pendingSelectionEndIndex = this._pendingSelectionStartIndex;
               }
            }
            else
            {
               var _loc9_:* = -1;
               this._pendingSelectionEndIndex = _loc9_;
               this._pendingSelectionStartIndex = _loc9_;
            }
            this.stageText.visible = true;
            this.stageText.assignFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._stageTextHasFocus)
         {
            return;
         }
         Starling.current.nativeStage.focus = Starling.current.nativeStage;
         this.dispatchEventWith("focusOut");
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this._stageTextIsComplete && this.stageText)
         {
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.stageText.selectRange(param1,param2);
         }
         else
         {
            this._pendingSelectionStartIndex = param1;
            this._pendingSelectionEndIndex = param2;
         }
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            var param1:Point = new Point();
         }
         if(!this._measureTextField)
         {
            var _loc6_:* = 0;
            param1.y = _loc6_;
            param1.x = _loc6_;
            return param1;
         }
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("data");
         if(_loc5_ || _loc3_)
         {
            this.refreshMeasureProperties();
         }
         param1 = this.measure(param1);
         return param1;
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
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("data");
         if(_loc4_ || _loc1_)
         {
            this.refreshMeasureProperties();
         }
         var _loc2_:Boolean = this._ignoreStageTextChanges;
         this._ignoreStageTextChanges = true;
         if(_loc4_)
         {
            this.refreshStageTextProperties();
         }
         if(_loc1_)
         {
            if(this.stageText.text != this._text)
            {
               if(this._pendingSelectionStartIndex < 0)
               {
                  this._pendingSelectionStartIndex = this.stageText.selectionActiveIndex;
                  this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
               }
               this.stageText.text = this._text;
            }
         }
         this._ignoreStageTextChanges = _loc2_;
         if(_loc4_ || _loc3_)
         {
            this.stageText.editable = this._isEditable && this._isEnabled;
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
         this._measureTextField.autoSize = "left";
         var _loc4_:Number = this.explicitWidth;
         if(_loc3_)
         {
            _loc4_ = Math.max(this._minWidth,Math.min(this._maxWidth,this._measureTextField.width));
         }
         this._measureTextField.width = _loc4_;
         var _loc2_:Number = this.explicitHeight;
         if(_loc5_)
         {
            _loc2_ = Math.max(this._minHeight,Math.min(this._maxHeight,this._measureTextField.height));
         }
         this._measureTextField.autoSize = "none";
         this._measureTextField.width = this.actualWidth;
         this._measureTextField.height = this.actualHeight;
         param1.x = _loc4_;
         param1.y = _loc2_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = false;
         var _loc7_:Boolean = this.isInvalid("state");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc6_:Boolean = this.isInvalid("position");
         var _loc2_:Boolean = this.isInvalid("skin");
         if(_loc6_ || param1 || _loc8_ || _loc2_ || _loc7_)
         {
            this.refreshViewPort();
            _loc3_ = this.stageText.viewPort;
            _loc4_ = this.textSnapshot?this.textSnapshot.texture.root:null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc3_.width != _loc4_.width || _loc3_.height != _loc4_.height;
         }
         if(!this._stageTextHasFocus && (_loc8_ || _loc5_ || param1 || this._needsNewTexture))
         {
            _loc9_ = this._text.length > 0;
            if(_loc9_)
            {
               this.refreshSnapshot();
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = _loc9_?1:0.0;
            }
            this.stageText.visible = false;
         }
         this.doPendingActions();
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
      
      protected function refreshMeasureProperties() : void
      {
         this._measureTextField.displayAsPassword = this._displayAsPassword;
         this._measureTextField.maxChars = this._maxChars;
         this._measureTextField.restrict = this._restrict;
         var _loc3_:* = this._multiline;
         this._measureTextField.wordWrap = _loc3_;
         this._measureTextField.multiline = _loc3_;
         var _loc2_:TextFormat = this._measureTextField.defaultTextFormat;
         _loc2_.color = this._color;
         _loc2_.font = this._fontFamily;
         _loc2_.italic = this._fontPosture == "italic";
         _loc2_.size = this._fontSize;
         _loc2_.bold = this._fontWeight == "bold";
         var _loc1_:String = this._textAlign;
         if(_loc1_ == "start")
         {
            _loc1_ = "left";
         }
         else if(_loc1_ == "end")
         {
            _loc1_ = "right";
         }
         _loc2_.align = _loc1_;
         this._measureTextField.defaultTextFormat = _loc2_;
         this._measureTextField.setTextFormat(_loc2_);
         this._measureTextField.text = this._text;
      }
      
      protected function refreshStageTextProperties() : void
      {
         if(this.stageText.multiline != this._multiline)
         {
            if(this.stageText)
            {
               this.disposeStageText();
            }
            this.createStageText();
         }
         this.stageText.autoCapitalize = this._autoCapitalize;
         this.stageText.autoCorrect = this._autoCorrect;
         this.stageText.color = this._color;
         this.stageText.displayAsPassword = this._displayAsPassword;
         this.stageText.fontFamily = this._fontFamily;
         this.stageText.fontPosture = this._fontPosture;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc1_:Number = matrixToScaleY(HELPER_MATRIX);
         var _loc3_:* = _loc2_;
         if(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_;
         }
         var _loc4_:Number = Starling.contentScaleFactor;
         this.stageText.fontSize = this._fontSize * _loc4_ * _loc3_;
         this.stageText.fontWeight = this._fontWeight;
         this.stageText.locale = this._locale;
         this.stageText.maxChars = this._maxChars;
         this.stageText.restrict = this._restrict;
         this.stageText.returnKeyLabel = this._returnKeyLabel;
         this.stageText.softKeyboardType = this._softKeyboardType;
         this.stageText.textAlign = this._textAlign;
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            this.setFocus();
         }
         if(this._pendingSelectionStartIndex >= 0)
         {
            _loc1_ = this._pendingSelectionStartIndex;
            _loc2_ = this._pendingSelectionEndIndex < 0?this._pendingSelectionStartIndex:this._pendingSelectionEndIndex;
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function texture_onRestore() : void
      {
         this.refreshSnapshot();
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = !this._stageTextHasFocus;
            this.textSnapshot.alpha = this._text.length > 0?1:0.0;
         }
         if(!this._stageTextHasFocus)
         {
            this.stageText.visible = false;
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:Rectangle = this.stageText.viewPort;
         if(_loc2_.width == 0 || _loc2_.height == 0)
         {
            return;
         }
         var _loc1_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,16711935);
         this.stageText.drawViewPortToBitmapData(_loc1_);
         if(!this.textSnapshot || this._needsNewTexture)
         {
            _loc4_ = Texture.fromBitmapData(_loc1_,false,false,Starling.contentScaleFactor);
            _loc4_.root.onRestore = texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc4_);
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc4_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            _loc3_ = this.textSnapshot.texture;
            _loc3_.root.uploadBitmapData(_loc1_);
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.scaleX = 1 / matrixToScaleX(HELPER_MATRIX);
         this.textSnapshot.scaleY = 1 / matrixToScaleY(HELPER_MATRIX);
         _loc1_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function refreshViewPort() : void
      {
         var _loc3_:Rectangle = Starling.current.viewPort;
         var _loc8_:Rectangle = this.stageText.viewPort;
         if(!_loc8_)
         {
            _loc8_ = new Rectangle();
         }
         if(!this.stageText.stage)
         {
            this.stageText.stage = Starling.current.nativeStage;
         }
         var _loc9_:* = 0;
         HELPER_POINT.y = _loc9_;
         HELPER_POINT.x = _loc9_;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc1_:Number = matrixToScaleY(HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc4_:* = 1.0;
         if(Starling.current.supportHighResolutions)
         {
            _loc4_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc7_:Number = Starling.contentScaleFactor / _loc4_;
         _loc8_.x = Math.round(_loc3_.x + HELPER_POINT.x * _loc7_);
         _loc8_.y = Math.round(_loc3_.y + HELPER_POINT.y * _loc7_);
         var _loc6_:Number = Math.round(this.actualWidth * _loc7_ * _loc2_);
         if(_loc6_ < 1 || isNaN(_loc6_))
         {
            _loc6_ = 1.0;
         }
         var _loc5_:Number = Math.round(this.actualHeight * _loc7_ * _loc1_);
         if(_loc5_ < 1 || isNaN(_loc5_))
         {
            _loc5_ = 1.0;
         }
         _loc8_.width = _loc6_;
         _loc8_.height = _loc5_;
         this.stageText.viewPort = _loc8_;
         this._measureTextField.width = this.actualWidth;
         this._measureTextField.height = this.actualHeight;
      }
      
      protected function disposeContent() : void
      {
         if(this._measureTextField)
         {
            Starling.current.nativeStage.removeChild(this._measureTextField);
            this._measureTextField = null;
         }
         if(this.stageText)
         {
            this.disposeStageText();
         }
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
      }
      
      protected function disposeStageText() : void
      {
         if(!this.stageText)
         {
            return;
         }
         this.stageText.removeEventListener("change",stageText_changeHandler);
         this.stageText.removeEventListener("keyDown",stageText_keyDownHandler);
         this.stageText.removeEventListener("keyUp",stageText_keyUpHandler);
         this.stageText.removeEventListener("focusIn",stageText_focusInHandler);
         this.stageText.removeEventListener("focusOut",stageText_focusOutHandler);
         this.stageText.removeEventListener("complete",stageText_completeHandler);
         this.stageText.removeEventListener("softKeyboardActivate",stageText_softKeyboardActivateHandler);
         this.stageText.removeEventListener("softKeyboardDeactivate",stageText_softKeyboardDeactivateHandler);
         this.stageText.stage = null;
         this.stageText.dispose();
         this.stageText = null;
      }
      
      protected function createStageText() : void
      {
         var _loc1_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         this._stageTextIsComplete = false;
         try
         {
            _loc1_ = Class(getDefinitionByName("flash.text.StageText"));
            _loc2_ = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
            _loc3_ = new _loc2_(this._multiline);
         }
         catch(error:Error)
         {
            _loc1_ = StageTextField;
            _loc3_ = {"multiline":this._multiline};
         }
         this.stageText = new _loc1_(_loc3_);
         this.stageText.visible = false;
         this.stageText.addEventListener("change",stageText_changeHandler);
         this.stageText.addEventListener("keyDown",stageText_keyDownHandler);
         this.stageText.addEventListener("keyUp",stageText_keyUpHandler);
         this.stageText.addEventListener("focusIn",stageText_focusInHandler);
         this.stageText.addEventListener("focusOut",stageText_focusOutHandler);
         this.stageText.addEventListener("softKeyboardActivate",stageText_softKeyboardActivateHandler);
         this.stageText.addEventListener("softKeyboardDeactivate",stageText_softKeyboardDeactivateHandler);
         this.stageText.addEventListener("complete",stageText_completeHandler);
         this.invalidate();
      }
      
      protected function addedToStageHandler(param1:starling.events.Event) : void
      {
         if(this._measureTextField && !this._measureTextField.parent)
         {
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         else if(!this._measureTextField)
         {
            this._measureTextField = new TextField();
            this._measureTextField.visible = false;
            var _loc2_:* = false;
            this._measureTextField.mouseWheelEnabled = _loc2_;
            this._measureTextField.mouseEnabled = _loc2_;
            this._measureTextField.autoSize = "left";
            this._measureTextField.multiline = false;
            this._measureTextField.wordWrap = false;
            this._measureTextField.embedFonts = false;
            this._measureTextField.defaultTextFormat = new TextFormat(null,11,0,false,false,false);
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         this.createStageText();
      }
      
      protected function removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.disposeContent();
      }
      
      protected function stageText_changeHandler(param1:flash.events.Event) : void
      {
         if(this._ignoreStageTextChanges)
         {
            return;
         }
         this.text = this.stageText.text;
      }
      
      protected function stageText_completeHandler(param1:flash.events.Event) : void
      {
         this.stageText.removeEventListener("complete",stageText_completeHandler);
         this.invalidate();
         this._stageTextIsComplete = true;
      }
      
      protected function stageText_focusInHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = true;
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate("skin");
         this.dispatchEventWith("focusIn");
      }
      
      protected function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = false;
         this.stageText.selectRange(1,1);
         this.invalidate("data");
         this.invalidate("skin");
         this.dispatchEventWith("focusOut");
      }
      
      protected function stageText_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == 13 || param1.keyCode == 16777230))
         {
            param1.preventDefault();
            this.dispatchEventWith("enter");
         }
         else if(param1.keyCode == 16777238)
         {
            param1.preventDefault();
            Starling.current.nativeStage.focus = Starling.current.nativeStage;
         }
      }
      
      protected function stageText_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == 13 || param1.keyCode == 16777230))
         {
            param1.preventDefault();
         }
      }
      
      protected function stageText_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardActivate",true);
      }
      
      protected function stageText_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardDeactivate",true);
      }
   }
}
