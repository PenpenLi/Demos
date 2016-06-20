package com.mvc.views.uis.mainCity.specialAct.limitSpecialElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.List;
   import lzm.starling.display.Button;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class LimitSpecialElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_limitSpecialElf:SwfSprite;
      
      public var spr_elfContainer:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_drawOne:SwfButton;
      
      public var btn_drawTen:SwfButton;
      
      public var tf_countDown:TextField;
      
      public var tf_score:TextField;
      
      public var tf_rank:TextField;
      
      public var tf_diamond:TextField;
      
      public var tf_elfName:TextField;
      
      public var rankList:List;
      
      public var rewardList:List;
      
      public var spr_playTipBg_s:SwfSprite;
      
      private var tipTf:TextField;
      
      public var btn_playTip:Button;
      
      private var helpBg:Quad;
      
      public function LimitSpecialElfUI()
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
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("limitSpecialElf");
         spr_limitSpecialElf = swf.createSprite("spr_limitSpecialElf");
         spr_limitSpecialElf.x = 1136 - spr_limitSpecialElf.width >> 1;
         spr_limitSpecialElf.y = 640 - spr_limitSpecialElf.height >> 1;
         addChild(spr_limitSpecialElf);
         spr_elfContainer = spr_limitSpecialElf.getSprite("spr_elfContainer");
         btn_close = spr_limitSpecialElf.getButton("btn_close");
         btn_drawOne = spr_limitSpecialElf.getButton("btn_drawOne");
         btn_drawTen = spr_limitSpecialElf.getButton("btn_drawTen");
         tf_countDown = spr_limitSpecialElf.getTextField("tf_countDown");
         tf_score = spr_limitSpecialElf.getTextField("tf_score");
         tf_rank = spr_limitSpecialElf.getTextField("tf_rank");
         tf_diamond = spr_limitSpecialElf.getTextField("tf_diamond");
         tf_diamond.autoScale = true;
         tf_elfName = spr_elfContainer.getTextField("tf_elfName");
         var _loc1_:TextField = GetCommon.getText(0,-30,spr_elfContainer.width,45,"敬告：限时神兽暂无“十连必出”设定","FZCuYuan-M03S",45,0,spr_elfContainer,false,true,true);
         spr_playTipBg_s = swf.createSprite("spr_playTipBg_s");
         tipTf = spr_playTipBg_s.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         btn_playTip = swf.createButton("btn_playTipBtn_b");
         btn_playTip.x = 10;
         btn_playTip.y = 10;
         addChild(btn_playTip);
         createRankList();
         createRewardList();
      }
      
      public function createRankList() : void
      {
         rankList = new List();
         rankList.x = 35;
         rankList.y = 190;
         rankList.width = 250;
         rankList.height = 215;
         rankList.isSelectable = false;
         rankList.itemRendererProperties.height = 20;
         rankList.itemRendererProperties.gap = 10;
         rankList.itemRendererProperties.stateToSkinFunction = null;
         rankList.dataProvider = new ListCollection();
      }
      
      public function createRewardList() : void
      {
         rewardList = new List();
         rewardList.x = 658;
         rewardList.y = 234;
         rewardList.width = 222;
         rewardList.height = 315;
         rewardList.isSelectable = false;
         rewardList.itemRendererProperties.stateToSkinFunction = null;
         rewardList.dataProvider = new ListCollection();
      }
      
      public function addHelp() : void
      {
         if(!helpBg)
         {
            helpBg = new Quad(1136,640,0);
            helpBg.alpha = 0.7;
            spr_playTipBg_s.addChildAt(helpBg,0);
         }
         addChild(spr_playTipBg_s);
         spr_playTipBg_s.addEventListener("touch",playTipImg_touchHandler);
      }
      
      public function clean() : void
      {
         spr_playTipBg_s.removeFromParent(true);
         spr_playTipBg_s = null;
      }
      
      private function playTipImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_playTipBg_s);
         if(_loc2_ != null && _loc2_.phase == "ended")
         {
            spr_playTipBg_s.removeFromParent();
            spr_playTipBg_s.removeEventListener("touch",playTipImg_touchHandler);
         }
      }
   }
}
