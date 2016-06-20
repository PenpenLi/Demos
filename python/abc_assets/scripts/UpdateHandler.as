package
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.events.KeyboardEvent;
   import flash.desktop.NativeApplication;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import com.common.util.UpdateUtil;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   
   public class UpdateHandler extends Sprite
   {
      
      public static var version:String = "1.1.0";
      
      public static var configInfoFromSever:Object;
      
      public static var configInfoFromLocal:Object;
      
      private static var instance:UpdateHandler;
      
      public static var tipTF1:TextField;
      
      public static var tipTF2:TextField;
      
      public static var tipsWin:Sprite;
       
      private var diffAssets:Array;
      
      private var callBack:Function;
      
      public function UpdateHandler()
      {
         diffAssets = [];
         super();
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         version = _loc1_._loc2_::versionNumber;
      }
      
      public static function getInstance() : UpdateHandler
      {
         return instance || new UpdateHandler();
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 16777238 || param1.keyCode == 32)
         {
            NativeApplication.nativeApplication.exit();
         }
      }
      
      public function initUpdate(param1:Object, param2:Object, param3:TextField, param4:TextField, param5:Sprite) : void
      {
         configInfoFromLocal = param1;
         configInfoFromSever = param2;
         tipTF1 = param3;
         tipTF2 = param4;
         tipsWin = param5;
      }
      
      public function isHasUpdate() : Boolean
      {
         if(configInfoFromLocal.totalVersion != configInfoFromSever.totalVersion)
         {
            tipTF1.text = "正在下载最新资源";
            getDiffAssets();
            return true;
         }
         saveConfigInfo();
         return false;
      }
      
      public function getAssetsFromSever(param1:Function) : void
      {
         callBack = param1;
         if(diffAssets.length > 3)
         {
            tipsWin.visible = true;
            (tipsWin.getChildByName("titletipTF") as TextField).text = "有" + diffAssets.length + "个文件需要更新，是否继续？";
            (tipsWin.getChildByName("continueBtn") as SimpleButton).addEventListener("click",continueUpdate);
            (tipsWin.getChildByName("cancelBtn") as SimpleButton).addEventListener("click",cancelUpdate);
         }
         else
         {
            doDownload();
         }
      }
      
      protected function continueUpdate(param1:MouseEvent) : void
      {
         tipsWin.parent.removeChild(tipsWin);
         tipsWin = null;
         doDownload();
      }
      
      protected function cancelUpdate(param1:MouseEvent) : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      private function doDownload() : void
      {
         if(diffAssets.length > 0)
         {
            trace(diffAssets[0].assetsSever);
            UpdateUtil.getInstance().setUrl(diffAssets[0].assetsSever + ".zip",diffAssets[0].assetsFile,true,true,loadNextAssets);
         }
         else
         {
            saveConfigInfo();
            UpdateUtil.getInstance().dispose();
            callBack();
         }
      }
      
      private function loadNextAssets() : void
      {
         diffAssets.splice(0,1);
         doDownload();
      }
      
      private function saveConfigInfo() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath("assets/AssetsConfig.json");
         trace(_loc1_.nativePath + ":可用目录");
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,"write");
         _loc2_.writeUTFBytes(JSON.stringify(configInfoFromSever));
         _loc2_.close();
         _loc2_ = null;
         _loc1_ = null;
      }
      
      private function getDiffAssets() : void
      {
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = false;
         var _loc2_:Array = [];
         var _loc1_:Array = [];
         var _loc3_:Array = [];
         var _loc5_:Array = [];
         _loc2_ = configInfoFromLocal.ui;
         _loc3_ = configInfoFromLocal.otherAssets;
         _loc1_ = configInfoFromSever.ui;
         _loc5_ = configInfoFromSever.otherAssets;
         diffAssets = [];
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc7_ = true;
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               if(_loc1_[_loc4_].assetsName == _loc2_[_loc6_].assetsName)
               {
                  if(_loc1_[_loc4_].assetsVersion != _loc2_[_loc6_].assetsVersion && _loc1_[_loc4_].assetsType == 1)
                  {
                     if((_loc1_[_loc4_].bigVersion as Array).indexOf(version) != -1)
                     {
                        diffAssets.push(_loc1_[_loc4_]);
                     }
                  }
                  _loc7_ = false;
                  break;
               }
               _loc6_++;
            }
            if(_loc1_[_loc4_].assetsType == 0)
            {
               _loc7_ = false;
            }
            if(_loc7_)
            {
               if((_loc1_[_loc4_].bigVersion as Array).indexOf(version) != -1)
               {
                  diffAssets.push(_loc1_[_loc4_]);
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc7_ = true;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               if(_loc5_[_loc4_].assetsName == _loc3_[_loc6_].assetsName)
               {
                  if(_loc5_[_loc4_].assetsVersion != _loc3_[_loc6_].assetsVersion && _loc5_[_loc4_].assetsType == 1)
                  {
                     if((_loc5_[_loc4_].bigVersion as Array).indexOf(version) != -1)
                     {
                        diffAssets.push(_loc5_[_loc4_]);
                     }
                  }
                  _loc7_ = false;
                  break;
               }
               _loc6_++;
            }
            if(_loc5_[_loc4_].assetsType == 0)
            {
               _loc7_ = false;
            }
            if(_loc7_)
            {
               if((_loc5_[_loc4_].bigVersion as Array).indexOf(version) != -1)
               {
                  diffAssets.push(_loc5_[_loc4_]);
               }
            }
            _loc4_++;
         }
      }
   }
}
