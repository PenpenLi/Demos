package com.mvc.views.uis.mainCity.lottery
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class LotteryUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_lotteryBg:SwfSprite;
      
      public var spr_contentMc:SwfSprite;
      
      public var spr_turntable:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_recharge:SwfButton;
      
      public var lotteryList:List;
      
      private var mc_itemArr:Array;
      
      public var xplain:TextField;
      
      public var count:TextField;
      
      public var sumText:TextField;
      
      public var diamondText:TextField;
      
      public var timeText:TextField;
      
      public var img_lotteryTxt:SwfImage;
      
      public function LotteryUI()
      {
         mc_itemArr = [];
         super();
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("lottery");
         spr_lotteryBg = swf.createSprite("spr_lottery");
         spr_turntable = swf.createSprite("spr_turntable1");
         spr_contentMc = spr_lotteryBg.getSprite("spr_contentMc");
         btn_close = spr_contentMc.getButton("btn_close");
         btn_recharge = spr_contentMc.getButton("btn_recharge");
         xplain = spr_contentMc.getTextField("activityText");
         count = spr_contentMc.getTextField("consumeText");
         timeText = spr_contentMc.getTextField("timeText");
         sumText = spr_contentMc.getTextField("sumText");
         diamondText = spr_contentMc.getTextField("diamondText");
         addChild(spr_lotteryBg);
         spr_lotteryBg.addChild(spr_turntable);
         spr_turntable.x = 18 + spr_turntable.width / 2;
         spr_turntable.y = 10 + spr_turntable.height / 2;
      }
      
      private function addList() : void
      {
         lotteryList = new List();
         lotteryList.width = 325;
         lotteryList.height = 177;
         lotteryList.x = 308;
         lotteryList.y = 213;
         lotteryList.isSelectable = false;
         lotteryList.itemRendererProperties.stateToSkinFunction = null;
         lotteryList.itemRendererProperties.padding = 0;
         lotteryList.itemRendererProperties.minHeight = 32;
         spr_contentMc.addChild(lotteryList);
      }
   }
}
