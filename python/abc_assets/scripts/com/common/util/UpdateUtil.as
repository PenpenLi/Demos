package com.common.util
{
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   import flash.filesystem.FileStream;
   import nochump.util.zip.ZipFile;
   import flash.events.StatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   import com.unzip.ane.ZipExtension;
   import nochump.util.zip.ZipEntry;
   
   public class UpdateUtil
   {
      
      private static var instance:com.common.util.UpdateUtil = null;
       
      private var urlReq:URLRequest;
      
      private var urlStream:URLStream;
      
      private var fileData:ByteArray;
      
      private var fileStream:FileStream;
      
      private var assetsFile:String;
      
      private var isUnZip:Boolean;
      
      private var isSave:Boolean;
      
      private var callBack:Function;
      
      private var zipFile:ZipFile;
      
      public function UpdateUtil()
      {
         urlStream = new URLStream();
         fileData = new ByteArray();
         fileStream = new FileStream();
         super();
         initLoad();
         ZipExtension.getInstance().addEventListener("status",handler_status);
      }
      
      public static function getInstance() : com.common.util.UpdateUtil
      {
         return instance || new com.common.util.UpdateUtil();
      }
      
      protected function handler_status(param1:StatusEvent) : void
      {
         if(param1.code == "删除目录成功:")
         {
            callBack();
         }
      }
      
      public function setUrl(param1:String, param2:String, param3:Boolean, param4:Boolean, param5:Function) : void
      {
         trace("下载路径：" + param1);
         isUnZip = param3;
         assetsFile = param2;
         isSave = param4;
         urlReq = new URLRequest(param1);
         urlStream.load(urlReq);
         callBack = param5;
      }
      
      private function initLoad() : void
      {
         urlStream.addEventListener("progress",progess);
         urlStream.addEventListener("complete",complete);
         urlStream.addEventListener("ioError",error);
      }
      
      protected function error(param1:IOErrorEvent) : void
      {
         UpdateHandler.tipTF1.text = "服务器或者网络错误，返回键退出";
         UpdateHandler.tipTF2.text = "网";
      }
      
      protected function progess(param1:ProgressEvent) : void
      {
         var _loc3_:Number = param1.bytesLoaded / 1048576;
         var _loc2_:Number = param1.bytesTotal / 1048576;
         if(isSave)
         {
            UpdateHandler.tipTF1.text = "正在下载最新资源 " + _loc3_.toFixed(3) + "m/" + _loc2_.toFixed(3) + "m";
         }
         UpdateHandler.tipTF2.text = param1.bytesLoaded / param1.bytesTotal * 100 + "%";
      }
      
      private function complete(param1:Event) : void
      {
         urlReq = null;
         urlStream.readBytes(fileData,0,urlStream.bytesAvailable);
         if(isSave)
         {
            writeAirFile();
            if(fileData != null)
            {
               fileData.clear();
            }
         }
         else
         {
            UpdateHandler.configInfoFromSever = JSON.parse(fileData.readUTFBytes(fileData.length));
            fileData.clear();
            callBack();
         }
      }
      
      private function writeAirFile() : void
      {
         var _loc1_:* = null;
         if(isUnZip)
         {
            _loc1_ = File.applicationStorageDirectory.resolvePath(assetsFile);
            doUnZip(_loc1_);
         }
         else
         {
            _loc1_ = File.applicationStorageDirectory.resolvePath(assetsFile);
            fileStream.open(_loc1_,"write");
            fileStream.writeBytes(fileData,0,fileData.length);
            fileStream.close();
            callBack();
         }
         _loc1_ = null;
      }
      
      private function doUnZip(param1:File) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         if(Capabilities.os.toLocaleUpperCase().indexOf("ANDROID") != -1 || Capabilities.os.toLocaleUpperCase().indexOf("LINUX") != -1)
         {
            _loc2_ = File.applicationStorageDirectory.resolvePath("temp.zip");
            fileStream.open(_loc2_,"write");
            fileStream.writeBytes(fileData,0,fileData.length);
            fileStream.close();
            ZipExtension.getInstance().UnZip(param1.nativePath,_loc2_.nativePath);
            _loc2_ = null;
         }
         else
         {
            zipFile = new ZipFile(fileData);
            _loc5_ = 0;
            while(_loc5_ < zipFile.entries.length)
            {
               _loc6_ = zipFile.entries[_loc5_] as ZipEntry;
               _loc6_.crc;
               if(!_loc6_.isDirectory())
               {
                  _loc7_ = param1;
                  _loc4_ = new File();
                  _loc4_ = _loc7_.resolvePath(_loc6_.name);
                  _loc3_ = new FileStream();
                  _loc3_.open(_loc4_,"write");
                  _loc3_.writeBytes(zipFile.getInput(_loc6_));
                  _loc3_.close();
                  _loc4_ = null;
               }
               _loc5_++;
            }
            callBack();
         }
      }
      
      public function dispose() : void
      {
         urlStream = null;
         fileData = null;
         fileStream = null;
      }
   }
}
