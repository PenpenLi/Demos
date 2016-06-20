package feathers.controls
{
   import feathers.core.FeathersControl;
   import flash.geom.Point;
   import starling.events.EventDispatcher;
   import starling.display.DisplayObject;
   import starling.animation.Tween;
   import starling.display.DisplayObjectContainer;
   import feathers.core.IValidating;
   import starling.core.Starling;
   import starling.display.Sprite;
   import flash.geom.Rectangle;
   import starling.events.Touch;
   import feathers.events.ExclusiveTouch;
   import feathers.system.DeviceCapabilities;
   import flash.utils.getTimer;
   import feathers.utils.math.roundToNearest;
   import starling.events.Event;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import starling.events.TouchEvent;
   import starling.events.ResizeEvent;
   import flash.events.KeyboardEvent;
   
   public class Drawers extends FeathersControl
   {
      
      public static const DOCK_MODE_PORTRAIT:String = "portrait";
      
      public static const DOCK_MODE_LANDSCAPE:String = "landscape";
      
      public static const DOCK_MODE_BOTH:String = "both";
      
      public static const DOCK_MODE_NONE:String = "none";
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static const OPEN_GESTURE_DRAG_CONTENT_EDGE:String = "dragContentEdge";
      
      public static const OPEN_GESTURE_DRAG_CONTENT:String = "dragContent";
      
      public static const OPEN_GESTURE_NONE:String = "none";
      
      protected static const SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD:String = "activeScreen";
      
      private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1,1.33,1.66,2];
      
      private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
      
      private static const HELPER_POINT:Point = new Point();
       
      protected var contentEventDispatcher:EventDispatcher;
      
      protected var _content:DisplayObject;
      
      protected var _topDrawer:DisplayObject;
      
      protected var _topDrawerDockMode:String = "none";
      
      protected var _topDrawerToggleEventType:String;
      
      protected var _isTopDrawerOpen:Boolean = false;
      
      protected var _rightDrawer:DisplayObject;
      
      protected var _rightDrawerDockMode:String = "none";
      
      protected var _rightDrawerToggleEventType:String;
      
      protected var _isRightDrawerOpen:Boolean = false;
      
      protected var _bottomDrawer:DisplayObject;
      
      protected var _bottomDrawerDockMode:String = "none";
      
      protected var _bottomDrawerToggleEventType:String;
      
      protected var _isBottomDrawerOpen:Boolean = false;
      
      protected var _leftDrawer:DisplayObject;
      
      protected var _leftDrawerDockMode:String = "none";
      
      protected var _leftDrawerToggleEventType:String;
      
      protected var _isLeftDrawerOpen:Boolean = false;
      
      protected var _autoSizeMode:String = "stage";
      
      protected var _clipDrawers:Boolean = true;
      
      protected var _openGesture:String = "dragContentEdge";
      
      protected var _minimumDragDistance:Number = 0.04;
      
      protected var _minimumDrawerThrowVelocity:Number = 5;
      
      protected var _openGestureEdgeSize:Number = 0.1;
      
      protected var _contentEventDispatcherChangeEventType:String;
      
      protected var _contentEventDispatcherField:String;
      
      protected var _contentEventDispatcherFunction:Function;
      
      protected var _openOrCloseTween:Tween;
      
      protected var _openOrCloseDuration:Number = 0.25;
      
      protected var _openOrCloseEase:Object = "easeOut";
      
      protected var isToggleTopDrawerPending:Boolean = false;
      
      protected var isToggleRightDrawerPending:Boolean = false;
      
      protected var isToggleBottomDrawerPending:Boolean = false;
      
      protected var isToggleLeftDrawerPending:Boolean = false;
      
      protected var pendingToggleDuration:Number;
      
      protected var touchPointID:int = -1;
      
      protected var _isDragging:Boolean = false;
      
      protected var _isDraggingTopDrawer:Boolean = false;
      
      protected var _isDraggingRightDrawer:Boolean = false;
      
      protected var _isDraggingBottomDrawer:Boolean = false;
      
      protected var _isDraggingLeftDrawer:Boolean = false;
      
      protected var _startTouchX:Number;
      
      protected var _startTouchY:Number;
      
      protected var _currentTouchX:Number;
      
      protected var _currentTouchY:Number;
      
      protected var _previousTouchTime:int;
      
      protected var _previousTouchX:Number;
      
      protected var _previousTouchY:Number;
      
      protected var _velocityX:Number = 0;
      
      protected var _velocityY:Number = 0;
      
      protected var _previousVelocityX:Vector.<Number>;
      
      protected var _previousVelocityY:Vector.<Number>;
      
      public function Drawers(param1:DisplayObject = null)
      {
         _previousVelocityX = new Vector.<Number>(0);
         _previousVelocityY = new Vector.<Number>(0);
         super();
         this.content = param1;
         this.addEventListener("addedToStage",drawers_addedToStageHandler);
         this.addEventListener("removedFromStage",drawers_removedFromStageHandler);
         this.addEventListener("touch",drawers_touchHandler);
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         if(this._content == param1)
         {
            return;
         }
         if(this._content)
         {
            if(this._contentEventDispatcherChangeEventType)
            {
               this._content.removeEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
            }
            if(this._autoSizeMode == "content")
            {
               this._content.removeEventListener("resize",content_resizeHandler);
            }
            if(this._content.parent == this)
            {
               this.removeChild(this._content,false);
            }
         }
         this._content = param1;
         if(this._content)
         {
            if(this._content is ScreenNavigator)
            {
               this.contentEventDispatcherField = "activeScreen";
               this.contentEventDispatcherChangeEventType = "change";
            }
            if(this._contentEventDispatcherChangeEventType)
            {
               this._content.addEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
            }
            if(this._autoSizeMode == "content")
            {
               this._content.addEventListener("resize",content_resizeHandler);
            }
            this.addChild(this._content);
         }
         this.invalidate("data");
      }
      
      public function get topDrawer() : DisplayObject
      {
         return this._topDrawer;
      }
      
      public function set topDrawer(param1:DisplayObject) : void
      {
         if(this._topDrawer == param1)
         {
            return;
         }
         if(this._topDrawer && this._topDrawer.parent == this)
         {
            this.removeChild(this._topDrawer,false);
         }
         this._topDrawer = param1;
         if(this._topDrawer)
         {
            this._topDrawer.visible = false;
            this._topDrawer.addEventListener("resize",drawer_resizeHandler);
            this.addChildAt(this._topDrawer,0);
         }
         this.invalidate("data");
      }
      
      public function get topDrawerDockMode() : String
      {
         return this._topDrawerDockMode;
      }
      
      public function set topDrawerDockMode(param1:String) : void
      {
         if(this._topDrawerDockMode == param1)
         {
            return;
         }
         this._topDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get topDrawerToggleEventType() : String
      {
         return this._topDrawerToggleEventType;
      }
      
      public function set topDrawerToggleEventType(param1:String) : void
      {
         if(this._topDrawerToggleEventType == param1)
         {
            return;
         }
         this._topDrawerToggleEventType = param1;
         this.invalidate("selected");
      }
      
      public function get isTopDrawerOpen() : Boolean
      {
         return this._topDrawer && this._isTopDrawerOpen;
      }
      
      public function set isTopDrawerOpen(param1:Boolean) : void
      {
         if(this.isTopDrawerDocked || this._isTopDrawerOpen == param1)
         {
            return;
         }
         this._isTopDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isTopDrawerDocked() : Boolean
      {
         if(!this._topDrawer || !this.stage)
         {
            return false;
         }
         if(this._topDrawerDockMode == "both")
         {
            return true;
         }
         if(this._topDrawerDockMode == "none")
         {
            return false;
         }
         if(this.stage.stageWidth > this.stage.stageHeight)
         {
            return this._topDrawerDockMode == "landscape";
         }
         return this._topDrawerDockMode == "portrait";
      }
      
      public function get rightDrawer() : DisplayObject
      {
         return this._rightDrawer;
      }
      
      public function set rightDrawer(param1:DisplayObject) : void
      {
         if(this._rightDrawer == param1)
         {
            return;
         }
         if(this._rightDrawer && this._rightDrawer.parent == this)
         {
            this.removeChild(this._rightDrawer,false);
         }
         this._rightDrawer = param1;
         if(this._rightDrawer)
         {
            this._rightDrawer.visible = false;
            this._rightDrawer.addEventListener("resize",drawer_resizeHandler);
            this.addChildAt(this._rightDrawer,0);
         }
         this.invalidate("data");
      }
      
      public function get rightDrawerDockMode() : String
      {
         return this._rightDrawerDockMode;
      }
      
      public function set rightDrawerDockMode(param1:String) : void
      {
         if(this._rightDrawerDockMode == param1)
         {
            return;
         }
         this._rightDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get rightDrawerToggleEventType() : String
      {
         return this._rightDrawerToggleEventType;
      }
      
      public function set rightDrawerToggleEventType(param1:String) : void
      {
         if(this._rightDrawerToggleEventType == param1)
         {
            return;
         }
         this._rightDrawerToggleEventType = param1;
         this.invalidate("selected");
      }
      
      public function get isRightDrawerOpen() : Boolean
      {
         return this._rightDrawer && this._isRightDrawerOpen;
      }
      
      public function set isRightDrawerOpen(param1:Boolean) : void
      {
         if(this.isRightDrawerDocked || this._isRightDrawerOpen == param1)
         {
            return;
         }
         this._isRightDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isRightDrawerDocked() : Boolean
      {
         if(!this._rightDrawer || !this.stage)
         {
            return false;
         }
         if(this._rightDrawerDockMode == "both")
         {
            return true;
         }
         if(this._rightDrawerDockMode == "none")
         {
            return false;
         }
         if(this.stage.stageWidth > this.stage.stageHeight)
         {
            return this._rightDrawerDockMode == "landscape";
         }
         return this._rightDrawerDockMode == "portrait";
      }
      
      public function get bottomDrawer() : DisplayObject
      {
         return this._bottomDrawer;
      }
      
      public function set bottomDrawer(param1:DisplayObject) : void
      {
         if(this._bottomDrawer == param1)
         {
            return;
         }
         if(this._bottomDrawer && this._bottomDrawer.parent == this)
         {
            this.removeChild(this._bottomDrawer,false);
         }
         this._bottomDrawer = param1;
         if(this._bottomDrawer)
         {
            this._bottomDrawer.visible = false;
            this._bottomDrawer.addEventListener("resize",drawer_resizeHandler);
            this.addChildAt(this._bottomDrawer,0);
         }
         this.invalidate("data");
      }
      
      public function get bottomDrawerDockMode() : String
      {
         return this._bottomDrawerDockMode;
      }
      
      public function set bottomDrawerDockMode(param1:String) : void
      {
         if(this._bottomDrawerDockMode == param1)
         {
            return;
         }
         this._bottomDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get bottomDrawerToggleEventType() : String
      {
         return this._bottomDrawerToggleEventType;
      }
      
      public function set bottomDrawerToggleEventType(param1:String) : void
      {
         if(this._bottomDrawerToggleEventType == param1)
         {
            return;
         }
         this._bottomDrawerToggleEventType = param1;
         this.invalidate("selected");
      }
      
      public function get isBottomDrawerOpen() : Boolean
      {
         return this._bottomDrawer && this._isBottomDrawerOpen;
      }
      
      public function set isBottomDrawerOpen(param1:Boolean) : void
      {
         if(this.isBottomDrawerDocked || this._isBottomDrawerOpen == param1)
         {
            return;
         }
         this._isBottomDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isBottomDrawerDocked() : Boolean
      {
         if(!this._bottomDrawer || !this.stage)
         {
            return false;
         }
         if(this._bottomDrawerDockMode == "both")
         {
            return true;
         }
         if(this._bottomDrawerDockMode == "none")
         {
            return false;
         }
         if(this.stage.stageWidth > this.stage.stageHeight)
         {
            return this._bottomDrawerDockMode == "landscape";
         }
         return this._bottomDrawerDockMode == "portrait";
      }
      
      public function get leftDrawer() : DisplayObject
      {
         return this._leftDrawer;
      }
      
      public function set leftDrawer(param1:DisplayObject) : void
      {
         if(this._leftDrawer == param1)
         {
            return;
         }
         if(this._leftDrawer && this._leftDrawer.parent == this)
         {
            this.removeChild(this._leftDrawer,false);
         }
         this._leftDrawer = param1;
         if(this._leftDrawer)
         {
            this._leftDrawer.visible = false;
            this._leftDrawer.addEventListener("resize",drawer_resizeHandler);
            this.addChildAt(this._leftDrawer,0);
         }
         this.invalidate("data");
      }
      
      public function get leftDrawerDockMode() : String
      {
         return this._leftDrawerDockMode;
      }
      
      public function set leftDrawerDockMode(param1:String) : void
      {
         if(this._leftDrawerDockMode == param1)
         {
            return;
         }
         this._leftDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get leftDrawerToggleEventType() : String
      {
         return this._leftDrawerToggleEventType;
      }
      
      public function set leftDrawerToggleEventType(param1:String) : void
      {
         if(this._leftDrawerToggleEventType == param1)
         {
            return;
         }
         this._leftDrawerToggleEventType = param1;
         this.invalidate("selected");
      }
      
      public function get isLeftDrawerOpen() : Boolean
      {
         return this._leftDrawer && this._isLeftDrawerOpen;
      }
      
      public function set isLeftDrawerOpen(param1:Boolean) : void
      {
         if(this.isLeftDrawerDocked || this._isLeftDrawerOpen == param1)
         {
            return;
         }
         this._isLeftDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isLeftDrawerDocked() : Boolean
      {
         if(!this._leftDrawer || !this.stage)
         {
            return false;
         }
         if(this._leftDrawerDockMode == "both")
         {
            return true;
         }
         if(this._leftDrawerDockMode == "none")
         {
            return false;
         }
         if(this.stage.stageWidth > this.stage.stageHeight)
         {
            return this._leftDrawerDockMode == "landscape";
         }
         return this._leftDrawerDockMode == "portrait";
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this._content)
         {
            if(this._autoSizeMode == "content")
            {
               this._content.addEventListener("resize",content_resizeHandler);
            }
            else
            {
               this._content.removeEventListener("resize",content_resizeHandler);
            }
         }
         this.invalidate("size");
      }
      
      public function get clipDrawers() : Boolean
      {
         return this._clipDrawers;
      }
      
      public function set clipDrawers(param1:Boolean) : void
      {
         if(this._clipDrawers == param1)
         {
            return;
         }
         this._clipDrawers = param1;
         this.invalidate("layout");
      }
      
      public function get openGesture() : String
      {
         return this._openGesture;
      }
      
      public function set openGesture(param1:String) : void
      {
         this._openGesture = param1;
      }
      
      public function get minimumDragDistance() : Number
      {
         return this._minimumDragDistance;
      }
      
      public function set minimumDragDistance(param1:Number) : void
      {
         this._minimumDragDistance = param1;
      }
      
      public function get minimumDrawerThrowVelocity() : Number
      {
         return this._minimumDrawerThrowVelocity;
      }
      
      public function set minimumDrawerThrowVelocity(param1:Number) : void
      {
         this._minimumDrawerThrowVelocity = param1;
      }
      
      public function get openGestureEdgeSize() : Number
      {
         return this._openGestureEdgeSize;
      }
      
      public function set openGestureEdgeSize(param1:Number) : void
      {
         this._openGestureEdgeSize = param1;
      }
      
      public function get contentEventDispatcherChangeEventType() : String
      {
         return this._contentEventDispatcherChangeEventType;
      }
      
      public function set contentEventDispatcherChangeEventType(param1:String) : void
      {
         if(this._contentEventDispatcherChangeEventType == param1)
         {
            return;
         }
         if(this._content && this._contentEventDispatcherChangeEventType)
         {
            this._content.removeEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
         }
         this._contentEventDispatcherChangeEventType = param1;
         if(this._content && this._contentEventDispatcherChangeEventType)
         {
            this._content.addEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
         }
         this.invalidate("selected");
      }
      
      public function get contentEventDispatcherField() : String
      {
         return this._contentEventDispatcherField;
      }
      
      public function set contentEventDispatcherField(param1:String) : void
      {
         if(this._contentEventDispatcherField == param1)
         {
            return;
         }
         this._contentEventDispatcherField = param1;
         this.invalidate("selected");
      }
      
      public function get contentEventDispatcherFunction() : Function
      {
         return this._contentEventDispatcherFunction;
      }
      
      public function set contentEventDispatcherFunction(param1:Function) : void
      {
         if(this._contentEventDispatcherFunction == param1)
         {
            return;
         }
         this._contentEventDispatcherFunction = param1;
         this.invalidate("selected");
      }
      
      public function get openOrCloseDuration() : Number
      {
         return this._openOrCloseDuration;
      }
      
      public function set openOrCloseDuration(param1:Number) : void
      {
         this._openOrCloseDuration = param1;
      }
      
      public function get openOrCloseEase() : Object
      {
         return this._openOrCloseEase;
      }
      
      public function set openOrCloseEase(param1:Object) : void
      {
         this._openOrCloseEase = param1;
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:DisplayObject = super.hitTest(param1,param2);
         if(_loc3_)
         {
            if(!param2)
            {
               return _loc3_;
            }
            if(this._isDragging)
            {
               return this;
            }
            if(this.isTopDrawerOpen && _loc3_ != this._topDrawer && !(this._topDrawer is DisplayObjectContainer && DisplayObjectContainer(this._topDrawer).contains(_loc3_)))
            {
               return this;
            }
            if(this.isRightDrawerOpen && _loc3_ != this._rightDrawer && !(this._rightDrawer is DisplayObjectContainer && DisplayObjectContainer(this._rightDrawer).contains(_loc3_)))
            {
               return this;
            }
            if(this.isBottomDrawerOpen && _loc3_ != this._bottomDrawer && !(this._bottomDrawer is DisplayObjectContainer && DisplayObjectContainer(this._bottomDrawer).contains(_loc3_)))
            {
               return this;
            }
            if(this.isLeftDrawerOpen && _loc3_ != this._leftDrawer && !(this._leftDrawer is DisplayObjectContainer && DisplayObjectContainer(this._leftDrawer).contains(_loc3_)))
            {
               return this;
            }
            return _loc3_;
         }
         if(param2 && (!this.visible || !this.touchable))
         {
            return null;
         }
         return this._hitArea.contains(param1.x,param1.y)?this:null;
      }
      
      public function toggleTopDrawer(param1:Number = NaN) : void
      {
         if(!this._topDrawer || this.isToggleTopDrawerPending || this.isTopDrawerDocked)
         {
            return;
         }
         this.isToggleTopDrawerPending = true;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = false;
         this.pendingToggleDuration = param1;
         this.invalidate("selected");
      }
      
      public function toggleRightDrawer(param1:Number = NaN) : void
      {
         if(!this._rightDrawer || this.isToggleRightDrawerPending || this.isRightDrawerDocked)
         {
            return;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = true;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = false;
         this.pendingToggleDuration = param1;
         this.invalidate("selected");
      }
      
      public function toggleBottomDrawer(param1:Number = NaN) : void
      {
         if(!this._bottomDrawer || this.isToggleBottomDrawerPending || this.isBottomDrawerDocked)
         {
            return;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = true;
         this.isToggleLeftDrawerPending = false;
         this.pendingToggleDuration = param1;
         this.invalidate("selected");
      }
      
      public function toggleLeftDrawer(param1:Number = NaN) : void
      {
         if(!this._leftDrawer || this.isToggleLeftDrawerPending || this.isLeftDrawerDocked)
         {
            return;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = true;
         this.pendingToggleDuration = param1;
         this.invalidate("selected");
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("layout");
         if(_loc2_)
         {
            this.refreshCurrentEventTarget();
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshDrawerStates();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
         this.handlePendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc6_:* = false;
         var _loc5_:* = false;
         var _loc2_:* = false;
         var _loc4_:* = false;
         var _loc3_:Boolean = isNaN(this.explicitWidth);
         var _loc8_:Boolean = isNaN(this.explicitHeight);
         if(!_loc3_ && !_loc8_)
         {
            return false;
         }
         if(this._autoSizeMode == "content" && this._content is IValidating)
         {
            IValidating(this._content).validate();
            _loc6_ = this.isTopDrawerDocked;
            if(_loc6_ && this._topDrawer is IValidating)
            {
               IValidating(this._topDrawer).validate();
            }
            _loc5_ = this.isRightDrawerDocked;
            if(_loc5_ && this._rightDrawer is IValidating)
            {
               IValidating(this._rightDrawer).validate();
            }
            _loc2_ = this.isBottomDrawerDocked;
            if(_loc2_ && this._bottomDrawer is IValidating)
            {
               IValidating(this._bottomDrawer).validate();
            }
            _loc4_ = this.isLeftDrawerDocked;
            if(_loc4_ && this._leftDrawer is IValidating)
            {
               IValidating(this._leftDrawer).validate();
            }
         }
         var _loc7_:Number = this.explicitWidth;
         if(_loc3_)
         {
            if(this._autoSizeMode == "content")
            {
               _loc7_ = this._content?this._content.width:0.0;
               if(_loc4_)
               {
                  _loc7_ = _loc7_ + this._leftDrawer.width;
               }
               if(_loc5_)
               {
                  _loc7_ = _loc7_ + this._rightDrawer.width;
               }
            }
            else
            {
               _loc7_ = this.stage.stageWidth;
            }
         }
         var _loc1_:Number = this.explicitHeight;
         if(_loc8_)
         {
            if(this._autoSizeMode == "content")
            {
               _loc1_ = this._content?this._content.height:0.0;
               if(_loc6_)
               {
                  _loc1_ = _loc1_ + this._topDrawer.width;
               }
               if(_loc2_)
               {
                  _loc1_ = _loc1_ + this._bottomDrawer.width;
               }
            }
            else
            {
               _loc1_ = this.stage.stageHeight;
            }
         }
         return this.setSizeInternal(_loc7_,_loc1_,false);
      }
      
      protected function layoutChildren() : void
      {
         var _loc17_:* = NaN;
         var _loc25_:* = NaN;
         var _loc7_:* = NaN;
         var _loc5_:* = NaN;
         var _loc15_:* = NaN;
         var _loc14_:* = NaN;
         var _loc1_:* = NaN;
         var _loc16_:* = NaN;
         var _loc18_:* = NaN;
         var _loc24_:* = NaN;
         var _loc23_:* = NaN;
         var _loc6_:* = NaN;
         if(this._topDrawer is IValidating)
         {
            IValidating(this._topDrawer).validate();
         }
         if(this._rightDrawer is IValidating)
         {
            IValidating(this._rightDrawer).validate();
         }
         if(this._bottomDrawer is IValidating)
         {
            IValidating(this._bottomDrawer).validate();
         }
         if(this._leftDrawer is IValidating)
         {
            IValidating(this._leftDrawer).validate();
         }
         var _loc13_:Boolean = this.isTopDrawerOpen;
         var _loc11_:Boolean = this.isRightDrawerOpen;
         var _loc26_:Boolean = this.isBottomDrawerOpen;
         var _loc4_:Boolean = this.isLeftDrawerOpen;
         var _loc22_:Boolean = this.isTopDrawerDocked;
         var _loc21_:Boolean = this.isRightDrawerDocked;
         var _loc9_:Boolean = this.isBottomDrawerDocked;
         var _loc20_:Boolean = this.isLeftDrawerDocked;
         var _loc3_:Number = this._topDrawer?this._topDrawer.height:0.0;
         var _loc8_:Number = this._rightDrawer?this._rightDrawer.width:0.0;
         var _loc10_:Number = this._bottomDrawer?this._bottomDrawer.height:0.0;
         var _loc2_:Number = this._leftDrawer?this._leftDrawer.width:0.0;
         var _loc19_:Number = this.actualWidth;
         if(_loc20_)
         {
            _loc19_ = _loc19_ - _loc2_;
         }
         if(_loc21_)
         {
            _loc19_ = _loc19_ - _loc8_;
         }
         var _loc12_:Number = this.actualHeight;
         if(_loc22_)
         {
            _loc12_ = _loc12_ - _loc3_;
         }
         if(_loc9_)
         {
            _loc12_ = _loc12_ - _loc10_;
         }
         if(_loc11_)
         {
            _loc17_ = -_loc8_;
            if(_loc20_)
            {
               _loc17_ = _loc17_ + _loc2_;
            }
            this._content.x = _loc17_;
         }
         else if(_loc4_ || _loc20_)
         {
            this._content.x = _loc2_;
         }
         else
         {
            this._content.x = 0;
         }
         if(_loc26_)
         {
            _loc25_ = -_loc10_;
            if(_loc22_)
            {
               _loc25_ = _loc25_ + _loc3_;
            }
            this._content.y = _loc25_;
         }
         else if(_loc13_ || _loc22_)
         {
            this._content.y = _loc3_;
         }
         else
         {
            this._content.y = 0;
         }
         if(this._autoSizeMode != "content")
         {
            this._content.width = _loc19_;
            this._content.height = _loc12_;
            if(this._content is IValidating)
            {
               IValidating(this._content).validate();
            }
         }
         if(this._topDrawer)
         {
            _loc7_ = 0.0;
            _loc5_ = 0.0;
            if(_loc22_)
            {
               if(_loc26_)
               {
                  _loc5_ = _loc5_ - _loc10_;
               }
               if(!_loc20_)
               {
                  _loc7_ = this._content.x;
               }
            }
            this._topDrawer.x = _loc7_;
            this._topDrawer.y = _loc5_;
            this._topDrawer.width = this.actualWidth;
            this._topDrawer.visible = _loc13_ || _loc22_;
            if(this._topDrawer is IValidating)
            {
               IValidating(this._topDrawer).validate();
            }
         }
         if(this._rightDrawer)
         {
            _loc15_ = this.actualWidth - _loc8_;
            _loc14_ = 0.0;
            _loc1_ = this.actualHeight;
            if(_loc21_)
            {
               _loc15_ = this._content.x + this._content.width;
               if(_loc22_)
               {
                  _loc1_ = _loc1_ - _loc3_;
               }
               if(_loc9_)
               {
                  _loc1_ = _loc1_ - _loc10_;
               }
               _loc14_ = this._content.y;
            }
            this._rightDrawer.x = _loc15_;
            this._rightDrawer.y = _loc14_;
            this._rightDrawer.height = _loc1_;
            this._rightDrawer.visible = _loc11_ || _loc21_;
            if(this._rightDrawer is IValidating)
            {
               IValidating(this._rightDrawer).validate();
            }
         }
         if(this._bottomDrawer)
         {
            _loc16_ = 0.0;
            _loc18_ = this.actualHeight - _loc10_;
            if(_loc9_)
            {
               if(!_loc20_)
               {
                  _loc16_ = this._content.x;
               }
               _loc18_ = this._content.y + this._content.height;
            }
            this._bottomDrawer.x = _loc16_;
            this._bottomDrawer.y = _loc18_;
            this._bottomDrawer.width = this.actualWidth;
            this._bottomDrawer.visible = _loc26_ || _loc9_;
            if(this._bottomDrawer is IValidating)
            {
               IValidating(this._bottomDrawer).validate();
            }
         }
         if(this._leftDrawer)
         {
            _loc24_ = 0.0;
            _loc23_ = 0.0;
            _loc6_ = this.actualHeight;
            if(_loc20_)
            {
               if(_loc11_)
               {
                  _loc24_ = _loc24_ - _loc8_;
               }
               if(_loc22_)
               {
                  _loc6_ = _loc6_ - _loc3_;
               }
               if(_loc9_)
               {
                  _loc6_ = _loc6_ - _loc10_;
               }
               _loc23_ = this._content.y;
            }
            this._leftDrawer.x = _loc24_;
            this._leftDrawer.y = _loc23_;
            this._leftDrawer.height = _loc6_;
            this._leftDrawer.visible = _loc4_ || _loc20_;
            if(this._leftDrawer is IValidating)
            {
               IValidating(this._leftDrawer).validate();
            }
         }
      }
      
      protected function handlePendingActions() : void
      {
         if(this.isToggleTopDrawerPending)
         {
            this._isTopDrawerOpen = !this._isTopDrawerOpen;
            this.isToggleTopDrawerPending = false;
            this.openOrCloseTopDrawer();
         }
         else if(this.isToggleRightDrawerPending)
         {
            this._isRightDrawerOpen = !this._isRightDrawerOpen;
            this.isToggleRightDrawerPending = false;
            this.openOrCloseRightDrawer();
         }
         else if(this.isToggleBottomDrawerPending)
         {
            this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
            this.isToggleBottomDrawerPending = false;
            this.openOrCloseBottomDrawer();
         }
         else if(this.isToggleLeftDrawerPending)
         {
            this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
            this.isToggleLeftDrawerPending = false;
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function openOrCloseTopDrawer() : void
      {
         if(!this._topDrawer || this.isTopDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.applyTopClipRect();
         this._topDrawer.visible = true;
         var _loc1_:Number = this._isTopDrawerOpen?this._topDrawer.height:0.0;
         this._openOrCloseTween = new Tween(this._content,this._openOrCloseDuration,this._openOrCloseEase);
         this._openOrCloseTween.animate("y",_loc1_);
         this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = topDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseRightDrawer() : void
      {
         if(!this._rightDrawer || this.isRightDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.applyRightClipRect();
         this._rightDrawer.visible = true;
         var _loc1_:* = 0.0;
         if(this._isRightDrawerOpen)
         {
            _loc1_ = -this._rightDrawer.width;
         }
         if(this.isLeftDrawerDocked)
         {
            _loc1_ = _loc1_ + this._leftDrawer.width;
         }
         this._openOrCloseTween = new Tween(this._content,this._openOrCloseDuration,this._openOrCloseEase);
         this._openOrCloseTween.animate("x",_loc1_);
         this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = rightDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseBottomDrawer() : void
      {
         if(!this._bottomDrawer || this.isBottomDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.applyBottomClipRect();
         this._bottomDrawer.visible = true;
         var _loc1_:* = 0.0;
         if(this._isBottomDrawerOpen)
         {
            _loc1_ = -this._bottomDrawer.height;
         }
         if(this.isTopDrawerDocked)
         {
            _loc1_ = _loc1_ + this._topDrawer.height;
         }
         this._openOrCloseTween = new Tween(this._content,this._openOrCloseDuration,this._openOrCloseEase);
         this._openOrCloseTween.animate("y",_loc1_);
         this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = bottomDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseLeftDrawer() : void
      {
         if(!this._leftDrawer || this.isLeftDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.applyLeftClipRect();
         this._leftDrawer.visible = true;
         var _loc2_:Number = this._isLeftDrawerOpen?this._leftDrawer.width:0.0;
         var _loc1_:Number = !isNaN(this.pendingToggleDuration)?this.pendingToggleDuration:this._openOrCloseDuration;
         this._openOrCloseTween = new Tween(this._content,_loc1_,this._openOrCloseEase);
         this._openOrCloseTween.animate("x",_loc2_);
         this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = leftDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function applyTopClipRect() : void
      {
         if(!this._clipDrawers || !(this._topDrawer is Sprite))
         {
            return;
         }
         var _loc1_:Sprite = Sprite(this._topDrawer);
         if(!_loc1_.clipRect)
         {
            _loc1_.clipRect = new Rectangle(0,0,this.actualWidth,this._content.y);
         }
      }
      
      protected function applyRightClipRect() : void
      {
         if(!this._clipDrawers || !(this._rightDrawer is Sprite))
         {
            return;
         }
         var _loc1_:Sprite = Sprite(this._rightDrawer);
         if(!_loc1_.clipRect)
         {
            _loc1_.clipRect = new Rectangle(0,0,-this._content.x,this.actualHeight);
         }
      }
      
      protected function applyBottomClipRect() : void
      {
         if(!this._clipDrawers || !(this._bottomDrawer is Sprite))
         {
            return;
         }
         var _loc1_:Sprite = Sprite(this._bottomDrawer);
         if(!_loc1_.clipRect)
         {
            _loc1_.clipRect = new Rectangle(0,0,this.actualWidth,-this._content.y);
         }
      }
      
      protected function applyLeftClipRect() : void
      {
         if(!this._clipDrawers || !(this._leftDrawer is Sprite))
         {
            return;
         }
         var _loc1_:Sprite = Sprite(this._leftDrawer);
         if(!_loc1_.clipRect)
         {
            _loc1_.clipRect = new Rectangle(0,0,this._content.x,this.actualHeight);
         }
      }
      
      protected function contentToContentEventDispatcher() : EventDispatcher
      {
         if(this._contentEventDispatcherFunction != null)
         {
            return this._contentEventDispatcherFunction(this._content) as EventDispatcher;
         }
         if(this._contentEventDispatcherField != null && this._content && this._content.hasOwnProperty(this._contentEventDispatcherField))
         {
            return this._content[this._contentEventDispatcherField] as EventDispatcher;
         }
         return this._content;
      }
      
      protected function refreshCurrentEventTarget() : void
      {
         if(this.contentEventDispatcher)
         {
            this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
         }
         this.contentEventDispatcher = this.contentToContentEventDispatcher();
         if(this.contentEventDispatcher)
         {
            this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
            this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
         }
      }
      
      protected function refreshDrawerStates() : void
      {
         if(this.isTopDrawerDocked)
         {
            this._isTopDrawerOpen = false;
         }
         if(this.isRightDrawerDocked)
         {
            this._isRightDrawerOpen = false;
         }
         if(this.isBottomDrawerDocked)
         {
            this._isBottomDrawerOpen = false;
         }
         if(this.isLeftDrawerDocked)
         {
            this._isLeftDrawerOpen = false;
         }
      }
      
      protected function handleTapToClose(param1:Touch) : void
      {
         param1.getLocation(this.stage,HELPER_POINT);
         if(this != this.stage.hitTest(HELPER_POINT,true))
         {
            return;
         }
         if(this.isTopDrawerOpen)
         {
            this._isTopDrawerOpen = false;
            this.openOrCloseTopDrawer();
         }
         else if(this.isRightDrawerOpen)
         {
            this._isRightDrawerOpen = false;
            this.openOrCloseRightDrawer();
         }
         else if(this.isBottomDrawerOpen)
         {
            this._isBottomDrawerOpen = false;
            this.openOrCloseBottomDrawer();
         }
         else if(this.isLeftDrawerOpen)
         {
            this._isLeftDrawerOpen = false;
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function handleTouchBegan(param1:Touch) : void
      {
         var _loc8_:* = false;
         var _loc7_:* = NaN;
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc2_:* = NaN;
         var _loc9_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc9_.getClaim(param1.id))
         {
            return;
         }
         param1.getLocation(this,HELPER_POINT);
         var _loc3_:Number = HELPER_POINT.x;
         var _loc4_:Number = HELPER_POINT.y;
         if(!this.isTopDrawerOpen && !this.isRightDrawerOpen && !this.isBottomDrawerOpen && !this.isLeftDrawerOpen)
         {
            if(this._openGesture == "none")
            {
               return;
            }
            if(this._openGesture == "dragContentEdge")
            {
               _loc8_ = false;
               if(this._topDrawer && !this.isTopDrawerDocked)
               {
                  _loc7_ = _loc4_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
                  if(_loc7_ >= 0 && _loc7_ <= this._openGestureEdgeSize)
                  {
                     _loc8_ = true;
                  }
               }
               if(!_loc8_)
               {
                  if(this._rightDrawer && !this.isRightDrawerDocked)
                  {
                     _loc6_ = (this.actualWidth - _loc3_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
                     if(_loc6_ >= 0 && _loc6_ <= this._openGestureEdgeSize)
                     {
                        _loc8_ = true;
                     }
                  }
                  if(!_loc8_)
                  {
                     if(this._bottomDrawer && !this.isBottomDrawerDocked)
                     {
                        _loc5_ = (this.actualHeight - _loc4_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
                        if(_loc5_ >= 0 && _loc5_ <= this._openGestureEdgeSize)
                        {
                           _loc8_ = true;
                        }
                     }
                     if(!_loc8_)
                     {
                        if(this._leftDrawer && !this.isLeftDrawerDocked)
                        {
                           _loc2_ = _loc3_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
                           if(_loc2_ >= 0 && _loc2_ <= this._openGestureEdgeSize)
                           {
                              _loc8_ = true;
                           }
                        }
                     }
                  }
               }
               if(!_loc8_)
               {
                  return;
               }
            }
         }
         else if(param1.target != this && !param1.isTouching(this._content) && !(this.isTopDrawerDocked && param1.isTouching(this._topDrawer)) && !(this.isRightDrawerDocked && param1.isTouching(this._rightDrawer)) && !(this.isBottomDrawerDocked && param1.isTouching(this._bottomDrawer)) && !(this.isLeftDrawerDocked && param1.isTouching(this._leftDrawer)))
         {
            return;
         }
         this.touchPointID = param1.id;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._previousTouchTime = getTimer();
         var _loc10_:* = _loc3_;
         this._currentTouchX = _loc10_;
         _loc10_ = _loc10_;
         this._startTouchX = _loc10_;
         this._previousTouchX = _loc10_;
         _loc10_ = _loc4_;
         this._currentTouchY = _loc10_;
         _loc10_ = _loc10_;
         this._startTouchY = _loc10_;
         this._previousTouchY = _loc10_;
         this._isDragging = false;
         this._isDraggingTopDrawer = false;
         this._isDraggingRightDrawer = false;
         this._isDraggingBottomDrawer = false;
         this._isDraggingLeftDrawer = false;
         _loc9_.addEventListener("change",exclusiveTouch_changeHandler);
      }
      
      protected function handleTouchMoved(param1:Touch) : void
      {
         param1.getLocation(this,HELPER_POINT);
         this._currentTouchX = HELPER_POINT.x;
         this._currentTouchY = HELPER_POINT.y;
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this._previousTouchTime;
         if(_loc3_ > 0)
         {
            this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
            if(this._previousVelocityX.length > 4)
            {
               this._previousVelocityX.shift();
            }
            this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
            if(this._previousVelocityY.length > 4)
            {
               this._previousVelocityY.shift();
            }
            this._velocityX = (this._currentTouchX - this._previousTouchX) / _loc3_;
            this._velocityY = (this._currentTouchY - this._previousTouchY) / _loc3_;
            this._previousTouchTime = _loc2_;
            this._previousTouchX = this._currentTouchX;
            this._previousTouchY = this._currentTouchY;
         }
      }
      
      protected function handleDragEnd() : void
      {
         var _loc8_:* = 0;
         var _loc2_:* = NaN;
         var _loc6_:* = NaN;
         var _loc5_:Number = this._velocityX * 2.33;
         var _loc3_:int = this._previousVelocityX.length;
         var _loc4_:* = 2.33;
         _loc8_ = 0;
         while(_loc8_ < _loc3_)
         {
            _loc2_ = VELOCITY_WEIGHTS[_loc8_];
            _loc5_ = _loc5_ + this._previousVelocityX.shift() * _loc2_;
            _loc4_ = _loc4_ + _loc2_;
            _loc8_++;
         }
         var _loc1_:Number = 1000 * _loc5_ / _loc4_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         _loc5_ = this._velocityY * 2.33;
         _loc3_ = this._previousVelocityY.length;
         _loc4_ = 2.33;
         _loc8_ = 0;
         while(_loc8_ < _loc3_)
         {
            _loc2_ = VELOCITY_WEIGHTS[_loc8_];
            _loc5_ = _loc5_ + this._previousVelocityY.shift() * _loc2_;
            _loc4_ = _loc4_ + _loc2_;
            _loc8_++;
         }
         var _loc7_:Number = 1000 * _loc5_ / _loc4_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         this._isDragging = false;
         if(this._isDraggingTopDrawer)
         {
            this._isDraggingTopDrawer = false;
            if(!this._isTopDrawerOpen && _loc7_ > this._minimumDrawerThrowVelocity)
            {
               this._isTopDrawerOpen = true;
            }
            else if(this._isTopDrawerOpen && _loc7_ < -this._minimumDrawerThrowVelocity)
            {
               this._isTopDrawerOpen = false;
            }
            else
            {
               this._isTopDrawerOpen = roundToNearest(this._content.y,this._topDrawer.height) != 0;
            }
            this.openOrCloseTopDrawer();
         }
         else if(this._isDraggingRightDrawer)
         {
            this._isDraggingRightDrawer = false;
            if(!this._isRightDrawerOpen && _loc1_ < -this._minimumDrawerThrowVelocity)
            {
               this._isRightDrawerOpen = true;
            }
            else if(this._isRightDrawerOpen && _loc1_ > this._minimumDrawerThrowVelocity)
            {
               this._isRightDrawerOpen = false;
            }
            else
            {
               _loc6_ = 0.0;
               if(this.isLeftDrawerDocked)
               {
                  _loc6_ = this._leftDrawer.width;
               }
               this._isRightDrawerOpen = roundToNearest(this._content.x,this._rightDrawer.width) != _loc6_;
            }
            this.openOrCloseRightDrawer();
         }
         else if(this._isDraggingBottomDrawer)
         {
            this._isDraggingBottomDrawer = false;
            if(!this._isBottomDrawerOpen && _loc7_ < -this._minimumDrawerThrowVelocity)
            {
               this._isBottomDrawerOpen = true;
            }
            else if(this._isBottomDrawerOpen && _loc7_ > this._minimumDrawerThrowVelocity)
            {
               this._isBottomDrawerOpen = false;
            }
            else
            {
               _loc6_ = 0.0;
               if(this.isTopDrawerDocked)
               {
                  _loc6_ = this._topDrawer.height;
               }
               this._isBottomDrawerOpen = roundToNearest(this._content.y,this._bottomDrawer.height) != _loc6_;
            }
            this.openOrCloseBottomDrawer();
         }
         else if(this._isDraggingLeftDrawer)
         {
            this._isDraggingLeftDrawer = false;
            if(!this._isLeftDrawerOpen && _loc1_ > this._minimumDrawerThrowVelocity)
            {
               this._isLeftDrawerOpen = true;
            }
            else if(this._isLeftDrawerOpen && _loc1_ < -this._minimumDrawerThrowVelocity)
            {
               this._isLeftDrawerOpen = false;
            }
            else
            {
               this._isLeftDrawerOpen = roundToNearest(this._content.x,this._leftDrawer.width) != 0;
            }
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function handleDragMove() : void
      {
         var _loc3_:* = NaN;
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = 0.0;
         var _loc6_:* = 0.0;
         if(this.isLeftDrawerDocked)
         {
            _loc5_ = this._leftDrawer.width;
         }
         if(this.isTopDrawerDocked)
         {
            _loc6_ = this._topDrawer.height;
         }
         if(this._isDraggingLeftDrawer)
         {
            _loc3_ = this._leftDrawer.width;
            if(this.isLeftDrawerOpen)
            {
               _loc5_ = _loc3_ + this._currentTouchX - this._startTouchX;
            }
            else
            {
               _loc5_ = this._currentTouchX - this._startTouchX;
            }
            if(_loc5_ < 0)
            {
               _loc5_ = 0.0;
            }
            if(_loc5_ > _loc3_)
            {
               _loc5_ = _loc3_;
            }
         }
         else if(this._isDraggingRightDrawer)
         {
            _loc1_ = this._rightDrawer.width;
            if(this.isRightDrawerOpen)
            {
               _loc5_ = -_loc1_ + this._currentTouchX - this._startTouchX;
            }
            else
            {
               _loc5_ = this._currentTouchX - this._startTouchX;
            }
            if(_loc5_ < -_loc1_)
            {
               _loc5_ = -_loc1_;
            }
            if(_loc5_ > 0)
            {
               _loc5_ = 0.0;
            }
            if(this.isLeftDrawerDocked)
            {
               _loc5_ = _loc5_ + this._leftDrawer.width;
            }
         }
         else if(this._isDraggingTopDrawer)
         {
            _loc2_ = this._topDrawer.height;
            if(this.isTopDrawerOpen)
            {
               _loc6_ = _loc2_ + this._currentTouchY - this._startTouchY;
            }
            else
            {
               _loc6_ = this._currentTouchY - this._startTouchY;
            }
            if(_loc6_ < 0)
            {
               _loc6_ = 0.0;
            }
            if(_loc6_ > _loc2_)
            {
               _loc6_ = _loc2_;
            }
            this._content.y = _loc6_;
         }
         else if(this._isDraggingBottomDrawer)
         {
            _loc4_ = this._bottomDrawer.height;
            if(this.isBottomDrawerOpen)
            {
               _loc6_ = -_loc4_ + this._currentTouchY - this._startTouchY;
            }
            else
            {
               _loc6_ = this._currentTouchY - this._startTouchY;
            }
            if(_loc6_ < -_loc4_)
            {
               _loc6_ = -_loc4_;
            }
            if(_loc6_ > 0)
            {
               _loc6_ = 0.0;
            }
            if(this.isTopDrawerDocked)
            {
               _loc6_ = _loc6_ + this._topDrawer.height;
            }
         }
         this._content.x = _loc5_;
         this._content.y = _loc6_;
         this.openOrCloseTween_onUpdate();
      }
      
      protected function checkForDragToClose() : void
      {
         var _loc2_:* = null;
         var _loc3_:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc1_:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if(this.isLeftDrawerOpen && _loc3_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingLeftDrawer = true;
            this.applyLeftClipRect();
         }
         else if(this.isRightDrawerOpen && _loc3_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingRightDrawer = true;
            this.applyRightClipRect();
         }
         else if(this.isTopDrawerOpen && _loc1_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingTopDrawer = true;
            this.applyTopClipRect();
         }
         else if(this.isBottomDrawerOpen && _loc1_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingBottomDrawer = true;
            this.applyBottomClipRect();
         }
         if(this._isDragging)
         {
            this._startTouchY = this._currentTouchY;
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
            _loc2_.claimTouch(this.touchPointID,this);
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function checkForDragToOpen() : void
      {
         var _loc2_:* = null;
         var _loc3_:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc1_:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if(this._leftDrawer && !this.isLeftDrawerDocked && _loc3_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingLeftDrawer = true;
            this._leftDrawer.visible = true;
            this.applyLeftClipRect();
         }
         else if(this._rightDrawer && !this.isRightDrawerDocked && _loc3_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingRightDrawer = true;
            this._rightDrawer.visible = true;
            this.applyRightClipRect();
         }
         else if(this._topDrawer && !this.isTopDrawerDocked && _loc1_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingTopDrawer = true;
            this._topDrawer.visible = true;
            this.applyTopClipRect();
         }
         else if(this._bottomDrawer && !this.isBottomDrawerDocked && _loc1_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingBottomDrawer = true;
            this._bottomDrawer.visible = true;
            this.applyBottomClipRect();
         }
         if(this._isDragging)
         {
            this._startTouchY = this._currentTouchY;
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc2_.claimTouch(this.touchPointID,this);
            _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function openOrCloseTween_onUpdate() : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc8_:* = NaN;
         var _loc10_:* = NaN;
         if(!this._clipDrawers)
         {
            return;
         }
         var _loc4_:Boolean = this.isTopDrawerDocked;
         var _loc3_:Boolean = this.isRightDrawerDocked;
         var _loc1_:Boolean = this.isBottomDrawerDocked;
         var _loc2_:Boolean = this.isLeftDrawerDocked;
         if(this._topDrawer is Sprite)
         {
            _loc5_ = Sprite(this._topDrawer);
            _loc6_ = _loc5_.clipRect;
            if(_loc6_)
            {
               _loc6_.height = this._content.y;
            }
         }
         if(this._rightDrawer is Sprite)
         {
            _loc5_ = Sprite(this._rightDrawer);
            _loc6_ = _loc5_.clipRect;
            if(_loc6_)
            {
               _loc8_ = -this._content.x;
               if(_loc2_)
               {
                  _loc8_ = _loc8_ + this.leftDrawer.width;
               }
               _loc6_.x = this._rightDrawer.width - _loc8_;
               _loc6_.width = _loc8_;
            }
         }
         if(this._bottomDrawer is Sprite)
         {
            _loc5_ = Sprite(this._bottomDrawer);
            _loc6_ = _loc5_.clipRect;
            if(_loc6_)
            {
               _loc10_ = -this._content.y;
               if(_loc4_)
               {
                  _loc10_ = _loc10_ + this.topDrawer.height;
               }
               _loc6_.y = this._bottomDrawer.height - _loc10_;
               _loc6_.height = _loc10_;
            }
         }
         if(this._leftDrawer is Sprite)
         {
            _loc5_ = Sprite(this._leftDrawer);
            _loc6_ = _loc5_.clipRect;
            if(_loc6_)
            {
               _loc6_.width = this._content.x;
            }
         }
         var _loc7_:Number = this._content.x;
         var _loc9_:Number = this._content.y;
         if(_loc4_)
         {
            if(_loc2_)
            {
               this._topDrawer.x = _loc7_ - this._leftDrawer.width;
            }
            else
            {
               this._topDrawer.x = _loc7_;
            }
            this._topDrawer.y = _loc9_ - this._topDrawer.height;
         }
         if(_loc3_)
         {
            this._rightDrawer.x = _loc7_ + this._content.width;
            this._rightDrawer.y = _loc9_;
         }
         if(_loc1_)
         {
            if(_loc2_)
            {
               this._bottomDrawer.x = _loc7_ - this._leftDrawer.width;
            }
            else
            {
               this._bottomDrawer.x = _loc7_;
            }
            this._bottomDrawer.y = _loc9_ + this._content.height;
         }
         if(_loc2_)
         {
            this._leftDrawer.x = _loc7_ - this._leftDrawer.width;
            this._leftDrawer.y = _loc9_;
         }
      }
      
      protected function topDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         if(this._topDrawer is Sprite)
         {
            Sprite(this._topDrawer).clipRect = null;
         }
         var _loc2_:Boolean = this.isTopDrawerOpen;
         var _loc1_:Boolean = this.isTopDrawerDocked;
         this._topDrawer.visible = _loc2_ || _loc1_;
         if(_loc2_)
         {
            this.dispatchEventWith("open");
         }
         else
         {
            this.dispatchEventWith("close");
         }
      }
      
      protected function rightDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         if(this._rightDrawer is Sprite)
         {
            Sprite(this._rightDrawer).clipRect = null;
         }
         var _loc1_:Boolean = this.isRightDrawerOpen;
         var _loc2_:Boolean = this.isRightDrawerDocked;
         this._rightDrawer.visible = _loc1_ || _loc2_;
         if(_loc1_)
         {
            this.dispatchEventWith("open");
         }
         else
         {
            this.dispatchEventWith("close");
         }
      }
      
      protected function bottomDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         if(this._bottomDrawer is Sprite)
         {
            Sprite(this._bottomDrawer).clipRect = null;
         }
         var _loc2_:Boolean = this.isBottomDrawerOpen;
         var _loc1_:Boolean = this.isBottomDrawerDocked;
         this._bottomDrawer.visible = _loc2_ || _loc1_;
         if(_loc2_)
         {
            this.dispatchEventWith("open");
         }
         else
         {
            this.dispatchEventWith("close");
         }
      }
      
      protected function leftDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         if(this._leftDrawer is Sprite)
         {
            Sprite(this._leftDrawer).clipRect = null;
         }
         var _loc1_:Boolean = this.isLeftDrawerOpen;
         var _loc2_:Boolean = this.isLeftDrawerDocked;
         this._leftDrawer.visible = _loc1_ || _loc2_;
         if(_loc1_)
         {
            this.dispatchEventWith("open");
         }
         else
         {
            this.dispatchEventWith("close");
         }
      }
      
      protected function content_eventDispatcherChangeHandler(param1:Event) : void
      {
         this.refreshCurrentEventTarget();
      }
      
      protected function drawers_addedToStageHandler(param1:Event) : void
      {
         this.stage.addEventListener("resize",stage_resizeHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",drawers_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function drawers_removedFromStageHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         if(this.touchPointID >= 0)
         {
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
         }
         this.touchPointID = -1;
         this._isDragging = false;
         this._isDraggingTopDrawer = false;
         this._isDraggingRightDrawer = false;
         this._isDraggingBottomDrawer = false;
         this._isDraggingLeftDrawer = false;
         this.stage.removeEventListener("resize",stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",drawers_nativeStage_keyDownHandler);
      }
      
      protected function drawers_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!this._isEnabled || this._openOrCloseTween)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,null,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == "moved")
            {
               this.handleTouchMoved(_loc2_);
               if(!this._isDragging)
               {
                  if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
                  {
                     this.checkForDragToClose();
                  }
                  else
                  {
                     this.checkForDragToOpen();
                  }
               }
               if(this._isDragging)
               {
                  this.handleDragMove();
               }
            }
            else if(_loc2_.phase == "ended")
            {
               this.touchPointID = -1;
               if(this._isDragging)
               {
                  this.handleDragEnd();
                  this.dispatchEventWith("endInteraction");
               }
               else
               {
                  ExclusiveTouch.forStage(this.stage).removeEventListener("change",exclusiveTouch_changeHandler);
                  if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
                  {
                     this.handleTapToClose(_loc2_);
                  }
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.handleTouchBegan(_loc2_);
         }
      }
      
      protected function exclusiveTouch_changeHandler(param1:Event, param2:int) : void
      {
         if(this.touchPointID < 0 || this.touchPointID != param2 || this._isDragging)
         {
            return;
         }
         var _loc3_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param2) == this)
         {
            return;
         }
         this.touchPointID = -1;
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.invalidate("size");
      }
      
      protected function drawers_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:* = false;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode == 16777238)
         {
            _loc2_ = false;
            if(this.isTopDrawerOpen)
            {
               this.toggleTopDrawer();
               _loc2_ = true;
            }
            else if(this.isRightDrawerOpen)
            {
               this.toggleRightDrawer();
               _loc2_ = true;
            }
            else if(this.isBottomDrawerOpen)
            {
               this.toggleBottomDrawer();
               _loc2_ = true;
            }
            else if(this.isLeftDrawerOpen)
            {
               this.toggleLeftDrawer();
               _loc2_ = true;
            }
            if(_loc2_)
            {
               param1.preventDefault();
            }
         }
      }
      
      protected function content_topDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._topDrawer || this.isTopDrawerDocked)
         {
            return;
         }
         this._isTopDrawerOpen = !this._isTopDrawerOpen;
         this.openOrCloseTopDrawer();
      }
      
      protected function content_rightDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._rightDrawer || this.isRightDrawerDocked)
         {
            return;
         }
         this._isRightDrawerOpen = !this._isRightDrawerOpen;
         this.openOrCloseRightDrawer();
      }
      
      protected function content_bottomDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._bottomDrawer || this.isBottomDrawerDocked)
         {
            return;
         }
         this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
         this.openOrCloseBottomDrawer();
      }
      
      protected function content_leftDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._leftDrawer || this.isLeftDrawerDocked)
         {
            return;
         }
         this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
         this.openOrCloseLeftDrawer();
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         if(this._isValidating || this._autoSizeMode != "content")
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function drawer_resizeHandler(param1:Event) : void
      {
         if(this._isValidating)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}
