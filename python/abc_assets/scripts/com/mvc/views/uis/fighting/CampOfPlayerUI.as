package com.mvc.views.uis.fighting
{
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.textures.Texture;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.fighting.FightingConfig;
   import flash.utils.getTimer;
   import starling.display.Image;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.core.Starling;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import extend.SoundEvent;
   import starling.animation.Tween;
   import com.common.util.ShowElfAbility;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import com.common.managers.SoundManager;
   
   public class CampOfPlayerUI extends CampBaseUI
   {
       
      public var expBar:SwfScale9Image;
      
      public var playerMc:SwfMovieClip;
      
      public var ballMc:SwfMovieClip;
      
      private var shareNum:int;
      
      private var shareResult:Function;
      
      private var maxLvDiff:int;
      
      private var _lvDiff:int;
      
      private var isAvatar:Boolean;
      
      private var ballActSwf:Swf;
      
      private var spr_star:SwfSprite;
      
      public function CampOfPlayerUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         moveRange = 10;
         statusBar = swf.createSprite("spr_playerStatusBar");
         statusBar.x = 675;
         statusBar.y = 135;
         statusBar.name = "statusBar";
         elfNameTF = GetCommon.getLabel(statusBar,32,4);
         currentHpTf = statusBar.getTextField("currentHpTf");
         totalHpTf = statusBar.getTextField("totalHpTf");
         lvTF = statusBar.getTextField("lvTF");
         lvTF.bold = true;
         spr_star = statusBar.getSprite("spr_star");
         sexIcon = statusBar.getImage("sexIcon");
         GhpBar = statusBar.getScale9Image("GhpBar");
         GhpBar.y = GhpBar.y - 1;
         GhpBar.x = GhpBar.x - 1;
         YhpBar = statusBar.getScale9Image("YhpBar");
         YhpBar.x = YhpBar.x - 1;
         RhpBar = statusBar.getScale9Image("RhpBar");
         RhpBar.y = RhpBar.y - 1;
         RhpBar.x = RhpBar.x - 1;
         expBar = statusBar.getScale9Image("expBar");
         addChild(statusBar);
         statusX = statusBar.x;
         statusBar.x = 1136;
         showElfNum.y = 135;
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("player" + (PlayerVO.trainPtId - 100000) + "Act");
         playerMc = _loc1_.createMovieClip("mc_player1");
         playerMc.gotoAndStop(0);
         playerMc.loop = false;
         ballActSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfBallAct");
         _loc1_ = null;
      }
      
      private function setBallMc(param1:int) : void
      {
         var _loc2_:* = null;
         if(ballMc == null || ballMc.name != "ball" + param1)
         {
            if(ballMc)
            {
               ballMc.removeFromParent(true);
            }
            ballMc = null;
            _loc2_ = "mc_ballAni" + param1;
            if(!ballActSwf.hasMovieClip(_loc2_))
            {
               _loc2_ = "mc_ballAni28";
            }
            ballMc = ballActSwf.createMovieClip(_loc2_);
            ballMc.gotoAndStop(0);
            ballMc.loop = false;
            ballMc.name = "ball" + param1;
         }
      }
      
      public function set myVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         if(_elfVO != null)
         {
            setElfInfo();
            statusBar.visible = true;
            statusBar.alpha = 1;
         }
      }
      
      public function setElfInfo() : void
      {
         lvTF.text = _elfVO.lv;
         elfNameTF.text = "<font color=\'" + brokenColor[_elfVO.brokenLv] + "\' size=\'22\'>" + _elfVO.nickName + brokenStr[_elfVO.brokenLv] + " </font>";
         elfNameTF.validate();
         spr_star.x = elfNameTF.x + elfNameTF.width + 5;
         spr_star.getTextField("starLv").text = "×" + _elfVO.starts;
         currentHpTf.text = _elfVO.currentHp.toString();
         totalHpTf.text = _elfVO.totalHp.toString();
         upDateElfShow(_elfVO.imgName.substr(4) + "_b");
         upDateElfSex();
         updateExpBar(0);
         initShow();
         updateHpShow(false);
         upDateStatusShow();
      }
      
      private function upDateElfShow(param1:String) : void
      {
         var _loc2_:* = null;
         if(elf)
         {
            elf.removeFromParent(true);
            elf = null;
         }
         var _loc3_:Texture = LoadOtherAssetsManager.getInstance().assets.getTexture(param1);
         if(_loc3_ == null)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"战斗找不到纹理",
               "imgName":param1,
               "elfId":_elfVO.elfId,
               "elfBack":FightingConfig.elfBackAssets,
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "starTime":((getTimer() - Pocketmon.startTime) / 60000).toFixed(2),
               "description":Pocketmon._description
            },null,null,"post");
         }
         elf = new Image(_loc3_);
         elf.alignPivot("center","bottom");
         elf.x = 290;
         elf.y = 330;
         addChild(elf);
         _loc2_ = null;
      }
      
      private function upDateElfSex() : void
      {
         if(sexImage)
         {
            sexImage.removeFromParent(true);
            sexImage = null;
         }
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         if(_elfVO.sex == 0)
         {
            sexImage = _loc1_.createImage("img_woman");
            sexImage.y = 0;
         }
         else if(_elfVO.sex == 1)
         {
            sexImage = _loc1_.createImage("img_man");
            sexImage.y = 2;
         }
         if(_elfVO.sex != 2 && _elfVO.sex != 3)
         {
            if(sexImage == null)
            {
               HttpClient.send(Game.upLoadUrl,{
                  "custom":Game.system,
                  "message":"CampOfPlayerUI找不到性别:" + _elfVO.sex,
                  "token":Game.token,
                  "userId":PlayerVO.userId,
                  "swfVersion":Pocketmon.swfVersion,
                  "description":Pocketmon._description
               },null,null,"post");
               return;
            }
            sexImage.x = 287;
            statusBar.addChild(sexImage);
         }
      }
      
      public function updateHpShow(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:Number = _elfVO.currentHp / _elfVO.totalHp;
         if(param1)
         {
            AniFactor.numTfAni(currentHpTf,_elfVO.currentHp);
            AniFactor.barScaleXAni(hpBar,_loc3_,param2,_elfVO.camp);
            Starling.juggler.delayCall(changeHpBar,0.5,_loc3_);
         }
         else
         {
            changeHpBar(_loc3_);
            currentHpTf.text = _elfVO.currentHp.toString();
            hpBar.scaleX = _loc3_;
         }
         if(myVO.totalHp != totalHpTf.text)
         {
            totalHpTf.text = myVO.totalHp.toString();
         }
      }
      
      private function changeHpBar(param1:Number) : void
      {
         if(param1 >= 0.5)
         {
            setHpBar(GhpBar,param1);
         }
         else if(param1 > 0.15)
         {
            setHpBar(YhpBar,param1);
         }
         else
         {
            setHpBar(RhpBar,param1);
         }
      }
      
      public function updateExpBar(param1:int) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:* = NaN;
         if(param1 == 0)
         {
            _loc3_ = CalculatorFactor.calculatorLvNeedExp(_elfVO,_elfVO.lv);
            _loc2_ = (_elfVO.currentExp - _loc3_) / (_elfVO.nextLvExp - _loc3_);
            AniFactor.barScaleXAni(expBar,_loc2_,false,null,0.8);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","expUp");
         }
         else
         {
            maxLvDiff = param1;
            scalexAni(param1,expBar.scaleX);
         }
      }
      
      private function scalexAni(param1:int, param2:Number) : void
      {
         lvDiff = param1;
         startScaleX = param2;
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","expUp");
         lvTF.text = _elfVO.lv - lvDiff;
         expBar.scaleX = startScaleX;
         var t:Tween = new Tween(expBar,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("scaleX",1);
         lvDiff = lvDiff - 1;
         _lvDiff = lvDiff;
         t.onComplete = function():void
         {
            SoundEvent.addEventListener("PLAY_ONCE_COMPLETE",playUpgradeMusic);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgradeBefore");
            var _loc1_:Tween = new Tween(statusBar,0.2,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",1,0);
         };
      }
      
      private function playUpgradeMusic() : void
      {
         SoundEvent.removeEventListener("PLAY_ONCE_COMPLETE",playUpgradeMusic);
         expBar.scaleX = 0;
         var _loc1_:Tween = new Tween(statusBar,0.01,"easeOut");
         Starling.juggler.add(_loc1_);
         SoundEvent.addEventListener("PLAY_ONCE_COMPLETE",nextAni);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         if(_lvDiff == 0)
         {
            CalculatorFactor.calculatorElf(_elfVO);
            ShowElfAbility.getInstance().show(_elfVO,maxLvDiff);
         }
      }
      
      private function nextAni() : void
      {
         LogUtil("干嘛不播放" + _lvDiff);
         SoundEvent.removeEventListener("PLAY_ONCE_COMPLETE",nextAni);
         if(_lvDiff == 0)
         {
            final();
            return;
         }
         scalexAni(_lvDiff,0);
      }
      
      private function final() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","expUp");
         var _loc2_:Number = CalculatorFactor.calculatorLvNeedExp(_elfVO,_elfVO.lv);
         var _loc1_:Number = (_elfVO.currentExp - _loc2_) / (_elfVO.nextLvExp - _loc2_);
         if(!FightingConfig.isShareExp)
         {
            if(CalculatorFactor.learnSkillHandler(_elfVO))
            {
               Dialogue.updateDialogue(_elfVO.nickName + "升到了" + _elfVO.lv + "级",true,"get_exp_complete");
            }
            else
            {
               FightingLogicFactor.dialogueAndNext(_elfVO.nickName + "升到了" + _elfVO.lv + "级","get_exp_complete");
            }
         }
         else if(CalculatorFactor.learnSkillHandler(_elfVO))
         {
            Dialogue.updateDialogue(_elfVO.nickName + "升到了" + _elfVO.lv + "级",true,"share_exp");
         }
         else
         {
            FightingLogicFactor.dialogueAndNext(_elfVO.nickName + "升到了" + _elfVO.lv + "级","share_exp");
         }
         lvTF.text = _elfVO.lv;
         expBar.scaleX = 0;
         AniFactor.barScaleXAni(expBar,_loc1_,false,null,0.8);
         updateHpShow(true,false);
      }
      
      private function initShow() : void
      {
         elf.scaleX = 0;
         statusBar.x = 1136;
         elf.visible = true;
         statusBar.visible = true;
      }
      
      public function playerImageComeAni() : void
      {
         playerMc.gotoAndStop(0);
         addChild(playerMc);
         playerMc.x = 1600;
         playerMc.y = -40;
         var _loc1_:Tween = new Tween(playerMc,1,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("x",150);
         if(NPCVO.name != null)
         {
            showElfNumHandler();
         }
      }
      
      private function showElfNumHandler() : void
      {
         if(showElfNum.numChildren > 1)
         {
            showElfNum.removeChildren(1,-1,true);
         }
         var i:int = 0;
         while(i < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[i] != null)
            {
               if(PlayerVO.bagElfVec[i].currentHp > 0)
               {
                  var showNumUnit:Image = swf.createImage("img_showNumUnit");
               }
               else
               {
                  showNumUnit = swf.createImage("img_showNumUnitDie");
               }
               showNumUnit.x = 300 + i * 46 - i * 0.5;
               showNumUnit.y = 5;
               showNumUnit.alpha = 0;
               showElfNum.addChild(showNumUnit);
               var t2:Tween = new Tween(showNumUnit,0.2,"easeOutBack");
               Starling.juggler.add(t2);
               t2.animate("x",83 + i * 46 - i * 0.2);
               t2.animate("alpha",1);
               t2.delay = i / 10 + 1;
               if(GetElfFactor.bagElfNum() >= NPCVO.bagElfVec.length)
               {
                  t2.onStart = function():void
                  {
                     SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","showElfNum");
                  };
               }
            }
            i = i + 1;
         }
         showElfNum.alpha = 1;
         addChild(showElfNum);
         showElfNum.x = 1300;
         var t:Tween = new Tween(showElfNum,0.3,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",670);
         t.delay = 0.5;
      }
      
      public function playerImageOutAni() : void
      {
         Starling.juggler.delayCall(throwBallAni,0.2);
         if(playerMc.parent == null)
         {
            return;
         }
         playerMc.gotoAndPlay(0);
         awayAni();
      }
      
      public function throwBallAni() : void
      {
         var _loc1_:int = getElfID(_elfVO.elfBallId);
         setBallMc(_loc1_);
         ballMc.y = 130;
         ballMc.x = -60;
         addChild(ballMc);
         ballMc.gotoAndPlay("throw");
         ballMc.completeFunction = removeBallMc;
      }
      
      private function getElfID(param1:int) : int
      {
         if(param1 >= 749 && param1 <= 763)
         {
            return param1 - 717;
         }
         if(param1 == 0)
         {
            return 28;
         }
         return param1;
      }
      
      public function catchAni(param1:int) : void
      {
         var _loc2_:int = getElfID(param1);
         setBallMc(_loc2_);
         ballMc.y = 130;
         ballMc.x = 130;
         addChild(ballMc);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","throwElfCatch");
         ballMc.gotoAndPlay("catch");
      }
      
      public function catchFailedAni(param1:SwfMovieClip = null) : void
      {
         ballMc.y = 17;
         ballMc.x = 817;
         addChild(ballMc);
         ballMc.gotoAndPlay("bomb");
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","openElf");
         ballMc.completeFunction = catchResult;
      }
      
      private function catchResult(param1:SwfMovieClip) : void
      {
         if(param1.currentLabel == "success")
         {
            SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","catchSuccessBg");
            SoundEvent.dispatchEvent("play_music_and_stop_bg",{
               "musicName":"captureOk",
               "isContinuePlayBGM":true
            });
         }
         removeBallMc(null);
         GameFacade.getInstance().sendNotification("catch_elf_end");
      }
      
      public function catchSuccessAni(param1:SwfMovieClip = null) : void
      {
         ballMc.y = 17;
         ballMc.x = 817;
         addChild(ballMc);
         ballMc.gotoAndPlay("success");
         ballMc.completeFunction = catchResult;
      }
      
      public function ballShareAni(param1:int, param2:Function) : void
      {
         shareNum = param1;
         shareResult = param2;
         ballMc.y = 17;
         ballMc.x = 817;
         addChild(ballMc);
         ballMc.gotoAndPlay("share");
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
         shareNum = shareNum - 1;
         if(shareNum == 0)
         {
            ballMc.completeFunction = shareResult;
         }
         else
         {
            ballMc.completeFunction = continueShare;
         }
      }
      
      private function continueShare(param1:SwfMovieClip) : void
      {
         ballMc.gotoAndPlay("share");
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
         shareNum = shareNum - 1;
         if(shareNum == 0)
         {
            ballMc.completeFunction = shareResult;
         }
         else
         {
            ballMc.completeFunction = continueShare;
         }
      }
      
      private function awayAni() : void
      {
         var t:Tween = new Tween(playerMc,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",-500);
         t.onComplete = function():*
         {
            var /*UnknownSlot*/:* = §§dup(function():void
            {
               showElfNum.removeFromParent();
               removeChild(playerMc);
            });
            return function():void
            {
               showElfNum.removeFromParent();
               removeChild(playerMc);
            };
         }();
         if(showElfNum.parent)
         {
            var t2:Tween = new Tween(showElfNum,0.3,"easeOut");
            Starling.juggler.add(t2);
            t2.animate("alpha",0);
            t2.animate("x",400);
         }
      }
      
      private function removeBallMc(param1:SwfMovieClip) : void
      {
         ballMc.completeFunction = null;
         ballMc.removeFromParent();
      }
      
      public function starAvatar() : void
      {
         updateHpShow(true);
         upDateElfShow("avatars_b");
         isAvatar = true;
         elf.y = -200;
         var t:Tween = new Tween(elf,0.7,"easeOut");
         Starling.juggler.add(t);
         t.animate("y",330);
         t.onComplete = function():void
         {
            elf.dispatchEventWith("end_help_skill_ani");
         };
      }
      
      public function avatarsEnd() : void
      {
         updateHpShow(true);
         upDateElfShow(_elfVO.imgName.substr(4) + "_b");
      }
      
      public function upDateStatusShow() : void
      {
         if(_elfVO.status.length == 0)
         {
            statusSpr.getTextField("stateTf").text = "";
            statusSpr.removeFromParent();
            return;
         }
         LogUtil("我方状态" + _elfVO.status);
         var _loc2_:String = StatusFactor.status[_elfVO.status[_elfVO.status.length - 1] - 1];
         if(statusSpr.getTextField("stateTf").text == _loc2_)
         {
            return;
         }
         statusSpr.getTextField("stateTf").text = _loc2_;
         statusSpr.y = 39;
         statusSpr.x = 44;
         statusBar.addChild(statusSpr);
         statusSpr.alpha = 0;
         var _loc1_:Tween = new Tween(statusSpr,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",1);
         return;
         §§push(LogUtil("更新了状态" + _loc2_));
      }
      
      private function setHpBar(param1:SwfScale9Image, param2:Number) : void
      {
         if(hpBar == param1)
         {
            LogUtil("玩家血条正处于这种颜色");
            hpBar.scaleX = param2;
            return;
         }
         statusBar.removeChild(GhpBar);
         statusBar.removeChild(YhpBar);
         statusBar.removeChild(RhpBar);
         param1.scaleX = param2;
         if(param1 == RhpBar && hpBar != RhpBar && _elfVO.currentHp > 0)
         {
            SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","warmBg");
            SoundEvent.dispatchEvent("play_music_and_stop_bg",{
               "musicName":"warm",
               "isContinuePlayBGM":true
            });
         }
         if(param1 != RhpBar && hpBar == RhpBar)
         {
            SoundManager.getInstance().stopMusic();
            SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC",FightingConfig.fightMusicAssets[0]);
         }
         hpBar = param1;
         statusBar.addChild(hpBar);
         return;
         §§push(LogUtil("玩家血条颜色变化咯" + param1.name));
      }
      
      override public function disposeMc() : void
      {
         if(playerMc)
         {
            playerMc.stop(true);
            playerMc.removeFromParent(true);
         }
         if(ballMc)
         {
            ballMc.stop(true);
            ballMc.removeFromParent(true);
         }
      }
      
      override public function get myVO() : ElfVO
      {
         return _elfVO;
      }
   }
}
