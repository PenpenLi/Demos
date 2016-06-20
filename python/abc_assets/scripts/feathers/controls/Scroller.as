package feathers.controls
{
   import feathers.core.FeathersControl;
   import flash.geom.Point;
   import starling.animation.Tween;
   import starling.display.Quad;
   import feathers.controls.supportClasses.IViewPort;
   import starling.display.DisplayObject;
   import feathers.core.PropertyProxy;
   import starling.core.Starling;
   import feathers.utils.math.roundToNearest;
   import flash.geom.Rectangle;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundUpToNearest;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import feathers.events.ExclusiveTouch;
   import flash.utils.getTimer;
   import flash.events.MouseEvent;
   
   public class Scroller extends FeathersControl
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";
      
      protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";
      
      protected static const INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS:String = "pendingRevealScrollBars";
      
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
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      private static const MINIMUM_VELOCITY:Number = 0.02;
      
      private static const FRICTION:Number = 0.998;
      
      private static const EXTRA_FRICTION:Number = 0.95;
      
      private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1,1.33,1.66,2];
      
      private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
      
      public static const DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";
      
      public static const DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";
       
      protected var horizontalScrollBarName:String = "feathers-scroller-horizontal-scroll-bar";
      
      protected var verticalScrollBarName:String = "feathers-scroller-vertical-scroll-bar";
      
      protected var horizontalScrollBar:feathers.controls.IScrollBar;
      
      protected var verticalScrollBar:feathers.controls.IScrollBar;
      
      protected var _topViewPortOffset:Number;
      
      protected var _rightViewPortOffset:Number;
      
      protected var _bottomViewPortOffset:Number;
      
      protected var _leftViewPortOffset:Number;
      
      protected var _hasHorizontalScrollBar:Boolean = false;
      
      protected var _hasVerticalScrollBar:Boolean = false;
      
      protected var _horizontalScrollBarTouchPointID:int = -1;
      
      protected var _verticalScrollBarTouchPointID:int = -1;
      
      protected var _touchPointID:int = -1;
      
      protected var _startTouchX:Number;
      
      protected var _startTouchY:Number;
      
      protected var _startHorizontalScrollPosition:Number;
      
      protected var _startVerticalScrollPosition:Number;
      
      protected var _currentTouchX:Number;
      
      protected var _currentTouchY:Number;
      
      protected var _previousTouchTime:int;
      
      protected var _previousTouchX:Number;
      
      protected var _previousTouchY:Number;
      
      protected var _velocityX:Number = 0;
      
      protected var _velocityY:Number = 0;
      
      protected var _previousVelocityX:Vector.<Number>;
      
      protected var _previousVelocityY:Vector.<Number>;
      
      protected var _lastViewPortWidth:Number = 0;
      
      protected var _lastViewPortHeight:Number = 0;
      
      protected var _hasViewPortBoundsChanged:Boolean = false;
      
      protected var _horizontalAutoScrollTween:Tween;
      
      protected var _verticalAutoScrollTween:Tween;
      
      protected var _isDraggingHorizontally:Boolean = false;
      
      protected var _isDraggingVertically:Boolean = false;
      
      protected var ignoreViewPortResizing:Boolean = false;
      
      protected var _touchBlocker:Quad;
      
      protected var _viewPort:IViewPort;
      
      protected var _snapToPages:Boolean = false;
      
      protected var _horizontalScrollBarFactory:Function;
      
      protected var _customHorizontalScrollBarName:String;
      
      protected var _horizontalScrollBarProperties:PropertyProxy;
      
      protected var _verticalScrollBarPosition:String = "right";
      
      protected var _verticalScrollBarFactory:Function;
      
      protected var _customVerticalScrollBarName:String;
      
      protected var _verticalScrollBarProperties:PropertyProxy;
      
      protected var actualHorizontalScrollStep:Number = 1;
      
      protected var explicitHorizontalScrollStep:Number = NaN;
      
      protected var _targetHorizontalScrollPosition:Number;
      
      protected var _horizontalScrollPosition:Number = 0;
      
      protected var _minHorizontalScrollPosition:Number = 0;
      
      protected var _maxHorizontalScrollPosition:Number = 0;
      
      protected var _horizontalPageIndex:int = 0;
      
      protected var _horizontalPageCount:int = 1;
      
      protected var _horizontalScrollPolicy:String = "auto";
      
      protected var actualVerticalScrollStep:Number = 1;
      
      protected var explicitVerticalScrollStep:Number = NaN;
      
      protected var _verticalMouseWheelScrollStep:Number = NaN;
      
      protected var _targetVerticalScrollPosition:Number;
      
      protected var _verticalScrollPosition:Number = 0;
      
      protected var _minVerticalScrollPosition:Number = 0;
      
      protected var _maxVerticalScrollPosition:Number = 0;
      
      protected var _verticalPageIndex:int = 0;
      
      protected var _verticalPageCount:int = 1;
      
      protected var _verticalScrollPolicy:String = "auto";
      
      protected var _clipContent:Boolean = true;
      
      protected var actualPageWidth:Number = 0;
      
      protected var explicitPageWidth:Number = NaN;
      
      protected var actualPageHeight:Number = 0;
      
      protected var explicitPageHeight:Number = NaN;
      
      protected var _hasElasticEdges:Boolean = true;
      
      protected var _elasticity:Number = 0.33;
      
      protected var _scrollBarDisplayMode:String = "float";
      
      protected var _interactionMode:String = "touch";
      
      protected var originalBackgroundWidth:Number = NaN;
      
      protected var originalBackgroundHeight:Number = NaN;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoHideBackground:Boolean = false;
      
      protected var _minimumDragDistance:Number = 0.04;
      
      protected var _minimumPageThrowVelocity:Number = 5;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalScrollBarHideTween:Tween;
      
      protected var _verticalScrollBarHideTween:Tween;
      
      protected var _hideScrollBarAnimationDuration:Number = 0.2;
      
      protected var _hideScrollBarAnimationEase:Object = "easeOut";
      
      protected var _elasticSnapDuration:Number = 0.24;
      
      protected var _pageThrowDuration:Number = 0.5;
      
      protected var _mouseWheelScrollDuration:Number = 0.35;
      
      protected var _throwEase:Object = "easeOut";
      
      protected var _snapScrollPositionsToPixels:Boolean = false;
      
      protected var _horizontalScrollBarIsScrolling:Boolean = false;
      
      protected var _verticalScrollBarIsScrolling:Boolean = false;
      
      protected var _isScrolling:Boolean = false;
      
      protected var _isScrollingStopped:Boolean = false;
      
      protected var pendingHorizontalScrollPosition:Number = NaN;
      
      protected var pendingVerticalScrollPosition:Number = NaN;
      
      protected var pendingHorizontalPageIndex:int = -1;
      
      protected var pendingVerticalPageIndex:int = -1;
      
      protected var pendingScrollDuration:Number;
      
      protected var isScrollBarRevealPending:Boolean = false;
      
      protected var _revealScrollBarsDuration:Number = 1.0;
      
      public function Scroller()
      {
         _previousVelocityX = new Vector.<Number>(0);
         _previousVelocityY = new Vector.<Number>(0);
         _horizontalScrollBarFactory = defaultHorizontalScrollBarFactory;
         _verticalScrollBarFactory = defaultVerticalScrollBarFactory;
         super();
         this.addEventListener("addedToStage",scroller_addedToStageHandler);
         this.addEventListener("removedFromStage",scroller_removedFromStageHandler);
      }
      
      protected static function defaultHorizontalScrollBarFactory() : feathers.controls.IScrollBar
      {
         var _loc1_:SimpleScrollBar = new SimpleScrollBar();
         _loc1_.direction = "horizontal";
         return _loc1_;
      }
      
      protected static function defaultVerticalScrollBarFactory() : feathers.controls.IScrollBar
      {
         var _loc1_:SimpleScrollBar = new SimpleScrollBar();
         _loc1_.direction = "vertical";
         return _loc1_;
      }
      
      public function get viewPort() : IViewPort
      {
         return this._viewPort;
      }
      
      public function set viewPort(param1:IViewPort) : void
      {
         if(this._viewPort == param1)
         {
            return;
         }
         if(this._viewPort)
         {
            this._viewPort.removeEventListener("resize",viewPort_resizeHandler);
            this.removeRawChildInternal(DisplayObject(this._viewPort));
         }
         this._viewPort = param1;
         if(this._viewPort)
         {
            this._viewPort.addEventListener("resize",viewPort_resizeHandler);
            this.addRawChildAtInternal(DisplayObject(this._viewPort),0);
         }
         this.invalidate("size");
      }
      
      public function get snapToPages() : Boolean
      {
         return this._snapToPages;
      }
      
      public function set snapToPages(param1:Boolean) : void
      {
         if(this._snapToPages == param1)
         {
            return;
         }
         this._snapToPages = param1;
         this.invalidate("scroll");
      }
      
      public function get horizontalScrollBarFactory() : Function
      {
         return this._horizontalScrollBarFactory;
      }
      
      public function set horizontalScrollBarFactory(param1:Function) : void
      {
         if(this._horizontalScrollBarFactory == param1)
         {
            return;
         }
         this._horizontalScrollBarFactory = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get customHorizontalScrollBarName() : String
      {
         return this._customHorizontalScrollBarName;
      }
      
      public function set customHorizontalScrollBarName(param1:String) : void
      {
         if(this._customHorizontalScrollBarName == param1)
         {
            return;
         }
         this._customHorizontalScrollBarName = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get horizontalScrollBarProperties() : Object
      {
         if(!this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._horizontalScrollBarProperties;
      }
      
      public function set horizontalScrollBarProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._horizontalScrollBarProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            var param1:Object = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
         }
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._horizontalScrollBarProperties = PropertyProxy(param1);
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get verticalScrollBarPosition() : String
      {
         return this._verticalScrollBarPosition;
      }
      
      public function set verticalScrollBarPosition(param1:String) : void
      {
         if(this._verticalScrollBarPosition == param1)
         {
            return;
         }
         this._verticalScrollBarPosition = param1;
         this.invalidate("styles");
      }
      
      public function get verticalScrollBarFactory() : Function
      {
         return this._verticalScrollBarFactory;
      }
      
      public function set verticalScrollBarFactory(param1:Function) : void
      {
         if(this._verticalScrollBarFactory == param1)
         {
            return;
         }
         this._verticalScrollBarFactory = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get customVerticalScrollBarName() : String
      {
         return this._customVerticalScrollBarName;
      }
      
      public function set customVerticalScrollBarName(param1:String) : void
      {
         if(this._customVerticalScrollBarName == param1)
         {
            return;
         }
         this._customVerticalScrollBarName = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get verticalScrollBarProperties() : Object
      {
         if(!this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._verticalScrollBarProperties;
      }
      
      public function set verticalScrollBarProperties(param1:Object) : void
      {
         var _loc3_:* = null;
         if(this._horizontalScrollBarProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            var param1:Object = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
         }
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._verticalScrollBarProperties = PropertyProxy(param1);
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get horizontalScrollStep() : Number
      {
         return this.actualHorizontalScrollStep;
      }
      
      public function set horizontalScrollStep(param1:Number) : void
      {
         if(this.explicitHorizontalScrollStep == param1)
         {
            return;
         }
         this.explicitHorizontalScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._snapScrollPositionsToPixels)
         {
            var param1:Number = Math.round(param1);
         }
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get minHorizontalScrollPosition() : Number
      {
         return this._minHorizontalScrollPosition;
      }
      
      public function get maxHorizontalScrollPosition() : Number
      {
         return this._maxHorizontalScrollPosition;
      }
      
      public function get horizontalPageIndex() : int
      {
         if(this.pendingHorizontalPageIndex >= 0)
         {
            return this.pendingHorizontalPageIndex;
         }
         return this._horizontalPageIndex;
      }
      
      public function get horizontalPageCount() : int
      {
         return this._horizontalPageCount;
      }
      
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(param1:String) : void
      {
         if(this._horizontalScrollPolicy == param1)
         {
            return;
         }
         this._horizontalScrollPolicy = param1;
         this.invalidate("scroll");
         this.invalidate("scrollBarRenderer");
      }
      
      public function get verticalScrollStep() : Number
      {
         return this.actualVerticalScrollStep;
      }
      
      public function set verticalScrollStep(param1:Number) : void
      {
         if(this.explicitVerticalScrollStep == param1)
         {
            return;
         }
         this.explicitVerticalScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalMouseWheelScrollStep() : Number
      {
         return this._verticalMouseWheelScrollStep;
      }
      
      public function set verticalMouseWheelScrollStep(param1:Number) : void
      {
         if(this._verticalMouseWheelScrollStep == param1)
         {
            return;
         }
         this._verticalMouseWheelScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._snapScrollPositionsToPixels)
         {
            var param1:Number = Math.round(param1);
         }
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         if(isNaN(param1))
         {
            throw new ArgumentError("verticalScrollPosition cannot be NaN.");
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get minVerticalScrollPosition() : Number
      {
         return this._minVerticalScrollPosition;
      }
      
      public function get maxVerticalScrollPosition() : Number
      {
         return this._maxVerticalScrollPosition;
      }
      
      public function get verticalPageIndex() : int
      {
         if(this.pendingVerticalPageIndex >= 0)
         {
            return this.pendingVerticalPageIndex;
         }
         return this._verticalPageIndex;
      }
      
      public function get verticalPageCount() : int
      {
         return this._verticalPageCount;
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(param1:String) : void
      {
         if(this._verticalScrollPolicy == param1)
         {
            return;
         }
         this._verticalScrollPolicy = param1;
         this.invalidate("scroll");
         this.invalidate("scrollBarRenderer");
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         this.invalidate("clipping");
      }
      
      public function get pageWidth() : Number
      {
         return this.actualPageWidth;
      }
      
      public function set pageWidth(param1:Number) : void
      {
         if(this.explicitPageWidth == param1)
         {
            return;
         }
         var _loc2_:Boolean = isNaN(param1);
         if(_loc2_ && isNaN(this.explicitPageWidth))
         {
            return;
         }
         this.explicitPageWidth = param1;
         if(_loc2_)
         {
            this.actualPageWidth = 0;
         }
         else
         {
            this.actualPageWidth = this.explicitPageWidth;
         }
      }
      
      public function get pageHeight() : Number
      {
         return this.actualPageHeight;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         if(this.explicitPageHeight == param1)
         {
            return;
         }
         var _loc2_:Boolean = isNaN(param1);
         if(_loc2_ && isNaN(this.explicitPageHeight))
         {
            return;
         }
         this.explicitPageHeight = param1;
         if(_loc2_)
         {
            this.actualPageHeight = 0;
         }
         else
         {
            this.actualPageHeight = this.explicitPageHeight;
         }
      }
      
      public function get hasElasticEdges() : Boolean
      {
         return this._hasElasticEdges;
      }
      
      public function set hasElasticEdges(param1:Boolean) : void
      {
         this._hasElasticEdges = param1;
      }
      
      public function get elasticity() : Number
      {
         return this._elasticity;
      }
      
      public function set elasticity(param1:Number) : void
      {
         this._elasticity = param1;
      }
      
      public function get scrollBarDisplayMode() : String
      {
         return this._scrollBarDisplayMode;
      }
      
      public function set scrollBarDisplayMode(param1:String) : void
      {
         if(this._scrollBarDisplayMode == param1)
         {
            return;
         }
         this._scrollBarDisplayMode = param1;
         this.invalidate("styles");
      }
      
      public function get interactionMode() : String
      {
         return this._interactionMode;
      }
      
      public function set interactionMode(param1:String) : void
      {
         if(this._interactionMode == param1)
         {
            return;
         }
         this._interactionMode = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
         {
            this.removeRawChildInternal(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin && this._backgroundSkin.parent != this)
         {
            this._backgroundSkin.visible = false;
            this.addRawChildInternal(this._backgroundSkin);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
         {
            this.removeRawChildInternal(this._backgroundDisabledSkin);
         }
         this._backgroundDisabledSkin = param1;
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
         {
            this._backgroundDisabledSkin.visible = false;
            this.addRawChildInternal(this._backgroundDisabledSkin);
         }
         this.invalidate("styles");
      }
      
      public function get autoHideBackground() : Boolean
      {
         return this._autoHideBackground;
      }
      
      public function set autoHideBackground(param1:Boolean) : void
      {
         if(this._autoHideBackground == param1)
         {
            return;
         }
         this._autoHideBackground = param1;
         this.invalidate("styles");
      }
      
      public function get minimumDragDistance() : Number
      {
         return this._minimumDragDistance;
      }
      
      public function set minimumDragDistance(param1:Number) : void
      {
         this._minimumDragDistance = param1;
      }
      
      public function get minimumPageThrowVelocity() : Number
      {
         return this._minimumPageThrowVelocity;
      }
      
      public function set minimumPageThrowVelocity(param1:Number) : void
      {
         this._minimumPageThrowVelocity = param1;
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate("styles");
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate("styles");
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate("styles");
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate("styles");
      }
      
      public function get hideScrollBarAnimationDuration() : Number
      {
         return this._hideScrollBarAnimationDuration;
      }
      
      public function set hideScrollBarAnimationDuration(param1:Number) : void
      {
         this._hideScrollBarAnimationDuration = param1;
      }
      
      public function get hideScrollBarAnimationEase() : Object
      {
         return this._hideScrollBarAnimationEase;
      }
      
      public function set hideScrollBarAnimationEase(param1:Object) : void
      {
         this._hideScrollBarAnimationEase = param1;
      }
      
      public function get elasticSnapDuration() : Number
      {
         return this._elasticSnapDuration;
      }
      
      public function set elasticSnapDuration(param1:Number) : void
      {
         this._elasticSnapDuration = param1;
      }
      
      public function get pageThrowDuration() : Number
      {
         return this._pageThrowDuration;
      }
      
      public function set pageThrowDuration(param1:Number) : void
      {
         this._pageThrowDuration = param1;
      }
      
      public function get mouseWheelScrollDuration() : Number
      {
         return this._mouseWheelScrollDuration;
      }
      
      public function set mouseWheelScrollDuration(param1:Number) : void
      {
         this._mouseWheelScrollDuration = param1;
      }
      
      public function get throwEase() : Object
      {
         return this._throwEase;
      }
      
      public function set throwEase(param1:Object) : void
      {
         this._throwEase = param1;
      }
      
      public function get snapScrollPositionsToPixels() : Boolean
      {
         return this._snapScrollPositionsToPixels;
      }
      
      public function set snapScrollPositionsToPixels(param1:Boolean) : void
      {
         if(this._snapScrollPositionsToPixels == param1)
         {
            return;
         }
         this._snapScrollPositionsToPixels = param1;
         if(this._snapScrollPositionsToPixels)
         {
            this.horizontalScrollPosition = Math.round(this._horizontalScrollPosition);
            this.verticalScrollPosition = Math.round(this._verticalScrollPosition);
         }
      }
      
      public function get isScrolling() : Boolean
      {
         return this._isScrolling;
      }
      
      public function get revealScrollBarsDuration() : Number
      {
         return this._revealScrollBarsDuration;
      }
      
      public function set revealScrollBarsDuration(param1:Number) : void
      {
         this._revealScrollBarsDuration = param1;
      }
      
      override public function dispose() : void
      {
         Starling.current.nativeStage.removeEventListener("mouseWheel",nativeStage_mouseWheelHandler);
         Starling.current.nativeStage.removeEventListener("orientationChange",nativeStage_orientationChangeHandler);
         super.dispose();
      }
      
      public function stopScrolling() : void
      {
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._isScrollingStopped = true;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
      }
      
      public function scrollToPosition(param1:Number, param2:Number, param3:Number = 0) : void
      {
         this.pendingHorizontalPageIndex = -1;
         this.pendingVerticalPageIndex = -1;
         if(this.pendingHorizontalScrollPosition == param1 && this.pendingVerticalScrollPosition == param2 && this.pendingScrollDuration == param3)
         {
            return;
         }
         this.pendingHorizontalScrollPosition = param1;
         this.pendingVerticalScrollPosition = param2;
         this.pendingScrollDuration = param3;
         this.invalidate("pendingScroll");
      }
      
      public function scrollToPageIndex(param1:int, param2:int, param3:Number = 0) : void
      {
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         var _loc5_:Boolean = this.pendingHorizontalPageIndex >= 0 && this.pendingHorizontalPageIndex != param1 || this.pendingHorizontalPageIndex < 0 && this._horizontalPageIndex != param1;
         var _loc6_:Boolean = this.pendingVerticalPageIndex >= 0 && this.pendingVerticalPageIndex != param2 || this.pendingVerticalPageIndex < 0 && this._verticalPageIndex != param2;
         var _loc4_:Boolean = (this.pendingHorizontalPageIndex >= 0 || this.pendingVerticalPageIndex >= 0) && this.pendingScrollDuration == param3;
         if(!_loc5_ && !_loc6_ && !_loc4_)
         {
            return;
         }
         this.pendingHorizontalPageIndex = param1;
         this.pendingVerticalPageIndex = param2;
         this.pendingScrollDuration = param3;
         this.invalidate("pendingScroll");
      }
      
      public function revealScrollBars() : void
      {
         this.isScrollBarRevealPending = true;
         this.invalidate("pendingRevealScrollBars");
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : DisplayObject
      {
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y;
         var _loc3_:DisplayObject = super.hitTest(param1,param2);
         if(!_loc3_)
         {
            if(param2 && (!this.visible || !this.touchable))
            {
               return null;
            }
            return this._hitArea.contains(_loc4_,_loc5_)?this:null;
         }
         return _loc3_;
      }
      
      override protected function draw() : void
      {
         var _loc5_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("scroll");
         var _loc8_:Boolean = this.isInvalid("clipping");
         var _loc11_:Boolean = this.isInvalid("styles");
         var _loc10_:Boolean = this.isInvalid("state");
         var _loc7_:Boolean = this.isInvalid("scrollBarRenderer");
         var _loc4_:Boolean = this.isInvalid("pendingScroll");
         var _loc9_:Boolean = this.isInvalid("pendingRevealScrollBars");
         if(_loc7_)
         {
            this.createScrollBars();
         }
         if(_loc5_ || _loc11_ || _loc10_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc7_ || _loc11_)
         {
            this.refreshScrollBarStyles();
            this.refreshInteractionModeEvents();
         }
         if(_loc7_ || _loc10_)
         {
            this.refreshEnabled();
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.validate();
         }
         var _loc12_:Number = this._maxHorizontalScrollPosition;
         var _loc3_:Number = this._maxVerticalScrollPosition;
         var _loc1_:* = 0;
         while(true)
         {
            this._hasViewPortBoundsChanged = false;
            if(_loc2_ || _loc6_ || _loc5_ || _loc11_ || _loc7_)
            {
               this.calculateViewPortOffsets(true,false);
               this.refreshViewPortBoundsWithoutFixedScrollBars();
               this.calculateViewPortOffsets(false,false);
            }
            _loc5_ = this.autoSizeIfNeeded() || _loc5_;
            this.calculateViewPortOffsets(false,true);
            if(_loc2_ || _loc6_ || _loc5_ || _loc11_ || _loc7_)
            {
               this.refreshViewPortBoundsWithFixedScrollBars();
               this.refreshScrollValues();
            }
            _loc1_++;
            if(_loc1_ < 10)
            {
               if(!this._hasViewPortBoundsChanged)
               {
                  break;
               }
               continue;
            }
            break;
         }
         this._lastViewPortWidth = viewPort.width;
         this._lastViewPortHeight = viewPort.height;
         if(_loc2_ || this._maxHorizontalScrollPosition != _loc12_ || this._maxVerticalScrollPosition != _loc3_)
         {
            _loc2_ = true;
            this.dispatchEventWith("scroll");
         }
         this.showOrHideChildren();
         if(_loc2_ || _loc5_ || _loc11_ || _loc7_)
         {
            this.layoutChildren();
         }
         if(_loc2_ || _loc5_ || _loc11_ || _loc7_)
         {
            this.refreshScrollBarValues();
         }
         if(_loc2_ || _loc5_ || _loc11_ || _loc7_ || _loc8_)
         {
            this.refreshClipRect();
         }
         if(_loc4_)
         {
            this.handlePendingScroll();
         }
         if(_loc9_)
         {
            this.handlePendingRevealScrollBars();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:Boolean = isNaN(this.explicitWidth);
         var _loc4_:Boolean = isNaN(this.explicitHeight);
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         var _loc3_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            _loc3_ = this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset;
            if(!isNaN(this.originalBackgroundWidth))
            {
               _loc3_ = Math.max(_loc3_,this.originalBackgroundWidth);
            }
         }
         if(_loc4_)
         {
            _loc1_ = this._viewPort.height + this._bottomViewPortOffset + this._topViewPortOffset;
            if(!isNaN(this.originalBackgroundHeight))
            {
               _loc1_ = Math.max(_loc1_,this.originalBackgroundHeight);
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createScrollBars() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.removeEventListener("beginInteraction",horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.removeEventListener("endInteraction",horizontalScrollBar_endInteractionHandler);
            this.horizontalScrollBar.removeEventListener("change",horizontalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.horizontalScrollBar),true);
            this.horizontalScrollBar = null;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.removeEventListener("beginInteraction",verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.removeEventListener("endInteraction",verticalScrollBar_endInteractionHandler);
            this.verticalScrollBar.removeEventListener("change",verticalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.verticalScrollBar),true);
            this.verticalScrollBar = null;
         }
         if(this._scrollBarDisplayMode != "none" && this._horizontalScrollPolicy != "off" && this._horizontalScrollBarFactory != null)
         {
            this.horizontalScrollBar = feathers.controls.IScrollBar(this._horizontalScrollBarFactory());
            _loc2_ = this._customHorizontalScrollBarName != null?this._customHorizontalScrollBarName:this.horizontalScrollBarName;
            this.horizontalScrollBar.nameList.add(_loc2_);
            this.horizontalScrollBar.addEventListener("change",horizontalScrollBar_changeHandler);
            this.horizontalScrollBar.addEventListener("beginInteraction",horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.addEventListener("endInteraction",horizontalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.horizontalScrollBar));
         }
         if(this._scrollBarDisplayMode != "none" && this._verticalScrollPolicy != "off" && this._verticalScrollBarFactory != null)
         {
            this.verticalScrollBar = feathers.controls.IScrollBar(this._verticalScrollBarFactory());
            _loc1_ = this._customVerticalScrollBarName != null?this._customVerticalScrollBarName:this.verticalScrollBarName;
            this.verticalScrollBar.nameList.add(_loc1_);
            this.verticalScrollBar.addEventListener("change",verticalScrollBar_changeHandler);
            this.verticalScrollBar.addEventListener("beginInteraction",verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.addEventListener("endInteraction",verticalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.verticalScrollBar));
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin)
         {
            if(this._backgroundSkin)
            {
               this._backgroundSkin.visible = false;
            }
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else if(this._backgroundDisabledSkin)
         {
            this._backgroundDisabledSkin.visible = false;
         }
         if(this.currentBackgroundSkin)
         {
            this.setRawChildIndexInternal(this.currentBackgroundSkin,0);
            if(isNaN(this.originalBackgroundWidth))
            {
               this.originalBackgroundWidth = this.currentBackgroundSkin.width;
            }
            if(isNaN(this.originalBackgroundHeight))
            {
               this.originalBackgroundHeight = this.currentBackgroundSkin.height;
            }
         }
      }
      
      protected function refreshScrollBarStyles() : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(this.horizontalScrollBar)
         {
            _loc3_ = this.horizontalScrollBar;
            var _loc5_:* = 0;
            var _loc4_:* = this._horizontalScrollBarProperties;
            for(var _loc1_ in this._horizontalScrollBarProperties)
            {
               if(_loc3_.hasOwnProperty(_loc1_))
               {
                  _loc2_ = this._horizontalScrollBarProperties[_loc1_];
                  this.horizontalScrollBar[_loc1_] = _loc2_;
               }
            }
            if(this._horizontalScrollBarHideTween)
            {
               Starling.juggler.remove(this._horizontalScrollBarHideTween);
               this._horizontalScrollBarHideTween = null;
            }
            this.horizontalScrollBar.alpha = this._scrollBarDisplayMode == "float"?0:1.0;
            this.horizontalScrollBar.touchable = this._interactionMode == "mouse" || this._interactionMode == "touchAndScrollBars";
         }
         if(this.verticalScrollBar)
         {
            _loc3_ = this.verticalScrollBar;
            var _loc7_:* = 0;
            var _loc6_:* = this._verticalScrollBarProperties;
            for(_loc1_ in this._verticalScrollBarProperties)
            {
               if(_loc3_.hasOwnProperty(_loc1_))
               {
                  _loc2_ = this._verticalScrollBarProperties[_loc1_];
                  this.verticalScrollBar[_loc1_] = _loc2_;
               }
            }
            if(this._verticalScrollBarHideTween)
            {
               Starling.juggler.remove(this._verticalScrollBarHideTween);
               this._verticalScrollBarHideTween = null;
            }
            this.verticalScrollBar.alpha = this._scrollBarDisplayMode == "float"?0:1.0;
            this.verticalScrollBar.touchable = this._interactionMode == "mouse" || this._interactionMode == "touchAndScrollBars";
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this._viewPort)
         {
            this._viewPort.isEnabled = this._isEnabled;
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.isEnabled = this._isEnabled;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.isEnabled = this._isEnabled;
         }
      }
      
      protected function refreshViewPortBoundsWithoutFixedScrollBars() : void
      {
         var _loc2_:Number = this._leftViewPortOffset + this._rightViewPortOffset;
         var _loc3_:Number = this._topViewPortOffset + this._bottomViewPortOffset;
         this._viewPort.visibleWidth = this.explicitWidth - _loc2_;
         this._viewPort.visibleHeight = this.explicitHeight - _loc3_;
         this._viewPort.minVisibleWidth = Math.max(0,this._minWidth - _loc2_);
         this._viewPort.maxVisibleWidth = this._maxWidth - _loc2_;
         this._viewPort.minVisibleHeight = Math.max(0,this._minHeight - _loc3_);
         this._viewPort.maxVisibleHeight = this._maxHeight - _loc3_;
         this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
         this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
         var _loc1_:Boolean = this.ignoreViewPortResizing;
         if(this._scrollBarDisplayMode == "fixed")
         {
            this.ignoreViewPortResizing = true;
         }
         this._viewPort.validate();
         this.ignoreViewPortResizing = _loc1_;
      }
      
      protected function refreshViewPortBoundsWithFixedScrollBars() : void
      {
         this._viewPort.visibleWidth = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
         this._viewPort.visibleHeight = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
         this._viewPort.validate();
      }
      
      protected function refreshScrollValues() : void
      {
         this.refreshScrollSteps();
         var _loc1_:Number = this._maxHorizontalScrollPosition;
         var _loc3_:Number = this._maxVerticalScrollPosition;
         this.refreshMinAndMaxScrollPositions();
         var _loc2_:Boolean = this._maxHorizontalScrollPosition != _loc1_ || this._maxVerticalScrollPosition != _loc3_;
         if(_loc2_ && this._touchPointID < 0)
         {
            this.clampScrollPositions();
         }
         this.refreshPageCount();
         this.refreshPageIndices();
         if(_loc2_)
         {
            if(this._horizontalAutoScrollTween && this._targetHorizontalScrollPosition > this._maxHorizontalScrollPosition && _loc1_ > this._maxHorizontalScrollPosition)
            {
               this._targetHorizontalScrollPosition = this._targetHorizontalScrollPosition - (_loc1_ - this._maxHorizontalScrollPosition);
               this.throwTo(this._targetHorizontalScrollPosition,NaN,this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
            }
            if(this._verticalAutoScrollTween && this._targetVerticalScrollPosition > this._maxVerticalScrollPosition && _loc3_ > this._maxVerticalScrollPosition)
            {
               this._targetVerticalScrollPosition = this._targetVerticalScrollPosition - (_loc3_ - this._maxVerticalScrollPosition);
               this.throwTo(NaN,this._targetVerticalScrollPosition,this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
            }
         }
      }
      
      protected function clampScrollPositions() : void
      {
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         if(!this._horizontalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._horizontalScrollPosition = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            _loc2_ = this._horizontalScrollPosition;
            if(_loc2_ < this._minHorizontalScrollPosition)
            {
               _loc2_ = this._minHorizontalScrollPosition;
            }
            else if(_loc2_ > this._maxHorizontalScrollPosition)
            {
               _loc2_ = this._maxHorizontalScrollPosition;
            }
            this.horizontalScrollPosition = _loc2_;
         }
         if(!this._verticalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._verticalScrollPosition = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            _loc1_ = this._verticalScrollPosition;
            if(_loc1_ < this._minVerticalScrollPosition)
            {
               _loc1_ = this._minVerticalScrollPosition;
            }
            else if(_loc1_ > this._maxVerticalScrollPosition)
            {
               _loc1_ = this._maxVerticalScrollPosition;
            }
            this.verticalScrollPosition = _loc1_;
         }
      }
      
      protected function refreshScrollSteps() : void
      {
         if(isNaN(this.explicitHorizontalScrollStep))
         {
            if(this._viewPort)
            {
               this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
            }
            else
            {
               this.actualHorizontalScrollStep = 1;
            }
         }
         else
         {
            this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
         }
         if(isNaN(this.explicitVerticalScrollStep))
         {
            if(this._viewPort)
            {
               this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
            }
            else
            {
               this.actualVerticalScrollStep = 1;
            }
         }
         else
         {
            this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
         }
      }
      
      protected function refreshMinAndMaxScrollPositions() : void
      {
         var _loc2_:Number = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
         var _loc1_:Number = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
         if(isNaN(this.explicitPageWidth))
         {
            this.actualPageWidth = _loc2_;
         }
         if(isNaN(this.explicitPageHeight))
         {
            this.actualPageHeight = _loc1_;
         }
         if(this._viewPort)
         {
            this._minHorizontalScrollPosition = this._viewPort.contentX;
            this._maxHorizontalScrollPosition = this._viewPort.width - _loc2_;
            if(this._maxHorizontalScrollPosition < this._minHorizontalScrollPosition)
            {
               this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition;
            }
            this._minVerticalScrollPosition = this._viewPort.contentY;
            this._maxVerticalScrollPosition = this._viewPort.height - _loc1_;
            if(this._maxVerticalScrollPosition < this._minVerticalScrollPosition)
            {
               this._maxVerticalScrollPosition = this._minVerticalScrollPosition;
            }
            if(this._snapScrollPositionsToPixels)
            {
               this._minHorizontalScrollPosition = Math.round(this._minHorizontalScrollPosition);
               this._minVerticalScrollPosition = Math.round(this._minVerticalScrollPosition);
               this._maxHorizontalScrollPosition = Math.round(this._maxHorizontalScrollPosition);
               this._maxVerticalScrollPosition = Math.round(this._maxVerticalScrollPosition);
            }
         }
         else
         {
            this._minHorizontalScrollPosition = 0;
            this._minVerticalScrollPosition = 0;
            this._maxHorizontalScrollPosition = 0;
            this._maxVerticalScrollPosition = 0;
         }
      }
      
      protected function refreshPageCount() : void
      {
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         if(this._snapToPages)
         {
            _loc2_ = this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition;
            _loc1_ = this._maxVerticalScrollPosition - this._minVerticalScrollPosition;
            this._horizontalPageCount = Math.ceil(_loc2_ / this.actualPageWidth) + 1;
            this._verticalPageCount = Math.ceil(_loc1_ / this.actualPageHeight) + 1;
         }
         else
         {
            this._horizontalPageCount = 1;
            this._verticalPageCount = 1;
         }
      }
      
      protected function refreshPageIndices() : void
      {
         var _loc3_:* = NaN;
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         if(!this._horizontalAutoScrollTween && this.pendingHorizontalPageIndex < 0)
         {
            if(this._snapToPages)
            {
               if(this._horizontalScrollPosition == this._maxHorizontalScrollPosition)
               {
                  this._horizontalPageIndex = this._horizontalPageCount - 1;
               }
               else
               {
                  _loc3_ = this._horizontalScrollPosition - this._minHorizontalScrollPosition;
                  this._horizontalPageIndex = Math.floor(_loc3_ / this.actualPageWidth);
               }
            }
            else
            {
               this._horizontalPageIndex = 0;
            }
            if(this._horizontalPageIndex < 0)
            {
               this._horizontalPageIndex = 0;
            }
            _loc1_ = this._horizontalPageCount - 1;
            if(this._horizontalPageIndex > _loc1_)
            {
               this._horizontalPageIndex = _loc1_;
            }
         }
         if(!this._verticalAutoScrollTween && this.pendingVerticalPageIndex < 0)
         {
            if(this._snapToPages)
            {
               if(this._verticalScrollPosition == this._maxVerticalScrollPosition)
               {
                  this._verticalPageIndex = this._verticalPageCount - 1;
               }
               else
               {
                  _loc2_ = this._verticalScrollPosition - this._minVerticalScrollPosition;
                  this._verticalPageIndex = Math.floor(_loc2_ / this.actualPageHeight);
               }
            }
            else
            {
               this._verticalPageIndex = 0;
            }
            if(this._verticalPageIndex < 0)
            {
               this._verticalPageIndex = 0;
            }
            _loc1_ = this._verticalPageCount - 1;
            if(this._verticalPageIndex > _loc1_)
            {
               this._verticalPageIndex = _loc1_;
            }
         }
      }
      
      protected function refreshScrollBarValues() : void
      {
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.minimum = this._minHorizontalScrollPosition;
            this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
            this.horizontalScrollBar.value = this._horizontalScrollPosition;
            this.horizontalScrollBar.page = this._maxHorizontalScrollPosition * this.actualPageWidth / this._viewPort.width;
            this.horizontalScrollBar.step = this.actualHorizontalScrollStep;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.minimum = this._minVerticalScrollPosition;
            this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
            this.verticalScrollBar.value = this._verticalScrollPosition;
            this.verticalScrollBar.page = this._maxVerticalScrollPosition * this.actualPageHeight / this._viewPort.height;
            this.verticalScrollBar.step = this.actualVerticalScrollStep;
         }
      }
      
      protected function showOrHideChildren() : void
      {
         var _loc1_:* = this._scrollBarDisplayMode == "fixed";
         var _loc2_:int = this.numRawChildrenInternal;
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.visible = !_loc1_ || this._hasVerticalScrollBar;
            this.setRawChildIndexInternal(DisplayObject(this.verticalScrollBar),_loc2_ - 1);
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.visible = !_loc1_ || this._hasHorizontalScrollBar;
            if(this.verticalScrollBar)
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc2_ - 2);
            }
            else
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc2_ - 1);
            }
         }
         if(this.currentBackgroundSkin)
         {
            if(this._autoHideBackground)
            {
               this.currentBackgroundSkin.visible = this._viewPort.width < this.actualWidth || this._viewPort.height < this.actualHeight || this._horizontalScrollPosition < 0 || this._horizontalScrollPosition > this._maxHorizontalScrollPosition || this._verticalScrollPosition < 0 || this._verticalScrollPosition > this._maxVerticalScrollPosition;
            }
            else
            {
               this.currentBackgroundSkin.visible = true;
            }
         }
      }
      
      protected function calculateViewPortOffsetsForFixedHorizontalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:* = NaN;
         var _loc3_:* = NaN;
         if(this.horizontalScrollBar)
         {
            _loc4_ = param2?this.actualWidth:this.explicitWidth;
            _loc3_ = this._viewPort.width + this._leftViewPortOffset + this._rightViewPortOffset;
            if(param1 || this._horizontalScrollPolicy == "on" || (_loc3_ > _loc4_ || _loc3_ > this._maxWidth) && this._horizontalScrollPolicy != "off")
            {
               this._hasHorizontalScrollBar = true;
               this._bottomViewPortOffset = this._bottomViewPortOffset + this.horizontalScrollBar.height;
            }
            else
            {
               this._hasHorizontalScrollBar = false;
            }
         }
         else
         {
            this._hasHorizontalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsetsForFixedVerticalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         if(this.verticalScrollBar)
         {
            _loc3_ = param2?this.actualHeight:this.explicitHeight;
            _loc4_ = this._viewPort.height + this._topViewPortOffset + this._bottomViewPortOffset;
            if(param1 || this._verticalScrollPolicy == "on" || (_loc4_ > _loc3_ || _loc4_ > this._maxHeight) && this._verticalScrollPolicy != "off")
            {
               this._hasVerticalScrollBar = true;
               if(this._verticalScrollBarPosition == "left")
               {
                  this._leftViewPortOffset = this._leftViewPortOffset + this.verticalScrollBar.width;
               }
               else
               {
                  this._rightViewPortOffset = this._rightViewPortOffset + this.verticalScrollBar.width;
               }
            }
            else
            {
               this._hasVerticalScrollBar = false;
            }
         }
         else
         {
            this._hasVerticalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         this._topViewPortOffset = this._paddingTop;
         this._rightViewPortOffset = this._paddingRight;
         this._bottomViewPortOffset = this._paddingBottom;
         this._leftViewPortOffset = this._paddingLeft;
         if(this._scrollBarDisplayMode == "fixed")
         {
            this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
            this.calculateViewPortOffsetsForFixedVerticalScrollBar(param1,param2);
            if(this._hasVerticalScrollBar && !this._hasHorizontalScrollBar)
            {
               this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
            }
         }
         else
         {
            this._hasHorizontalScrollBar = this._isDraggingHorizontally || this._horizontalAutoScrollTween;
            this._hasVerticalScrollBar = this._isDraggingVertically || this._verticalAutoScrollTween;
         }
      }
      
      protected function refreshInteractionModeEvents() : void
      {
         if(this._interactionMode == "touch" || this._interactionMode == "touchAndScrollBars")
         {
            this.addEventListener("touch",scroller_touchHandler);
            if(!this._touchBlocker)
            {
               this._touchBlocker = new Quad(100,100,16711935);
               this._touchBlocker.alpha = 0;
               this._touchBlocker.visible = false;
               this.addRawChildInternal(this._touchBlocker);
            }
         }
         else
         {
            this.removeEventListener("touch",scroller_touchHandler);
            if(this._touchBlocker)
            {
               this.removeRawChildInternal(this._touchBlocker,true);
               this._touchBlocker = null;
            }
         }
         if((this._interactionMode == "mouse" || this._interactionMode == "touchAndScrollBars") && this._scrollBarDisplayMode == "float")
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.addEventListener("touch",horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.addEventListener("touch",verticalScrollBar_touchHandler);
            }
         }
         else
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.removeEventListener("touch",horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.removeEventListener("touch",verticalScrollBar_touchHandler);
            }
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackgroundSkin)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.validate();
         }
         if(this._touchBlocker)
         {
            this._touchBlocker.x = this._leftViewPortOffset;
            this._touchBlocker.y = this._topViewPortOffset;
            this._touchBlocker.width = this._viewPort.visibleWidth;
            this._touchBlocker.height = this._viewPort.visibleHeight;
         }
         this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
         this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.x = this._leftViewPortOffset;
            this.horizontalScrollBar.y = this._topViewPortOffset + this._viewPort.visibleHeight;
            if(this._scrollBarDisplayMode != "fixed")
            {
               this.horizontalScrollBar.y = this.horizontalScrollBar.y - this.horizontalScrollBar.height;
               if((this._hasVerticalScrollBar || this._verticalScrollBarHideTween) && this.verticalScrollBar)
               {
                  this.horizontalScrollBar.width = this._viewPort.visibleWidth - this.verticalScrollBar.width;
               }
               else
               {
                  this.horizontalScrollBar.width = this._viewPort.visibleWidth;
               }
            }
            else
            {
               this.horizontalScrollBar.width = this._viewPort.visibleWidth;
            }
         }
         if(this.verticalScrollBar)
         {
            if(this._verticalScrollBarPosition == "left")
            {
               this.verticalScrollBar.x = this._paddingLeft;
            }
            else
            {
               this.verticalScrollBar.x = this._leftViewPortOffset + this._viewPort.visibleWidth;
            }
            this.verticalScrollBar.y = this._topViewPortOffset;
            if(this._scrollBarDisplayMode != "fixed")
            {
               this.verticalScrollBar.x = this.verticalScrollBar.x - this.verticalScrollBar.width;
               if((this._hasHorizontalScrollBar || this._horizontalScrollBarHideTween) && this.horizontalScrollBar)
               {
                  this.verticalScrollBar.height = this._viewPort.visibleHeight - this.horizontalScrollBar.height;
               }
               else
               {
                  this.verticalScrollBar.height = this._viewPort.visibleHeight;
               }
            }
            else
            {
               this.verticalScrollBar.height = this._viewPort.visibleHeight;
            }
         }
      }
      
      protected function refreshClipRect() : void
      {
         var _loc3_:* = null;
         var _loc5_:* = NaN;
         var _loc2_:* = NaN;
         var _loc4_:Boolean = this._hasElasticEdges && (this._interactionMode == "touch" || this._interactionMode == "touchAndScrollBars");
         var _loc1_:Boolean = this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition || this._maxVerticalScrollPosition != this._minVerticalScrollPosition;
         if(this._clipContent && (_loc4_ || _loc1_))
         {
            if(!this._viewPort.clipRect)
            {
               this._viewPort.clipRect = new Rectangle();
            }
            _loc3_ = this._viewPort.clipRect;
            _loc3_.x = this._horizontalScrollPosition;
            _loc3_.y = this._verticalScrollPosition;
            _loc5_ = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
            if(_loc5_ < 0)
            {
               _loc5_ = 0.0;
            }
            _loc3_.width = _loc5_;
            _loc2_ = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
            if(_loc2_ < 0)
            {
               _loc2_ = 0.0;
            }
            _loc3_.height = _loc2_;
            this._viewPort.clipRect = _loc3_;
         }
         else
         {
            this._viewPort.clipRect = null;
         }
      }
      
      protected function get numRawChildrenInternal() : int
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).numRawChildren;
         }
         return this.numChildren;
      }
      
      protected function addRawChildInternal(param1:DisplayObject) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChild(param1);
         }
         return this.addChild(param1);
      }
      
      protected function addRawChildAtInternal(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChildAt(param1,param2);
         }
         return this.addChildAt(param1,param2);
      }
      
      protected function removeRawChildInternal(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChild(param1,param2);
         }
         return this.removeChild(param1,param2);
      }
      
      protected function removeRawChildAtInternal(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChildAt(param1,param2);
         }
         return this.removeChildAt(param1,param2);
      }
      
      protected function setRawChildIndexInternal(param1:DisplayObject, param2:int) : void
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).setRawChildIndex(param1,param2);
         }
         return this.setChildIndex(param1,param2);
      }
      
      protected function updateHorizontalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc3_:Number = this._startTouchX - param1;
         var _loc2_:Number = this._startHorizontalScrollPosition + _loc3_;
         if(_loc2_ < this._minHorizontalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc2_ = _loc2_ - (_loc2_ - this._minHorizontalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc2_ = this._minHorizontalScrollPosition;
            }
         }
         else if(_loc2_ > this._maxHorizontalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc2_ = _loc2_ - (_loc2_ - this._maxHorizontalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc2_ = this._maxHorizontalScrollPosition;
            }
         }
         this.horizontalScrollPosition = _loc2_;
      }
      
      protected function updateVerticalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc3_:Number = this._startTouchY - param1;
         var _loc2_:Number = this._startVerticalScrollPosition + _loc3_;
         if(_loc2_ < this._minVerticalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc2_ = _loc2_ - (_loc2_ - this._minVerticalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc2_ = this._minVerticalScrollPosition;
            }
         }
         else if(_loc2_ > this._maxVerticalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc2_ = _loc2_ - (_loc2_ - this._maxVerticalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc2_ = this._maxVerticalScrollPosition;
            }
         }
         this.verticalScrollPosition = _loc2_;
      }
      
      protected function throwTo(param1:Number = NaN, param2:Number = NaN, param3:Number = 0.5) : void
      {
         if(!isNaN(param1))
         {
            if(this._horizontalAutoScrollTween)
            {
               Starling.juggler.remove(this._horizontalAutoScrollTween);
               this._horizontalAutoScrollTween = null;
            }
            if(this._horizontalScrollPosition != param1)
            {
               this.revealHorizontalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.horizontalScrollPosition = param1;
               }
               else
               {
                  this._targetHorizontalScrollPosition = param1;
                  this._horizontalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._horizontalAutoScrollTween.animate("horizontalScrollPosition",param1);
                  this._horizontalAutoScrollTween.onComplete = horizontalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._horizontalAutoScrollTween);
               }
            }
            else
            {
               this.finishScrollingHorizontally();
            }
         }
         if(!isNaN(param2))
         {
            if(this._verticalAutoScrollTween)
            {
               Starling.juggler.remove(this._verticalAutoScrollTween);
               this._verticalAutoScrollTween = null;
            }
            if(this._verticalScrollPosition != param2)
            {
               this.revealVerticalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.verticalScrollPosition = param2;
               }
               else
               {
                  this._targetVerticalScrollPosition = param2;
                  this._verticalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._verticalAutoScrollTween.animate("verticalScrollPosition",param2);
                  this._verticalAutoScrollTween.onComplete = verticalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._verticalAutoScrollTween);
               }
            }
            else
            {
               this.finishScrollingVertically();
            }
         }
         if(param3 == 0)
         {
            this.completeScroll();
         }
      }
      
      protected function throwToPage(param1:int = -1, param2:int = -1, param3:Number = 0.5) : void
      {
         var _loc5_:Number = this._horizontalScrollPosition;
         if(param1 >= 0)
         {
            _loc5_ = this.actualPageWidth * param1;
         }
         if(_loc5_ < this._minHorizontalScrollPosition)
         {
            _loc5_ = this._minHorizontalScrollPosition;
         }
         if(_loc5_ > this._maxHorizontalScrollPosition)
         {
            _loc5_ = this._maxHorizontalScrollPosition;
         }
         var _loc4_:Number = this._verticalScrollPosition;
         if(param2 >= 0)
         {
            _loc4_ = this.actualPageHeight * param2;
         }
         if(_loc4_ < this._minVerticalScrollPosition)
         {
            _loc4_ = this._minVerticalScrollPosition;
         }
         if(_loc4_ > this._maxVerticalScrollPosition)
         {
            _loc4_ = this._maxVerticalScrollPosition;
         }
         if(param3 > 0)
         {
            this.throwTo(_loc5_,_loc4_,param3);
         }
         else
         {
            this.horizontalScrollPosition = _loc5_;
            this.verticalScrollPosition = _loc4_;
         }
         if(param1 >= 0)
         {
            this._horizontalPageIndex = param1;
         }
         if(param2 >= 0)
         {
            this._verticalPageIndex = param2;
         }
      }
      
      protected function finishScrollingHorizontally() : void
      {
         var _loc1_:* = NaN;
         if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            _loc1_ = this._minHorizontalScrollPosition;
         }
         else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            _loc1_ = this._maxHorizontalScrollPosition;
         }
         this._isDraggingHorizontally = false;
         if(isNaN(_loc1_))
         {
            this.completeScroll();
         }
         else
         {
            this.throwTo(_loc1_,NaN,this._elasticSnapDuration);
         }
      }
      
      protected function finishScrollingVertically() : void
      {
         var _loc1_:* = NaN;
         if(this._verticalScrollPosition < this._minVerticalScrollPosition)
         {
            _loc1_ = this._minVerticalScrollPosition;
         }
         else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
         {
            _loc1_ = this._maxVerticalScrollPosition;
         }
         this._isDraggingVertically = false;
         if(isNaN(_loc1_))
         {
            this.completeScroll();
         }
         else
         {
            this.throwTo(NaN,_loc1_,this._elasticSnapDuration);
         }
      }
      
      protected function throwHorizontally(param1:Number) : void
      {
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc6_:* = NaN;
         var _loc9_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:* = 0;
         var _loc3_:* = NaN;
         if(this._snapToPages)
         {
            _loc7_ = 1000 * param1 / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
            if(_loc7_ > this._minimumPageThrowVelocity)
            {
               _loc8_ = roundDownToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else if(_loc7_ < -this._minimumPageThrowVelocity)
            {
               _loc8_ = roundUpToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else
            {
               _loc6_ = this._maxHorizontalScrollPosition % this.actualPageWidth;
               _loc9_ = this._maxHorizontalScrollPosition - _loc6_;
               if(_loc6_ < this.actualPageWidth && this._horizontalScrollPosition >= _loc9_)
               {
                  _loc4_ = this._horizontalScrollPosition - _loc9_;
                  if(_loc7_ > this._minimumPageThrowVelocity)
                  {
                     _loc8_ = _loc9_ + roundDownToNearest(_loc4_,_loc6_);
                  }
                  else if(_loc7_ < -this._minimumPageThrowVelocity)
                  {
                     _loc8_ = _loc9_ + roundUpToNearest(_loc4_,_loc6_);
                  }
                  else
                  {
                     _loc8_ = _loc9_ + roundToNearest(_loc4_,_loc6_);
                  }
               }
               else
               {
                  _loc8_ = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
               }
            }
            if(_loc8_ < this._minHorizontalScrollPosition)
            {
               _loc8_ = this._minHorizontalScrollPosition;
            }
            else if(_loc8_ > this._maxHorizontalScrollPosition)
            {
               _loc8_ = this._maxHorizontalScrollPosition;
            }
            if(_loc8_ == this._maxHorizontalScrollPosition)
            {
               _loc2_ = this._horizontalPageCount - 1;
            }
            else
            {
               _loc2_ = (_loc8_ - this._minHorizontalScrollPosition) / this.actualPageWidth;
            }
            this.throwToPage(_loc2_,-1,this._pageThrowDuration);
            return;
         }
         var _loc10_:Number = Math.abs(param1);
         if(_loc10_ <= 0.02)
         {
            this.finishScrollingHorizontally();
            return;
         }
         var _loc5_:Number = this._horizontalScrollPosition + (param1 - 0.02) / Math.log(0.998);
         if(_loc5_ < this._minHorizontalScrollPosition || _loc5_ > this._maxHorizontalScrollPosition)
         {
            _loc3_ = 0.0;
            _loc5_ = this._horizontalScrollPosition;
            while(Math.abs(param1) > 0.02)
            {
               _loc5_ = _loc5_ - param1;
               if(_loc5_ < this._minHorizontalScrollPosition || _loc5_ > this._maxHorizontalScrollPosition)
               {
                  if(this._hasElasticEdges)
                  {
                     var param1:Number = param1 * 0.998 * 0.95;
                  }
                  else
                  {
                     if(_loc5_ < this._minHorizontalScrollPosition)
                     {
                        _loc5_ = this._minHorizontalScrollPosition;
                     }
                     else if(_loc5_ > this._maxHorizontalScrollPosition)
                     {
                        _loc5_ = this._maxHorizontalScrollPosition;
                     }
                     _loc3_++;
                     break;
                  }
               }
               else
               {
                  param1 = param1 * 0.998;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = Math.log(0.02 / _loc10_) / Math.log(0.998);
         }
         this.throwTo(_loc5_,NaN,_loc3_ / 1000);
      }
      
      protected function throwVertically(param1:Number) : void
      {
         var _loc7_:* = NaN;
         var _loc10_:* = NaN;
         var _loc2_:* = NaN;
         var _loc8_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = 0;
         var _loc3_:* = NaN;
         if(this._snapToPages)
         {
            _loc7_ = 1000 * param1 / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
            if(_loc7_ > this._minimumPageThrowVelocity)
            {
               _loc10_ = roundDownToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else if(_loc7_ < -this._minimumPageThrowVelocity)
            {
               _loc10_ = roundUpToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else
            {
               _loc2_ = this._maxVerticalScrollPosition % this.actualPageHeight;
               _loc8_ = this._maxVerticalScrollPosition - _loc2_;
               if(_loc2_ < this.actualPageHeight && this._verticalScrollPosition >= _loc8_)
               {
                  _loc5_ = this._verticalScrollPosition - _loc8_;
                  if(_loc7_ > this._minimumPageThrowVelocity)
                  {
                     _loc10_ = _loc8_ + roundDownToNearest(_loc5_,_loc2_);
                  }
                  else if(_loc7_ < -this._minimumPageThrowVelocity)
                  {
                     _loc10_ = _loc8_ + roundUpToNearest(_loc5_,_loc2_);
                  }
                  else
                  {
                     _loc10_ = _loc8_ + roundToNearest(_loc5_,_loc2_);
                  }
               }
               else
               {
                  _loc10_ = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
               }
            }
            if(_loc10_ < this._minVerticalScrollPosition)
            {
               _loc10_ = this._minVerticalScrollPosition;
            }
            else if(_loc10_ > this._maxVerticalScrollPosition)
            {
               _loc10_ = this._maxVerticalScrollPosition;
            }
            if(_loc10_ == this._maxVerticalScrollPosition)
            {
               _loc6_ = this._verticalPageCount - 1;
            }
            else
            {
               _loc6_ = (_loc10_ - this._minVerticalScrollPosition) / this.actualPageHeight;
            }
            this.throwToPage(-1,_loc6_,this._pageThrowDuration);
            return;
         }
         var _loc9_:Number = Math.abs(param1);
         if(_loc9_ <= 0.02)
         {
            this.finishScrollingVertically();
            return;
         }
         var _loc4_:Number = this._verticalScrollPosition + (param1 - 0.02) / Math.log(0.998);
         if(_loc4_ < this._minVerticalScrollPosition || _loc4_ > this._maxVerticalScrollPosition)
         {
            _loc3_ = 0.0;
            _loc4_ = this._verticalScrollPosition;
            while(Math.abs(param1) > 0.02)
            {
               _loc4_ = _loc4_ - param1;
               if(_loc4_ < this._minVerticalScrollPosition || _loc4_ > this._maxVerticalScrollPosition)
               {
                  if(this._hasElasticEdges)
                  {
                     var param1:Number = param1 * 0.998 * 0.95;
                  }
                  else
                  {
                     if(_loc4_ < this._minVerticalScrollPosition)
                     {
                        _loc4_ = this._minVerticalScrollPosition;
                     }
                     else if(_loc4_ > this._maxVerticalScrollPosition)
                     {
                        _loc4_ = this._maxVerticalScrollPosition;
                     }
                     _loc3_++;
                     break;
                  }
               }
               else
               {
                  param1 = param1 * 0.998;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = Math.log(0.02 / _loc9_) / Math.log(0.998);
         }
         this.throwTo(NaN,_loc4_,_loc3_ / 1000);
      }
      
      protected function hideHorizontalScrollBar(param1:Number = 0) : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != "float" || this._horizontalScrollBarHideTween)
         {
            return;
         }
         if(this.horizontalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.horizontalScrollBar.alpha = 0;
         }
         else
         {
            this._horizontalScrollBarHideTween = new Tween(this.horizontalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._horizontalScrollBarHideTween.fadeTo(0);
            this._horizontalScrollBarHideTween.delay = param1;
            this._horizontalScrollBarHideTween.onComplete = horizontalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._horizontalScrollBarHideTween);
         }
      }
      
      protected function hideVerticalScrollBar(param1:Number = 0) : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != "float" || this._verticalScrollBarHideTween)
         {
            return;
         }
         if(this.verticalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.verticalScrollBar.alpha = 0;
         }
         else
         {
            this._verticalScrollBarHideTween = new Tween(this.verticalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._verticalScrollBarHideTween.fadeTo(0);
            this._verticalScrollBarHideTween.delay = param1;
            this._verticalScrollBarHideTween.onComplete = verticalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._verticalScrollBarHideTween);
         }
      }
      
      protected function revealHorizontalScrollBar() : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != "float")
         {
            return;
         }
         if(this._horizontalScrollBarHideTween)
         {
            Starling.juggler.remove(this._horizontalScrollBarHideTween);
            this._horizontalScrollBarHideTween = null;
         }
         this.horizontalScrollBar.alpha = 1;
      }
      
      protected function revealVerticalScrollBar() : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != "float")
         {
            return;
         }
         if(this._verticalScrollBarHideTween)
         {
            Starling.juggler.remove(this._verticalScrollBarHideTween);
            this._verticalScrollBarHideTween = null;
         }
         this.verticalScrollBar.alpha = 1;
      }
      
      protected function startScroll() : void
      {
         if(this._isScrolling)
         {
            return;
         }
         this._isScrolling = true;
         if(this._touchBlocker)
         {
            this._touchBlocker.visible = true;
         }
         this.dispatchEventWith("scrollStart");
      }
      
      protected function completeScroll() : void
      {
         if(!this._isScrolling || this._verticalAutoScrollTween || this._horizontalAutoScrollTween || this._isDraggingHorizontally || this._isDraggingVertically || this._horizontalScrollBarIsScrolling || this._verticalScrollBarIsScrolling)
         {
            return;
         }
         this._isScrolling = false;
         if(this._touchBlocker)
         {
            this._touchBlocker.visible = false;
         }
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
         this.validate();
         this.dispatchEventWith("scrollComplete");
      }
      
      protected function handlePendingScroll() : void
      {
         if(!isNaN(this.pendingHorizontalScrollPosition) || !isNaN(this.pendingVerticalScrollPosition))
         {
            this.throwTo(this.pendingHorizontalScrollPosition,this.pendingVerticalScrollPosition,this.pendingScrollDuration);
            this.pendingHorizontalScrollPosition = NaN;
            this.pendingVerticalScrollPosition = NaN;
         }
         if(this.pendingHorizontalPageIndex >= 0 || this.pendingVerticalPageIndex >= 0)
         {
            this.throwToPage(this.pendingHorizontalPageIndex,this.pendingVerticalPageIndex,this.pendingScrollDuration);
            this.pendingHorizontalPageIndex = -1;
            this.pendingVerticalPageIndex = -1;
         }
      }
      
      protected function handlePendingRevealScrollBars() : void
      {
         if(!this.isScrollBarRevealPending || this._scrollBarDisplayMode != "float")
         {
            return;
         }
         this.revealHorizontalScrollBar();
         this.revealVerticalScrollBar();
         this.hideHorizontalScrollBar(this._revealScrollBarsDuration);
         this.hideVerticalScrollBar(this._revealScrollBarsDuration);
      }
      
      protected function viewPort_resizeHandler(param1:starling.events.Event) : void
      {
         if(this.ignoreViewPortResizing || this._viewPort.width == this._lastViewPortWidth && this._viewPort.height == this._lastViewPortHeight)
         {
            return;
         }
         this._lastViewPortWidth = this._viewPort.width;
         this._lastViewPortHeight = this._viewPort.height;
         if(this._isValidating)
         {
            this._hasViewPortBoundsChanged = true;
         }
         else
         {
            this.invalidate("size");
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function verticalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.verticalScrollPosition = this.verticalScrollBar.value;
      }
      
      protected function horizontalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.horizontalScrollPosition = this.horizontalScrollBar.value;
      }
      
      protected function horizontalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         this._horizontalScrollBarIsScrolling = true;
         this.dispatchEventWith("beginInteraction");
         this.startScroll();
      }
      
      protected function horizontalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._horizontalScrollBarIsScrolling = false;
         this.dispatchEventWith("endInteraction");
         this.completeScroll();
      }
      
      protected function verticalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         this._verticalScrollBarIsScrolling = true;
         this.dispatchEventWith("beginInteraction");
         this.startScroll();
      }
      
      protected function verticalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._verticalScrollBarIsScrolling = false;
         this.dispatchEventWith("endInteraction");
         this.completeScroll();
      }
      
      protected function horizontalAutoScrollTween_onComplete() : void
      {
         this._horizontalAutoScrollTween = null;
         this.finishScrollingHorizontally();
      }
      
      protected function verticalAutoScrollTween_onComplete() : void
      {
         this._verticalAutoScrollTween = null;
         this.finishScrollingVertically();
      }
      
      protected function horizontalScrollBarHideTween_onComplete() : void
      {
         this._horizontalScrollBarHideTween = null;
      }
      
      protected function verticalScrollBarHideTween_onComplete() : void
      {
         this._verticalScrollBarHideTween = null;
      }
      
      protected function scroller_touchHandler(param1:TouchEvent) : void
      {
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this,"began");
         if(!_loc2_)
         {
            return;
         }
         if(this._interactionMode == "touchAndScrollBars" && (param1.interactsWith(DisplayObject(this.horizontalScrollBar)) || param1.interactsWith(DisplayObject(this.verticalScrollBar))))
         {
            return;
         }
         _loc2_.getLocation(this,HELPER_POINT);
         var _loc4_:Number = HELPER_POINT.x;
         var _loc3_:Number = HELPER_POINT.y;
         if(_loc4_ < this._leftViewPortOffset || _loc3_ < this._topViewPortOffset || _loc4_ >= this.actualWidth - this._rightViewPortOffset || _loc3_ >= this.actualHeight - this._bottomViewPortOffset)
         {
            return;
         }
         var _loc5_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc5_.getClaim(_loc2_.id))
         {
            return;
         }
         if(this._horizontalAutoScrollTween && this._horizontalScrollPolicy != "off")
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
            if(this._isScrolling)
            {
               this._isDraggingHorizontally = true;
            }
         }
         if(this._verticalAutoScrollTween && this._verticalScrollPolicy != "off")
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
            if(this._isScrolling)
            {
               this._isDraggingVertically = true;
            }
         }
         this._touchPointID = _loc2_.id;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._previousTouchTime = getTimer();
         var _loc6_:* = _loc4_;
         this._currentTouchX = _loc6_;
         _loc6_ = _loc6_;
         this._startTouchX = _loc6_;
         this._previousTouchX = _loc6_;
         _loc6_ = _loc3_;
         this._currentTouchY = _loc6_;
         _loc6_ = _loc6_;
         this._startTouchY = _loc6_;
         this._previousTouchY = _loc6_;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
         this._isScrollingStopped = false;
         this.addEventListener("enterFrame",enterFrameHandler);
         this.stage.addEventListener("touch",stage_touchHandler);
         if(this._isScrolling && (this._isDraggingHorizontally || this._isDraggingVertically))
         {
            _loc5_.claimTouch(this._touchPointID,this);
         }
         else
         {
            _loc5_.addEventListener("change",exclusiveTouch_changeHandler);
         }
      }
      
      protected function enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc5_:* = null;
         if(this._isScrollingStopped)
         {
            return;
         }
         var _loc3_:int = getTimer();
         var _loc4_:int = _loc3_ - this._previousTouchTime;
         if(_loc4_ > 0)
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
            this._velocityX = (this._currentTouchX - this._previousTouchX) / _loc4_;
            this._velocityY = (this._currentTouchY - this._previousTouchY) / _loc4_;
            this._previousTouchTime = _loc3_;
            this._previousTouchX = this._currentTouchX;
            this._previousTouchY = this._currentTouchY;
         }
         var _loc6_:Number = Math.abs(this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc2_:Number = Math.abs(this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if((this._horizontalScrollPolicy == "on" || this._horizontalScrollPolicy == "auto" && this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition) && !this._isDraggingHorizontally && _loc6_ >= this._minimumDragDistance)
         {
            if(this.horizontalScrollBar)
            {
               this.revealHorizontalScrollBar();
            }
            this._startTouchX = this._currentTouchX;
            this._startHorizontalScrollPosition = this._horizontalScrollPosition;
            this._isDraggingHorizontally = true;
            if(!this._isDraggingVertically)
            {
               this.dispatchEventWith("beginInteraction");
               _loc5_ = ExclusiveTouch.forStage(this.stage);
               _loc5_.removeEventListener("change",exclusiveTouch_changeHandler);
               _loc5_.claimTouch(this._touchPointID,this);
               this.startScroll();
            }
         }
         if((this._verticalScrollPolicy == "on" || this._verticalScrollPolicy == "auto" && this._minVerticalScrollPosition != this._maxVerticalScrollPosition) && !this._isDraggingVertically && _loc2_ >= this._minimumDragDistance)
         {
            if(this.verticalScrollBar)
            {
               this.revealVerticalScrollBar();
            }
            this._startTouchY = this._currentTouchY;
            this._startVerticalScrollPosition = this._verticalScrollPosition;
            this._isDraggingVertically = true;
            if(!this._isDraggingHorizontally)
            {
               _loc5_ = ExclusiveTouch.forStage(this.stage);
               _loc5_.removeEventListener("change",exclusiveTouch_changeHandler);
               _loc5_.claimTouch(this._touchPointID,this);
               this.dispatchEventWith("beginInteraction");
               this.startScroll();
            }
         }
         if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
         {
            this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
         }
         if(this._isDraggingVertically && !this._verticalAutoScrollTween)
         {
            this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
         }
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc7_:* = false;
         var _loc8_:* = false;
         var _loc6_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:* = NaN;
         var _loc9_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:Touch = param1.getTouch(this.stage,null,this._touchPointID);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.phase == "moved")
         {
            _loc3_.getLocation(this,HELPER_POINT);
            this._currentTouchX = HELPER_POINT.x;
            this._currentTouchY = HELPER_POINT.y;
         }
         else if(_loc3_.phase == "ended")
         {
            if(!this._isDraggingHorizontally && !this._isDraggingVertically)
            {
               ExclusiveTouch.forStage(this.stage).removeEventListener("change",exclusiveTouch_changeHandler);
            }
            this.removeEventListener("enterFrame",enterFrameHandler);
            this.stage.removeEventListener("touch",stage_touchHandler);
            this._touchPointID = -1;
            this.dispatchEventWith("endInteraction");
            _loc7_ = false;
            _loc8_ = false;
            if(this._horizontalScrollPosition < this._minHorizontalScrollPosition || this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
            {
               _loc7_ = true;
               this.finishScrollingHorizontally();
            }
            if(this._verticalScrollPosition < this._minVerticalScrollPosition || this._verticalScrollPosition > this._maxVerticalScrollPosition)
            {
               _loc8_ = true;
               this.finishScrollingVertically();
            }
            if(_loc7_ && _loc8_)
            {
               return;
            }
            if(!_loc7_ && this._isDraggingHorizontally)
            {
               _loc6_ = this._velocityX * 2.33;
               _loc4_ = this._previousVelocityX.length;
               _loc5_ = 2.33;
               _loc9_ = 0;
               while(_loc9_ < _loc4_)
               {
                  _loc2_ = VELOCITY_WEIGHTS[_loc9_];
                  _loc6_ = _loc6_ + this._previousVelocityX.shift() * _loc2_;
                  _loc5_ = _loc5_ + _loc2_;
                  _loc9_++;
               }
               this.throwHorizontally(_loc6_ / _loc5_);
            }
            else
            {
               this.hideHorizontalScrollBar();
            }
            if(!_loc8_ && this._isDraggingVertically)
            {
               _loc6_ = this._velocityY * 2.33;
               _loc4_ = this._previousVelocityY.length;
               _loc5_ = 2.33;
               _loc9_ = 0;
               while(_loc9_ < _loc4_)
               {
                  _loc2_ = VELOCITY_WEIGHTS[_loc9_];
                  _loc6_ = _loc6_ + this._previousVelocityY.shift() * _loc2_;
                  _loc5_ = _loc5_ + _loc2_;
                  _loc9_++;
               }
               this.throwVertically(_loc6_ / _loc5_);
            }
            else
            {
               this.hideVerticalScrollBar();
            }
         }
      }
      
      protected function exclusiveTouch_changeHandler(param1:starling.events.Event, param2:int) : void
      {
         if(this._touchPointID < 0 || this._touchPointID != param2 || this._isDraggingHorizontally || this._isDraggingVertically)
         {
            return;
         }
         var _loc3_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param2) == this)
         {
            return;
         }
         this._touchPointID = -1;
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.stage.removeEventListener("touch",stage_touchHandler);
         _loc3_.removeEventListener("change",exclusiveTouch_changeHandler);
         this.dispatchEventWith("endInteraction");
      }
      
      protected function nativeStage_mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc8_:* = NaN;
         var _loc3_:* = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._maxVerticalScrollPosition == 0 || this._verticalScrollPolicy == "off")
         {
            return;
         }
         var _loc4_:* = 1.0;
         if(Starling.current.supportHighResolutions)
         {
            _loc4_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc2_:Rectangle = Starling.current.viewPort;
         var _loc7_:Number = _loc4_ / Starling.contentScaleFactor;
         HELPER_POINT.x = (param1.stageX - _loc2_.x) / _loc7_;
         HELPER_POINT.y = (param1.stageY - _loc2_.y) / _loc7_;
         if(this.contains(this.stage.hitTest(HELPER_POINT,true)))
         {
            this.globalToLocal(HELPER_POINT,HELPER_POINT);
            _loc5_ = HELPER_POINT.x;
            _loc6_ = HELPER_POINT.y;
            if(_loc5_ < this._leftViewPortOffset || _loc6_ < this._topViewPortOffset || _loc5_ >= this.actualWidth - this._rightViewPortOffset || _loc6_ >= this.actualHeight - this._bottomViewPortOffset)
            {
               return;
            }
            this.revealVerticalScrollBar();
            _loc8_ = this._verticalMouseWheelScrollStep;
            if(isNaN(_loc8_))
            {
               _loc8_ = this.actualVerticalScrollStep;
            }
            _loc3_ = this._verticalScrollPosition - param1.delta * _loc8_;
            if(_loc3_ < this._minVerticalScrollPosition)
            {
               _loc3_ = this._minVerticalScrollPosition;
            }
            else if(_loc3_ > this._maxVerticalScrollPosition)
            {
               _loc3_ = this._maxVerticalScrollPosition;
            }
            this.throwTo(NaN,_loc3_,this._mouseWheelScrollDuration);
         }
      }
      
      protected function nativeStage_orientationChangeHandler(param1:flash.events.Event) : void
      {
         if(this._touchPointID < 0)
         {
            return;
         }
         var _loc2_:* = this._currentTouchX;
         this._previousTouchX = _loc2_;
         this._startTouchX = _loc2_;
         _loc2_ = this._currentTouchY;
         this._previousTouchY = _loc2_;
         this._startTouchY = _loc2_;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
      }
      
      protected function horizontalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = false;
         if(!this._isEnabled)
         {
            this._horizontalScrollBarTouchPointID = -1;
            return;
         }
         var _loc4_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._horizontalScrollBarTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(_loc4_,"ended",this._horizontalScrollBarTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._horizontalScrollBarTouchPointID = -1;
            _loc2_.getLocation(_loc4_,HELPER_POINT);
            _loc3_ = this.horizontalScrollBar.hitTest(HELPER_POINT,true) != null;
            if(!_loc3_)
            {
               this.hideHorizontalScrollBar();
            }
         }
         else
         {
            _loc2_ = param1.getTouch(_loc4_,"began");
            if(_loc2_)
            {
               this._horizontalScrollBarTouchPointID = _loc2_.id;
               return;
            }
            _loc2_ = param1.getTouch(_loc4_,"hover");
            if(_loc2_)
            {
               this.revealHorizontalScrollBar();
               return;
            }
            this.hideHorizontalScrollBar();
         }
      }
      
      protected function verticalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = false;
         if(!this._isEnabled)
         {
            this._verticalScrollBarTouchPointID = -1;
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._verticalScrollBarTouchPointID >= 0)
         {
            _loc3_ = param1.getTouch(_loc2_,"ended",this._verticalScrollBarTouchPointID);
            if(!_loc3_)
            {
               return;
            }
            this._verticalScrollBarTouchPointID = -1;
            _loc3_.getLocation(_loc2_,HELPER_POINT);
            _loc4_ = this.verticalScrollBar.hitTest(HELPER_POINT,true) != null;
            if(!_loc4_)
            {
               this.hideVerticalScrollBar();
            }
         }
         else
         {
            _loc3_ = param1.getTouch(_loc2_,"began");
            if(_loc3_)
            {
               this._verticalScrollBarTouchPointID = _loc3_.id;
               return;
            }
            _loc3_ = param1.getTouch(_loc2_,"hover");
            if(_loc3_)
            {
               this.revealVerticalScrollBar();
               return;
            }
            this.hideVerticalScrollBar();
         }
      }
      
      protected function scroller_addedToStageHandler(param1:starling.events.Event) : void
      {
         Starling.current.nativeStage.addEventListener("mouseWheel",nativeStage_mouseWheelHandler,false,0,true);
         Starling.current.nativeStage.addEventListener("orientationChange",nativeStage_orientationChangeHandler,false,0,true);
      }
      
      protected function scroller_removedFromStageHandler(param1:starling.events.Event) : void
      {
         var _loc4_:* = null;
         Starling.current.nativeStage.removeEventListener("mouseWheel",nativeStage_mouseWheelHandler);
         Starling.current.nativeStage.removeEventListener("orientationChange",nativeStage_orientationChangeHandler);
         if(this._touchPointID >= 0)
         {
            _loc4_ = ExclusiveTouch.forStage(this.stage);
            _loc4_.removeEventListener("change",exclusiveTouch_changeHandler);
         }
         this._touchPointID = -1;
         this._horizontalScrollBarTouchPointID = -1;
         this._verticalScrollBarTouchPointID = -1;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._horizontalScrollBarIsScrolling = false;
         this._verticalScrollBarIsScrolling = false;
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.stage.removeEventListener("touch",stage_touchHandler);
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         var _loc3_:Number = this._horizontalScrollPosition;
         var _loc2_:Number = this._verticalScrollPosition;
         if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._minHorizontalScrollPosition;
         }
         else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
         }
         if(this._verticalScrollPosition < this._minVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._minVerticalScrollPosition;
         }
         else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._maxVerticalScrollPosition;
         }
         if(_loc3_ != this._horizontalScrollPosition || _loc2_ != this._verticalScrollPosition)
         {
            this.dispatchEventWith("scroll");
         }
      }
   }
}
