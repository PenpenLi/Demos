package com.mvc.views.mediator.mainCity.playerInfo.infoPanel
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.GameSettingUI;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import starling.events.Event;
   import starling.display.DisplayObject;
   import feathers.controls.ToggleSwitch;
   import com.common.managers.SoundManager;
   import lzm.util.LSOManager;
   import extend.SoundEvent;
   import com.massage.ane.UmengExtension;
   import com.common.util.WinTweens;
   import com.common.util.DisposeDisplay;
   import org.puremvc.as3.interfaces.INotification;
   
   public class GameSettingMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "GameSettingMediator";
       
      private var gameSettingUI:GameSettingUI;
      
      public function GameSettingMediator(param1:Object = null)
      {
         super("GameSettingMediator",param1);
         gameSettingUI = param1 as GameSettingUI;
         gameSettingUI.addEventListener("triggered",gameSetting_triggeredHandler);
         gameSettingUI.gameSettingSpr.addEventListener("touch",gameSettingUI_touchHandler);
      }
      
      private function gameSettingUI_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(gameSettingUI.gameSettingSpr);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(_loc2_.target == gameSettingUI.img_sysOff)
            {
               gameSettingUI.switchSysOrOth(true);
            }
            if(_loc2_.target == gameSettingUI.img_othOff)
            {
               gameSettingUI.switchSysOrOth(false);
            }
         }
      }
      
      private function ts_fightAuto_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(gameSettingUI.ts_fightAuto);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(PlayerVO.vipRank < 1)
            {
               Tips.show("亲，自动战斗要VIP才能开放哦。");
               gameSettingUI.ts_fightAuto.isEnabled = false;
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            gameSettingUI.ts_fightAuto.isEnabled = true;
         }
      }
      
      private function ts_recoverHpAuto_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(gameSettingUI.ts_recoverHpAuto);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(PlayerVO.vipRank < 1)
            {
               Tips.show("亲，自动使用药品要VIP才能开放哦。");
               gameSettingUI.ts_recoverHpAuto.isEnabled = false;
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            gameSettingUI.ts_recoverHpAuto.isEnabled = true;
         }
      }
      
      private function ts_music_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            SoundManager.BGSwitch = true;
            LSOManager.put("BGMusic",true);
            SoundEvent.dispatchEvent("open_music");
         }
         else
         {
            SoundManager.BGSwitch = false;
            LSOManager.put("BGMusic",false);
            SoundEvent.dispatchEvent("close_music");
         }
      }
      
      private function ts_sound_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            SoundManager.SESwitch = true;
            LSOManager.put("SEMusic",true);
         }
         else
         {
            SoundManager.SESwitch = false;
            LSOManager.put("SEMusic",false);
         }
      }
      
      private function ts_animation_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            Config.isOpenAni = true;
            LSOManager.put("isOpenCartoon",true);
         }
         else
         {
            Config.isOpenAni = false;
            LSOManager.put("isOpenCartoon",false);
         }
      }
      
      private function ts_fightAuto_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            Config.isAutoFighting = true;
            LSOManager.put("isAutoFightSave",true);
         }
         else
         {
            Config.isAutoFighting = false;
            LSOManager.put("isAutoFightSave",false);
         }
      }
      
      private function ts_getPower_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            LSOManager.put("isGetPower",true);
            Config.getPowerSwitch = true;
            UmengExtension.getInstance().UMSwitch("1|1");
         }
         else
         {
            LSOManager.put("isGetPower",false);
            Config.getPowerSwitch = false;
            UmengExtension.getInstance().UMSwitch("1|0");
         }
      }
      
      private function ts_chat_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            LSOManager.put("isPrivateChat",true);
            Config.privateChaSwitch = true;
            UmengExtension.getInstance().UMSwitch("2|1");
         }
         else
         {
            LSOManager.put("isPrivateChat",false);
            Config.privateChaSwitch = false;
            UmengExtension.getInstance().UMSwitch("2|0");
         }
      }
      
      private function ts_attack_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            LSOManager.put("isSeriesAttack",true);
            Config.seriesAttackSwitch = true;
            UmengExtension.getInstance().UMSwitch("3|1");
         }
         else
         {
            LSOManager.put("isSeriesAttack",false);
            Config.seriesAttackSwitch = false;
            UmengExtension.getInstance().UMSwitch("3|0");
         }
      }
      
      private function ts_recoverHpAuto_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            Config.isAutoFightingUseProp = true;
            LSOManager.put("isAutoFightUsePropSave",true);
         }
         else
         {
            Config.isAutoFightingUseProp = false;
            LSOManager.put("isAutoFightUsePropSave",false);
         }
      }
      
      private function ts_acceptPvpInvite_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            Config.isPvpInviteSure = true;
            LSOManager.put("isPvpInviteSureSave",true);
         }
         else
         {
            Config.isPvpInviteSure = false;
            LSOManager.put("isPvpInviteSureSave",false);
         }
      }
      
      private function ts_fightingAni_changeHandler(param1:Event) : void
      {
         LogUtil(param1.target + " ts_target: " + (param1.target as DisplayObject).name);
         if((param1.target as ToggleSwitch).isSelected)
         {
            Config.isOpenFightingAni = true;
            LSOManager.put("isOpenFightingAniSave",true);
         }
         else
         {
            Config.isOpenFightingAni = false;
            LSOManager.put("isOpenFightingAniSave",false);
         }
      }
      
      private function ts_fullPower_changeHandler(param1:Event) : void
      {
      }
      
      private function gameSetting_triggeredHandler(param1:Event) : void
      {
         LogUtil("target: " + param1.target);
         var _loc2_:* = param1.target;
         if(gameSettingUI.settingCloseBtn === _loc2_)
         {
            gameSettingUI.list.removeFromParent();
            WinTweens.closeWin(gameSettingUI.gameSettingSpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         tsRemoveEventListener();
         DisposeDisplay.dispose(gameSettingUI.displayVec);
         gameSettingUI.displayVec = new Vector.<DisplayObject>([]);
         gameSettingUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_gamesetting_list"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_gamesetting_list" === _loc2_)
         {
            gameSettingUI.createSwitch();
            tsAddEventListener();
            gameSettingUI.switchSysOrOth(true);
         }
      }
      
      private function tsAddEventListener() : void
      {
         gameSettingUI.ts_fightAuto.addEventListener("touch",ts_fightAuto_touchHandler);
         gameSettingUI.ts_recoverHpAuto.addEventListener("touch",ts_recoverHpAuto_touchHandler);
         gameSettingUI.ts_music.addEventListener("change",ts_music_changeHandler);
         gameSettingUI.ts_sound.addEventListener("change",ts_sound_changeHandler);
         gameSettingUI.ts_animation.addEventListener("change",ts_animation_changeHandler);
         gameSettingUI.ts_fightAuto.addEventListener("change",ts_fightAuto_changeHandler);
         gameSettingUI.ts_getPower.addEventListener("change",ts_getPower_changeHandler);
         gameSettingUI.ts_chat.addEventListener("change",ts_chat_changeHandler);
         gameSettingUI.ts_attack.addEventListener("change",ts_attack_changeHandler);
         gameSettingUI.ts_recoverHpAuto.addEventListener("change",ts_recoverHpAuto_changeHandler);
         gameSettingUI.ts_acceptPvpInvite.addEventListener("change",ts_acceptPvpInvite_changeHandler);
         gameSettingUI.ts_fightingAni.addEventListener("change",ts_fightingAni_changeHandler);
      }
      
      private function tsRemoveEventListener() : void
      {
         gameSettingUI.ts_fightAuto.removeEventListener("touch",ts_fightAuto_touchHandler);
         gameSettingUI.ts_recoverHpAuto.removeEventListener("touch",ts_recoverHpAuto_touchHandler);
         gameSettingUI.ts_music.removeEventListener("change",ts_music_changeHandler);
         gameSettingUI.ts_sound.removeEventListener("change",ts_sound_changeHandler);
         gameSettingUI.ts_animation.removeEventListener("change",ts_animation_changeHandler);
         gameSettingUI.ts_fightAuto.removeEventListener("change",ts_fightAuto_changeHandler);
         gameSettingUI.ts_getPower.removeEventListener("change",ts_getPower_changeHandler);
         gameSettingUI.ts_chat.removeEventListener("change",ts_chat_changeHandler);
         gameSettingUI.ts_attack.removeEventListener("change",ts_attack_changeHandler);
         gameSettingUI.ts_recoverHpAuto.removeEventListener("change",ts_recoverHpAuto_changeHandler);
         gameSettingUI.ts_acceptPvpInvite.removeEventListener("change",ts_acceptPvpInvite_changeHandler);
         gameSettingUI.ts_fightingAni.removeEventListener("change",ts_fightingAni_changeHandler);
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         tsRemoveEventListener();
         DisposeDisplay.dispose(gameSettingUI.displayVec);
         gameSettingUI.displayVec = new Vector.<DisplayObject>([]);
         facade.removeMediator("GameSettingMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
