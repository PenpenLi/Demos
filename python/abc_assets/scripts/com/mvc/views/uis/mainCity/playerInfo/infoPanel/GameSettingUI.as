package com.mvc.views.uis.mainCity.playerInfo.infoPanel
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ToggleSwitch;
   import starling.display.Image;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.text.TextField;
   import starling.display.Quad;
   import com.common.managers.SoundManager;
   
   public class GameSettingUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var gameSettingSpr:SwfSprite;
      
      public var settingCloseBtn:Button;
      
      public var musicONBtn:Button;
      
      public var soundEffectONBtn:Button;
      
      public var animationOpenBtn:SwfButton;
      
      public var musicOFFBtn:Button;
      
      public var soundEffectOFFBtn:Button;
      
      public var animationOffBtn:SwfButton;
      
      public var ts_music:ToggleSwitch;
      
      public var ts_sound:ToggleSwitch;
      
      public var ts_animation:ToggleSwitch;
      
      public var ts_fightAuto:ToggleSwitch;
      
      public var ts_getPower:ToggleSwitch;
      
      public var ts_chat:ToggleSwitch;
      
      public var ts_attack:ToggleSwitch;
      
      public var ts_recoverHpAuto:ToggleSwitch;
      
      public var ts_acceptPvpInvite:ToggleSwitch;
      
      public var ts_fightingAni:ToggleSwitch;
      
      public var img_sysOn:Image;
      
      public var img_sysOff:Image;
      
      public var img_othOn:Image;
      
      public var img_othOff:Image;
      
      public var list:List;
      
      private var sysListCollection:ListCollection;
      
      private var othListCollection:ListCollection;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function GameSettingUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         gameSettingSpr = swf.createSprite("spr_setting_s");
         gameSettingSpr.x = 1136 - gameSettingSpr.width >> 1;
         gameSettingSpr.y = 640 - gameSettingSpr.height >> 1;
         addChild(gameSettingSpr);
         var _loc2_:TextField = gameSettingSpr.getChildByName("fightAutoTf") as TextField;
         settingCloseBtn = gameSettingSpr.getButton("btn_close");
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.6;
         addChildAt(_loc1_,0);
         img_sysOn = gameSettingSpr.getImage("img_sysOn");
         img_sysOff = gameSettingSpr.getImage("img_sysOff");
         img_othOn = gameSettingSpr.getImage("img_othOn");
         img_othOff = gameSettingSpr.getImage("img_othOff");
         createList();
      }
      
      private function createList() : void
      {
         list = new List();
         list.x = 40;
         list.y = 100;
         list.width = 475;
         list.height = 290;
         list.isSelectable = false;
         list.itemRendererProperties.height = 65;
      }
      
      public function createSwitch() : void
      {
         ts_music = new ToggleSwitch();
         ts_music.isSelected = SoundManager.BGSwitch;
         displayVec.push(ts_music);
         ts_sound = new ToggleSwitch();
         ts_sound.isSelected = SoundManager.SESwitch;
         displayVec.push(ts_sound);
         ts_animation = new ToggleSwitch();
         ts_animation.isSelected = Config.isOpenAni;
         displayVec.push(ts_animation);
         ts_fightAuto = new ToggleSwitch();
         if(Config.isAutoFighting)
         {
            ts_fightAuto.isSelected = true;
         }
         else
         {
            ts_fightAuto.isSelected = false;
         }
         displayVec.push(ts_fightAuto);
         ts_getPower = new ToggleSwitch();
         ts_getPower.isSelected = Config.getPowerSwitch;
         displayVec.push(ts_getPower);
         ts_chat = new ToggleSwitch();
         ts_chat.isSelected = Config.privateChaSwitch;
         displayVec.push(ts_chat);
         ts_attack = new ToggleSwitch();
         ts_attack.isSelected = Config.seriesAttackSwitch;
         displayVec.push(ts_attack);
         ts_recoverHpAuto = new ToggleSwitch();
         ts_recoverHpAuto.isSelected = Config.isAutoFightingUseProp;
         displayVec.push(ts_recoverHpAuto);
         ts_acceptPvpInvite = new ToggleSwitch();
         ts_acceptPvpInvite.isSelected = Config.isPvpInviteSure;
         displayVec.push(ts_acceptPvpInvite);
         ts_fightingAni = new ToggleSwitch();
         ts_fightingAni.isSelected = Config.isOpenFightingAni;
         displayVec.push(ts_fightingAni);
         setListData();
      }
      
      public function switchSysOrOth(param1:Boolean) : void
      {
         gameSettingSpr.addChild(list);
         img_sysOn.visible = param1;
         img_sysOff.visible = !param1;
         img_othOn.visible = !param1;
         img_othOff.visible = param1;
         if(param1)
         {
            list.dataProvider = sysListCollection;
         }
         else
         {
            list.dataProvider = othListCollection;
         }
      }
      
      private function setListData() : void
      {
         if(sysListCollection)
         {
            sysListCollection.removeAll();
            sysListCollection = null;
         }
         if(othListCollection)
         {
            othListCollection.removeAll();
            othListCollection = null;
         }
         sysListCollection = new ListCollection([{
            "label":"音乐",
            "accessory":ts_music
         },{
            "label":"音效",
            "accessory":ts_sound
         },{
            "label":"弹窗动画",
            "accessory":ts_animation
         },{
            "label":"战斗动画",
            "accessory":ts_fightingAni
         },{
            "label":"自动战斗",
            "accessory":ts_fightAuto
         },{
            "label":"开启自动战斗时，自动使用药品",
            "accessory":ts_recoverHpAuto
         }]);
         othListCollection = new ListCollection([{
            "label":"12、18点领取体力通知",
            "accessory":ts_getPower
         },{
            "label":"私聊消息通知",
            "accessory":ts_chat
         },{
            "label":"竞技场被攻击通知",
            "accessory":ts_attack
         },{
            "label":"是否接受陌生人pvp对战邀请",
            "accessory":ts_acceptPvpInvite
         }]);
      }
   }
}
