package feathers.layout
{
   import starling.events.EventDispatcher;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import feathers.core.IFeathersControl;
   
   public class AnchorLayout extends EventDispatcher implements ILayout
   {
      
      protected static const CIRCULAR_REFERENCE_ERROR:String = "It is impossible to create this layout due to a circular reference in the AnchorLayoutData.";
      
      private static const HELPER_POINT:Point = new Point();
       
      protected var _helperVector1:Vector.<DisplayObject>;
      
      protected var _helperVector2:Vector.<DisplayObject>;
      
      public function AnchorLayout()
      {
         _helperVector1 = new Vector.<DisplayObject>(0);
         _helperVector2 = new Vector.<DisplayObject>(0);
         super();
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return false;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc10_:Number = param2?param2.x:0.0;
         var _loc15_:Number = param2?param2.y:0.0;
         var _loc5_:Number = param2?param2.minWidth:0.0;
         var _loc9_:Number = param2?param2.minHeight:0.0;
         var _loc11_:Number = param2?param2.maxWidth:Infinity;
         var _loc12_:Number = param2?param2.maxHeight:Infinity;
         var _loc7_:Number = param2?param2.explicitWidth:NaN;
         var _loc4_:Number = param2?param2.explicitHeight:NaN;
         var _loc13_:* = _loc7_;
         var _loc6_:* = _loc4_;
         var _loc8_:Boolean = isNaN(_loc7_);
         var _loc14_:Boolean = isNaN(_loc4_);
         if(_loc8_ || _loc14_)
         {
            this.validateItems(param1,true);
            this.measureViewPort(param1,_loc13_,_loc6_,HELPER_POINT);
            if(_loc8_)
            {
               _loc13_ = Math.min(_loc11_,Math.max(_loc5_,HELPER_POINT.x));
            }
            if(_loc14_)
            {
               _loc6_ = Math.min(_loc12_,Math.max(_loc9_,HELPER_POINT.y));
            }
         }
         else
         {
            this.validateItems(param1,false);
         }
         this.layoutWithBounds(param1,_loc10_,_loc15_,_loc13_,_loc6_);
         this.measureContent(param1,_loc13_,_loc6_,HELPER_POINT);
         if(!param3)
         {
            var param3:LayoutBoundsResult = new LayoutBoundsResult();
         }
         param3.contentWidth = HELPER_POINT.x;
         param3.contentHeight = HELPER_POINT.y;
         param3.viewPortWidth = _loc13_;
         param3.viewPortHeight = _loc6_;
         return param3;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         if(!param7)
         {
            var param7:Point = new Point();
         }
         param7.x = 0;
         param7.y = 0;
         return param7;
      }
      
      protected function measureViewPort(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point = null) : Point
      {
         var _loc7_:* = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         HELPER_POINT.x = 0;
         HELPER_POINT.y = 0;
         var _loc6_:* = param1;
         var _loc8_:Vector.<DisplayObject> = this._helperVector1;
         this.measureVector(param1,_loc8_,HELPER_POINT);
         var _loc5_:Number = _loc8_.length;
         while(_loc5_ > 0)
         {
            if(_loc8_ == this._helperVector1)
            {
               _loc6_ = this._helperVector1;
               _loc8_ = this._helperVector2;
            }
            else
            {
               _loc6_ = this._helperVector2;
               _loc8_ = this._helperVector1;
            }
            this.measureVector(_loc6_,_loc8_,HELPER_POINT);
            _loc7_ = _loc5_;
            _loc5_ = _loc8_.length;
            if(_loc7_ == _loc5_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError("It is impossible to create this layout due to a circular reference in the AnchorLayoutData.");
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         if(!param4)
         {
            var param4:Point = HELPER_POINT.clone();
         }
         return param4;
      }
      
      protected function measureVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Point = null) : Point
      {
         var _loc10_:* = 0;
         var _loc6_:* = null;
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = false;
         if(!param3)
         {
            var param3:Point = new Point();
         }
         param2.length = 0;
         var _loc8_:int = param1.length;
         var _loc4_:* = 0;
         _loc10_ = 0;
         for(; _loc10_ < _loc8_; _loc10_++)
         {
            _loc6_ = param1[_loc10_];
            if(_loc6_ is ILayoutDisplayObject)
            {
               _loc5_ = ILayoutDisplayObject(_loc6_);
               if(_loc5_.includeInLayout)
               {
                  _loc9_ = _loc5_.layoutData as AnchorLayoutData;
               }
               continue;
            }
            _loc7_ = !_loc9_ || this.isReadyForLayout(_loc9_,_loc10_,param1,param2);
            if(!_loc7_)
            {
               param2[_loc4_] = _loc6_;
               _loc4_++;
            }
            else
            {
               this.measureItem(_loc6_,param3);
            }
         }
         return param3;
      }
      
      protected function measureItem(param1:DisplayObject, param2:Point) : void
      {
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc5_:Number = param2.x;
         var _loc4_:Number = param2.y;
         var _loc7_:* = false;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc6_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc6_)
            {
               _loc5_ = Math.max(_loc5_,this.measureItemHorizontally(_loc3_,_loc6_));
               _loc4_ = Math.max(_loc4_,this.measureItemVertically(_loc3_,_loc6_));
               _loc7_ = true;
            }
         }
         if(!_loc7_)
         {
            _loc5_ = Math.max(_loc5_,param1.x + param1.width);
            _loc4_ = Math.max(_loc4_,param1.y + param1.height);
         }
         param2.x = _loc5_;
         param2.y = _loc4_;
      }
      
      protected function measureItemHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc4_:* = NaN;
         var _loc5_:Number = param1.width;
         if(param2 && param1 is IFeathersControl)
         {
            _loc4_ = param2.percentWidth;
            if(!isNaN(_loc4_))
            {
               _loc5_ = IFeathersControl(param1).minWidth;
            }
         }
         var _loc7_:DisplayObject = DisplayObject(param1);
         var _loc3_:Number = this.getLeftOffset(_loc7_);
         var _loc6_:Number = this.getRightOffset(_loc7_);
         return _loc5_ + _loc3_ + _loc6_;
      }
      
      protected function measureItemVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc3_:* = NaN;
         var _loc6_:Number = param1.height;
         if(param2 && param1 is IFeathersControl)
         {
            _loc3_ = param2.percentHeight;
            if(!isNaN(_loc3_))
            {
               _loc6_ = IFeathersControl(param1).minHeight;
            }
         }
         var _loc5_:DisplayObject = DisplayObject(param1);
         var _loc7_:Number = this.getTopOffset(_loc5_);
         var _loc4_:Number = this.getBottomOffset(_loc5_);
         return _loc6_ + _loc7_ + _loc4_;
      }
      
      protected function getTopOffset(param1:DisplayObject) : Number
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc13_:* = NaN;
         var _loc11_:* = false;
         var _loc12_:* = null;
         var _loc10_:* = NaN;
         var _loc9_:* = false;
         var _loc4_:* = null;
         var _loc6_:* = NaN;
         var _loc8_:* = false;
         var _loc7_:* = null;
         var _loc2_:* = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc5_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc5_)
            {
               _loc13_ = _loc5_.top;
               _loc11_ = !isNaN(_loc13_);
               if(_loc11_)
               {
                  _loc12_ = _loc5_.topAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc13_ = _loc13_ + (_loc12_.height + this.getTopOffset(_loc12_));
                  }
                  else
                  {
                     return _loc13_;
                  }
               }
               else
               {
                  _loc13_ = 0.0;
               }
               _loc10_ = _loc5_.bottom;
               _loc9_ = !isNaN(_loc10_);
               if(_loc9_)
               {
                  _loc4_ = _loc5_.bottomAnchorDisplayObject;
                  if(_loc4_)
                  {
                     _loc13_ = Math.max(_loc13_,-_loc4_.height - _loc10_ + this.getTopOffset(_loc4_));
                  }
               }
               _loc6_ = _loc5_.verticalCenter;
               _loc8_ = !isNaN(_loc6_);
               if(_loc8_)
               {
                  _loc7_ = _loc5_.verticalCenterAnchorDisplayObject;
                  if(_loc7_)
                  {
                     _loc2_ = _loc6_ - (param1.height - _loc7_.height) / 2;
                     _loc13_ = Math.max(_loc13_,_loc2_ + this.getTopOffset(_loc7_));
                  }
                  else if(_loc6_ > 0)
                  {
                     return _loc6_ * 2;
                  }
               }
               return _loc13_;
            }
         }
         return 0;
      }
      
      protected function getRightOffset(param1:DisplayObject) : Number
      {
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc11_:* = NaN;
         var _loc7_:* = false;
         var _loc6_:* = null;
         var _loc9_:* = NaN;
         var _loc4_:* = false;
         var _loc10_:* = null;
         var _loc12_:* = NaN;
         var _loc5_:* = false;
         var _loc13_:* = null;
         var _loc2_:* = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc8_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc8_)
            {
               _loc11_ = _loc8_.right;
               _loc7_ = !isNaN(_loc11_);
               if(_loc7_)
               {
                  _loc6_ = _loc8_.rightAnchorDisplayObject;
                  if(_loc6_)
                  {
                     _loc11_ = _loc11_ + (_loc6_.width + this.getRightOffset(_loc6_));
                  }
                  else
                  {
                     return _loc11_;
                  }
               }
               else
               {
                  _loc11_ = 0.0;
               }
               _loc9_ = _loc8_.left;
               _loc4_ = !isNaN(_loc9_);
               if(_loc4_)
               {
                  _loc10_ = _loc8_.leftAnchorDisplayObject;
                  if(_loc10_)
                  {
                     _loc11_ = Math.max(_loc11_,-_loc10_.width - _loc9_ + this.getRightOffset(_loc10_));
                  }
               }
               _loc12_ = _loc8_.horizontalCenter;
               _loc5_ = !isNaN(_loc12_);
               if(_loc5_)
               {
                  _loc13_ = _loc8_.horizontalCenterAnchorDisplayObject;
                  if(_loc13_)
                  {
                     _loc2_ = -_loc12_ - (param1.width - _loc13_.width) / 2;
                     _loc11_ = Math.max(_loc11_,_loc2_ + this.getRightOffset(_loc13_));
                  }
                  else if(_loc12_ < 0)
                  {
                     return -_loc12_ * 2;
                  }
               }
               return _loc11_;
            }
         }
         return 0;
      }
      
      protected function getBottomOffset(param1:DisplayObject) : Number
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = NaN;
         var _loc9_:* = false;
         var _loc4_:* = null;
         var _loc13_:* = NaN;
         var _loc11_:* = false;
         var _loc12_:* = null;
         var _loc6_:* = NaN;
         var _loc8_:* = false;
         var _loc7_:* = null;
         var _loc2_:* = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc5_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc5_)
            {
               _loc10_ = _loc5_.bottom;
               _loc9_ = !isNaN(_loc10_);
               if(_loc9_)
               {
                  _loc4_ = _loc5_.bottomAnchorDisplayObject;
                  if(_loc4_)
                  {
                     _loc10_ = _loc10_ + (_loc4_.height + this.getBottomOffset(_loc4_));
                  }
                  else
                  {
                     return _loc10_;
                  }
               }
               else
               {
                  _loc10_ = 0.0;
               }
               _loc13_ = _loc5_.top;
               _loc11_ = !isNaN(_loc13_);
               if(_loc11_)
               {
                  _loc12_ = _loc5_.topAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc10_ = Math.max(_loc10_,-_loc12_.height - _loc13_ + this.getBottomOffset(_loc12_));
                  }
               }
               _loc6_ = _loc5_.verticalCenter;
               _loc8_ = !isNaN(_loc6_);
               if(_loc8_)
               {
                  _loc7_ = _loc5_.verticalCenterAnchorDisplayObject;
                  if(_loc7_)
                  {
                     _loc2_ = -_loc6_ - (param1.height - _loc7_.height) / 2;
                     _loc10_ = Math.max(_loc10_,_loc2_ + this.getBottomOffset(_loc7_));
                  }
                  else if(_loc6_ < 0)
                  {
                     return -_loc6_ * 2;
                  }
               }
               return _loc10_;
            }
         }
         return 0;
      }
      
      protected function getLeftOffset(param1:DisplayObject) : Number
      {
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = NaN;
         var _loc4_:* = false;
         var _loc10_:* = null;
         var _loc11_:* = NaN;
         var _loc7_:* = false;
         var _loc6_:* = null;
         var _loc12_:* = NaN;
         var _loc5_:* = false;
         var _loc13_:* = null;
         var _loc2_:* = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc8_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc8_)
            {
               _loc9_ = _loc8_.left;
               _loc4_ = !isNaN(_loc9_);
               if(_loc4_)
               {
                  _loc10_ = _loc8_.leftAnchorDisplayObject;
                  if(_loc10_)
                  {
                     _loc9_ = _loc9_ + (_loc10_.width + this.getLeftOffset(_loc10_));
                  }
                  else
                  {
                     return _loc9_;
                  }
               }
               else
               {
                  _loc9_ = 0.0;
               }
               _loc11_ = _loc8_.right;
               _loc7_ = !isNaN(_loc11_);
               if(_loc7_)
               {
                  _loc6_ = _loc8_.rightAnchorDisplayObject;
                  if(_loc6_)
                  {
                     _loc9_ = Math.max(_loc9_,-_loc6_.width - _loc11_ + this.getLeftOffset(_loc6_));
                  }
               }
               _loc12_ = _loc8_.horizontalCenter;
               _loc5_ = !isNaN(_loc12_);
               if(_loc5_)
               {
                  _loc13_ = _loc8_.horizontalCenterAnchorDisplayObject;
                  if(_loc13_)
                  {
                     _loc2_ = _loc12_ - (param1.width - _loc13_.width) / 2;
                     _loc9_ = Math.max(_loc9_,_loc2_ + this.getLeftOffset(_loc13_));
                  }
                  else if(_loc12_ > 0)
                  {
                     return _loc12_ * 2;
                  }
               }
               return _loc9_;
            }
         }
         return 0;
      }
      
      protected function layoutWithBounds(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc8_:* = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         var _loc7_:* = param1;
         var _loc9_:Vector.<DisplayObject> = this._helperVector1;
         this.layoutVector(param1,_loc9_,param2,param3,param4,param5);
         var _loc6_:Number = _loc9_.length;
         while(_loc6_ > 0)
         {
            if(_loc9_ == this._helperVector1)
            {
               _loc7_ = this._helperVector1;
               _loc9_ = this._helperVector2;
            }
            else
            {
               _loc7_ = this._helperVector2;
               _loc9_ = this._helperVector1;
            }
            this.layoutVector(_loc7_,_loc9_,param2,param3,param4,param5);
            _loc8_ = _loc6_;
            _loc6_ = _loc9_.length;
            if(_loc8_ == _loc6_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError("It is impossible to create this layout due to a circular reference in the AnchorLayoutData.");
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
      }
      
      protected function layoutVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc9_:* = 0;
         var _loc12_:* = null;
         var _loc7_:* = null;
         var _loc10_:* = null;
         var _loc8_:* = false;
         param2.length = 0;
         var _loc13_:int = param1.length;
         var _loc11_:* = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc13_)
         {
            _loc12_ = param1[_loc9_];
            _loc7_ = _loc12_ as ILayoutDisplayObject;
            if(!(!_loc7_ || !_loc7_.includeInLayout))
            {
               _loc10_ = _loc7_.layoutData as AnchorLayoutData;
               if(_loc10_)
               {
                  _loc8_ = this.isReadyForLayout(_loc10_,_loc9_,param1,param2);
                  if(!_loc8_)
                  {
                     param2[_loc11_] = _loc12_;
                     _loc11_++;
                  }
                  else
                  {
                     this.positionHorizontally(_loc7_,_loc10_,param3,param4,param5,param6);
                     this.positionVertically(_loc7_,_loc10_,param3,param4,param5,param6);
                  }
               }
            }
            _loc9_++;
         }
      }
      
      protected function positionHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc10_:* = NaN;
         var _loc7_:* = NaN;
         var _loc15_:* = NaN;
         var _loc24_:* = null;
         var _loc11_:* = null;
         var _loc22_:* = NaN;
         var _loc18_:* = null;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:* = NaN;
         var _loc20_:IFeathersControl = param1 as IFeathersControl;
         var _loc23_:Number = param2.percentWidth;
         var _loc19_:* = false;
         if(!isNaN(_loc23_))
         {
            if(_loc23_ > 100)
            {
               _loc23_ = 100.0;
            }
            _loc10_ = _loc23_ * 0.01 * param5;
            if(_loc20_)
            {
               _loc7_ = _loc20_.minWidth;
               _loc15_ = _loc20_.maxWidth;
               if(_loc10_ < _loc7_)
               {
                  _loc10_ = _loc7_;
               }
               else if(_loc10_ > _loc15_)
               {
                  _loc10_ = _loc15_;
               }
            }
            param1.width = _loc10_;
            _loc19_ = true;
         }
         var _loc16_:Number = param2.left;
         var _loc8_:* = !isNaN(_loc16_);
         if(_loc8_)
         {
            _loc24_ = param2.leftAnchorDisplayObject;
            if(_loc24_)
            {
               param1.x = _loc24_.x + _loc24_.width + _loc16_;
            }
            else
            {
               param1.x = param3 + _loc16_;
            }
         }
         var _loc25_:Number = param2.horizontalCenter;
         var _loc9_:* = !isNaN(_loc25_);
         var _loc17_:Number = param2.right;
         var _loc21_:* = !isNaN(_loc17_);
         if(_loc21_)
         {
            _loc11_ = param2.rightAnchorDisplayObject;
            if(_loc8_)
            {
               _loc22_ = param5;
               if(_loc11_)
               {
                  _loc22_ = _loc11_.x;
               }
               if(_loc24_)
               {
                  _loc22_ = _loc22_ - (_loc24_.x + _loc24_.width);
               }
               _loc19_ = false;
               param1.width = _loc22_ - _loc17_ - _loc16_;
            }
            else if(_loc9_)
            {
               _loc18_ = param2.horizontalCenterAnchorDisplayObject;
               if(_loc18_)
               {
                  _loc12_ = _loc18_.x + _loc18_.width / 2 + _loc25_;
               }
               else
               {
                  _loc12_ = param5 / 2 + _loc25_;
               }
               if(_loc11_)
               {
                  _loc13_ = _loc11_.x - _loc17_;
               }
               else
               {
                  _loc13_ = param5 - _loc17_;
               }
               _loc19_ = false;
               param1.width = 2 * (_loc13_ - _loc12_);
               param1.x = param5 - _loc17_ - param1.width;
            }
            else if(_loc11_)
            {
               param1.x = _loc11_.x - param1.width - _loc17_;
            }
            else
            {
               param1.x = param3 + param5 - _loc17_ - param1.width;
            }
         }
         else if(_loc9_)
         {
            _loc18_ = param2.horizontalCenterAnchorDisplayObject;
            if(_loc18_)
            {
               _loc12_ = _loc18_.x + _loc18_.width / 2 + _loc25_;
            }
            else
            {
               _loc12_ = param5 / 2 + _loc25_;
            }
            if(_loc8_)
            {
               _loc19_ = false;
               param1.width = 2 * (_loc12_ - param1.x);
            }
            else
            {
               param1.x = _loc12_ - param1.width / 2;
            }
         }
         if(_loc19_)
         {
            _loc14_ = param1.x;
            _loc10_ = param1.width;
            if(_loc14_ + _loc10_ > param5)
            {
               _loc10_ = param5 - _loc14_;
               if(_loc20_)
               {
                  if(_loc10_ < _loc7_)
                  {
                     _loc10_ = _loc7_;
                  }
               }
               param1.width = _loc10_;
            }
         }
      }
      
      protected function positionVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc16_:* = NaN;
         var _loc19_:* = NaN;
         var _loc22_:* = NaN;
         var _loc25_:* = null;
         var _loc14_:* = null;
         var _loc13_:* = NaN;
         var _loc8_:* = null;
         var _loc18_:* = NaN;
         var _loc20_:* = NaN;
         var _loc11_:* = NaN;
         var _loc15_:IFeathersControl = param1 as IFeathersControl;
         var _loc21_:Number = param2.percentHeight;
         var _loc7_:* = false;
         if(!isNaN(_loc21_))
         {
            if(_loc21_ > 100)
            {
               _loc21_ = 100.0;
            }
            _loc16_ = _loc21_ * 0.01 * param6;
            if(_loc15_)
            {
               _loc19_ = _loc15_.minHeight;
               _loc22_ = _loc15_.maxHeight;
               if(_loc16_ < _loc19_)
               {
                  _loc16_ = _loc19_;
               }
               else if(_loc16_ > _loc22_)
               {
                  _loc16_ = _loc22_;
               }
            }
            param1.height = _loc16_;
            _loc7_ = true;
         }
         var _loc12_:Number = param2.top;
         var _loc24_:* = !isNaN(_loc12_);
         if(_loc24_)
         {
            _loc25_ = param2.topAnchorDisplayObject;
            if(_loc25_)
            {
               param1.y = _loc25_.y + _loc25_.height + _loc12_;
            }
            else
            {
               param1.y = param4 + _loc12_;
            }
         }
         var _loc17_:Number = param2.verticalCenter;
         var _loc9_:* = !isNaN(_loc17_);
         var _loc23_:Number = param2.bottom;
         var _loc10_:* = !isNaN(_loc23_);
         if(_loc10_)
         {
            _loc14_ = param2.bottomAnchorDisplayObject;
            if(_loc24_)
            {
               _loc13_ = param6;
               if(_loc14_)
               {
                  _loc13_ = _loc14_.y;
               }
               if(_loc25_)
               {
                  _loc13_ = _loc13_ - (_loc25_.y + _loc25_.height);
               }
               _loc7_ = false;
               param1.height = _loc13_ - _loc23_ - _loc12_;
            }
            else if(_loc9_)
            {
               _loc8_ = param2.verticalCenterAnchorDisplayObject;
               if(_loc8_)
               {
                  _loc18_ = _loc8_.y + _loc8_.height / 2 + _loc17_;
               }
               else
               {
                  _loc18_ = param6 / 2 + _loc17_;
               }
               if(_loc14_)
               {
                  _loc20_ = _loc14_.y - _loc23_;
               }
               else
               {
                  _loc20_ = param6 - _loc23_;
               }
               _loc7_ = false;
               param1.height = 2 * (_loc20_ - _loc18_);
               param1.y = param6 - _loc23_ - param1.height;
            }
            else if(_loc14_)
            {
               param1.y = _loc14_.y - param1.height - _loc23_;
            }
            else
            {
               param1.y = param4 + param6 - _loc23_ - param1.height;
            }
         }
         else if(_loc9_)
         {
            _loc8_ = param2.verticalCenterAnchorDisplayObject;
            if(_loc8_)
            {
               _loc18_ = _loc8_.y + _loc8_.height / 2 + _loc17_;
            }
            else
            {
               _loc18_ = param6 / 2 + _loc17_;
            }
            if(_loc24_)
            {
               _loc7_ = false;
               param1.height = 2 * (_loc18_ - param1.y);
            }
            else
            {
               param1.y = _loc18_ - param1.height / 2;
            }
         }
         if(_loc7_)
         {
            _loc11_ = param1.y;
            _loc16_ = param1.height;
            if(_loc11_ + _loc16_ > param6)
            {
               _loc16_ = param6 - _loc11_;
               if(_loc15_)
               {
                  if(_loc16_ < _loc19_)
                  {
                     _loc16_ = _loc19_;
                  }
               }
               param1.height = _loc16_;
            }
         }
      }
      
      protected function measureContent(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point = null) : Point
      {
         var _loc11_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = NaN;
         var _loc5_:* = NaN;
         var _loc9_:* = param2;
         var _loc8_:* = param3;
         var _loc10_:int = param1.length;
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc6_ = param1[_loc11_];
            _loc7_ = _loc6_.x + _loc6_.width;
            _loc5_ = _loc6_.y + _loc6_.height;
            if(!isNaN(_loc7_) && _loc7_ > _loc9_)
            {
               _loc9_ = _loc7_;
            }
            if(!isNaN(_loc5_) && _loc5_ > _loc8_)
            {
               _loc8_ = _loc5_;
            }
            _loc11_++;
         }
         param4.x = _loc9_;
         param4.y = _loc8_;
         return param4;
      }
      
      protected function isReadyForLayout(param1:AnchorLayoutData, param2:int, param3:Vector.<DisplayObject>, param4:Vector.<DisplayObject>) : Boolean
      {
         var _loc5_:int = param2 + 1;
         var _loc9_:DisplayObject = param1.leftAnchorDisplayObject;
         if(_loc9_ && (param3.indexOf(_loc9_,_loc5_) >= _loc5_ || param4.indexOf(_loc9_) >= 0))
         {
            return false;
         }
         var _loc8_:DisplayObject = param1.rightAnchorDisplayObject;
         if(_loc8_ && (param3.indexOf(_loc8_,_loc5_) >= _loc5_ || param4.indexOf(_loc8_) >= 0))
         {
            return false;
         }
         var _loc7_:DisplayObject = param1.topAnchorDisplayObject;
         if(_loc7_ && (param3.indexOf(_loc7_,_loc5_) >= _loc5_ || param4.indexOf(_loc7_) >= 0))
         {
            return false;
         }
         var _loc6_:DisplayObject = param1.bottomAnchorDisplayObject;
         if(_loc6_ && (param3.indexOf(_loc6_,_loc5_) >= _loc5_ || param4.indexOf(_loc6_) >= 0))
         {
            return false;
         }
         return true;
      }
      
      protected function isReferenced(param1:DisplayObject, param2:Vector.<DisplayObject>) : Boolean
      {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:int = param2.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_ = param2[_loc6_] as ILayoutDisplayObject;
            if(!(!_loc3_ || _loc3_ == param1))
            {
               _loc5_ = _loc3_.layoutData as AnchorLayoutData;
               if(_loc5_)
               {
                  if(_loc5_.leftAnchorDisplayObject == param1 || _loc5_.horizontalCenterAnchorDisplayObject == param1 || _loc5_.rightAnchorDisplayObject == param1 || _loc5_.topAnchorDisplayObject == param1 || _loc5_.verticalCenterAnchorDisplayObject == param1 || _loc5_.bottomAnchorDisplayObject == param1)
                  {
                     return true;
                  }
               }
            }
            _loc6_++;
         }
         return false;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Boolean) : void
      {
         var _loc8_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc5_:* = false;
         var _loc7_:* = false;
         var _loc6_:* = false;
         var _loc12_:* = false;
         var _loc11_:* = false;
         var _loc10_:* = false;
         var _loc13_:int = param1.length;
         _loc8_ = 0;
         for(; _loc8_ < _loc13_; _loc8_++)
         {
            _loc3_ = param1[_loc8_] as IFeathersControl;
            if(_loc3_)
            {
               if(param2)
               {
                  _loc3_.validate();
               }
               else
               {
                  if(_loc3_ is ILayoutDisplayObject)
                  {
                     _loc4_ = ILayoutDisplayObject(_loc3_);
                     if(_loc4_.includeInLayout)
                     {
                        _loc9_ = _loc4_.layoutData as AnchorLayoutData;
                        if(_loc9_)
                        {
                           _loc5_ = !isNaN(_loc9_.left);
                           _loc7_ = !isNaN(_loc9_.right);
                           _loc6_ = !isNaN(_loc9_.horizontalCenter);
                           if(_loc7_ && !_loc5_ && !_loc6_ || _loc6_)
                           {
                              _loc3_.validate();
                              continue;
                           }
                           _loc12_ = !isNaN(_loc9_.top);
                           _loc11_ = !isNaN(_loc9_.bottom);
                           _loc10_ = !isNaN(_loc9_.verticalCenter);
                           if(_loc11_ && !_loc12_ && !_loc10_ || _loc10_)
                           {
                              _loc3_.validate();
                              continue;
                           }
                        }
                     }
                     continue;
                  }
                  if(this.isReferenced(DisplayObject(_loc3_),param1))
                  {
                     _loc3_.validate();
                     continue;
                  }
               }
               continue;
            }
         }
      }
   }
}
