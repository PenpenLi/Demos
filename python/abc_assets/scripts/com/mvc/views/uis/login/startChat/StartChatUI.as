package com.mvc.views.uis.login.startChat
{
   import starling.display.Sprite;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetStartChatFactor;
   import com.common.util.dialogue.StartDialogue;
   import com.common.events.EventCenter;
   import flash.utils.setTimeout;
   import extend.SoundEvent;
   import com.mvc.views.mediator.mainCity.myElf.EvolveMcMediator;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import com.mvc.models.proxy.login.LoginPro;
   import starling.display.DisplayObject;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class StartChatUI extends Sprite
   {
       
      private var startImg:Image;
      
      private var spr_study:SwfSprite;
      
      private var containBg:Sprite;
      
      private var hometBgImg:Image;
      
      private var swf:Swf;
      
      public function StartChatUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("startChat");
         showElfImage();
      }
      
      private function showElfImage() : void
      {
         LogUtil("==========================");
         containBg = new Sprite();
         addChild(containBg);
         GetStartChatFactor.getStartChat();
         startImg = swf.createImage("img_world");
         containBg.addChild(startImg);
         StartDialogue.getInstance().init();
         StartDialogue.getInstance().playDialogue();
         fadeOutOrIn(startImg,1,0,0.5);
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",showElf);
      }
      
      private function showElf() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",showElf);
         StartDialogue.getInstance().boshi.gotoAndPlay("paoqiu");
         var elfVoicetime:int = setTimeout(playElfVoice,1500);
         StartDialogue.getInstance().touchable = false;
         StartDialogue.nextMark.stop();
         StartDialogue.getInstance().boshi.completeFunction = function():void
         {
            StartDialogue.getInstance().touchable = true;
            StartDialogue.nextMark.play();
            StartDialogue.getInstance().boshi.gotoAndStop("yuandishuohua");
         };
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",removeElf);
      }
      
      private function playElfVoice() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf25");
      }
      
      private function removeElf() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",removeElf);
         StartDialogue.getInstance().boshi.gotoAndStop("over");
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",playEvolve);
      }
      
      private function playEvolve() : void
      {
         StartDialogue.getInstance().touchable = false;
         StartDialogue.getInstance().alpha = 0;
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",playEvolve);
         EventCenter.addEventListener("elf_evolve_mc_complete",evolve_mc_completeHandler);
         EvolveMcMediator.evolvoElfVo = GetElfFactor.getElfVO("129");
         Facade.getInstance().sendNotification("switch_win",null,"load_elfEvolveMc");
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",seleSex);
      }
      
      private function evolve_mc_completeHandler() : void
      {
         EventCenter.removeEventListener("elf_evolve_mc_complete",evolve_mc_completeHandler);
         StartDialogue.getInstance().alpha = 1;
         StartDialogue.getInstance().touchable = true;
         StartDialogue.getInstance().playDialogue();
      }
      
      private function seleSex() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",seleSex);
         addChild(SeleSexUI.getInstance());
         SeleSexUI.getInstance().init();
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",setName);
      }
      
      public function setName() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",setName);
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFNAME_WIN");
         Facade.getInstance().sendNotification("SEND_SETNAME_ELF",null);
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",switchHomeBg);
      }
      
      private function switchHomeBg() : void
      {
         fadeOutOrIn(startImg,0,1,1,addHome);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",switchHomeBg);
      }
      
      private function addHome() : void
      {
         hometBgImg = swf.createImage("img_wanjia");
         containBg.addChild(hometBgImg);
         fadeOutOrIn(hometBgImg,1,0,0.5);
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",switchStudyBg);
      }
      
      private function switchStudyBg() : void
      {
         fadeOutOrIn(hometBgImg,0,1,1,addStudy);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",switchStudyBg);
      }
      
      private function addStudy() : void
      {
         spr_study = swf.createSprite("spr_boshi_s");
         containBg.addChild(spr_study);
         fadeOutOrIn(spr_study,1,0,0.5);
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",seleElf);
      }
      
      private function seleElf() : void
      {
         LogUtil("选择精灵=======");
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",seleElf);
         var _loc1_:int = setTimeout(gotoSeleElf,1000);
         StartDialogue.getInstance().touchable = false;
         EventCenter.addEventListener("NPC_DIALOGUE_EVENT",gotoFighting);
      }
      
      private function gotoSeleElf() : void
      {
         SeleElfUI.getInstance().init();
         addChild(SeleElfUI.getInstance());
         StartDialogue.getInstance().touchable = true;
      }
      
      private function gotoFighting() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",gotoFighting);
         var _loc1_:int = setTimeout(Fighting,1000);
         StartDialogue.getInstance().touchable = false;
         EventCenter.addEventListener("npc_dialogue_end",gotoCity);
      }
      
      private function Fighting() : void
      {
         PlayerVO.enemyElfVec[0].lv = "1";
         PlayerVO.enemyElfVec[0].brokenLv = "0";
         PlayerVO.enemyElfVec[0].camp = "camp_of_computer";
         CalculatorFactor.calculatorElf(PlayerVO.enemyElfVec[0]);
         FightingConfig.sceneName = "daoguan2";
         FightingConfig.fightingAI = 0;
         GotoChallenge.gotoChallenge("小茂","xiao3mao4",PlayerVO.enemyElfVec,false);
         StartDialogue.getInstance().touchable = true;
      }
      
      private function gotoCity() : void
      {
         EventCenter.removeEventListener("npc_dialogue_end",gotoCity);
         (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1002();
      }
      
      private function fadeOutOrIn(param1:DisplayObject, param2:int, param3:int, param4:Number, param5:Function = null) : void
      {
         target = param1;
         end = param2;
         start = param3;
         time = param4;
         remove = param5;
         if(end == 1)
         {
            target.alpha = 0;
         }
         else
         {
            StartDialogue.getInstance().removeFromParent();
         }
         var t:Tween = new Tween(target,time,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",end,start);
         t.onComplete = function():void
         {
            var _loc1_:* = null;
            if(remove)
            {
               remove();
            }
            if(end == 1)
            {
               addChild(StartDialogue.getInstance());
               StartDialogue.getInstance().alpha = 0;
               _loc1_ = new Tween(StartDialogue.getInstance(),0.5,"easeOut");
               Starling.juggler.add(_loc1_);
               _loc1_.animate("alpha",1,0);
            }
            else
            {
               target.removeFromParent();
            }
         };
      }
      
      public function removeEvent() : void
      {
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",showElf);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",removeElf);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",seleSex);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",setName);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",switchHomeBg);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",switchStudyBg);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",seleElf);
         EventCenter.removeEventListener("NPC_DIALOGUE_EVENT",gotoFighting);
      }
   }
}
