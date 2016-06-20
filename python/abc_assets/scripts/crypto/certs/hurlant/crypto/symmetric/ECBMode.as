package crypto.certs.hurlant.crypto.symmetric
{
   import flash.utils.ByteArray;
   import crypto.certs.hurlant.util.Memory;
   
   public class ECBMode implements IMode, ICipher
   {
       
      private var key:crypto.certs.hurlant.crypto.symmetric.ISymmetricKey;
      
      private var padding:crypto.certs.hurlant.crypto.symmetric.IPad;
      
      public function ECBMode(param1:crypto.certs.hurlant.crypto.symmetric.ISymmetricKey, param2:crypto.certs.hurlant.crypto.symmetric.IPad = null)
      {
         super();
         this.key = param1;
         if(param2 == null)
         {
            var param2:crypto.certs.hurlant.crypto.symmetric.IPad = new PKCS5(param1.getBlockSize());
         }
         else
         {
            param2.setBlockSize(param1.getBlockSize());
         }
         this.padding = param2;
      }
      
      public function getBlockSize() : uint
      {
         return key.getBlockSize();
      }
      
      public function encrypt(param1:ByteArray) : void
      {
         var _loc4_:* = 0;
         padding.pad(param1);
         param1.position = 0;
         var _loc5_:uint = key.getBlockSize();
         var _loc3_:ByteArray = new ByteArray();
         var _loc2_:ByteArray = new ByteArray();
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.length = 0;
            param1.readBytes(_loc3_,0,_loc5_);
            key.encrypt(_loc3_);
            _loc2_.writeBytes(_loc3_);
            _loc4_ = _loc4_ + _loc5_;
         }
         param1.length = 0;
         param1.writeBytes(_loc2_);
      }
      
      public function decrypt(param1:ByteArray) : void
      {
         var _loc4_:* = 0;
         param1.position = 0;
         var _loc5_:uint = key.getBlockSize();
         if(param1.length % _loc5_ != 0)
         {
            throw new Error("ECB mode cipher length must be a multiple of blocksize " + _loc5_);
         }
         var _loc3_:ByteArray = new ByteArray();
         var _loc2_:ByteArray = new ByteArray();
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.length = 0;
            param1.readBytes(_loc3_,0,_loc5_);
            key.decrypt(_loc3_);
            _loc2_.writeBytes(_loc3_);
            _loc4_ = _loc4_ + _loc5_;
         }
         padding.unpad(_loc2_);
         param1.length = 0;
         param1.writeBytes(_loc2_);
      }
      
      public function dispose() : void
      {
         key.dispose();
         key = null;
         padding = null;
         Memory.gc();
      }
      
      public function toString() : String
      {
         return key.toString() + "-ecb";
      }
   }
}
