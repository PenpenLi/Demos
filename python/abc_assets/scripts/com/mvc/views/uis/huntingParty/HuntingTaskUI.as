package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import starling.display.Image;
   import feathers.controls.ScrollContainer;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.HorizontalLayout;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.managers.ElfFrontImageManager;
   import com.common.util.RewardHandle;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import lzm.util.TimeUtil;
   
   public class HuntingTaskUI extends Sprite
   {
       
      public var swf:Swf;
      
      public var spr_task:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var light:SwfImage;
      
      public var prompt:TextField;
      
      public var time:TextField;
      
      public var btn_get:SwfButton;
      
      public var btn_f5:SwfButton;
      
      public var diaTxt:TextField;
      
      private var elfImage:Image;
      
      private var panel:ScrollContainer;
      
      private var btn_noGet:SwfButton;
      
      private var btn_getten:SwfButton;
      
      private var imageName:String;
      
      private var elfName:TextField;
      
      public function HuntingTaskUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty1"));
         var _loc2_:* = 1.3;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         addChild(_loc1_);
         init();
         addRewardContainer();
      }
      
      public function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_task = swf.createSprite("spr_task");
         btn_close = spr_task.getButton("btn_close");
         light = spr_task.getImage("light");
         prompt = spr_task.getTextField("prompt");
         time = spr_task.getTextField("time");
         btn_get = spr_task.getButton("btn_get");
         btn_noGet = spr_task.getButton("btn_noGet");
         btn_getten = spr_task.getButton("btn_getten");
         btn_f5 = spr_task.getButton("btn_f5");
         diaTxt = spr_task.getTextField("diaTxt");
         elfName = spr_task.getTextField("elfName");
         diaTxt.text = "300";
         spr_task.x = 1136 - spr_task.width >> 1;
         spr_task.y = 640 - spr_task.height >> 1;
         addChild(spr_task);
         var _loc1_:* = false;
         btn_getten.enabled = _loc1_;
         btn_noGet.enabled = _loc1_;
      }
      
      public function addRewardContainer() : void
      {
         panel = new ScrollContainer();
         panel.width = 570;
         panel.height = 150;
         panel.y = 250;
         panel.x = 410;
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 30;
         _loc1_.useVirtualLayout = false;
         panel.scrollBarDisplayMode = "none";
         panel.horizontalScrollPolicy = "none";
         panel.layout = _loc1_;
         spr_task.addChild(panel);
      }
      
      public function setInfo() : void
      {
         removeHandle();
         prompt.text = "        在限定时间内捕获目标精灵即可获得以下奖励，目标奖励可以使用钻石刷新,刷新后会重新计算捕捉时间。";
         imageName = HuntPartyVO.catchElfObj.goalElfVo.imgName;
         ElfFrontImageManager.getInstance().getImg([imageName],showElf);
         RewardHandle.showReward(HuntPartyVO.catchElfObj.rewardObj,panel,0.8);
         var _loc1_:* = false;
         btn_noGet.visible = _loc1_;
         _loc1_ = _loc1_;
         btn_getten.visible = _loc1_;
         btn_get.visible = _loc1_;
         switch(HuntPartyVO.catchElfObj.state)
         {
            case 0:
               btn_noGet.visible = true;
               break;
            case 1:
               btn_get.visible = true;
               break;
            case 2:
               btn_getten.visible = true;
               break;
         }
      }
      
      private function showElf() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imageName));
         ElfFrontImageManager.getInstance().autoZoom(elfImage,380,true);
         elfImage.x = 210;
         elfImage.y = 335;
         spr_task.addChild(elfImage);
         elfName.text = HuntPartyVO.catchElfObj.goalElfVo.name;
         AniFactor.ifOpen = true;
         AniFactor.elfAni(elfImage);
      }
      
      public function updateTime() : void
      {
         time.text = "剩余时间: " + TimeUtil.convertStringToDate(HuntPartyVO.catchElfObj.lessTime);
      }
      
      public function removeHandle() : void
      {
         prompt.text = "";
         elfName.text = "";
         if(elfImage)
         {
            ElfFrontImageManager.getInstance().disposeImg(elfImage);
         }
         if(panel.numChildren > 0)
         {
            panel.removeChildren(0,-1,true);
         }
      }
   }
}
