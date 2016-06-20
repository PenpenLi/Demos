package feathers.controls
{
   import feathers.system.DeviceCapabilities;
   import flash.display.DisplayObjectContainer;
   import starling.core.Starling;
   import flash.display.LoaderInfo;
   import feathers.utils.display.calculateScaleRatioToFit;
   import starling.events.Event;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.events.KeyboardEvent;
   
   public class Screen extends LayoutGroup implements IScreen
   {
       
      protected var _originalWidth:Number = NaN;
      
      protected var _originalHeight:Number = NaN;
      
      protected var _originalDPI:int = 0;
      
      protected var _screenID:String;
      
      protected var _owner:feathers.controls.ScreenNavigator;
      
      protected var _pixelScale:Number = 1;
      
      protected var _dpiScale:Number = 1;
      
      protected var backButtonHandler:Function;
      
      protected var menuButtonHandler:Function;
      
      protected var searchButtonHandler:Function;
      
      public function Screen()
      {
         this.addEventListener("addedToStage",screen_addedToStageHandler);
         this.addEventListener("resize",screen_resizeHandler);
         super();
         this.originalDPI = DeviceCapabilities.dpi;
      }
      
      public function get originalWidth() : Number
      {
         return this._originalWidth;
      }
      
      public function set originalWidth(param1:Number) : void
      {
         if(this._originalWidth == param1)
         {
            return;
         }
         this._originalWidth = param1;
         if(this.stage)
         {
            this.refreshPixelScale();
         }
      }
      
      public function get originalHeight() : Number
      {
         return this._originalHeight;
      }
      
      public function set originalHeight(param1:Number) : void
      {
         if(this._originalHeight == param1)
         {
            return;
         }
         this._originalHeight = param1;
         if(this.stage)
         {
            this.refreshPixelScale();
         }
      }
      
      public function get originalDPI() : int
      {
         return this._originalDPI;
      }
      
      public function set originalDPI(param1:int) : void
      {
         if(this._originalDPI == param1)
         {
            return;
         }
         this._originalDPI = param1;
         this._dpiScale = DeviceCapabilities.dpi / this._originalDPI;
         this.invalidate("size");
      }
      
      public function get screenID() : String
      {
         return this._screenID;
      }
      
      public function set screenID(param1:String) : void
      {
         this._screenID = param1;
      }
      
      public function get owner() : feathers.controls.ScreenNavigator
      {
         return this._owner;
      }
      
      public function set owner(param1:feathers.controls.ScreenNavigator) : void
      {
         this._owner = param1;
      }
      
      protected function get pixelScale() : Number
      {
         return this._pixelScale;
      }
      
      protected function get dpiScale() : Number
      {
         return this._dpiScale;
      }
      
      protected function refreshPixelScale() : void
      {
         if(!this.stage)
         {
            return;
         }
         var _loc1_:LoaderInfo = DisplayObjectContainer(Starling.current.nativeStage.root).getChildAt(0).loaderInfo;
         if(isNaN(this._originalWidth))
         {
            try
            {
               this._originalWidth = _loc1_.width;
            }
            catch(error:Error)
            {
               this._originalWidth = this.stage.stageWidth;
            }
         }
         if(isNaN(this._originalHeight))
         {
            try
            {
               this._originalHeight = _loc1_.height;
            }
            catch(error:Error)
            {
               this._originalHeight = this.stage.stageHeight;
            }
         }
         this._pixelScale = calculateScaleRatioToFit(originalWidth,originalHeight,this.actualWidth,this.actualHeight);
      }
      
      protected function screen_addedToStageHandler(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         this.refreshPixelScale();
         this.addEventListener("removedFromStage",screen_removedFromStageHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",screen_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function screen_removedFromStageHandler(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         this.removeEventListener("removedFromStage",screen_removedFromStageHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",screen_nativeStage_keyDownHandler);
      }
      
      protected function screen_resizeHandler(param1:Event) : void
      {
         this.refreshPixelScale();
      }
      
      protected function screen_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(this.backButtonHandler != null && param1.keyCode == 16777238)
         {
            param1.preventDefault();
            this.backButtonHandler();
         }
         if(this.menuButtonHandler != null && param1.keyCode == 16777234)
         {
            param1.preventDefault();
            this.menuButtonHandler();
         }
         if(this.searchButtonHandler != null && param1.keyCode == 16777247)
         {
            param1.preventDefault();
            this.searchButtonHandler();
         }
      }
   }
}
