package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.trial.TrialMediator;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.mainCity.trial.TrialSelectBossMediator;
   import com.mvc.GameFacade;
   
   public class TrialBossUnit extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_bossBg:SwfSprite;
      
      private var tf_bossName:TextField;
      
      private var tf_openData:TextField;
      
      private var bossImg:Image;
      
      private var spr_openData:SwfSprite;
      
      private var _index:int;
      
      public function TrialBossUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         spr_bossBg = swf.createSprite("spr_bossBg");
         addChild(spr_bossBg);
         spr_openData = spr_bossBg.getSprite("openDataSpr");
         tf_bossName = spr_bossBg.getTextField("tf_bossName");
         tf_openData = spr_openData.getTextField("tf_openData");
      }
      
      public function setBoss(param1:int) : void
      {
         _index = param1;
         LogUtil(TrialMediator.bossVoVec[param1].bossName + "名字");
         tf_bossName.text = TrialMediator.bossVoVec[param1].bossName;
         tf_openData.text = setOpenDataTxt(TrialMediator.bossVoVec[param1].openData);
         if(param1 == 7)
         {
            ElfFrontImageManager.getInstance().getImg(["img_miao1miao1"],showMaoMaoImage);
         }
         else
         {
            LogUtil("npc材质" + TrialMediator.bossVoVec[param1].bossImg);
            NpcImageManager.getInstance().getImg([TrialMediator.bossVoVec[param1].bossImg],addBossImg);
         }
      }
      
      private function showMaoMaoImage() : void
      {
         bossImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("img_miao1miao1"));
         var _loc1_:* = 0.7;
         bossImg.scaleY = _loc1_;
         bossImg.scaleX = _loc1_;
         bossImg.x = spr_bossBg.width - bossImg.width >> 1;
         bossImg.y = spr_bossBg.height - bossImg.height >> 1;
         bossImg.name = _index;
         spr_bossBg.addChildAt(bossImg,1);
      }
      
      private function addBossImg() : void
      {
         bossImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(TrialMediator.bossVoVec[_index].bossImg));
         var _loc1_:* = 0.7;
         bossImg.scaleY = _loc1_;
         bossImg.scaleX = _loc1_;
         bossImg.x = spr_bossBg.width - bossImg.width >> 1;
         bossImg.y = spr_bossBg.height - bossImg.height >> 1;
         bossImg.name = _index;
         spr_bossBg.addChildAt(bossImg,1);
         if(_index == 6)
         {
            TrialSelectBossMediator.isAllBossLoaded = true;
            GameFacade.getInstance().sendNotification("trial_update_boss_list");
         }
      }
      
      public function showDoubleIcon() : void
      {
         var _loc1_:Image = swf.createImage("img_doubleReward");
         _loc1_.x = this.width - _loc1_.width;
         addChild(_loc1_);
      }
      
      public function setOpenDataTxt(param1:int) : String
      {
         var _loc2_:* = null;
         switch(param1)
         {
            case 0:
               _loc2_ = "每周日开放";
               break;
            case 1:
               _loc2_ = "每周一开放";
               break;
            case 2:
               _loc2_ = "每周二开放";
               break;
            case 3:
               _loc2_ = "每周三开放";
               break;
            case 4:
               _loc2_ = "每周四开放";
               break;
            case 5:
               _loc2_ = "每周五开放";
               break;
            case 6:
               _loc2_ = "每周六开放";
            case 8:
               _loc2_ = "每天开放";
               break;
            default:
               _loc2_ = "每周六开放";
         }
         return _loc2_;
      }
   }
}
