package com.mvc.views.uis.fighting
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import starling.display.Quad;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.textures.Texture;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.fighting.CampOfPlayerMedia;
   import com.mvc.views.mediator.fighting.CampOfComputerMedia;
   import com.mvc.models.vos.elf.SkillVO;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class FightingUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var btnBars:SwfSprite;
      
      public var eleBtn:Button;
      
      public var backPackBtn:Button;
      
      public var goOutBtn:Button;
      
      public var skillBtnContainer:Sprite;
      
      public var campOfPlayer:com.mvc.views.uis.fighting.CampOfPlayerUI;
      
      public var campComputer:com.mvc.views.uis.fighting.CampOfComputerUI;
      
      public var autoFBtn:SwfButton;
      
      public var handFBtn:SwfButton;
      
      public var speedBtn:SwfButton;
      
      public var speedTF:TextField;
      
      public var bg:Image;
      
      public var bg2:Quad;
      
      private var timeBg:SwfSprite;
      
      public var timeTF:TextField;
      
      public var canNotGoOutRound:TextField;
      
      public var propInfoSpr:SwfSprite;
      
      public var propImage:Sprite;
      
      public var speedBtnSpr:SwfSprite;
      
      private var natureBg:Image;
      
      private var blackBg:Image;
      
      public function FightingUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         skillBtnContainer = new Sprite();
         if(FightingConfig.selectMap)
         {
            _loc1_ = LoadOtherAssetsManager.getInstance().assets.getTexture(FightingConfig.selectMap.sceneName);
         }
         else
         {
            _loc1_ = LoadOtherAssetsManager.getInstance().assets.getTexture(FightingConfig.sceneName);
         }
         bg = new Image(_loc1_);
         addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("fighting");
         addCampOfComputer();
         addCampOfPlayer();
         addBtnBars();
         addAutoFightingBtn();
         addSpeedBtn();
         bg.blendMode = "none";
      }
      
      private function addSpeedBtn() : void
      {
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            return;
         }
         speedBtnSpr = swf.createSprite("spr_speed");
         speedBtn = speedBtnSpr.getButton("speedBtn");
         speedTF = speedBtnSpr.getTextField("speedTF");
         LogUtil("当前延迟时间" + Config.dialogueDelay);
         if(Config.dialogueDelay == 1.5)
         {
            speedTF.text = "X0";
         }
         else if(Config.dialogueDelay == 1)
         {
            speedTF.text = "X1";
         }
         else if(Config.dialogueDelay == 0.5)
         {
            speedTF.text = "X2";
         }
         speedBtnSpr.scaleX = Config.scaleX;
         speedBtnSpr.scaleY = Config.scaleY;
         speedBtnSpr.x = 1034 * Config.scaleX;
         speedBtnSpr.y = 118 * Config.scaleY;
         speedBtnSpr.name = "speedBtnSpr";
         Config.stage.addChild(speedBtnSpr);
      }
      
      public function showSkillChangeScene(param1:uint, param2:Number, param3:Number) : void
      {
         color = param1;
         alpha = param2;
         time = param3;
         if(bg2 == null)
         {
            bg2 = new Quad(1136,640,16777215);
         }
         LogUtil("颜色" + color);
         bg2.color = color;
         bg2.alpha = 0;
         addChildAt(bg2,1);
         var t:Tween = new Tween(bg2,0.5,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",alpha,0);
         t.onComplete = function():void
         {
            var t:Tween = new Tween(bg2,0.4,"easeOut");
            Starling.juggler.add(t);
            t.delay = time;
            t.animate("alpha",0,alpha);
            t.onComplete = function():void
            {
               bg2.removeFromParent();
            };
         };
      }
      
      public function goodEffectShow() : void
      {
         if(bg2 == null)
         {
            bg2 = new Quad(1136,640,16777215);
         }
         bg2.color = 0;
         bg2.alpha = 0.8;
         addChildAt(bg2,1);
         var remove:Function = function():void
         {
            bg2.removeFromParent();
         };
         Starling.juggler.delayCall(remove,2);
      }
      
      private function addAutoFightingBtn() : void
      {
         autoFBtn = swf.createButton("btn_autoFight_b");
         autoFBtn.x = 1006;
         autoFBtn.y = 5;
         autoFBtn.name = "btn_autoFight_b";
         handFBtn = swf.createButton("btn_handBtn_b");
         handFBtn.scaleX = Config.scaleX;
         handFBtn.scaleY = Config.scaleY;
         handFBtn.x = 1006 * Config.scaleX;
         handFBtn.y = 5 * Config.scaleY;
         handFBtn.name = "btn_handBtn_b";
      }
      
      private function addCampOfPlayer() : void
      {
         LogUtil("什么情况");
         if(!GameFacade.getInstance().hasMediator("CampOfPlayerMedia"))
         {
            GameFacade.getInstance().registerMediator(new CampOfPlayerMedia(new com.mvc.views.uis.fighting.CampOfPlayerUI()));
         }
         campOfPlayer = (GameFacade.getInstance().retrieveMediator("CampOfPlayerMedia") as CampOfPlayerMedia).UI as com.mvc.views.uis.fighting.CampOfPlayerUI;
         campOfPlayer.x = 15;
         campOfPlayer.y = 212;
         addChild(campOfPlayer);
         campOfPlayer.name = "campOfPlayer";
      }
      
      private function addCampOfComputer() : void
      {
         if(!GameFacade.getInstance().hasMediator("CampOfComputerMedia"))
         {
            GameFacade.getInstance().registerMediator(new CampOfComputerMedia(new com.mvc.views.uis.fighting.CampOfComputerUI()));
         }
         campComputer = (GameFacade.getInstance().retrieveMediator("CampOfComputerMedia") as CampOfComputerMedia).UI as com.mvc.views.uis.fighting.CampOfComputerUI;
         addChild(campComputer);
         campComputer.name = "campComputer";
      }
      
      private function addBtnBars() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc1_:* = null;
         btnBars = swf.createSprite("spr_btnBar_s");
         btnBars.x = 0;
         btnBars.y = 490;
         eleBtn = btnBars.getButton("eleBtn");
         backPackBtn = btnBars.getButton("backPackBtn");
         goOutBtn = btnBars.getButton("goOutBtn");
         addChild(btnBars);
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = swf.createButton("btn_skillBtn_b");
            _loc3_.name = "nullSkill";
            _loc1_ = _loc3_.skin as Sprite;
            (_loc1_.getChildByName("skillNameTf") as TextField).text = "无";
            (_loc1_.getChildByName("ppTf") as TextField).text = "";
            (_loc1_.getChildByName("propertyTF") as TextField).text = "";
            _loc3_.x = _loc2_ * 180;
            _loc3_.y = 8;
            _loc3_.scaleNum = 1.1;
            skillBtnContainer.addChild(_loc3_);
            _loc2_++;
         }
         btnBars.addChild(skillBtnContainer);
         skillBtnContainer.name = "skillBtnContainer";
      }
      
      public function upDateSkillBtn(param1:Vector.<SkillVO>) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc10_:* = null;
         var _loc3_:* = null;
         var _loc9_:* = null;
         var _loc2_:* = null;
         _loc8_ = 0;
         while(_loc8_ < 4)
         {
            _loc5_ = skillBtnContainer.getChildAt(_loc8_) as Button;
            _loc5_.name = "nullSkill";
            _loc4_ = _loc5_.skin as Sprite;
            if(_loc4_ == null)
            {
               return;
            }
            (_loc4_.getChildByName("skillNameTf") as TextField).text = "无";
            (_loc4_.getChildByName("ppTf") as TextField).text = "";
            (_loc4_.getChildByName("propertyTF") as TextField).text = "";
            if(_loc4_.getChildByName("mark") != null)
            {
               (_loc4_.getChildByName("mark") as SwfMovieClip).removeFromParent(true);
            }
            if(_loc4_.getChildByName("markDown") != null)
            {
               (_loc4_.getChildByName("markDown") as SwfMovieClip).removeFromParent(true);
            }
            if(_loc4_.getChildByName("mark2") != null)
            {
               (_loc4_.getChildByName("mark2") as Image).removeFromParent(true);
            }
            if(_loc4_.getChildByName("natureImage") != null)
            {
               (_loc4_.getChildByName("natureImage") as Image).removeFromParent(true);
            }
            (_loc4_.getChildByName("natureBg") as Image).color = 8421504;
            (_loc4_.getChildByName("blackBg") as Image).color = 16777215;
            (_loc4_.getChildByName("ppTf") as TextField).color = 16777215;
            (_loc4_.getChildByName("propertyTF") as TextField).color = 16777215;
            _loc8_++;
         }
         if(param1 == null)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_ = skillBtnContainer.getChildAt(_loc6_) as Button;
            _loc5_.name = "skill" + _loc6_;
            _loc4_ = _loc5_.skin as Sprite;
            (_loc4_.getChildByName("skillNameTf") as TextField).text = param1[_loc6_].name;
            (_loc4_.getChildByName("ppTf") as TextField).text = "PP " + param1[_loc6_].currentPP + "/" + param1[_loc6_].totalPP;
            (_loc4_.getChildByName("propertyTF") as TextField).text = param1[_loc6_].property;
            _loc7_ = CalculatorFactor.natureArr.indexOf(param1[_loc6_].property);
            (_loc4_.getChildByName("natureBg") as Image).color = CalculatorFactor.natureColor[_loc7_];
            _loc10_ = swf.createImage("img_nature" + _loc7_);
            _loc10_.alignPivot();
            _loc10_.x = 54;
            _loc10_.y = 99;
            _loc10_.name = "natureImage";
            _loc4_.addChild(_loc10_);
            if(param1[_loc6_].isNoSuggest == true)
            {
               _loc10_.color = 8421504;
               (_loc4_.getChildByName("natureBg") as Image).color = 8421504;
               (_loc4_.getChildByName("blackBg") as Image).color = 8421504;
               (_loc4_.getChildByName("ppTf") as TextField).color = 8421504;
               (_loc4_.getChildByName("propertyTF") as TextField).color = 8421504;
            }
            if(param1[_loc6_].isRestrain && param1[_loc6_].currentPP > 0)
            {
               _loc3_ = swf.createMovieClip("mc_arrow");
               _loc3_.name = "mark";
               _loc3_.x = 60;
               _loc3_.y = 70;
               _loc4_.addChild(_loc3_);
               _loc3_.gotoAndPlay(0);
            }
            if(param1[_loc6_].isNoGoodEffect)
            {
               _loc9_ = swf.createMovieClip("mc_arrowDown");
               _loc9_.name = "markDown";
               _loc9_.x = 60;
               _loc9_.y = 70;
               _loc4_.addChild(_loc9_);
               _loc9_.gotoAndPlay(0);
            }
            if(param1[_loc6_].isNoEffect)
            {
               _loc2_ = swf.createImage("img_noEffect");
               _loc2_.name = "mark2";
               _loc2_.x = 45;
               _loc2_.y = 45;
               _loc4_.addChild(_loc2_);
            }
            _loc6_++;
         }
      }
      
      public function showCountdown() : void
      {
         if(timeBg == null)
         {
            timeBg = swf.createSprite("spr_timeBg_ss");
            timeTF = timeBg.getTextField("timeTF");
            timeBg.x = 578 * Config.scaleX;
            timeBg.y = ((timeBg.height >> 1) - 3) * Config.scaleY;
            timeBg.scaleX = Config.scaleX;
            timeBg.scaleY = Config.scaleY;
         }
         Config.stage.addChild(timeBg);
         timeBg.alpha = 0;
         var _loc1_:Tween = new Tween(timeBg,0.5,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",1);
      }
      
      public function closeCountdown() : void
      {
         if(timeBg == null)
         {
            return;
         }
         var t:Tween = new Tween(timeBg,0.5,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",0);
         t.onComplete = function():void
         {
            if(timeBg != null)
            {
               timeBg.removeFromParent(true);
               timeBg = null;
            }
         };
      }
      
      public function showPropInfoSpr(param1:PropVO) : void
      {
         var _loc2_:* = null;
         if(canNotGoOutRound == null)
         {
            propInfoSpr = swf.createSprite("spr_propInfo");
            canNotGoOutRound = propInfoSpr.getTextField("lessNum");
            canNotGoOutRound.y = canNotGoOutRound.y + 2;
            propInfoSpr.y = 180;
         }
         if(propImage != null)
         {
            propImage.removeFromParent(true);
         }
         canNotGoOutRound.text = param1.effectValue;
         propImage = GetpropImage.getPropSpr(param1);
         propImage.x = 2;
         propImage.y = -35;
         propInfoSpr.addChild(propImage);
         if(propInfoSpr.parent == null)
         {
            addChild(propInfoSpr);
            _loc2_ = new Tween(propInfoSpr,1,"easeOut");
            Starling.juggler.add(_loc2_);
            _loc2_.animate("x",0,-134);
         }
         Starling.juggler.removeTweens(canNotGoOutRound);
         canNotGoOutRound.alpha = 1;
      }
      
      public function canNotGoOutRoundText() : void
      {
         var _loc1_:* = null;
         if(propInfoSpr == null)
         {
            return;
         }
         if(propInfoSpr.parent == null)
         {
            return;
         }
         var _loc2_:int = canNotGoOutRound.text - 1;
         canNotGoOutRound.text = _loc2_;
         if(_loc2_ == 3)
         {
            _loc1_ = new Tween(canNotGoOutRound,0.8,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",0,1);
            _loc1_.repeatCount = 2147483647;
         }
         if(_loc2_ > 3)
         {
            Starling.juggler.removeTweens(canNotGoOutRound);
            canNotGoOutRound.alpha = 1;
         }
         if(_loc2_ == 0)
         {
            closeShowPropInfoSpr();
         }
      }
      
      private function closeShowPropInfoSpr() : void
      {
         var t:Tween = new Tween(propInfoSpr,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",-134);
         t.onComplete = function():void
         {
            propInfoSpr.removeFromParent();
            propImage.removeFromParent(true);
         };
      }
   }
}
