package
{
   import lzm.starling.STLStarup;
   import flash.display.Stage;
   import flash.events.StageOrientationEvent;
   import flash.filesystem.File;
   import flash.desktop.NativeApplication;
   import com.common.sdk.SDKManager;
   import flash.utils.getTimer;
   import flash.text.TextField;
   import flash.display.Sprite;
   import flash.events.UncaughtErrorEvent;
   import flash.events.ErrorEvent;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.events.EventCenter;
   import flash.events.FullScreenEvent;
   import flash.events.Event;
   import com.common.sdk.SDKEvent;
   import com.massage.ane.UmengExtension;
   import com.common.managers.SoundManager;
   import extend.SoundEvent;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.views.mediator.mainCity.playerInfo.PlayInfoBarMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.buyDiamond.BuyDiamondMediator;
   import flash.events.ThrottleEvent;
   
   public class Pocketmon extends STLStarup
   {
      
      public static var isDeActive:Boolean;
      
      public static var sdkTool;
      
      public static var _channel:int;
      
      public static var _description:String;
      
      public static var swfVersion:String = "1.6.1.1";
      
      public static var startTime:int;
       
      private var decArr:Array;
      
      private var _nativeStage:Stage;
      
      public function Pocketmon()
      {
         decArr = ["wdj","oppo"];
         super();
      }
      
      private function onOrientationChanging(param1:StageOrientationEvent) : void
      {
         if(param1.afterOrientation == "upsideDown" || param1.afterOrientation == "default")
         {
            param1.preventDefault();
         }
      }
      
      public function starGame2(param1:Stage, param2:int) : void
      {
         LogUtil(param1);
         var _loc4_:File = File.applicationStorageDirectory.resolvePath("assets/ui/andriod/bag/bag.png");
         if(_loc4_.exists)
         {
            _loc4_.deleteFile();
         }
         trace("存在吗" + _loc4_.exists);
         App.init(param1);
         _channel = param2;
         var _loc3_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc5_:Namespace = _loc3_.namespace();
         _description = _loc3_._loc5_::description;
         sdkTool = SDKManager.getInstance().setANEtype(param2);
         param1.addEventListener("activate",onActive);
         param1.addEventListener("deactivate",onDeActive);
         loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError",onUncaughtError);
         param1.addEventListener("throttle",pauseHandler);
         startTime = getTimer();
      }
      
      public function startGameOfOther(param1:Stage, param2:Object, param3:Object, param4:TextField, param5:TextField, param6:Sprite) : void
      {
         _nativeStage = param1;
         UpdateHandler.getInstance().initUpdate(param2,param3,param4,param5,param6);
         if(UpdateHandler.getInstance().isHasUpdate())
         {
            UpdateHandler.getInstance().getAssetsFromSever(inToGame);
         }
         else
         {
            inToGame();
         }
      }
      
      private function inToGame() : void
      {
         trace("进入游戏了？");
         App.init(_nativeStage);
         _channel = 3;
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         _description = _loc1_._loc2_::description;
         sdkTool = SDKManager.getInstance().setANEtype(_channel);
         _nativeStage.addEventListener("activate",onActive);
         _nativeStage.addEventListener("deactivate",onDeActive);
         loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError",onUncaughtError);
         _nativeStage.addEventListener("throttle",pauseHandler);
         startTime = getTimer();
      }
      
      protected function onUncaughtError(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:String = param1.error.getStackTrace();
         if(!_loc2_)
         {
            if(param1.error is Error)
            {
               _loc2_ = Error(param1.error).message;
            }
            else if(param1.error is ErrorEvent)
            {
               _loc2_ = ErrorEvent(param1.error).text;
            }
            else
            {
               _loc2_ = param1.error.toString();
            }
         }
         var _loc3_:String = "0.0.0.0";
         if(Config.configInfo != null)
         {
            _loc3_ = Config.configInfo.totalVersion;
         }
         if(_loc2_.indexOf("Error #3672") == -1 && _loc2_.indexOf("Error #3691") == -1 && _loc2_.indexOf("Error #3694") == -1)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":_loc2_,
               "token":Game.token,
               "userId":PlayerVO.userId,
               "configVersion":_loc3_,
               "swfVersion":swfVersion,
               "starTime":((getTimer() - startTime) / 60000).toFixed(2),
               "description":_description
            },result,null,"post");
         }
         else
         {
            loaderInfo.uncaughtErrorEvents.removeEventListener("uncaughtError",onUncaughtError);
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":_loc2_,
               "token":Game.token,
               "userId":PlayerVO.userId,
               "configVersion":_loc3_,
               "swfVersion":swfVersion,
               "starTime":((getTimer() - startTime) / 60000).toFixed(2),
               "description":_description
            },result,null,"post");
            if(_loc2_.indexOf("Error #3672") != -1)
            {
               EventCenter.dispatchEvent("error",{"message":"程序异常"});
            }
            else if(_loc2_.indexOf("Error #3691") != -1)
            {
               EventCenter.dispatchEvent("error",{"message":"程序出错"});
            }
            else if(PlayerVO.userId == null)
            {
               EventCenter.dispatchEvent("error",{"message":"程序遇到错误"});
            }
         }
      }
      
      private function result(param1:Object) : void
      {
      }
      
      public function starGame(param1:FullScreenEvent) : void
      {
         App.init(stage);
         stage.addEventListener("activate",onActive);
         stage.addEventListener("deactivate",onDeActive);
         stage.removeEventListener("fullScreen",starGame);
      }
      
      protected function onDeActive(param1:Event) : void
      {
         trace("active停止");
         if(decArr.indexOf(Pocketmon._description) != -1)
         {
            SDKEvent.dispatchEvent("on_pause_event");
         }
         NativeApplication.nativeApplication.systemIdleMode = "normal";
         UmengExtension.getInstance().UMAnalysic("onDeActive");
         if(SoundManager.BGSwitch)
         {
            SoundEvent.dispatchEvent("close_music");
         }
         pvpDeActiveHandle();
      }
      
      private function pvpDeActiveHandle() : void
      {
         if(LoadPageCmd.lastPage is PVPBgUI && FightingMedia.isFighting && PVPBgMediator.pvpFrom == 1)
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6004();
         }
      }
      
      protected function onActive(param1:Event) : void
      {
         trace("active恢复");
         if(decArr.indexOf(Pocketmon._description) != -1)
         {
            SDKEvent.dispatchEvent("on_resume_event");
         }
         UmengExtension.getInstance().UMAnalysic("onActive");
         if(NativeApplication.nativeApplication.systemIdleMode != "keepAwake")
         {
            NativeApplication.nativeApplication.systemIdleMode = "keepAwake";
         }
         if(SoundManager.BGSwitch)
         {
            SoundEvent.dispatchEvent("open_music");
         }
         isDeActive = false;
         pvpActiveHandle();
         if(PlayInfoBarMediator.savePower > 0)
         {
            Facade.getInstance().sendNotification("update_play_power_info",PlayInfoBarMediator.savePower);
            PlayInfoBarMediator.savePower = 0;
         }
         if(BuyDiamondMediator.isUpdateGift)
         {
            Facade.getInstance().sendNotification("update_diamond_recharge_double");
            BuyDiamondMediator.isUpdateGift = false;
         }
      }
      
      private function pvpActiveHandle() : void
      {
         if(LoadPageCmd.lastPage is PVPBgUI && FightingMedia.isFighting && PVPBgMediator.pvpFrom == 1)
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6005();
         }
      }
      
      protected function pauseHandler(param1:ThrottleEvent) : void
      {
         var _loc2_:* = param1.state;
         if("pause" !== _loc2_)
         {
            if("resume" !== _loc2_)
            {
               if("throttle" === _loc2_)
               {
                  if(param1.targetFrameRate == 4)
                  {
                     SDKEvent.dispatchEvent("on_pause_event");
                  }
                  else
                  {
                     SDKEvent.dispatchEvent("on_stop_event");
                  }
               }
            }
            else
            {
               SDKEvent.dispatchEvent("on_resume_event");
            }
         }
         else
         {
            SDKEvent.dispatchEvent("on_pause_event");
         }
      }
   }
}
