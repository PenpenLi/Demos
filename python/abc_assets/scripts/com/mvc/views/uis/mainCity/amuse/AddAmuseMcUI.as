package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import starling.animation.Tween;
   import feathers.controls.Button;
   import feathers.controls.Label;
   import lzm.starling.swf.display.SwfParticleSyetem;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.events.EventCenter;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.GameFacade;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.MainCityUI;
   
   public class AddAmuseMcUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var ball1:Image;
      
      public var ball2:Image;
      
      public var ball3:Image;
      
      public var rewardUnitUIVec:Vector.<DropPropUnitUI>;
      
      public var elfLightMcVec:Vector.<SwfMovieClip>;
      
      private var quad:Quad;
      
      private var tween:Tween;
      
      private var amuseRewardUnitUI:com.mvc.views.uis.mainCity.amuse.AmuseScoreRechargeGoodUnit;
      
      public var drawBtn:Button;
      
      public var yesBtn:Button;
      
      public var tipTf:Label;
      
      public var lightMc:SwfMovieClip;
      
      private var elfLightMc:SwfMovieClip;
      
      public var fireParticle:SwfParticleSyetem;
      
      public var rewardQuad:Quad;
      
      public var drawBtn2:SwfButton;
      
      public var yesBtn2:SwfButton;
      
      private var amuseBg:Image;
      
      public function AddAmuseMcUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuseMc");
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuse");
         amuseBg = _loc1_.createImage("img_amuseBg");
         addChild(amuseBg);
         rewardQuad = new Quad(1136,640,0);
         rewardQuad.alpha = 0.8;
         ball1 = swf.createImage("img_ball_farward1");
         ball1.pivotX = ball1.width >> 1;
         ball1.pivotY = ball1.height >> 1;
         ball2 = swf.createImage("img_ball_farward2");
         ball2.pivotX = ball2.width >> 1;
         ball2.pivotY = ball2.height >> 1;
         ball3 = swf.createImage("img_ball_farward3");
         ball3.pivotX = ball3.width >> 1;
         ball3.pivotY = ball3.height >> 1;
         lightMc = swf.createMovieClip("mc_light256");
         drawBtn = new Button();
         drawBtn.x = 450;
         drawBtn.y = 510;
         yesBtn = new Button();
         yesBtn.label = "确定";
         yesBtn.x = 600;
         yesBtn.y = 510;
         var _loc2_:TextFormat = new TextFormat("FZCuYuan-M03S",15,16777215);
         _loc2_.align = "center";
         tipTf = new Label();
         tipTf.width = 100;
         tipTf.height = 50;
         tipTf.x = 405;
         tipTf.y = 580;
         tipTf.touchable = false;
         tipTf.textRendererProperties.isHTML = true;
         tipTf.textRendererProperties.textFormat = _loc2_;
         drawBtn2 = swf.createButton("btn_drawAgain");
         drawBtn2.x = 400;
         drawBtn2.y = 507;
         yesBtn2 = swf.createButton("btn_yes");
         yesBtn2.x = 600;
         yesBtn2.y = 507;
         rewardUnitUIVec = new Vector.<DropPropUnitUI>();
         elfLightMcVec = new Vector.<SwfMovieClip>();
      }
      
      public function showRewardMc(param1:Array, param2:int = 568, param3:int = 320, param4:Boolean = false) : void
      {
         arr = param1;
         mcX = param2;
         mcY = param3;
         isTen = param4;
         var reward:Sprite = createReward(arr,mcX,mcY,isTen);
         var onComplete:Function = function():void
         {
            var _loc1_:* = 1;
            reward.scaleY = _loc1_;
            reward.scaleX = _loc1_;
            reward.x = mcX;
            reward.y = mcY;
            (reward as DropPropUnitUI).rewardNameTf.visible = true;
            if(arr[0] is PropVO)
            {
               arr.splice(0,1);
               EventCenter.dispatchEvent("amuse_send_reward");
            }
            else if(arr[0] is ElfVO)
            {
               elfLightMc = swf.createMovieClip("mc_lightElf280");
               elfLightMc.pivotX = 140;
               elfLightMc.pivotY = 140;
               elfLightMc.x = 55;
               elfLightMc.y = 56;
               elfLightMc.touchable = false;
               reward.addChildAt(elfLightMc,0);
               elfLightMcVec.push(elfLightMc);
               _loc1_ = 0.9;
               elfLightMc.scaleY = _loc1_;
               elfLightMc.scaleX = _loc1_;
               GameFacade.getInstance().sendNotification("SHOW_Drew_ELF",arr[0]);
               arr[0] = null;
               arr.splice(0,1);
            }
         };
         var ani2:Function = function():void
         {
            var _loc1_:Tween = new Tween(reward,0.3,"easeOut");
            _loc1_.animate("scaleX",1,3);
            _loc1_.animate("scaleY",1,3);
            _loc1_.moveTo(mcX,mcY);
            Starling.juggler.add(_loc1_);
            _loc1_.onComplete = onComplete;
         };
         if(arr[0] is ElfVO)
         {
            reward.alignPivot();
            tween = new Tween(reward,0.3,"easeOut");
            tween.animate("scaleX",3,0);
            tween.animate("scaleY",3,0);
            tween.animate("alpha",1,0);
            tween.animate("rotation",0,deg2rad(360));
            reward.y = reward.y - 30;
            tween.onComplete = onComplete;
         }
         else if(arr[0] is PropVO)
         {
            reward.alignPivot();
            tween = new Tween(reward,0.3,"easeOut");
            tween.animate("scaleX",1,2);
            tween.animate("scaleY",1,2);
            tween.moveTo(mcX,mcY);
            tween.onComplete = onComplete;
         }
         Starling.juggler.add(tween);
      }
      
      public function createReward(param1:Array, param2:int, param3:int, param4:Boolean = false) : Sprite
      {
         var _loc5_:DropPropUnitUI = new DropPropUnitUI();
         _loc5_.pivotX = _loc5_.width - 40 >> 1;
         _loc5_.pivotY = _loc5_.height >> 1;
         _loc5_.x = 568;
         _loc5_.y = 320;
         _loc5_.rewardNameTf.visible = false;
         _loc5_.setTextColor(16777215);
         addChild(_loc5_);
         rewardUnitUIVec.push(_loc5_);
         if(param4)
         {
            randomReward(param1);
         }
         if(param1[0] is ElfVO)
         {
            LogUtil("精灵");
            _loc5_.myElfVo = param1[0];
         }
         else if(param1[0] is PropVO)
         {
            LogUtil("道具");
            _loc5_.myPropVo = param1[0];
         }
         return _loc5_;
      }
      
      private function randomReward(param1:Array) : void
      {
         var _loc4_:* = param1[0];
         var _loc3_:int = Math.floor(Math.random() * (param1.length - 1));
         var _loc2_:* = param1[_loc3_];
         param1[0] = _loc2_;
         param1[_loc3_] = _loc4_;
      }
      
      public function selectAmuseMc() : Image
      {
         if(AmusePro._recrId == 1 || AmusePro._recrId == 4)
         {
            if(ball1.parent == null)
            {
               addChild(ball1);
               ball1.x = 1136 >> 1;
               ball1.y = 640 >> 1;
            }
            return ball1;
         }
         if(AmusePro._recrId == 3 || AmusePro._recrId == 6)
         {
            if(ball3.parent == null)
            {
               addChild(ball3);
               ball3.x = 1136 >> 1;
               ball3.y = 640 >> 1;
            }
            return ball3;
         }
         if(AmusePro._recrId == 7 || AmusePro._recrId == 8)
         {
            if(ball2.parent == null)
            {
               addChild(ball2);
               ball2.x = 1136 >> 1;
               ball2.y = 640 >> 1;
            }
            return ball2;
         }
         return ball1;
      }
      
      public function moveReward() : void
      {
         var i:int = rewardUnitUIVec.length - 1;
         while(i >= 0)
         {
            var tween:Tween = new Tween(rewardUnitUIVec[i],0.3,"easeOut");
            Starling.juggler.add(tween);
            tween.moveTo(rewardUnitUIVec[i].x,rewardUnitUIVec[i].y - 50);
            i = i - 1;
         }
         tween.onComplete = function():void
         {
            var _loc1_:* = 0;
            _loc1_ = rewardUnitUIVec.length - 1;
            while(_loc1_ >= 0)
            {
               Starling.juggler.removeTweens(rewardUnitUIVec[_loc1_]);
               _loc1_--;
            }
         };
         var j:int = 0;
         while(j < elfLightMcVec.length)
         {
            elfLightMcVec[j].y = elfLightMcVec[j].y - 50;
            j = j + 1;
         }
      }
      
      public function addOrRemoveBtn(param1:Boolean) : void
      {
         if(param1)
         {
            determineTipTf();
            addChild(drawBtn2);
            addChild(yesBtn2);
            yesBtn2.name = "sureBtn";
            BeginnerGuide.playBeginnerGuide();
            PlayerVO.isAcceptPvp = true;
         }
         else
         {
            tipTf.removeFromParent();
            drawBtn2.removeFromParent();
            yesBtn2.removeFromParent();
         }
      }
      
      private function determineTipTf() : void
      {
         switch(AmusePro._recrId - 1)
         {
            case 0:
               addChild(tipTf);
               tipTf.text = "5000金币\n<font color=\'#07a0f2\'>(一次)</font>";
               break;
            case 2:
               addChild(tipTf);
               tipTf.text = "350钻石\n<font color=\'#07a0f2\'>(一次)</font>";
               break;
            case 3:
               addChild(tipTf);
               tipTf.text = AmusePro.priceArr[1] + "金币" + "\n<font color=\'#07a0f2\'>(十次)</font>";
            case 5:
               addChild(tipTf);
               if(LoadPageCmd.lastPage is MainCityUI)
               {
                  tipTf.text = "3080钻石\n<font color=\'#07a0f2\'>(十次)</font>";
               }
               else
               {
                  tipTf.text = AmusePro.priceArr[3] + "钻石" + "\n<font color=\'#07a0f2\'>(十次)</font>";
               }
               break;
            case 6:
               addChild(tipTf);
               tipTf.text = "500钻石\n<font color=\'#07a0f2\'>(一次)</font>";
               break;
            case 7:
               addChild(tipTf);
               tipTf.text = AmusePro.priceArr[5] + "钻石" + "\n<font color=\'#07a0f2\'>(十次)</font>";
               break;
            default:
               addChild(tipTf);
               tipTf.text = AmusePro.priceArr[1] + "金币" + "\n<font color=\'#07a0f2\'>(十次)</font>";
         }
      }
   }
}
