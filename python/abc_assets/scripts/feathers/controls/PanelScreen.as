package feathers.controls
{
   import feathers.system.DeviceCapabilities;
   import starling.events.Event;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import starling.core.Starling;
   import flash.events.KeyboardEvent;
   
   public class PanelScreen extends Panel implements IScreen
   {
      
      public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-screen-header";
      
      public static const SCROLL_POLICY_AUTO:String = "auto";
      
      public static const SCROLL_POLICY_ON:String = "on";
      
      public static const SCROLL_POLICY_OFF:String = "off";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
      
      public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";
      
      public static const INTERACTION_MODE_TOUCH:String = "touch";
      
      public static const INTERACTION_MODE_MOUSE:String = "mouse";
      
      public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
       
      protected var _screenID:String;
      
      protected var _owner:feathers.controls.ScreenNavigator;
      
      protected var _originalDPI:int = 0;
      
      protected var _dpiScale:Number = 1;
      
      protected var backButtonHandler:Function;
      
      protected var menuButtonHandler:Function;
      
      protected var searchButtonHandler:Function;
      
      public function PanelScreen()
      {
         this.addEventListener("addedToStage",panelScreen_addedToStageHandler);
         super();
         this.headerName = "feathers-panel-screen-header";
         this.originalDPI = DeviceCapabilities.dpi;
         this.clipContent = false;
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
      
      protected function get dpiScale() : Number
      {
         return this._dpiScale;
      }
      
      protected function panelScreen_addedToStageHandler(param1:Event) : void
      {
         this.addEventListener("removedFromStage",panelScreen_removedFromStageHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",panelScreen_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function panelScreen_removedFromStageHandler(param1:Event) : void
      {
         this.removeEventListener("removedFromStage",panelScreen_removedFromStageHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",panelScreen_nativeStage_keyDownHandler);
      }
      
      protected function panelScreen_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
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
