package com.common.net
{
   import flash.events.EventDispatcher;
   import flash.concurrent.Mutex;
   import flash.net.Socket;
   import flash.utils.Dictionary;
   import crypto.certs.hurlant.crypto.symmetric.ECBMode;
   import crypto.certs.hurlant.crypto.symmetric.AESKey;
   import flash.system.MessageChannel;
   import flash.system.Worker;
   import flash.system.WorkerDomain;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import com.common.util.loading.NETLoading;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import crypto.certs.hurlant.util.Base64;
   import flash.events.ProgressEvent;
   import com.mvc.models.proxy.login.LoginPro;
   import com.common.util.loading.GameLoading;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import flash.events.IOErrorEvent;
   import lzm.util.OSUtil;
   import com.unzip.ane.ZipExtension;
   
   public class Client extends EventDispatcher
   {
      
      private static var instance:com.common.net.Client = null;
      
      private static const HEAD_LENGTH:int = 4;
      
      public static const CONNECT_COMPLETE:String = "CONNECT_COMPLETE";
      
      public static var _mutex:Mutex;
       
      private var socket:Socket;
      
      private var callObjs:Dictionary;
      
      private var msgLen:int;
      
      private var isFirstLoad:Boolean = true;
      
      private var timeDiff:Number;
      
      private var sendNum:int = 0;
      
      public var _host:String;
      
      public var _port:int;
      
      private var _reConnectCount:int = 0;
      
      private var calculatorTime:Number = 0;
      
      private var isSplitPack:Boolean;
      
      private var key:String = "jydasai38hao1616";
      
      private var ebcMode:ECBMode;
      
      private var desKey:AESKey;
      
      private var currentNote:int;
      
      protected var mainToWorker:MessageChannel;
      
      protected var workerToMain:MessageChannel;
      
      protected var worker:Worker;
      
      public function Client()
      {
         super();
         initSocket();
         initEcbMode();
         var _loc1_:* = true;
         if(OSUtil.isWindows())
         {
            _loc1_ = true;
         }
         else if(ZipExtension.getInstance().getCpuNum() > 1)
         {
            _loc1_ = true;
            ZipExtension.getInstance().dispose();
         }
         else
         {
            _loc1_ = false;
            ZipExtension.getInstance().dispose();
         }
         _loc1_ = false;
         if(_loc1_)
         {
            initWorker();
         }
         Config.stage.addEventListener("enterFrame",heartPackHandler);
      }
      
      public static function getInstance() : com.common.net.Client
      {
         return instance || new com.common.net.Client();
      }
      
      private function initSocket() : void
      {
         socket = new Socket();
         socket.addEventListener("socketData",dataHandler);
         socket.addEventListener("connect",connectHandler);
         socket.addEventListener("close",closeHandler);
         socket.addEventListener("ioError",catchError);
      }
      
      public function connect(param1:String = null, param2:int = 0) : void
      {
         socket.connect(param1,param2);
      }
      
      private function initWorker() : void
      {
         worker = WorkerDomain.current.createWorker(Workers.Decrypt);
         mainToWorker = Worker.current.createMessageChannel(worker);
         workerToMain = worker.createMessageChannel(Worker.current);
         _mutex = new Mutex();
         worker.setSharedProperty("mainToWorker",mainToWorker);
         worker.setSharedProperty("workerToMain",workerToMain);
         worker.setSharedProperty("mutex",_mutex);
         workerToMain.addEventListener("channelMessage",onWorkerToMain);
         worker.start();
      }
      
      protected function onWorkerToMain(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         while(workerToMain.messageAvailable)
         {
            _loc2_ = workerToMain.receive();
            _loc3_ = _loc2_.toString();
            _loc2_.clear();
            _loc2_ = null;
            parseMessage(_loc3_);
         }
      }
      
      private function parseMessage(param1:String) : void
      {
         var _loc2_:Object = JSON.parse(param1);
         var _loc3_:int = _loc2_.msgId;
         if(_loc3_ == currentNote && _loc3_ != 5555)
         {
            NETLoading.removeLoading();
         }
         if(_loc3_ != 5555)
         {
            if(_loc2_.status == "error")
            {
               LogUtil("接收消息号（错误）：" + _loc3_,JSON.stringify(_loc2_));
               Alert.show(_loc2_.msgId + "错误信息:" + _loc2_.data.msg,"",new ListCollection([{"label":"确定"}]));
               return;
            }
            LogUtil("接收消息号：" + _loc3_);
            callObjs["note" + _loc3_]["note" + _loc3_].apply(null,[_loc2_]);
         }
      }
      
      private function initEcbMode() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes(key);
         desKey = new AESKey(_loc1_);
         ebcMode = new ECBMode(desKey);
      }
      
      public function addCallObj(param1:String, param2:Object) : void
      {
         if(callObjs == null)
         {
            callObjs = new Dictionary(true);
         }
         callObjs[param1] = param2;
      }
      
      public function sendBytes(param1:Object, param2:Boolean = true) : Boolean
      {
         if(!socket.connected)
         {
            return false;
         }
         if(param1.msgId != 5555)
         {
            currentNote = param1.msgId;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(JSON.stringify(param1));
         var param1:Object = null;
         return writePack(_loc3_,param2);
      }
      
      private function writePack(param1:ByteArray, param2:Boolean) : Boolean
      {
         if(!socket.connected)
         {
            return false;
         }
         if(param2)
         {
            NETLoading.addLoading();
         }
         ebcMode.encrypt(param1);
         var _loc3_:String = Base64.encodeByteArray(param1);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUnsignedInt(_loc3_.length);
         _loc4_.writeUTFBytes(_loc3_);
         _loc4_.compress();
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeInt(_loc4_.length);
         _loc5_.writeBytes(_loc4_);
         socket.writeBytes(_loc5_);
         socket.flush();
         param1.clear();
         _loc4_.clear();
         _loc5_.clear();
         return true;
      }
      
      public function convertByteArrayToString(param1:ByteArray) : String
      {
         var _loc2_:* = null;
         if(param1)
         {
            param1.position = 0;
            _loc2_ = param1.readUTF();
         }
         return _loc2_;
      }
      
      private function dataHandler(param1:ProgressEvent) : void
      {
         parseNetData();
      }
      
      private function parseNetData() : void
      {
         var _loc6_:* = 0;
         var _loc5_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc1_:* = null;
         if(socket.bytesAvailable >= 4)
         {
            if(!isSplitPack)
            {
               msgLen = socket.readInt();
            }
            if(msgLen == 0)
            {
               return;
            }
            _loc6_ = socket.bytesAvailable;
            if(_loc6_ >= msgLen)
            {
               isSplitPack = false;
               _loc5_ = new ByteArray();
               socket.readBytes(_loc5_,0,msgLen);
               _loc5_.uncompress();
               if(_mutex != null)
               {
                  _loc5_.shareable = true;
                  mainToWorker.send(_loc5_);
               }
               else
               {
                  _loc2_ = _loc5_.readUnsignedInt();
                  _loc3_ = _loc5_.readUTFBytes(_loc2_);
                  _loc5_.clear();
                  _loc5_ = null;
                  _loc4_ = Base64.decodeToByteArray(_loc3_);
                  ebcMode.decrypt(_loc4_);
                  _loc1_ = _loc4_.toString();
                  _loc4_.clear();
                  _loc4_ = null;
                  parseMessage(_loc1_);
               }
            }
            else
            {
               isSplitPack = true;
            }
         }
         if(socket.connected && !isSplitPack)
         {
            if(socket.bytesAvailable >= 4)
            {
               parseNetData();
            }
         }
      }
      
      protected function connectClose() : void
      {
         socket.close();
         LogUtil("---------------链接断开-------------",LoginPro.isMaintenance);
         if(!LoginPro.isMaintenance)
         {
            CheckNetStatus.monitor.start();
            if(!CheckNetStatus.isHaveConnect)
            {
               if(!GameLoading.getIntance().isLoadingAssets)
               {
                  CheckNetStatus.reConnect();
               }
               else
               {
                  GameLoading.getIntance().isTellNetDisconnect = true;
               }
            }
         }
         removeLoading();
      }
      
      private function closeHandler(param1:Event) : void
      {
         this.connectClose();
      }
      
      protected function connectComplete() : void
      {
         LogUtil("服务器已连接");
         CheckNetStatus.init();
         _reConnectCount = §§dup()._reConnectCount + 1;
         removeLoading();
         dispatchEvent(new Event("CONNECT_COMPLETE"));
         WorldTime.getInstance().addEventListener("TIME_CHANGE",heartPackHandler);
      }
      
      private function connectHandler(param1:Event) : void
      {
         this.connectComplete();
      }
      
      protected function catchError(param1:IOErrorEvent) : void
      {
         LogUtil("异常");
         removeLoading();
      }
      
      private function removeLoading() : void
      {
      }
      
      protected function reConnectHandler(param1:Event) : void
      {
      }
      
      private function heartPackHandler() : void
      {
         if(calculatorTime == 0)
         {
            calculatorTime = new Date().getTime();
         }
         var _loc1_:Number = new Date().getTime();
         if(_loc1_ - calculatorTime > 10000)
         {
            writeHeart();
            calculatorTime = _loc1_;
         }
      }
      
      private function writeHeart() : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc1_:Object = {};
         _loc1_.msgId = 5555;
         sendBytes(_loc1_,false);
      }
      
      public function get connected() : Boolean
      {
         if(socket)
         {
            return socket.connected;
         }
         return false;
      }
      
      public function newSocket() : void
      {
         socket.removeEventListener("socketData",dataHandler);
         socket.removeEventListener("connect",connectHandler);
         socket.removeEventListener("close",closeHandler);
         socket.removeEventListener("ioError",catchError);
         socket = null;
         initSocket();
      }
      
      public function close() : void
      {
         LogUtil("关闭socket链接");
         if(socket)
         {
            socket.close();
         }
      }
   }
}
