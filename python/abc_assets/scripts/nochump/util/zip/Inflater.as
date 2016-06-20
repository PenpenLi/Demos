package nochump.util.zip
{
   import flash.utils.ByteArray;
   
   public class Inflater
   {
      
      private static const MAXBITS:int = 15;
      
      private static const MAXLCODES:int = 286;
      
      private static const MAXDCODES:int = 30;
      
      private static const MAXCODES:int = 316;
      
      private static const FIXLCODES:int = 288;
      
      private static const LENS:Array = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258];
      
      private static const LEXT:Array = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0];
      
      private static const DISTS:Array = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];
      
      private static const DEXT:Array = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13];
       
      private var inbuf:ByteArray;
      
      private var incnt:uint;
      
      private var bitbuf:int;
      
      private var bitcnt:int;
      
      private var lencode:Object;
      
      private var distcode:Object;
      
      public function Inflater()
      {
         super();
      }
      
      public function setInput(param1:ByteArray) : void
      {
         inbuf = param1;
         inbuf.endian = "littleEndian";
      }
      
      public function inflate(param1:ByteArray) : uint
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         bitcnt = 0;
         bitbuf = 0;
         incnt = 0;
         var _loc2_:* = 0;
         while(true)
         {
            _loc3_ = bits(1);
            _loc4_ = bits(2);
            if(_loc4_ == 0)
            {
               stored(param1);
            }
            else
            {
               if(_loc4_ == 3)
               {
                  throw new Error("invalid block type (type == 3)",-1);
               }
               lencode = {
                  "count":[],
                  "symbol":[]
               };
               distcode = {
                  "count":[],
                  "symbol":[]
               };
               if(_loc4_ == 1)
               {
                  constructFixedTables();
               }
               else if(_loc4_ == 2)
               {
                  _loc2_ = constructDynamicTables();
               }
               if(_loc2_ != 0)
               {
                  return _loc2_;
               }
               _loc2_ = codes(param1);
            }
            if(_loc2_ == 0)
            {
               if(_loc3_)
               {
                  break;
               }
               continue;
            }
            break;
         }
         return _loc2_;
      }
      
      private function bits(param1:int) : int
      {
         var _loc2_:int = bitbuf;
         while(bitcnt < param1)
         {
            if(incnt == inbuf.length)
            {
               throw new Error("available inflate data did not terminate",2);
            }
            incnt = §§dup(incnt) + 1;
            _loc2_ = _loc2_ | inbuf[incnt] << bitcnt;
            bitcnt = §§dup().bitcnt + 8;
         }
         bitbuf = _loc2_ >> param1;
         bitcnt = §§dup().bitcnt - param1;
         return _loc2_ & (1 << param1) - 1;
      }
      
      private function construct(param1:Object, param2:Array, param3:int) : int
      {
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:Array = [];
         _loc6_ = 0;
         while(_loc6_ <= 15)
         {
            param1.count[_loc6_] = 0;
            _loc6_++;
         }
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            var _loc8_:* = param1.count;
            var _loc9_:* = param2[_loc5_];
            var _loc10_:* = _loc8_[_loc9_] + 1;
            _loc8_[_loc9_] = _loc10_;
            _loc5_++;
         }
         if(param1.count[0] == param3)
         {
            return 0;
         }
         var _loc7_:* = 1;
         _loc6_ = 1;
         while(_loc6_ <= 15)
         {
            _loc7_ = _loc7_ << 1;
            _loc7_ = _loc7_ - param1.count[_loc6_];
            if(_loc7_ < 0)
            {
               return _loc7_;
            }
            _loc6_++;
         }
         _loc4_[1] = 0;
         _loc6_ = 1;
         while(_loc6_ < 15)
         {
            _loc4_[_loc6_ + 1] = _loc4_[_loc6_] + param1.count[_loc6_];
            _loc6_++;
         }
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            if(param2[_loc5_] != 0)
            {
               _loc8_ = _loc4_;
               _loc9_ = param2[_loc5_];
               _loc10_ = §§dup(_loc8_[_loc9_]) + 1;
               _loc8_[_loc9_] = _loc10_;
               param1.symbol[_loc8_[_loc9_]] = _loc5_;
            }
            _loc5_++;
         }
         return _loc7_;
      }
      
      private function decode(param1:Object) : int
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         _loc3_ = 1;
         while(_loc3_ <= 15)
         {
            _loc2_ = _loc2_ | bits(1);
            _loc4_ = param1.count[_loc3_];
            if(_loc2_ < _loc6_ + _loc4_)
            {
               return param1.symbol[_loc5_ + (_loc2_ - _loc6_)];
            }
            _loc5_ = _loc5_ + _loc4_;
            _loc6_ = _loc6_ + _loc4_;
            _loc6_ = _loc6_ << 1;
            _loc2_ = _loc2_ << 1;
            _loc3_++;
         }
         return -9;
      }
      
      private function codes(param1:ByteArray) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(true)
         {
            _loc2_ = decode(lencode);
            if(_loc2_ < 0)
            {
               break;
            }
            if(_loc2_ < 256)
            {
               param1[param1.length] = _loc2_;
            }
            else if(_loc2_ > 256)
            {
               _loc2_ = _loc2_ - 257;
               if(_loc2_ >= 29)
               {
                  throw new Error("invalid literal/length or distance code in fixed or dynamic block",-9);
               }
               _loc3_ = LENS[_loc2_] + bits(LEXT[_loc2_]);
               _loc2_ = decode(distcode);
               if(_loc2_ < 0)
               {
                  return _loc2_;
               }
               _loc4_ = DISTS[_loc2_] + bits(DEXT[_loc2_]);
               if(_loc4_ > param1.length)
               {
                  throw new Error("distance is too far back in fixed or dynamic block",-10);
               }
               while(true)
               {
                  _loc3_--;
                  if(!_loc3_)
                  {
                     break;
                  }
                  param1[param1.length] = param1[param1.length - _loc4_];
               }
            }
            if(_loc2_ == 256)
            {
               return 0;
            }
         }
         return _loc2_;
      }
      
      private function stored(param1:ByteArray) : void
      {
         bitbuf = 0;
         bitcnt = 0;
         if(incnt + 4 > inbuf.length)
         {
            throw new Error("available inflate data did not terminate",2);
         }
         incnt = §§dup(incnt) + 1;
         var _loc2_:uint = inbuf[incnt];
         incnt = §§dup(incnt) + 1;
         _loc2_ = _loc2_ | inbuf[incnt] << 8;
         incnt = §§dup(incnt) + 1;
         if(inbuf[incnt] != (~_loc2_ & 255) || inbuf[incnt] != (~_loc2_ >> 8 & 255))
         {
            throw new Error("stored block length did not match one\'s complement",-2);
         }
         if(incnt + _loc2_ > inbuf.length)
         {
            throw new Error("available inflate data did not terminate",2);
         }
         while(_loc2_--)
         {
            incnt = §§dup(incnt) + 1;
            param1[param1.length] = inbuf[incnt];
         }
      }
      
      private function constructFixedTables() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < 144)
         {
            _loc2_[_loc1_] = 8;
            _loc1_++;
         }
         while(_loc1_ < 256)
         {
            _loc2_[_loc1_] = 9;
            _loc1_++;
         }
         while(_loc1_ < 280)
         {
            _loc2_[_loc1_] = 7;
            _loc1_++;
         }
         while(_loc1_ < 288)
         {
            _loc2_[_loc1_] = 8;
            _loc1_++;
         }
         construct(lencode,_loc2_,288);
         _loc1_ = 0;
         while(_loc1_ < 30)
         {
            _loc2_[_loc1_] = 5;
            _loc1_++;
         }
         construct(distcode,_loc2_,30);
      }
      
      private function constructDynamicTables() : int
      {
         var _loc8_:* = 0;
         var _loc1_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:Array = [];
         var _loc9_:Array = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];
         var _loc3_:int = bits(5) + 257;
         var _loc7_:int = bits(5) + 1;
         var _loc6_:int = bits(4) + 4;
         if(_loc3_ > 286 || _loc7_ > 30)
         {
            throw new Error("dynamic block code description: too many length or distance codes",-3);
         }
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc2_[_loc9_[_loc8_]] = bits(3);
            _loc8_++;
         }
         while(_loc8_ < 19)
         {
            _loc2_[_loc9_[_loc8_]] = 0;
            _loc8_++;
         }
         var _loc4_:int = construct(lencode,_loc2_,19);
         if(_loc4_ != 0)
         {
            throw new Error("dynamic block code description: code lengths codes incomplete",-4);
         }
         _loc8_ = 0;
         while(_loc8_ < _loc3_ + _loc7_)
         {
            _loc1_ = decode(lencode);
            if(_loc1_ < 16)
            {
               _loc8_++;
               _loc2_[_loc8_] = _loc1_;
            }
            else
            {
               _loc5_ = 0;
               if(_loc1_ == 16)
               {
                  if(_loc8_ == 0)
                  {
                     throw new Error("dynamic block code description: repeat lengths with no first length",-5);
                  }
                  _loc5_ = _loc2_[_loc8_ - 1];
                  _loc1_ = 3 + bits(2);
               }
               else if(_loc1_ == 17)
               {
                  _loc1_ = 3 + bits(3);
               }
               else
               {
                  _loc1_ = 11 + bits(7);
               }
               if(_loc8_ + _loc1_ > _loc3_ + _loc7_)
               {
                  throw new Error("dynamic block code description: repeat more than specified lengths",-6);
               }
               while(true)
               {
                  _loc1_--;
                  if(!_loc1_)
                  {
                     break;
                  }
                  _loc8_++;
                  _loc2_[_loc8_] = _loc5_;
               }
            }
         }
         _loc4_ = construct(lencode,_loc2_,_loc3_);
         if(_loc4_ < 0 || _loc4_ > 0 && _loc3_ - lencode.count[0] != 1)
         {
            throw new Error("dynamic block code description: invalid literal/length code lengths",-7);
         }
         _loc4_ = construct(distcode,_loc2_.slice(_loc3_),_loc7_);
         if(_loc4_ < 0 || _loc4_ > 0 && _loc7_ - distcode.count[0] != 1)
         {
            throw new Error("dynamic block code description: invalid distance code lengths",-8);
         }
         return _loc4_;
      }
   }
}
