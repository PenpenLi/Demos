package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.controls.List;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.util.TimeUtil;
   import com.mvc.models.vos.huntingParty.HuntRankVO;
   import com.mvc.models.vos.huntingParty.RankRewardVO;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.GetCommon;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalLayout;
   import com.common.util.RewardHandle;
   import com.mvc.models.vos.huntingParty.RankVO;
   import starling.display.Quad;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class HuntingRankUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_rank:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var CDTime:TextField;
      
      public var score:TextField;
      
      public var myRank:TextField;
      
      public var bg6:SwfScale9Image;
      
      public var bg7:SwfScale9Image;
      
      public var rewardList:List;
      
      public var rankList:List;
      
      public var btn_help:SwfScale9Image;
      
      private var colorArr:Array;
      
      public function HuntingRankUI()
      {
         colorArr = [16737792,12403978,682634,8734489];
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty1"));
         var _loc2_:* = 1.3;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         addChild(_loc1_);
         init();
         initList();
      }
      
      private function initList() : void
      {
         rewardList = new List();
         rewardList.x = bg7.x;
         rewardList.y = bg7.y + 3;
         rewardList.width = bg7.width;
         rewardList.height = bg7.height - 5;
         rewardList.isSelectable = false;
         rewardList.itemRendererProperties.stateToSkinFunction = null;
         spr_rank.addChild(rewardList);
         rewardList.addEventListener("creationComplete",creatComplete);
         rankList = new List();
         rankList.x = bg6.x;
         rankList.y = bg6.y + 2;
         rankList.width = bg6.width - 2;
         rankList.height = bg6.height - 11;
         rankList.isSelectable = false;
         rankList.itemRendererProperties.stateToSkinFunction = null;
         rankList.itemRendererProperties.minHeight = 50;
         spr_rank.addChild(rankList);
         rankList.addEventListener("creationComplete",creatComplete2);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = -2;
         _loc1_.paddingRight = 0;
         _loc1_.paddingLeft = -4;
         rewardList.layout = _loc1_;
      }
      
      private function creatComplete2() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = -16;
         var _loc2_:* = -10;
         _loc1_.paddingBottom = _loc2_;
         _loc1_.paddingTop = _loc2_;
         _loc1_.paddingRight = 0;
         _loc1_.paddingLeft = -10;
         rankList.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_rank = swf.createSprite("spr_rank");
         btn_close = spr_rank.getButton("btn_close");
         CDTime = spr_rank.getTextField("CDTime");
         score = spr_rank.getTextField("score");
         myRank = spr_rank.getTextField("myRank");
         bg6 = spr_rank.getScale9Image("bg6");
         bg7 = spr_rank.getScale9Image("bg7");
         btn_help = spr_rank.getScale9Image("btn_help");
         spr_rank.x = 1136 - spr_rank.width >> 1;
         spr_rank.y = 640 - spr_rank.height >> 1;
         addChild(spr_rank);
      }
      
      public function setInfo() : void
      {
         CDTime.text = TimeUtil.convertStringToDate(HuntRankVO.lessTime);
         score.text = HuntRankVO.myScore;
         myRank.text = HuntRankVO.myRank;
      }
      
      public function setIcon(param1:RankRewardVO) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         param1.order > 4?4:param1.order;
         _loc3_.addChild(swf.createImage("img_list" + param1.order));
         var _loc4_:SwfImage = swf.createImage("img_icon_pm");
         _loc4_.y = 8;
         _loc3_.addChild(_loc4_);
         GetCommon.getText(_loc4_.x + 10,_loc4_.y,_loc4_.width - 20,_loc4_.height,param1.title,"FZCuYuan-M03S",20,16777215,_loc3_,false,false,true,true);
         var _loc5_:ScrollContainer = new ScrollContainer();
         _loc5_.width = 279;
         _loc5_.height = 100;
         _loc5_.x = 3;
         _loc5_.y = 33;
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.verticalAlign = "middle";
         _loc2_.horizontalAlign = "center";
         _loc2_.gap = 10;
         _loc2_.useVirtualLayout = false;
         _loc5_.scrollBarDisplayMode = "none";
         _loc5_.horizontalScrollPolicy = "none";
         _loc5_.layout = _loc2_;
         _loc3_.addChild(_loc5_);
         RewardHandle.showReward(param1.rewardObj,_loc5_,0.6,16777215);
         return _loc3_;
      }
      
      public function setIcon2(param1:RankVO) : Sprite
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = null;
         var _loc6_:Sprite = new Sprite();
         if(param1.rank % 2 == 0)
         {
            _loc4_ = new Quad(628,50,14930865);
         }
         else
         {
            _loc4_ = new Quad(628,50,13940368);
         }
         _loc6_.addChild(_loc4_);
         if(param1.vip > 0)
         {
            _loc2_ = GetCommon.getVipIcon(param1.vip,0.9);
            _loc2_.x = 30;
            _loc2_.y = 2;
            _loc6_.addChild(_loc2_);
         }
         if(param1.rank <= 3)
         {
            _loc7_ = swf.createImage("img_rank" + param1.rank);
            _loc7_.x = 100;
            _loc7_.y = 10;
            _loc6_.addChild(_loc7_);
         }
         else
         {
            GetCommon.getText(85,0,50,50,param1.rank,"FZCuYuan-M03S",28,8865043,_loc6_);
         }
         if(param1.rank > 0)
         {
            _loc3_ = param1.rank > 4?4:param1.rank;
            _loc5_ = GetCommon.getText(240,0,50,50,"【" + param1.serverId + "区】" + param1.niceName,"FZCuYuan-M03S",20,colorArr[_loc3_ - 1],_loc6_,true,false,false,true);
            GetCommon.getText(500,0,50,50,param1.score,"FZCuYuan-M03S",20,colorArr[_loc3_ - 1],_loc6_,true,false,false,true);
         }
         return _loc6_;
      }
   }
}
