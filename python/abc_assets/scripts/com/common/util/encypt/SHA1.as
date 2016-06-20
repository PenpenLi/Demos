package com.common.util.encypt
{
   import flash.utils.ByteArray;
   
   public class SHA1
   {
      
      public static var digest:ByteArray;
       
      public function SHA1()
      {
         super();
      }
      
      public static function hash(param1:String) : String
      {
         var _loc2_:Array = createBlocksFromString(param1);
         var _loc3_:ByteArray = hashBlocks(_loc2_);
         return IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true);
      }
      
      public static function hashBytes(param1:ByteArray) : String
      {
         var _loc2_:Array = SHA1.createBlocksFromByteArray(param1);
         var _loc3_:ByteArray = hashBlocks(_loc2_);
         return IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true) + IntUtil.toHex(_loc3_.readInt(),true);
      }
      
      private static function hashBlocks(param1:Array) : ByteArray
      {
         var _loc3_:* = 0;
         var _loc11_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc16_:* = 0;
         var _loc9_:* = 1732584193;
         var _loc10_:* = 4023233417;
         var _loc12_:* = 2562383102;
         var _loc13_:* = 271733878;
         var _loc14_:* = 3285377520;
         var _loc15_:int = param1.length;
         var _loc17_:Array = new Array(80);
         _loc11_ = 0;
         while(_loc11_ < _loc15_)
         {
            _loc2_ = _loc9_;
            _loc4_ = _loc10_;
            _loc5_ = _loc12_;
            _loc6_ = _loc13_;
            _loc7_ = _loc14_;
            _loc16_ = 0;
            while(_loc16_ < 20)
            {
               if(_loc16_ < 16)
               {
                  _loc17_[_loc16_] = param1[_loc11_ + _loc16_];
               }
               else
               {
                  _loc3_ = _loc17_[_loc16_ - 3] ^ _loc17_[_loc16_ - 8] ^ _loc17_[_loc16_ - 14] ^ _loc17_[_loc16_ - 16];
                  _loc17_[_loc16_] = _loc3_ << 1 | _loc3_ >>> 31;
               }
               _loc3_ = (_loc2_ << 5 | _loc2_ >>> 27) + (_loc4_ & _loc5_ | ~_loc4_ & _loc6_) + _loc7_ + _loc17_[_loc16_] + 1518500249;
               _loc7_ = _loc6_;
               _loc6_ = _loc5_;
               _loc5_ = _loc4_ << 30 | _loc4_ >>> 2;
               _loc4_ = _loc2_;
               _loc2_ = _loc3_;
               _loc16_++;
            }
            while(_loc16_ < 40)
            {
               _loc3_ = _loc17_[_loc16_ - 3] ^ _loc17_[_loc16_ - 8] ^ _loc17_[_loc16_ - 14] ^ _loc17_[_loc16_ - 16];
               _loc17_[_loc16_] = _loc3_ << 1 | _loc3_ >>> 31;
               _loc3_ = (_loc2_ << 5 | _loc2_ >>> 27) + (_loc4_ ^ _loc5_ ^ _loc6_) + _loc7_ + _loc17_[_loc16_] + 1859775393;
               _loc7_ = _loc6_;
               _loc6_ = _loc5_;
               _loc5_ = _loc4_ << 30 | _loc4_ >>> 2;
               _loc4_ = _loc2_;
               _loc2_ = _loc3_;
               _loc16_++;
            }
            while(_loc16_ < 60)
            {
               _loc3_ = _loc17_[_loc16_ - 3] ^ _loc17_[_loc16_ - 8] ^ _loc17_[_loc16_ - 14] ^ _loc17_[_loc16_ - 16];
               _loc17_[_loc16_] = _loc3_ << 1 | _loc3_ >>> 31;
               _loc3_ = (_loc2_ << 5 | _loc2_ >>> 27) + (_loc4_ & _loc5_ | _loc4_ & _loc6_ | _loc5_ & _loc6_) + _loc7_ + _loc17_[_loc16_] + 2.400959708E9;
               _loc7_ = _loc6_;
               _loc6_ = _loc5_;
               _loc5_ = _loc4_ << 30 | _loc4_ >>> 2;
               _loc4_ = _loc2_;
               _loc2_ = _loc3_;
               _loc16_++;
            }
            while(_loc16_ < 80)
            {
               _loc3_ = _loc17_[_loc16_ - 3] ^ _loc17_[_loc16_ - 8] ^ _loc17_[_loc16_ - 14] ^ _loc17_[_loc16_ - 16];
               _loc17_[_loc16_] = _loc3_ << 1 | _loc3_ >>> 31;
               _loc3_ = (_loc2_ << 5 | _loc2_ >>> 27) + (_loc4_ ^ _loc5_ ^ _loc6_) + _loc7_ + _loc17_[_loc16_] + 3.395469782E9;
               _loc7_ = _loc6_;
               _loc6_ = _loc5_;
               _loc5_ = _loc4_ << 30 | _loc4_ >>> 2;
               _loc4_ = _loc2_;
               _loc2_ = _loc3_;
               _loc16_++;
            }
            _loc9_ = _loc9_ + _loc2_;
            _loc10_ = _loc10_ + _loc4_;
            _loc12_ = _loc12_ + _loc5_;
            _loc13_ = _loc13_ + _loc6_;
            _loc14_ = _loc14_ + _loc7_;
            _loc11_ = _loc11_ + 16;
         }
         var _loc8_:ByteArray = new ByteArray();
         _loc8_.writeInt(_loc9_);
         _loc8_.writeInt(_loc10_);
         _loc8_.writeInt(_loc12_);
         _loc8_.writeInt(_loc13_);
         _loc8_.writeInt(_loc14_);
         _loc8_.position = 0;
         digest = new ByteArray();
         digest.writeBytes(_loc8_);
         digest.position = 0;
         return _loc8_;
      }
      
      private static function createBlocksFromByteArray(param1:ByteArray) : Array
      {
         var _loc4_:* = 0;
         var _loc5_:int = param1.position;
         param1.position = 0;
         var _loc3_:Array = [];
         var _loc2_:int = param1.length * 8;
         var _loc6_:* = 255;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            var _loc7_:* = _loc4_ >> 5;
            var _loc8_:* = _loc3_[_loc7_] | (param1.readInt() & _loc6_) << 24 - _loc4_ % 32;
            _loc3_[_loc7_] = _loc8_;
            _loc4_ = _loc4_ + 8;
         }
         _loc8_ = _loc2_ >> 5;
         _loc7_ = _loc3_[_loc8_] | 128 << 24 - _loc2_ % 32;
         _loc3_[_loc8_] = _loc7_;
         _loc3_[(_loc2_ + 64 >> 9 << 4) + 15] = _loc2_;
         param1.position = _loc5_;
         return _loc3_;
      }
      
      private static function createBlocksFromString(param1:String) : Array
      {
         var _loc4_:* = 0;
         var _loc3_:Array = [];
         var _loc2_:int = param1.length * 8;
         var _loc5_:* = 255;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            var _loc6_:* = _loc4_ >> 5;
            var _loc7_:* = _loc3_[_loc6_] | (param1.charCodeAt(_loc4_ / 8) & _loc5_) << 24 - _loc4_ % 32;
            _loc3_[_loc6_] = _loc7_;
            _loc4_ = _loc4_ + 8;
         }
         _loc7_ = _loc2_ >> 5;
         _loc6_ = _loc3_[_loc7_] | 128 << 24 - _loc2_ % 32;
         _loc3_[_loc7_] = _loc6_;
         _loc3_[(_loc2_ + 64 >> 9 << 4) + 15] = _loc2_;
         return _loc3_;
      }
   }
}
