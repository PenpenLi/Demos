package com.mvc.views.uis.fighting
{
   import starling.display.Image;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadOtherAssetsManager;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.fighting.NPCVO;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import extend.SoundEvent;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import com.mvc.views.mediator.fighting.AniFactor;
   import lzm.starling.swf.display.SwfScale9Image;
   
   public class CampOfComputerUI extends CampBaseUI
   {
       
      public var npcImage:Image;
      
      public var ballMc:SwfMovieClip;
      
      private var spr_star:SwfSprite;
      
      public function CampOfComputerUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         moveRange = -20;
         statusBar = swf.createSprite("spr_comStatusBar");
         currentHpTf = statusBar.getTextField("currentHpTf");
         totalHpTf = statusBar.getTextField("totalHpTf");
         statusBar.x = 68;
         statusBar.y = 10;
         statusX = statusBar.x;
         showElfNum.y = 50;
         showElfNum.scaleX = -1;
         elfNameTF = GetCommon.getLabel(statusBar,30,48);
         spr_star = statusBar.getSprite("spr_star");
         lvTF = statusBar.getTextField("lvTF");
         lvTF.bold = true;
         sexIcon = statusBar.getImage("sexIcon");
         GhpBar = statusBar.getScale9Image("GhpBar");
         YhpBar = statusBar.getScale9Image("YhpBar");
         RhpBar = statusBar.getScale9Image("RhpBar");
         elfBall = statusBar.getImage("elfBall");
         elfBall.visible = false;
         addChild(statusBar);
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfBallAct");
         ballMc = _loc1_.createMovieClip("mc_otherThow");
         ballMc.gotoAndStop(0);
         ballMc.loop = false;
         _loc1_ = null;
         shadow = swf.createImage("img_shadow");
         shadow.alignPivot();
         shadow.alpha = 0.7;
         addChild(shadow);
         shadow.scaleX = 0;
      }
      
      public function set myVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         lvTF.text = _elfVO.lv;
         elfNameTF.text = "<font color=\'" + brokenColor[_elfVO.brokenLv] + "\' size=\'22\'>" + _elfVO.name + brokenStr[_elfVO.brokenLv] + " </font>";
         elfNameTF.validate();
         spr_star.x = elfNameTF.x + elfNameTF.width + 5;
         spr_star.getTextField("starLv").text = "×" + _elfVO.starts;
         upDateElfShow(_elfVO.imgName);
         elf.visible = true;
         statusBar.visible = true;
         statusBar.alpha = 1;
         updateHpShow(false);
         statusBar.x = -432;
         upDateStatusShow();
         currentHpTf.text = _elfVO.currentHp;
         totalHpTf.text = _elfVO.totalHp;
      }
      
      private function upDateElfShow(param1:String) : void
      {
         if(elf)
         {
            elf.removeFromParent(true);
            elf = null;
         }
         elf = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(param1));
         elf.pivotX = elf.width / 2;
         elf.pivotY = elf.height;
         elf.x = 870;
         elf.y = 170 + (elf.height >> 1);
         addChild(elf);
         upDateElfSex();
         shadow.x = elf.x;
         shadow.y = elf.y;
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
                  "message":"找不到性别:" + _elfVO.sex,
                  "token":Game.token,
                  "userId":PlayerVO.userId,
                  "swfVersion":Pocketmon.swfVersion,
                  "description":Pocketmon._description
               },null,null,"post");
               return;
            }
            sexImage.x = 289;
            sexImage.y = 43;
            statusBar.addChild(sexImage);
         }
      }
      
      public function updateNpc() : void
      {
         if(npcImage)
         {
            npcImage.texture.dispose();
            npcImage.removeFromParent(true);
            npcImage = null;
         }
         LogUtil("NPCVO.imageName===========",NPCVO.imageName);
         npcImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(NPCVO.imageName));
         var _loc1_:* = 0.8;
         npcImage.scaleY = _loc1_;
         npcImage.scaleX = _loc1_;
      }
      
      private function showElfNumHandler() : void
      {
         if(showElfNum.numChildren > 1)
         {
            showElfNum.removeChildren(1,-1,true);
         }
         var i:int = 0;
         while(i < NPCVO.bagElfVec.length)
         {
            if(NPCVO.bagElfVec[i].currentHp > 0)
            {
               var showNumUnit:Image = swf.createImage("img_showNumUnit");
            }
            else
            {
               showNumUnit = swf.createImage("img_showNumUnitDie");
            }
            showNumUnit.x = 350 + i * 46;
            showNumUnit.y = 5;
            showNumUnit.alpha = 0;
            showElfNum.addChild(showNumUnit);
            var t2:Tween = new Tween(showNumUnit,0.2,"easeOutBack");
            Starling.juggler.add(t2);
            t2.animate("x",83 + i * 46 - i * 0.2);
            t2.animate("alpha",1);
            t2.delay = i / 10 + 1;
            if(GetElfFactor.bagElfNum() < NPCVO.bagElfVec.length)
            {
               t2.onStart = function():void
               {
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","showElfNum");
               };
            }
            i = i + 1;
         }
         showElfNum.alpha = 1;
         addChild(showElfNum);
         showElfNum.x = -100;
         var t:Tween = new Tween(showElfNum,0.3,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",448);
         t.delay = 0.5;
      }
      
      public function npcImageComeAni() : void
      {
         updateNpc();
         addChild(npcImage);
         npcImage.x = -500;
         var _loc1_:Tween = new Tween(npcImage,1,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("x",750);
         showElfNumHandler();
      }
      
      public function npcImageOutAni() : void
      {
         var t:Tween = new Tween(npcImage,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",1600);
         t.onComplete = function():void
         {
            showElfNum.removeFromParent();
            npcImage.texture.dispose();
            removeChild(npcImage,true);
         };
         var t2:Tween = new Tween(showElfNum,0.3,"easeOut");
         Starling.juggler.add(t2);
         t2.animate("alpha",0);
         t2.animate("x",711);
      }
      
      public function elfBeCatchAni() : void
      {
         var _loc1_:Tween = new Tween(elf,0.1,"easeIn");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",0);
         var _loc2_:Tween = new Tween(shadow,0.1,"easeIn");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("scaleX",0);
      }
      
      public function elfAwayFromElfBallAni() : void
      {
         var _loc1_:Tween = new Tween(elf,0.8,"easeOutElastic");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1);
         var _loc2_:Tween = new Tween(shadow,0.1,"easeIn");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("scaleX",1);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + _elfVO.sound);
      }
      
      public function starAvatar() : void
      {
         updateHpShow(false);
         upDateElfShow("img_avatars");
         elf.y = -350;
         var t:Tween = new Tween(elf,0.7,"easeOut");
         Starling.juggler.add(t);
         t.animate("y",170 + (elf.height >> 1));
         t.onComplete = function():void
         {
            elf.dispatchEventWith("end_help_skill_ani");
         };
      }
      
      public function avatarsEnd() : void
      {
         updateHpShow(false);
         upDateElfShow(_elfVO.imgName);
      }
      
      public function throwBallAni() : void
      {
         ballMc.x = 870;
         ballMc.y = 170;
         addChild(ballMc);
         ballMc.gotoAndPlay(0);
         ballMc.completeFunction = removeBallMc;
      }
      
      private function removeBallMc(param1:SwfMovieClip) : void
      {
         ballMc.completeFunction = null;
         removeChild(ballMc);
      }
      
      public function upDateStatusShow() : void
      {
         if(_elfVO.status.length == 0)
         {
            statusSpr.getTextField("stateTf").text = "";
            statusSpr.removeFromParent();
            return;
         }
         LogUtil("电脑状态" + _elfVO.status);
         var _loc2_:String = StatusFactor.status[_elfVO.status[_elfVO.status.length - 1] - 1];
         if(statusSpr.getTextField("stateTf").text == _loc2_)
         {
            return;
         }
         statusSpr.getTextField("stateTf").text = _loc2_;
         statusSpr.x = 44;
         statusSpr.y = 83;
         statusBar.addChild(statusSpr);
         statusSpr.alpha = 0;
         var _loc1_:Tween = new Tween(statusSpr,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",1);
      }
      
      public function updateHpShow(param1:Boolean = false) : void
      {
         var _loc2_:Number = _elfVO.currentHp / _elfVO.totalHp;
         AniFactor.barScaleXAni(hpBar,_loc2_,param1,_elfVO.camp);
         AniFactor.numTfAni(currentHpTf,_elfVO.currentHp);
         Starling.juggler.delayCall(changeHpBar,0.5,_loc2_);
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
      
      private function setHpBar(param1:SwfScale9Image, param2:Number) : void
      {
         if(hpBar == param1)
         {
            LogUtil("电脑血条正处于这种颜色");
            hpBar.scaleX = param2;
            return;
         }
         statusBar.removeChild(GhpBar);
         statusBar.removeChild(YhpBar);
         statusBar.removeChild(RhpBar);
         param1.scaleX = param2;
         hpBar = param1;
         statusBar.addChild(hpBar);
         return;
         §§push(LogUtil("电脑血条颜色变化咯" + param1.name));
      }
      
      override public function disposeMc() : void
      {
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
