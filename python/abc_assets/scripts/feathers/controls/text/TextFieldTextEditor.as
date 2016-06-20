package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextEditor;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextField;
   import starling.display.Image;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import starling.utils.MatrixUtil;
   import feathers.utils.geom.matrixToRotation;
   import starling.utils.getNextPowerOfTwo;
   import starling.textures.ConcreteTexture;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import starling.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   
   public class TextFieldTextEditor extends FeathersControl implements ITextEditor
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
       
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var measureTextField:TextField;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _textFieldClipRect:Rectangle;
      
      protected var _textFieldOffsetX:Number = 0;
      
      protected var _textFieldOffsetY:Number = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _textFormat:TextFormat;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _multiline:Boolean = false;
      
      protected var _isHTML:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _textFieldHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionStartIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var resetScrollOnFocusOut:Boolean = true;
      
      public function TextFieldTextEditor()
      {
         _textFieldClipRect = new Rectangle();
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
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         if(this._alwaysShowSelection == param1)
         {
            return;
         }
         this._alwaysShowSelection = param1;
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
         return false;
      }
      
      override public function dispose() : void
      {
         this.disposeContent();
         super.dispose();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc3_:Boolean = this.textSnapshot?!this.textSnapshot.visible:this._textFieldHasFocus;
         this.textField.visible = _loc3_;
         this.transformTextField();
         this.positionSnapshot();
         super.render(param1,param2);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = NaN;
         if(this.textField)
         {
            if(!this.textField.parent)
            {
               Starling.current.nativeStage.addChild(this.textField);
            }
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
                  this._pendingSelectionStartIndex = this.textField.getCharIndexAtPoint(_loc3_,_loc5_);
                  if(this._pendingSelectionStartIndex < 0)
                  {
                     if(this._multiline)
                     {
                        _loc6_ = _loc5_ / this.textField.getLineMetrics(0).height + (this.textField.scrollV - 1);
                        try
                        {
                           this._pendingSelectionStartIndex = this.textField.getLineOffset(_loc6_) + this.textField.getLineLength(_loc6_);
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
                     _loc2_ = this.textField.getCharBoundaries(this._pendingSelectionStartIndex);
                     if(_loc2_)
                     {
                        _loc4_ = _loc2_.x;
                        if(_loc2_ && _loc4_ + _loc2_.width - _loc3_ < _loc3_ - _loc4_)
                        {
                           §§dup(this)._pendingSelectionStartIndex++;
                        }
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
            if(!this._focusManager)
            {
               Starling.current.nativeStage.focus = this.textField;
            }
            this.textField.requestSoftKeyboard();
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._textFieldHasFocus || this._focusManager)
         {
            return;
         }
         Starling.current.nativeStage.focus = Starling.current.nativeStage;
         this.dispatchEventWith("focusOut");
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this.textField)
         {
            this.validate();
            this.textField.setSelection(param1,param2);
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
         this.textField = new TextField();
         this.textField.needsSoftKeyboard = true;
         this.textField.addEventListener("change",textField_changeHandler);
         this.textField.addEventListener("focusIn",textField_focusInHandler);
         this.textField.addEventListener("focusOut",textField_focusOutHandler);
         this.textField.addEventListener("keyDown",textField_keyDownHandler);
         this.textField.addEventListener("softKeyboardActivate",textField_softKeyboardActivateHandler);
         this.textField.addEventListener("softKeyboardDeactivate",textField_softKeyboardDeactivateHandler);
         this.measureTextField = new TextField();
         this.measureTextField.autoSize = "left";
         this.measureTextField.selectable = false;
         this.measureTextField.mouseWheelEnabled = false;
         this.measureTextField.mouseEnabled = false;
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
            this.commitStylesAndData(this.textField);
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
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            var param1:Point = new Point();
         }
         var _loc3_:Boolean = isNaN(this.explicitWidth);
         var _loc5_:Boolean = isNaN(this.explicitHeight);
         if(!_loc3_ && !_loc5_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         this.commitStylesAndData(this.measureTextField);
         var _loc4_:Number = this.explicitWidth;
         if(_loc3_)
         {
            this.measureTextField.width = _loc4_;
            _loc4_ = Math.max(this._minWidth,Math.min(this._maxWidth,this.measureTextField.textWidth + 4));
         }
         var _loc2_:Number = this.explicitHeight;
         if(_loc5_)
         {
            this.measureTextField.width = _loc4_;
            _loc2_ = Math.max(this._minHeight,Math.min(this._maxHeight,this.textField.textHeight + 4));
         }
         param1.x = _loc4_;
         param1.y = _loc2_;
         return param1;
      }
      
      protected function commitStylesAndData(param1:TextField) : void
      {
         param1.maxChars = this._maxChars;
         param1.restrict = this._restrict;
         param1.alwaysShowSelection = this._alwaysShowSelection;
         param1.displayAsPassword = this._displayAsPassword;
         param1.wordWrap = this._wordWrap;
         param1.multiline = this._multiline;
         param1.embedFonts = this._embedFonts;
         param1.type = this._isEditable?"input":"dynamic";
         param1.selectable = this._isEnabled;
         if(this._textFormat)
         {
            param1.defaultTextFormat = this._textFormat;
         }
         if(this._isHTML)
         {
            if(param1.htmlText != this._text)
            {
               if(param1 == this.textField && this._pendingSelectionStartIndex < 0)
               {
                  this._pendingSelectionStartIndex = this.textField.selectionBeginIndex;
                  this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
               }
               param1.htmlText = this._text;
            }
         }
         else if(param1.text != this._text)
         {
            if(param1 == this.textField && this._pendingSelectionStartIndex < 0)
            {
               this._pendingSelectionStartIndex = this.textField.selectionBeginIndex;
               this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
            }
            param1.text = this._text;
         }
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("data");
         if(param1)
         {
            this.refreshSnapshotParameters();
            this.refreshTextFieldSize();
            this.transformTextField();
            this.positionSnapshot();
         }
         this.checkIfNewSnapshotIsNeeded();
         if(!this._textFieldHasFocus && (_loc3_ || _loc2_ || this._needsNewTexture))
         {
            this.addEventListener("enterFrame",enterFrameHandler);
         }
         this.doPendingActions();
      }
      
      protected function refreshTextFieldSize() : void
      {
         this.textField.width = this.actualWidth;
         this.textField.height = this.actualHeight;
      }
      
      protected function refreshSnapshotParameters() : void
      {
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldClipRect.x = 0;
         this._textFieldClipRect.y = 0;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this._textFieldClipRect.width = this.actualWidth * Starling.contentScaleFactor * matrixToScaleX(HELPER_MATRIX);
         this._textFieldClipRect.height = this.actualHeight * Starling.contentScaleFactor * matrixToScaleY(HELPER_MATRIX);
      }
      
      protected function transformTextField() : void
      {
         if(!this.textField.visible)
         {
            return;
         }
         var _loc4_:* = 0;
         HELPER_POINT.y = _loc4_;
         HELPER_POINT.x = _loc4_;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc1_:Rectangle = Starling.current.viewPort;
         var _loc2_:* = 1.0;
         if(Starling.current.supportHighResolutions)
         {
            _loc2_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc3_:Number = Starling.contentScaleFactor / _loc2_;
         this.textField.x = Math.round(_loc1_.x + HELPER_POINT.x * _loc3_);
         this.textField.y = Math.round(_loc1_.y + HELPER_POINT.y * _loc3_);
         this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / 3.141592653589793;
         _loc3_ = Starling.contentScaleFactor;
         this.textField.scaleX = matrixToScaleX(HELPER_MATRIX) * _loc3_;
         this.textField.scaleY = matrixToScaleY(HELPER_MATRIX) * _loc3_;
      }
      
      protected function positionSnapshot() : void
      {
         if(!this.textSnapshot)
         {
            return;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
         this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
      }
      
      protected function checkIfNewSnapshotIsNeeded() : void
      {
         this._snapshotWidth = getNextPowerOfTwo(this._textFieldClipRect.width);
         this._snapshotHeight = getNextPowerOfTwo(this._textFieldClipRect.height);
         var _loc1_:ConcreteTexture = this.textSnapshot?this.textSnapshot.texture.root:null;
         this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != _loc1_.width || this._snapshotHeight != _loc1_.height;
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
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionStartIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function texture_onRestore() : void
      {
         this.refreshSnapshot();
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc6_:* = null;
         var _loc5_:* = null;
         if(this.textField.width == 0 || this.textField.height == 0)
         {
            return;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc1_:Number = matrixToScaleY(HELPER_MATRIX);
         var _loc4_:Number = Starling.contentScaleFactor;
         HELPER_MATRIX.identity();
         HELPER_MATRIX.translate(this._textFieldOffsetX,this._textFieldOffsetY);
         HELPER_MATRIX.scale(_loc4_ * _loc2_,_loc4_ * _loc1_);
         var _loc3_:BitmapData = new BitmapData(this._snapshotWidth,this._snapshotHeight,true,16711935);
         _loc3_.draw(this.textField,HELPER_MATRIX,null,null,this._textFieldClipRect);
         if(!this.textSnapshot || this._needsNewTexture)
         {
            _loc6_ = Texture.fromBitmapData(_loc3_,false,false,Starling.contentScaleFactor);
            _loc6_.root.onRestore = texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc6_);
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc6_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            _loc5_ = this.textSnapshot.texture;
            _loc5_.root.uploadBitmapData(_loc3_);
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.scaleX = 1 / matrixToScaleX(HELPER_MATRIX);
         this.textSnapshot.scaleY = 1 / matrixToScaleY(HELPER_MATRIX);
         _loc3_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function disposeContent() : void
      {
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textField.parent)
         {
            Starling.current.nativeStage.removeChild(this.textField);
         }
      }
      
      protected function addedToStageHandler(param1:starling.events.Event) : void
      {
         this.invalidate("data");
      }
      
      protected function removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.disposeContent();
      }
      
      protected function enterFrameHandler(param1:starling.events.Event) : void
      {
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.refreshSnapshot();
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = !this._textFieldHasFocus;
            this.textSnapshot.alpha = this._text.length > 0?1:0.0;
         }
      }
      
      protected function textField_changeHandler(param1:flash.events.Event) : void
      {
         this.text = this.textField.text;
      }
      
      protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = true;
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate("skin");
         this.dispatchEventWith("focusIn");
      }
      
      protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = false;
         if(this.resetScrollOnFocusOut)
         {
            var _loc2_:* = 0;
            this.textField.scrollV = _loc2_;
            this.textField.scrollH = _loc2_;
         }
         this.invalidate("data");
         this.invalidate("skin");
         this.dispatchEventWith("focusOut");
      }
      
      protected function textField_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.dispatchEventWith("enter");
         }
      }
      
      protected function textField_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardActivate",true);
      }
      
      protected function textField_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardDeactivate",true);
      }
   }
}
