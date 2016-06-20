package lzm.util
{
   import flash.utils.ByteArray;
   
   public class XXTEA
   {
       
      public function XXTEA()
      {
         super();
      }
      
      public static function NetEncrypt(param1:String, param2:String) : String
      {
         var _loc3_:ByteArray = ToUtf8(param1);
         var _loc4_:ByteArray = ToUtf8(param2);
         if(_loc3_.length == 0)
         {
            return param1;
         }
         return Utf8toString(ToByteArray(Encrypt(ToUInt32Array(_loc3_,true),ToUInt32Array(_loc4_,false)),false));
      }
      
      public static function NetDecrypt(param1:String, param2:String) : String
      {
         var _loc7_:* = 0;
         var _loc3_:ByteArray = Base64.decodeToByteArray(param1);
         var _loc4_:ByteArray = ToUtf8(param2);
         if(_loc3_.length == 0)
         {
            return param1;
         }
         var _loc5_:Array = ToByteArray(Decrypt(ToUInt32Array(_loc3_,false),ToUInt32Array(_loc4_,false)),true);
         var _loc6_:ByteArray = new ByteArray();
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc6_[_loc7_] = _loc5_[_loc7_];
            _loc7_++;
         }
         return _loc6_.toString();
      }
      
      private static function ToUInt32Array(param1:ByteArray, param2:Boolean) : Array
      {
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:Array = [];
         var _loc4_:uint = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_[_loc6_ >>> 2] = _loc3_[_loc6_ >>> 2] | param1[_loc6_] << (_loc6_ & 3) << 3;
            _loc6_++;
         }
         if(param2)
         {
            _loc3_.push(_loc4_);
            _loc5_ = param1.length - 1;
            _loc3_[_loc5_ >>> 2] = _loc3_[_loc5_ >>> 2] | param1[_loc5_] << (_loc5_ & 3) << 3;
         }
         return _loc3_;
      }
      
      private static function Encrypt(param1:Array, param2:Array) : Array
      {
         var _loc11_:* = null;
         var _loc12_:* = 0;
         var _loc7_:int = param1.length - 1;
         if(_loc7_ < 1)
         {
            return param1;
         }
         if(param2.length < 4)
         {
            _loc11_ = [];
            _loc11_ = param2.slice();
            var param2:* = _loc11_;
         }
         while(param2.length < 4)
         {
            param2.push(0);
         }
         var _loc9_:uint = param1[_loc7_];
         var _loc10_:uint = param1[0];
         var _loc6_:* = 2654435769;
         var _loc8_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:* = 0;
         var _loc4_:int = 6 + 52 / (_loc7_ + 1);
         while(true)
         {
            _loc4_--;
            if(_loc4_ <= 0)
            {
               break;
            }
            _loc8_ = _loc8_ + _loc6_;
            _loc3_ = _loc8_ >>> 2 & 3;
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc10_ = param1[_loc5_ + 1];
               var _loc13_:* = _loc5_;
               var _loc14_:* = param1[_loc13_] + ((_loc9_ >>> 5 ^ _loc10_ << 2) + (_loc10_ >>> 3 ^ _loc9_ << 4) ^ (_loc8_ ^ _loc10_) + (param2[_loc5_ & 3 ^ _loc3_] ^ _loc9_));
               param1[_loc13_] = _loc14_;
               _loc9_ = _loc14_;
               _loc5_++;
            }
            _loc10_ = param1[0];
            _loc14_ = _loc7_;
            _loc13_ = param1[_loc14_] + ((_loc9_ >>> 5 ^ _loc10_ << 2) + (_loc10_ >>> 3 ^ _loc9_ << 4) ^ (_loc8_ ^ _loc10_) + (param2[_loc5_ & 3 ^ _loc3_] ^ _loc9_));
            param1[_loc14_] = _loc13_;
            _loc9_ = _loc13_;
         }
         _loc12_ = 0;
         while(_loc12_ < param1.length)
         {
            param1[_loc12_] = param1[_loc12_];
            _loc12_++;
         }
         return param1;
      }
      
      private static function Decrypt(param1:Array, param2:Array) : Array
      {
         var _loc11_:* = null;
         var _loc8_:* = 0;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:int = param1.length - 1;
         if(_loc7_ < 1)
         {
            return param1;
         }
         if(param2.length < 4)
         {
            _loc11_ = [];
            _loc11_ = param2.slice();
            var param2:* = _loc11_;
         }
         while(param2.length < 4)
         {
            param2.push(0);
         }
         var _loc9_:uint = param1[_loc7_];
         var _loc10_:uint = param1[0];
         var _loc6_:* = 2654435769;
         var _loc4_:int = 6 + 52 / (_loc7_ + 1);
         _loc8_ = _loc4_ * _loc6_;
         while(_loc8_ != 0)
         {
            _loc3_ = _loc8_ >>> 2 & 3;
            _loc5_ = _loc7_;
            while(_loc5_ > 0)
            {
               _loc9_ = param1[_loc5_ - 1];
               var _loc12_:* = _loc5_;
               var _loc13_:* = param1[_loc12_] - ((_loc9_ >>> 5 ^ _loc10_ << 2) + (_loc10_ >>> 3 ^ _loc9_ << 4) ^ (_loc8_ ^ _loc10_) + (param2[_loc5_ & 3 ^ _loc3_] ^ _loc9_));
               param1[_loc12_] = _loc13_;
               _loc10_ = _loc13_;
               _loc5_--;
            }
            _loc9_ = param1[_loc7_];
            _loc13_ = 0;
            _loc12_ = param1[_loc13_] - ((_loc9_ >>> 5 ^ _loc10_ << 2) + (_loc10_ >>> 3 ^ _loc9_ << 4) ^ (_loc8_ ^ _loc10_) + (param2[_loc5_ & 3 ^ _loc3_] ^ _loc9_));
            param1[_loc13_] = _loc12_;
            _loc10_ = _loc12_;
            _loc8_ = _loc8_ - _loc6_;
         }
         return param1;
      }
      
      private static function ToByteArray(param1:Array, param2:Boolean) : Array
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:* = 0;
         if(param2)
         {
            _loc5_ = param1[param1.length - 1];
         }
         else
         {
            _loc5_ = param1.length << 2;
         }
         var _loc3_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = param1[_loc6_ >>> 2] >>> (_loc6_ & 3) << 3 & 255;
            _loc3_.push(_loc4_);
            _loc6_++;
         }
         return _loc3_;
      }
      
      private static function ToUtf8(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      private static function Utf8toString(param1:Array) : String
      {
         var _loc3_:* = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeByte(param1[_loc3_]);
            _loc3_++;
         }
         _loc2_.position = 0;
         if(_loc2_.bytesAvailable > 0)
         {
            return Base64.encodeByteArray(_loc2_);
         }
         return "";
      }
   }
}
