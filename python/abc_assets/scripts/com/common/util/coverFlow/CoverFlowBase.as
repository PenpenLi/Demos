package com.common.util.coverFlow
{
   import starling.display.Sprite;
   import flash.geom.Point;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import flash.utils.getTimer;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.events.Event;
   import flash.geom.Rectangle;
   
   public class CoverFlowBase extends Sprite
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private static const DEFAULT_CENTER_MARGIN:Number = 60;
      
      private static const DEFAULT_HORIZONTAL_SPACING:Number = 100;
      
      private static const DEFAULT_HORIZONTAL_SPACING_OFFSET:Number = 0;
      
      private static const DEFAULT_BACK_ROW_DEPTH:Number = 150;
      
      private static const DEFAULT_BACK_ROW_ANGLE:Number = 45;
      
      private static const DEFAULT_VERTICAL_OFFSET:Number = 0;
      
      private static const DEFAULT_MINSCALE:Number = 0.5;
      
      private static const DIS:int = 50;
       
      private var _covers:Vector.<com.common.util.coverFlow.Cover>;
      
      private var _selectedIndex:int;
      
      private var screenWidth:Number;
      
      private var screenHeight:Number;
      
      private var _tweenDuration:int = 1200;
      
      private var _startTime:int;
      
      private var _elapsed:int;
      
      private var _coversLength:uint;
      
      private var _sortedCovers:Vector.<com.common.util.coverFlow.Cover>;
      
      private var _centerMargin:Number;
      
      private var _horizontalSpacing:Number;
      
      private var _horizontalSpacingOffset:Number;
      
      private var _backRowDepth:Number;
      
      private var _backRowAngle:Number;
      
      private var _verticalOffset:Number;
      
      private var _minScale:Number;
      
      private var _isMove:Boolean;
      
      private var _downTime:int;
      
      private const DISTIME:int = 150;
      
      private var _downPoint:Point;
      
      public function CoverFlowBase(param1:Number, param2:Number)
      {
         super();
         screenWidth = param1;
         screenHeight = param2;
         this.clipRect = new Rectangle(0,-screenHeight * 0.5,screenWidth,screenHeight);
         _centerMargin = 60;
         _horizontalSpacing = 100;
         _horizontalSpacingOffset = 0;
         _backRowDepth = 150;
         _backRowAngle = 45;
         _verticalOffset = 0;
         _minScale = 0.5;
      }
      
      private function swipeGestures(param1:String, param2:int) : void
      {
         if(param1 == "left")
         {
            this.selectedIndex = _selectedIndex + param2;
         }
         if(param1 == "right")
         {
            this.selectedIndex = _selectedIndex - param2;
         }
      }
      
      public function addCover(param1:Vector.<com.common.util.coverFlow.Cover>) : void
      {
         var _loc2_:* = 0;
         _covers = param1;
         _coversLength = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _coversLength)
         {
            param1[_loc2_].addEventListener("touch",covers_touchHandler);
            this.addChild(param1[_loc2_]);
            _loc2_++;
         }
         layout();
      }
      
      private function covers_touchHandler(param1:TouchEvent) : void
      {
         var _loc6_:* = 0;
         var _loc5_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc3_:Touch = param1.getTouch(this);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.phase == "began")
         {
            _downPoint = _loc3_.getLocation(this.stage);
            _downTime = getTimer();
            _isMove = false;
         }
         else if(_loc3_.phase == "moved")
         {
            _loc6_ = getTimer() - _downTime;
            if(150 > _loc6_)
            {
               return;
            }
            _isMove = true;
            moveCover(param1.currentTarget as com.common.util.coverFlow.Cover,_loc3_);
         }
         else if(_loc3_.phase == "ended")
         {
            _loc6_ = getTimer() - _downTime;
            if(150 > _loc6_)
            {
               _loc5_ = _loc3_.getLocation(this.stage);
               _loc2_ = _loc5_.x - _downPoint.x;
               if(Math.abs(_loc2_) > 50)
               {
                  _loc4_ = Math.abs(_loc2_) / 130 > 1?Math.abs(_loc2_) / 130:1.0;
                  LogUtil("划动步数" + _loc4_);
                  swipeGestures(_loc2_ > 0?"right":"left",_loc4_);
               }
               else if(this.selectedIndex != _covers.indexOf(param1.currentTarget as com.common.util.coverFlow.Cover))
               {
                  this.selectedIndex = _covers.indexOf(param1.currentTarget as com.common.util.coverFlow.Cover);
               }
               else
               {
                  Facade.getInstance().sendNotification("trial_touch_boss_cover",selectedIndex);
               }
            }
            else if(_isMove)
            {
               this.selectedIndex = _selectedIndex;
            }
         }
      }
      
      private function moveCover(param1:com.common.util.coverFlow.Cover, param2:Touch) : void
      {
         var _loc6_:* = null;
         var _loc3_:* = 0;
         var _loc8_:* = 0;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc9_:* = NaN;
         var _loc7_:* = 0;
         _sortedCovers = Vector.<com.common.util.coverFlow.Cover>([]);
         _sortedCovers = _covers.concat();
         _sortedCovers = _sortedCovers.sort(depthSort);
         _loc8_ = 0;
         while(_loc8_ < _coversLength)
         {
            _loc6_ = _sortedCovers[_loc8_];
            this.setChildIndex(_loc6_,this.numChildren - (_loc8_ + 1));
            _loc8_++;
         }
         _selectedIndex = _covers.indexOf(_sortedCovers[0]);
         _loc7_ = 0;
         while(_loc7_ < _coversLength)
         {
            _loc6_ = _covers[_loc7_];
            _loc6_.endX = _loc6_.endX + (param2.globalX - param2.previousGlobalX);
            if(_loc7_ == _selectedIndex)
            {
               _loc9_ = screenWidth / 2;
               _loc5_ = 1 - Math.abs(_loc9_ - _loc6_.endX) / 100;
               _loc3_ = 1;
               _loc6_.endScale = 0.95 + 0.050000000000000044 * _loc5_;
               LogUtil(_loc5_ + "中间: " + _loc6_.endScale);
            }
            else if(_loc7_ < _selectedIndex)
            {
               _loc3_ = _selectedIndex - _loc7_;
               _loc9_ = screenWidth / 2 - _centerMargin - _loc3_ * _horizontalSpacing - horizontalSpacingOffset / (_coversLength - 1) * _loc3_;
               _loc5_ = 1 - (_loc9_ - _loc6_.endX) / 100;
               _loc4_ = 1 - (1 - _minScale) / (_coversLength - 1) * _loc3_ - 0.05;
               _loc6_.endScale = _loc4_ + 0.05 * _loc5_;
            }
            else if(_loc7_ > _selectedIndex)
            {
               _loc3_ = _loc7_ - _selectedIndex;
               _loc9_ = screenWidth / 2 + _centerMargin + _loc3_ * _horizontalSpacing + horizontalSpacingOffset / (_coversLength - 1) * _loc3_;
               _loc5_ = 1 - (_loc6_.endX - _loc9_) / 100;
               _loc4_ = 1 - (1 - _minScale) / (_coversLength - 1) * _loc3_ - 0.05;
               _loc6_.endScale = _loc4_ + 0.05 * _loc5_;
            }
            _loc6_.updateTween(0,0);
            _loc7_++;
         }
      }
      
      private function layout() : void
      {
         var _loc1_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < _coversLength)
         {
            _loc1_ = _covers[_loc2_];
            if(_loc2_ == _selectedIndex)
            {
               _loc1_.x = screenWidth / 2;
               var _loc4_:* = 1;
               _loc1_.scaleY = _loc4_;
               _loc1_.scaleX = _loc4_;
               this.setChildIndex(_loc1_,this.numChildren - 1);
            }
            else if(_loc2_ < _selectedIndex)
            {
               _loc3_ = _selectedIndex - _loc2_;
               _loc1_.x = screenWidth / 2 - _centerMargin - _loc3_ * _horizontalSpacing - horizontalSpacingOffset / (_coversLength - 1) * _loc3_;
               _loc4_ = 1 - (1 - _minScale) / (_coversLength - 1) * _loc3_;
               _loc1_.scaleY = _loc4_;
               _loc1_.scaleX = _loc4_;
               this.setChildIndex(_loc1_,this.numChildren - (_loc3_ + 1));
            }
            else if(_loc2_ > _selectedIndex)
            {
               _loc3_ = _loc2_ - _selectedIndex;
               _loc1_.x = screenWidth / 2 + _centerMargin + _loc3_ * _horizontalSpacing + horizontalSpacingOffset / (_coversLength - 1) * _loc3_;
               _loc4_ = 1 - (1 - _minScale) / (_coversLength - 1) * _loc3_;
               _loc1_.scaleY = _loc4_;
               _loc1_.scaleX = _loc4_;
               this.setChildIndex(_loc1_,this.numChildren - (_loc3_ + 1));
            }
            _loc2_++;
         }
      }
      
      private function determineLayout(param1:uint) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < _coversLength)
         {
            _loc3_ = _covers[_loc4_];
            if(_loc4_ == param1)
            {
               _loc3_.endX = screenWidth / 2;
               _loc3_.endScale = 1;
            }
            else if(_loc4_ < param1)
            {
               _loc2_ = param1 - _loc4_;
               _loc3_.endX = screenWidth / 2 - _centerMargin - _loc2_ * _horizontalSpacing - horizontalSpacingOffset / (_coversLength - 1) * _loc2_;
               var _loc5_:* = 1 - (1 - _minScale) / (_coversLength - 1) * _loc2_;
               _loc3_.scaleY = _loc5_;
               _loc3_.endScale = _loc5_;
            }
            else if(_loc4_ > param1)
            {
               _loc2_ = _loc4_ - param1;
               _loc3_.endX = screenWidth / 2 + _centerMargin + _loc2_ * _horizontalSpacing + horizontalSpacingOffset / (_coversLength - 1) * _loc2_;
               _loc5_ = 1 - (1 - _minScale) / (_coversLength - 1) * _loc2_;
               _loc3_.scaleY = _loc5_;
               _loc3_.endScale = _loc5_;
            }
            _loc4_++;
         }
      }
      
      private function animate(param1:Event) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         _elapsed = getTimer() - _startTime;
         if(_elapsed > _tweenDuration)
         {
            removeEventListener("enterFrame",animate);
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _coversLength)
         {
            _loc2_ = _covers[_loc3_];
            _loc2_.updateTween(_elapsed,_tweenDuration);
            _loc3_++;
         }
         _sortedCovers = Vector.<com.common.util.coverFlow.Cover>([]);
         _sortedCovers = _covers.concat();
         _sortedCovers = _sortedCovers.sort(depthSort);
         _loc3_ = 0;
         while(_loc3_ < _coversLength)
         {
            _loc2_ = _sortedCovers[_loc3_];
            this.setChildIndex(_loc2_,this.numChildren - (_loc3_ + 1));
            _loc3_++;
         }
      }
      
      private function depthSort(param1:com.common.util.coverFlow.Cover, param2:com.common.util.coverFlow.Cover) : Number
      {
         var _loc3_:Number = Math.abs(param1.x - screenWidth / 2);
         var _loc4_:Number = Math.abs(param2.x - screenWidth / 2);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(_covers.length == 0)
         {
            _selectedIndex = param1;
            return;
         }
         LogUtil("索引" + param1);
         _selectedIndex = Math.max(0,Math.min(param1,_covers.length - 1));
         _startTime = getTimer();
         determineLayout(_selectedIndex);
         removeEventListener("enterFrame",animate);
         addEventListener("enterFrame",animate);
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      public function get centerMargin() : Number
      {
         return _centerMargin;
      }
      
      public function set horizontalSpacing(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:* = 100.0;
         }
         _horizontalSpacing = Math.max(0,param1);
      }
      
      public function get horizontalSpacing() : Number
      {
         return _horizontalSpacing;
      }
      
      public function get horizontalSpacingOffset() : Number
      {
         return _horizontalSpacingOffset;
      }
      
      public function set horizontalSpacingOffset(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:* = 0.0;
         }
         _horizontalSpacingOffset = Math.abs(param1);
      }
      
      public function set backRowDepth(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:Number = 150;
         }
         _backRowDepth = Math.max(0,param1);
      }
      
      public function get backRowDepth() : Number
      {
         return _backRowDepth;
      }
      
      public function set backRowAngle(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:* = 45.0;
         }
         _backRowAngle = Math.min(90,Math.abs(param1));
      }
      
      public function get backRowAngle() : Number
      {
         return _backRowAngle;
      }
      
      public function set verticalOffset(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:* = 0.0;
         }
         _verticalOffset = param1;
      }
      
      public function get verticalOffset() : Number
      {
         return _verticalOffset;
      }
      
      public function get minScale() : Number
      {
         return _minScale;
      }
      
      public function set minScale(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:* = 0.5;
         }
         _minScale = Math.max(0,Math.min(param1,1));
      }
   }
}
