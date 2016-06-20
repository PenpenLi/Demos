package lzm.util
{
   import flash.geom.Rectangle;
   
   public class MaxRectsBinPack
   {
      
      public static const BESTSHORTSIDEFIT:int = 0;
      
      public static const BESTLONGSIDEFIT:int = 1;
      
      public static const BESTAREAFIT:int = 2;
      
      public static const BOTTOMLEFTRULE:int = 3;
      
      public static const CONTACTPOINTRULE:int = 4;
       
      public var binWidth:int = 0;
      
      public var binHeight:int = 0;
      
      public var allowRotations:Boolean = false;
      
      public var usedRectangles:Vector.<Rectangle>;
      
      public var freeRectangles:Vector.<Rectangle>;
      
      private var score1:int = 0;
      
      private var score2:int = 0;
      
      private var bestShortSideFit:int;
      
      private var bestLongSideFit:int;
      
      public function MaxRectsBinPack(param1:int, param2:int, param3:Boolean = false)
      {
         usedRectangles = new Vector.<Rectangle>();
         freeRectangles = new Vector.<Rectangle>();
         super();
         init(param1,param2,param3);
      }
      
      private function init(param1:int, param2:int, param3:Boolean = false) : void
      {
         if(count(param1) % 1 != 0 || count(param2) % 1 != 0)
         {
            throw new Error("Must be 2,4,8,16,32,...512,1024,...");
         }
         binWidth = param1;
         binHeight = param2;
         allowRotations = param3;
         var _loc4_:Rectangle = new Rectangle();
         _loc4_.x = 0;
         _loc4_.y = 0;
         _loc4_.width = param1;
         _loc4_.height = param2;
         usedRectangles.length = 0;
         freeRectangles.length = 0;
         freeRectangles.push(_loc4_);
      }
      
      private function count(param1:Number) : Number
      {
         if(param1 >= 2)
         {
            return count(param1 / 2);
         }
         return param1;
      }
      
      public function insert(param1:int, param2:int, param3:int) : Rectangle
      {
         var _loc4_:Rectangle = new Rectangle();
         score1 = 0;
         score2 = 0;
         switch(param3)
         {
            case 0:
               _loc4_ = findPositionForNewNodeBestShortSideFit(param1,param2);
               break;
            case 1:
               _loc4_ = findPositionForNewNodeBestLongSideFit(param1,param2,score2,score1);
               break;
            case 2:
               _loc4_ = findPositionForNewNodeBestAreaFit(param1,param2,score1,score2);
               break;
            case 3:
               _loc4_ = findPositionForNewNodeBottomLeft(param1,param2,score1,score2);
               break;
            case 4:
               _loc4_ = findPositionForNewNodeContactPoint(param1,param2,score1);
               break;
         }
         if(_loc4_.height == 0)
         {
            return _loc4_;
         }
         placeRectangle(_loc4_);
         return _loc4_;
      }
      
      private function insert2(param1:Vector.<Rectangle>, param2:Vector.<Rectangle>, param3:int) : void
      {
         var _loc9_:* = 0;
         var _loc8_:* = 0;
         var _loc4_:* = 0;
         var _loc6_:* = null;
         var _loc11_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc10_:* = null;
         param2.length = 0;
         while(param1.length > 0)
         {
            _loc9_ = 2147483647;
            _loc8_ = 2147483647;
            _loc4_ = -1;
            _loc6_ = new Rectangle();
            _loc11_ = 0;
            while(_loc11_ < param1.length)
            {
               _loc7_ = 0;
               _loc5_ = 0;
               _loc10_ = scoreRectangle(param1[_loc11_].width,param1[_loc11_].height,param3,_loc7_,_loc5_);
               if(_loc7_ < _loc9_ || _loc7_ == _loc9_ && _loc5_ < _loc8_)
               {
                  _loc9_ = _loc7_;
                  _loc8_ = _loc5_;
                  _loc6_ = _loc10_;
                  _loc4_ = _loc11_;
               }
               _loc11_++;
            }
            if(_loc4_ == -1)
            {
               return;
            }
            placeRectangle(_loc6_);
            param1.splice(_loc4_,1);
         }
      }
      
      private function placeRectangle(param1:Rectangle) : void
      {
         var _loc3_:* = 0;
         var _loc2_:int = freeRectangles.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(splitFreeNode(freeRectangles[_loc3_],param1))
            {
               freeRectangles.splice(_loc3_,1);
               _loc3_--;
               _loc2_--;
            }
            _loc3_++;
         }
         pruneFreeList();
         usedRectangles.push(param1);
      }
      
      private function scoreRectangle(param1:int, param2:int, param3:int, param4:int, param5:int) : Rectangle
      {
         var _loc6_:Rectangle = new Rectangle();
         var param4:* = 2147483647;
         var param5:* = 2147483647;
         switch(param3)
         {
            case 0:
               _loc6_ = findPositionForNewNodeBestShortSideFit(param1,param2);
               break;
            case 1:
               _loc6_ = findPositionForNewNodeBestLongSideFit(param1,param2,param5,param4);
               break;
            case 2:
               _loc6_ = findPositionForNewNodeBestAreaFit(param1,param2,param4,param5);
               break;
            case 3:
               _loc6_ = findPositionForNewNodeBottomLeft(param1,param2,param4,param5);
               break;
            case 4:
               _loc6_ = findPositionForNewNodeContactPoint(param1,param2,param4);
               param4 = -param4;
               break;
         }
         if(_loc6_.height == 0)
         {
            param4 = 2147483647;
            param5 = 2147483647;
         }
         return _loc6_;
      }
      
      private function occupancy() : Number
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0.0;
         _loc1_ = 0;
         while(_loc1_ < usedRectangles.length)
         {
            _loc2_ = _loc2_ + usedRectangles[_loc1_].width * usedRectangles[_loc1_].height;
            _loc1_++;
         }
         return _loc2_ / (binWidth * binHeight);
      }
      
      private function findPositionForNewNodeBottomLeft(param1:int, param2:int, param3:int, param4:int) : Rectangle
      {
         var _loc7_:* = null;
         var _loc5_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:Rectangle = new Rectangle();
         var param3:* = 2147483647;
         _loc8_ = 0;
         while(_loc8_ < freeRectangles.length)
         {
            _loc7_ = freeRectangles[_loc8_];
            if(_loc7_.width >= param1 && _loc7_.height >= param2)
            {
               _loc5_ = _loc7_.y + param2;
               if(_loc5_ < param3 || _loc5_ == param3 && _loc7_.x < param4)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param1;
                  _loc6_.height = param2;
                  param3 = _loc5_;
                  var param4:int = _loc7_.x;
               }
            }
            if(allowRotations && _loc7_.width >= param2 && _loc7_.height >= param1)
            {
               _loc5_ = _loc7_.y + param1;
               if(_loc5_ < param3 || _loc5_ == param3 && _loc7_.x < param4)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param2;
                  _loc6_.height = param1;
                  param3 = _loc5_;
                  param4 = _loc7_.x;
               }
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      private function findPositionForNewNodeBestShortSideFit(param1:int, param2:int) : Rectangle
      {
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc9_:* = 0;
         var _loc8_:* = 0;
         var _loc10_:* = 0;
         var _loc3_:* = 0;
         var _loc11_:* = 0;
         var _loc13_:* = 0;
         var _loc12_:Rectangle = new Rectangle();
         bestShortSideFit = 2147483647;
         bestLongSideFit = score2;
         _loc8_ = 0;
         while(_loc8_ < freeRectangles.length)
         {
            _loc6_ = freeRectangles[_loc8_];
            if(_loc6_.width >= param1 && _loc6_.height >= param2)
            {
               _loc7_ = Math.abs(_loc6_.width - param1);
               _loc5_ = Math.abs(_loc6_.height - param2);
               _loc4_ = Math.min(_loc7_,_loc5_);
               _loc9_ = Math.max(_loc7_,_loc5_);
               if(_loc4_ < bestShortSideFit || _loc4_ == bestShortSideFit && _loc9_ < bestLongSideFit)
               {
                  _loc12_.x = _loc6_.x;
                  _loc12_.y = _loc6_.y;
                  _loc12_.width = param1;
                  _loc12_.height = param2;
                  bestShortSideFit = _loc4_;
                  bestLongSideFit = _loc9_;
               }
            }
            if(allowRotations && _loc6_.width >= param2 && _loc6_.height >= param1)
            {
               _loc10_ = Math.abs(_loc6_.width - param2);
               _loc3_ = Math.abs(_loc6_.height - param1);
               _loc11_ = Math.min(_loc10_,_loc3_);
               _loc13_ = Math.max(_loc10_,_loc3_);
               if(_loc11_ < bestShortSideFit || _loc11_ == bestShortSideFit && _loc13_ < bestLongSideFit)
               {
                  _loc12_.x = _loc6_.x;
                  _loc12_.y = _loc6_.y;
                  _loc12_.width = param2;
                  _loc12_.height = param1;
                  bestShortSideFit = _loc11_;
                  bestLongSideFit = _loc13_;
               }
            }
            _loc8_++;
         }
         return _loc12_;
      }
      
      private function findPositionForNewNodeBestLongSideFit(param1:int, param2:int, param3:int, param4:int) : Rectangle
      {
         var _loc9_:* = null;
         var _loc10_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc11_:* = 0;
         var _loc8_:Rectangle = new Rectangle();
         var param4:* = 2147483647;
         _loc11_ = 0;
         while(_loc11_ < freeRectangles.length)
         {
            _loc9_ = freeRectangles[_loc11_];
            if(_loc9_.width >= param1 && _loc9_.height >= param2)
            {
               _loc10_ = Math.abs(_loc9_.width - param1);
               _loc7_ = Math.abs(_loc9_.height - param2);
               _loc5_ = Math.min(_loc10_,_loc7_);
               _loc6_ = Math.max(_loc10_,_loc7_);
               if(_loc6_ < param4 || _loc6_ == param4 && _loc5_ < param3)
               {
                  _loc8_.x = _loc9_.x;
                  _loc8_.y = _loc9_.y;
                  _loc8_.width = param1;
                  _loc8_.height = param2;
                  var param3:* = _loc5_;
                  param4 = _loc6_;
               }
            }
            if(allowRotations && _loc9_.width >= param2 && _loc9_.height >= param1)
            {
               _loc10_ = Math.abs(_loc9_.width - param2);
               _loc7_ = Math.abs(_loc9_.height - param1);
               _loc5_ = Math.min(_loc10_,_loc7_);
               _loc6_ = Math.max(_loc10_,_loc7_);
               if(_loc6_ < param4 || _loc6_ == param4 && _loc5_ < param3)
               {
                  _loc8_.x = _loc9_.x;
                  _loc8_.y = _loc9_.y;
                  _loc8_.width = param2;
                  _loc8_.height = param1;
                  param3 = _loc5_;
                  param4 = _loc6_;
               }
            }
            _loc11_++;
         }
         return _loc8_;
      }
      
      private function findPositionForNewNodeBestAreaFit(param1:int, param2:int, param3:int, param4:int) : Rectangle
      {
         var _loc8_:* = null;
         var _loc10_:* = 0;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc9_:* = 0;
         var _loc11_:* = 0;
         var _loc7_:Rectangle = new Rectangle();
         var param3:* = 2147483647;
         _loc11_ = 0;
         while(_loc11_ < freeRectangles.length)
         {
            _loc8_ = freeRectangles[_loc11_];
            _loc9_ = _loc8_.width * _loc8_.height - param1 * param2;
            if(_loc8_.width >= param1 && _loc8_.height >= param2)
            {
               _loc10_ = Math.abs(_loc8_.width - param1);
               _loc6_ = Math.abs(_loc8_.height - param2);
               _loc5_ = Math.min(_loc10_,_loc6_);
               if(_loc9_ < param3 || _loc9_ == param3 && _loc5_ < param4)
               {
                  _loc7_.x = _loc8_.x;
                  _loc7_.y = _loc8_.y;
                  _loc7_.width = param1;
                  _loc7_.height = param2;
                  var param4:* = _loc5_;
                  param3 = _loc9_;
               }
            }
            if(allowRotations && _loc8_.width >= param2 && _loc8_.height >= param1)
            {
               _loc10_ = Math.abs(_loc8_.width - param2);
               _loc6_ = Math.abs(_loc8_.height - param1);
               _loc5_ = Math.min(_loc10_,_loc6_);
               if(_loc9_ < param3 || _loc9_ == param3 && _loc5_ < param4)
               {
                  _loc7_.x = _loc8_.x;
                  _loc7_.y = _loc8_.y;
                  _loc7_.width = param2;
                  _loc7_.height = param1;
                  param4 = _loc5_;
                  param3 = _loc9_;
               }
            }
            _loc11_++;
         }
         return _loc7_;
      }
      
      private function commonIntervalLength(param1:int, param2:int, param3:int, param4:int) : int
      {
         if(param2 < param3 || param4 < param1)
         {
            return 0;
         }
         return Math.min(param2,param4) - Math.max(param1,param3);
      }
      
      private function contactPointScoreNode(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         if(param1 == 0 || param1 + param3 == binWidth)
         {
            _loc5_ = _loc5_ + param4;
         }
         if(param2 == 0 || param2 + param4 == binHeight)
         {
            _loc5_ = _loc5_ + param3;
         }
         _loc7_ = 0;
         while(_loc7_ < usedRectangles.length)
         {
            _loc6_ = usedRectangles[_loc7_];
            if(_loc6_.x == param1 + param3 || _loc6_.x + _loc6_.width == param1)
            {
               _loc5_ = _loc5_ + commonIntervalLength(_loc6_.y,_loc6_.y + _loc6_.height,param2,param2 + param4);
            }
            if(_loc6_.y == param2 + param4 || _loc6_.y + _loc6_.height == param2)
            {
               _loc5_ = _loc5_ + commonIntervalLength(_loc6_.x,_loc6_.x + _loc6_.width,param1,param1 + param3);
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function findPositionForNewNodeContactPoint(param1:int, param2:int, param3:int) : Rectangle
      {
         var _loc6_:* = null;
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:Rectangle = new Rectangle();
         var param3:* = -1;
         _loc7_ = 0;
         while(_loc7_ < freeRectangles.length)
         {
            _loc6_ = freeRectangles[_loc7_];
            if(_loc6_.width >= param1 && _loc6_.height >= param2)
            {
               _loc4_ = contactPointScoreNode(_loc6_.x,_loc6_.y,param1,param2);
               if(_loc4_ > param3)
               {
                  _loc5_.x = _loc6_.x;
                  _loc5_.y = _loc6_.y;
                  _loc5_.width = param1;
                  _loc5_.height = param2;
                  param3 = _loc4_;
               }
            }
            if(allowRotations && _loc6_.width >= param2 && _loc6_.height >= param1)
            {
               _loc4_ = contactPointScoreNode(_loc6_.x,_loc6_.y,param2,param1);
               if(_loc4_ > param3)
               {
                  _loc5_.x = _loc6_.x;
                  _loc5_.y = _loc6_.y;
                  _loc5_.width = param2;
                  _loc5_.height = param1;
                  param3 = _loc4_;
               }
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function splitFreeNode(param1:Rectangle, param2:Rectangle) : Boolean
      {
         var _loc3_:* = null;
         if(param2.x >= param1.x + param1.width || param2.x + param2.width <= param1.x || param2.y >= param1.y + param1.height || param2.y + param2.height <= param1.y)
         {
            return false;
         }
         if(param2.x < param1.x + param1.width && param2.x + param2.width > param1.x)
         {
            if(param2.y > param1.y && param2.y < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.height = param2.y - _loc3_.y;
               freeRectangles.push(_loc3_);
            }
            if(param2.y + param2.height < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.y = param2.y + param2.height;
               _loc3_.height = param1.y + param1.height - (param2.y + param2.height);
               freeRectangles.push(_loc3_);
            }
         }
         if(param2.y < param1.y + param1.height && param2.y + param2.height > param1.y)
         {
            if(param2.x > param1.x && param2.x < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.width = param2.x - _loc3_.x;
               freeRectangles.push(_loc3_);
            }
            if(param2.x + param2.width < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.x = param2.x + param2.width;
               _loc3_.width = param1.x + param1.width - (param2.x + param2.width);
               freeRectangles.push(_loc3_);
            }
         }
         return true;
      }
      
      private function pruneFreeList() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < freeRectangles.length)
         {
            _loc1_ = _loc2_ + 1;
            while(_loc1_ < freeRectangles.length)
            {
               if(isContainedIn(freeRectangles[_loc2_],freeRectangles[_loc1_]))
               {
                  freeRectangles.splice(_loc2_,1);
                  break;
               }
               if(isContainedIn(freeRectangles[_loc1_],freeRectangles[_loc2_]))
               {
                  freeRectangles.splice(_loc1_,1);
               }
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private function isContainedIn(param1:Rectangle, param2:Rectangle) : Boolean
      {
         return param1.x >= param2.x && param1.y >= param2.y && param1.x + param1.width <= param2.x + param2.width && param1.y + param1.height <= param2.y + param2.height;
      }
   }
}
