package nochump.util.zip
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   
   public class ZipFile
   {
       
      private var buf:ByteArray;
      
      private var entryList:Array;
      
      private var entryTable:Dictionary;
      
      private var locOffsetTable:Dictionary;
      
      public function ZipFile(param1:IDataInput)
      {
         super();
         buf = new ByteArray();
         buf.endian = "littleEndian";
         param1.readBytes(buf);
         readEntries();
      }
      
      public function get entries() : Array
      {
         return entryList;
      }
      
      public function get size() : uint
      {
         return entryList.length;
      }
      
      public function getEntry(param1:String) : ZipEntry
      {
         return entryTable[param1];
      }
      
      public function getInput(param1:ZipEntry) : ByteArray
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         buf.position = locOffsetTable[param1.name] + 30 - 2;
         var _loc3_:uint = buf.readShort();
         buf.position = buf.position + (param1.name.length + _loc3_);
         var _loc5_:ByteArray = new ByteArray();
         if(param1.compressedSize > 0)
         {
            buf.readBytes(_loc5_,0,param1.compressedSize);
         }
         switch(param1.method)
         {
            case 0:
               return _loc5_;
            case 8:
               _loc2_ = new ByteArray();
               _loc4_ = new Inflater();
               _loc4_.setInput(_loc5_);
               _loc4_.inflate(_loc2_);
               return _loc2_;
            default:
               throw new ZipError("invalid compression method");
         }
      }
      
      private function readEntries() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc1_:* = 0;
         var _loc2_:* = null;
         readEND();
         entryTable = new Dictionary();
         locOffsetTable = new Dictionary();
         _loc3_ = 0;
         while(_loc3_ < entryList.length)
         {
            _loc4_ = new ByteArray();
            _loc4_.endian = "littleEndian";
            buf.readBytes(_loc4_,0,46);
            if(_loc4_.readUnsignedInt() != 33639248)
            {
               throw new ZipError("invalid CEN header (bad signature)");
            }
            _loc4_.position = 28;
            _loc1_ = _loc4_.readUnsignedShort();
            if(_loc1_ == 0)
            {
               throw new ZipError("missing entry name");
            }
            _loc2_ = new ZipEntry(buf.readUTFBytes(_loc1_));
            _loc1_ = _loc4_.readUnsignedShort();
            _loc2_.extra = new ByteArray();
            if(_loc1_ > 0)
            {
               buf.readBytes(_loc2_.extra,0,_loc1_);
            }
            buf.position = buf.position + _loc4_.readUnsignedShort();
            _loc4_.position = 6;
            _loc2_.version = _loc4_.readUnsignedShort();
            _loc2_.flag = _loc4_.readUnsignedShort();
            if((_loc2_.flag & 1) == 1)
            {
               throw new ZipError("encrypted ZIP entry not supported");
            }
            _loc2_.method = _loc4_.readUnsignedShort();
            _loc2_.dostime = _loc4_.readUnsignedInt();
            _loc2_.crc = _loc4_.readUnsignedInt();
            _loc2_.compressedSize = _loc4_.readUnsignedInt();
            _loc2_.size = _loc4_.readUnsignedInt();
            entryList[_loc3_] = _loc2_;
            entryTable[_loc2_.name] = _loc2_;
            _loc4_.position = 42;
            locOffsetTable[_loc2_.name] = _loc4_.readUnsignedInt();
            _loc3_++;
         }
      }
      
      private function readEND() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.endian = "littleEndian";
         buf.position = findEND();
         buf.readBytes(_loc1_,0,22);
         _loc1_.position = 10;
         entryList = new Array(_loc1_.readUnsignedShort());
         _loc1_.position = 16;
         buf.position = _loc1_.readUnsignedInt();
      }
      
      private function findEND() : uint
      {
         var _loc1_:uint = buf.length - 22;
         var _loc2_:uint = Math.max(0,_loc1_ - 65535);
         _loc1_;
         while(_loc1_ >= _loc2_)
         {
            if(buf[_loc1_] == 80)
            {
               buf.position = _loc1_;
               if(buf.readUnsignedInt() == 101010256)
               {
                  return _loc1_;
               }
            }
            _loc1_--;
         }
         throw new ZipError("invalid zip");
      }
   }
}
