package starling.display
{
   import starling.textures.Texture;
   import starling.text.TextField;
   import flash.geom.Rectangle;
   import starling.events.TouchEvent;
   import flash.ui.Mouse;
   import starling.events.Touch;
   
   public class Button extends DisplayObjectContainer
   {
      
      private static const MAX_DRAG_DIST:Number = 50;
       
      private var mUpState:Texture;
      
      private var mDownState:Texture;
      
      private var mContents:starling.display.Sprite;
      
      private var mBackground:starling.display.Image;
      
      private var mTextField:TextField;
      
      private var mTextBounds:Rectangle;
      
      private var mScaleWhenDown:Number;
      
      private var mAlphaWhenDisabled:Number;
      
      private var mEnabled:Boolean;
      
      private var mIsDown:Boolean;
      
      private var mUseHandCursor:Boolean;
      
      public function Button(param1:Texture, param2:String = "", param3:Texture = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Texture cannot be null");
         }
         mUpState = param1;
         mDownState = param3?param3:param1;
         mBackground = new starling.display.Image(param1);
         mScaleWhenDown = param3?1:0.9;
         mAlphaWhenDisabled = 0.5;
         mEnabled = true;
         mIsDown = false;
         mUseHandCursor = true;
         mTextBounds = new Rectangle(0,0,param1.width,param1.height);
         mContents = new starling.display.Sprite();
         mContents.addChild(mBackground);
         addChild(mContents);
         addEventListener("touch",onTouch);
         this.touchGroup = true;
         this.text = param2;
      }
      
      override public function dispose() : void
      {
         if(mTextField)
         {
            mTextField.dispose();
         }
         super.dispose();
      }
      
      private function resetContents() : void
      {
         mIsDown = false;
         mBackground.texture = mUpState;
         var _loc1_:* = 0;
         mContents.y = _loc1_;
         mContents.x = _loc1_;
         _loc1_ = 1;
         mContents.scaleY = _loc1_;
         mContents.scaleX = _loc1_;
      }
      
      private function createTextField() : void
      {
         if(mTextField == null)
         {
            mTextField = new TextField(mTextBounds.width,mTextBounds.height,"");
            mTextField.vAlign = "center";
            mTextField.hAlign = "center";
            mTextField.touchable = false;
            mTextField.autoScale = true;
            mTextField.batchable = true;
         }
         mTextField.width = mTextBounds.width;
         mTextField.height = mTextBounds.height;
         mTextField.x = mTextBounds.x;
         mTextField.y = mTextBounds.y;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         Mouse.cursor = mUseHandCursor && mEnabled && param1.interactsWith(this)?"button":"auto";
         var _loc2_:Touch = param1.getTouch(this);
         if(!mEnabled || _loc2_ == null)
         {
            return;
         }
         if(_loc2_.phase == "began" && !mIsDown)
         {
            mBackground.texture = mDownState;
            var _loc4_:* = mScaleWhenDown;
            mContents.scaleY = _loc4_;
            mContents.scaleX = _loc4_;
            mContents.x = (1 - mScaleWhenDown) / 2 * mBackground.width;
            mContents.y = (1 - mScaleWhenDown) / 2 * mBackground.height;
            mIsDown = true;
         }
         else if(_loc2_.phase == "moved" && mIsDown)
         {
            _loc3_ = getBounds(stage);
            if(_loc2_.globalX < _loc3_.x - 50 || _loc2_.globalY < _loc3_.y - 50 || _loc2_.globalX > _loc3_.x + _loc3_.width + 50 || _loc2_.globalY > _loc3_.y + _loc3_.height + 50)
            {
               resetContents();
            }
         }
         else if(_loc2_.phase == "ended" && mIsDown)
         {
            resetContents();
            dispatchEventWith("triggered",true);
         }
      }
      
      public function get scaleWhenDown() : Number
      {
         return mScaleWhenDown;
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         mScaleWhenDown = param1;
      }
      
      public function get alphaWhenDisabled() : Number
      {
         return mAlphaWhenDisabled;
      }
      
      public function set alphaWhenDisabled(param1:Number) : void
      {
         mAlphaWhenDisabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return mEnabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(mEnabled != param1)
         {
            mEnabled = param1;
            mContents.alpha = param1?1:mAlphaWhenDisabled;
            resetContents();
         }
      }
      
      public function get text() : String
      {
         return mTextField?mTextField.text:"";
      }
      
      public function set text(param1:String) : void
      {
         if(param1.length == 0)
         {
            if(mTextField)
            {
               mTextField.text = param1;
               mTextField.removeFromParent();
            }
         }
         else
         {
            createTextField();
            mTextField.text = param1;
            if(mTextField.parent == null)
            {
               mContents.addChild(mTextField);
            }
         }
      }
      
      public function get fontName() : String
      {
         return mTextField?mTextField.fontName:"Verdana";
      }
      
      public function set fontName(param1:String) : void
      {
         createTextField();
         mTextField.fontName = param1;
      }
      
      public function get fontSize() : Number
      {
         return mTextField?mTextField.fontSize:12.0;
      }
      
      public function set fontSize(param1:Number) : void
      {
         createTextField();
         mTextField.fontSize = param1;
      }
      
      public function get fontColor() : uint
      {
         return mTextField?mTextField.color:0;
      }
      
      public function set fontColor(param1:uint) : void
      {
         createTextField();
         mTextField.color = param1;
      }
      
      public function get fontBold() : Boolean
      {
         return mTextField?mTextField.bold:false;
      }
      
      public function set fontBold(param1:Boolean) : void
      {
         createTextField();
         mTextField.bold = param1;
      }
      
      public function get upState() : Texture
      {
         return mUpState;
      }
      
      public function set upState(param1:Texture) : void
      {
         if(mUpState != param1)
         {
            mUpState = param1;
            if(!mIsDown)
            {
               mBackground.texture = param1;
            }
         }
      }
      
      public function get downState() : Texture
      {
         return mDownState;
      }
      
      public function set downState(param1:Texture) : void
      {
         if(mDownState != param1)
         {
            mDownState = param1;
            if(mIsDown)
            {
               mBackground.texture = param1;
            }
         }
      }
      
      public function get textVAlign() : String
      {
         return mTextField?mTextField.vAlign:"center";
      }
      
      public function set textVAlign(param1:String) : void
      {
         createTextField();
         mTextField.vAlign = param1;
      }
      
      public function get textHAlign() : String
      {
         return mTextField?mTextField.hAlign:"center";
      }
      
      public function set textHAlign(param1:String) : void
      {
         createTextField();
         mTextField.hAlign = param1;
      }
      
      public function get textBounds() : Rectangle
      {
         return mTextBounds.clone();
      }
      
      public function set textBounds(param1:Rectangle) : void
      {
         mTextBounds = param1.clone();
         createTextField();
      }
      
      override public function get useHandCursor() : Boolean
      {
         return mUseHandCursor;
      }
      
      override public function set useHandCursor(param1:Boolean) : void
      {
         mUseHandCursor = param1;
      }
   }
}
