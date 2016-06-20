package com.mvc.views.uis.mainCity.sign
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.mainCity.sign.SignVO;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class SignUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_sign:SwfSprite;
      
      public var spr_addUp:SwfSprite;
      
      public var progress:TextField;
      
      public var btn_get:SwfButton;
      
      public var jionText:TextField;
      
      public var btn_close:SwfButton;
      
      public var addUpContain:Sprite;
      
      public var signRewardList:List;
      
      public var isScrolling:Boolean;
      
      public function SignUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("sign");
         spr_sign = swf.createSprite("spr_sign");
         spr_addUp = spr_sign.getSprite("spr_addUp");
         progress = spr_addUp.getTextField("progress");
         btn_get = spr_addUp.getButton("btn_get");
         jionText = spr_sign.getTextField("jionText");
         btn_close = spr_sign.getButton("btn_close");
         spr_sign.getScale9Image("spr_bigList").height = 430;
         spr_sign.x = 1136 - spr_sign.width >> 1;
         spr_sign.y = 640 - spr_sign.height >> 1;
         addChild(spr_sign);
         addUpContain = new Sprite();
         addUpContain.x = 73;
         addUpContain.y = 190;
         spr_sign.addChild(addUpContain);
         addMenu();
      }
      
      private function addMenu() : void
      {
         signRewardList = new List();
         signRewardList.width = 650;
         signRewardList.height = 415;
         signRewardList.y = 175;
         signRewardList.x = 280;
         signRewardList.isSelectable = false;
         signRewardList.itemRendererProperties.stateToSkinFunction = null;
         spr_sign.addChild(signRewardList);
      }
      
      public function showSign() : void
      {
         if(SignVO.isTodaySigned)
         {
            jionText.text = "今日已签到";
            jionText.color = 11794716;
         }
         else
         {
            jionText.text = "今日未签到";
            jionText.color = 16777215;
         }
         showUpaddProgress();
      }
      
      public function showUpaddProgress() : void
      {
         progress.text = SignVO.totalTimes + "/" + SignPro.addUpVec[SignVO.lastRewardId].times;
      }
      
      public function showMonth() : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(SignVO.month > 9)
         {
            _loc3_ = swf.createImage("img_month" + SignVO.month / 10);
            _loc2_ = swf.createImage("img_month" + SignVO.month % 10);
            _loc3_.x = 396;
            _loc3_.y = 64;
            _loc2_.x = 432;
            _loc2_.y = 46;
            spr_sign.addChild(_loc3_);
            spr_sign.addChild(_loc2_);
         }
         else
         {
            _loc1_ = swf.createImage("img_month" + SignVO.month);
            _loc1_.x = 426;
            _loc1_.y = 50;
            spr_sign.addChild(_loc1_);
         }
      }
   }
}
