package com.common.managers
{
   import lzm.starling.swf.SwfAssetManager;
   import flash.filesystem.File;
   import flash.utils.getTimer;
   import starling.utils.formatString;
   import lzm.starling.STLConstant;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.net.Client;
   import com.common.util.loading.GameLoading;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.fighting.FightingPro;
   import lzm.util.OSUtil;
   import flash.desktop.NativeApplication;
   
   public class LoadSwfAssetsManager
   {
      
      private static var instance:com.common.managers.LoadSwfAssetsManager = null;
      
      public static var isLoading:Boolean;
       
      private var _assets:SwfAssetManager;
      
      private var file:File;
      
      private var rootClass:Game;
      
      private var fileStr:String;
      
      private var assetsArray:Array;
      
      private var version:String;
      
      public function LoadSwfAssetsManager()
      {
         super();
         _assets = new SwfAssetManager(STLConstant.scale);
         _assets.verbose = true;
         rootClass = Config.starling.root as Game;
         if(OSUtil.isWindows() || OSUtil.isIPhone())
         {
            fileStr = "PC";
         }
         if(OSUtil.isAndriod())
         {
            fileStr = "andriod";
         }
         assetsArray = Config.configInfo.ui;
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         version = _loc1_._loc2_::versionNumber;
      }
      
      public static function getInstance() : com.common.managers.LoadSwfAssetsManager
      {
         return instance || new com.common.managers.LoadSwfAssetsManager();
      }
      
      public function removeAsset(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            LogUtil("移除了SWF资源" + param1[_loc2_]);
            _assets.removeSwf(param1[_loc2_],true);
            _loc2_++;
         }
      }
      
      public function addAssets(param1:Array, param2:Boolean = false, param3:int = 30) : void
      {
         assetName = param1;
         isShowLoading = param2;
         fps = param3;
         var now:Number = getTimer();
         var i:int = 0;
         while(i < assetName.length)
         {
            setFile(assetName[i]);
            _assets.enqueue(assetName[i],[file.resolvePath(formatString("assets/ui/" + fileStr + "/" + assetName[i],STLConstant.scale))],fps);
            file = null;
            i = i + 1;
         }
         rootClass.touchable = false;
         PlayerVO.isAcceptPvp = false;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(isShowLoading)
            {
               GameLoading.getIntance().updateProgress(param1);
            }
            if(param1 == 1)
            {
               rootClass.touchable = true;
               PlayerVO.isAcceptPvp = true;
               GameLoading.getIntance().removeLoading();
               loadAssetComplete();
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      private function setFile(param1:String) : void
      {
         var _loc2_:Object = getAssetsInfo(param1);
         if(_loc2_ == null)
         {
            file = File.applicationDirectory;
            return;
         }
         if(_loc2_.assetsType == 0 || (_loc2_.bigVersion as Array).indexOf(version) == -1)
         {
            file = File.applicationDirectory;
         }
         else
         {
            file = File.applicationStorageDirectory;
         }
      }
      
      private function getAssetsInfo(param1:String) : Object
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < assetsArray.length)
         {
            if(assetsArray[_loc2_].assetsName == param1)
            {
               return assetsArray[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addSkillAssets(param1:Array, param2:Boolean = false) : void
      {
         assetName = param1;
         isLoading = param2;
         setFile("skill");
         var i:int = 0;
         while(i < assetName.length)
         {
            var resource:Array = [file.resolvePath(formatString("assets/ui/" + fileStr + "/skill/" + assetName[i],STLConstant.scale))];
            LogUtil(resource[resource.length - 1].exists + ":是否存在技能资源:" + assetName[i]);
            if(resource[resource.length - 1].exists)
            {
               _assets.enqueue(assetName[i],resource,15);
            }
            i = i + 1;
         }
         if(isLoading)
         {
            if(!resource[resource.length - 1].exists)
            {
               loadAssetComplete();
               return;
            }
            rootClass.touchable = false;
            if(Client._mutex)
            {
               Client._mutex.lock();
            }
            _assets.loadQueue(function(param1:Number):void
            {
               GameLoading.getIntance().updateProgress(param1);
               if(param1 == 1)
               {
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  rootClass.touchable = true;
                  loadAssetComplete();
               }
            },function():void
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
            });
         }
         file = null;
      }
      
      public function addCommentAssets() : void
      {
         LogUtil("assets/ui/" + fileStr + "/login");
         var arr:Array = ["common","chat","bag","prop","npcMin"];
         var i:int = 0;
         while(i < arr.length)
         {
            setFile(arr[i]);
            _assets.enqueue(arr[i],[file.resolvePath(formatString("assets/ui/" + fileStr + "/" + arr[i],STLConstant.scale))],60);
            file = null;
            i = i + 1;
         }
         setFile("elfPanel");
         _assets.enqueue("elfPanel",[file.resolvePath(formatString("assets/ui/" + fileStr + "/elfPanel",STLConstant.scale))],30);
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            GameLoading.getIntance().updateProgress(param1);
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               loadAssetComplete();
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      private function loadAssetComplete() : void
      {
         EventCenter.dispatchEvent("load_swf_asset_complete");
         isLoading = false;
         if(FightingPro.isPvpOver)
         {
            if(FightingPro.isOutLineOfSelf)
            {
               FightingPro.dropLineOfSelfHandler();
            }
            else
            {
               FightingPro.dropLineHandler();
            }
         }
      }
      
      public function get assets() : SwfAssetManager
      {
         return _assets;
      }
   }
}
