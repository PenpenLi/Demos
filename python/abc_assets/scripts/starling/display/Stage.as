package starling.display
{
   import starling.events.EnterFrameEvent;
   import flash.geom.Point;
   import flash.display.BitmapData;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import flash.errors.IllegalOperationError;
   import starling.filters.FragmentFilter;
   
   public class Stage extends DisplayObjectContainer
   {
       
      private var mWidth:int;
      
      private var mHeight:int;
      
      private var mColor:uint;
      
      private var mEnterFrameEvent:EnterFrameEvent;
      
      private var mEnterFrameListeners:Vector.<starling.display.DisplayObject>;
      
      public function Stage(param1:int, param2:int, param3:uint = 0)
      {
         super();
         mWidth = param1;
         mHeight = param2;
         mColor = param3;
         mEnterFrameEvent = new EnterFrameEvent("enterFrame",0);
         mEnterFrameListeners = new Vector.<starling.display.DisplayObject>(0);
      }
      
      public function advanceTime(param1:Number) : void
      {
         mEnterFrameEvent.reset("enterFrame",false,param1);
         broadcastEvent(mEnterFrameEvent);
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : starling.display.DisplayObject
      {
         if(param2 && (!visible || !touchable))
         {
            return null;
         }
         if(param1.x < 0 || param1.x > mWidth || param1.y < 0 || param1.y > mHeight)
         {
            return null;
         }
         var _loc3_:starling.display.DisplayObject = super.hitTest(param1,param2);
         if(_loc3_ == null)
         {
            _loc3_ = this;
         }
         return _loc3_;
      }
      
      public function drawToBitmapData(param1:BitmapData = null, param2:Boolean = true) : BitmapData
      {
         var _loc3_:RenderSupport = new RenderSupport();
         var _loc4_:Starling = Starling.current;
         if(param1 == null)
         {
            var param1:BitmapData = new BitmapData(_loc4_.backBufferWidth,_loc4_.backBufferHeight,param2);
         }
         _loc3_.renderTarget = null;
         _loc3_.setOrthographicProjection(0,0,mWidth,mHeight);
         if(param2)
         {
            _loc3_.clear();
         }
         else
         {
            _loc3_.clear(mColor,1);
         }
         render(_loc3_,1);
         _loc3_.finishQuadBatch();
         Starling.current.context.drawToBitmapData(param1);
         Starling.current.context.present();
         return param1;
      }
      
      function addEnterFrameListener(param1:starling.display.DisplayObject) : void
      {
         mEnterFrameListeners.push(param1);
      }
      
      function removeEnterFrameListener(param1:starling.display.DisplayObject) : void
      {
         var _loc2_:int = mEnterFrameListeners.indexOf(param1);
         if(_loc2_ >= 0)
         {
            mEnterFrameListeners.splice(_loc2_,1);
         }
      }
      
      override function getChildEventListeners(param1:starling.display.DisplayObject, param2:String, param3:Vector.<starling.display.DisplayObject>) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         if(param2 == "enterFrame" && param1 == this)
         {
            _loc5_ = 0;
            _loc4_ = mEnterFrameListeners.length;
            while(_loc5_ < _loc4_)
            {
               param3[param3.length] = mEnterFrameListeners[_loc5_];
               _loc5_++;
            }
         }
         else
         {
            super.getChildEventListeners(param1,param2,param3);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot set width of stage");
      }
      
      override public function set height(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot set height of stage");
      }
      
      override public function set x(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot set x-coordinate of stage");
      }
      
      override public function set y(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot set y-coordinate of stage");
      }
      
      override public function set scaleX(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot scale stage");
      }
      
      override public function set scaleY(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot scale stage");
      }
      
      override public function set rotation(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot rotate stage");
      }
      
      override public function set skewX(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot skew stage");
      }
      
      override public function set skewY(param1:Number) : void
      {
         throw new IllegalOperationError("Cannot skew stage");
      }
      
      override public function set filter(param1:FragmentFilter) : void
      {
         throw new IllegalOperationError("Cannot add filter to stage. Add it to \'root\' instead!");
      }
      
      public function get color() : uint
      {
         return mColor;
      }
      
      public function set color(param1:uint) : void
      {
         mColor = param1;
      }
      
      public function get stageWidth() : int
      {
         return mWidth;
      }
      
      public function set stageWidth(param1:int) : void
      {
         mWidth = param1;
      }
      
      public function get stageHeight() : int
      {
         return mHeight;
      }
      
      public function set stageHeight(param1:int) : void
      {
         mHeight = param1;
      }
   }
}
