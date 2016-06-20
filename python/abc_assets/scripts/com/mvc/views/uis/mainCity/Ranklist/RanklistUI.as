package com.mvc.views.uis.mainCity.Ranklist
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.GetCommon;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.mediator.mainCity.Ranklist.RanklistMedia;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class RanklistUI extends Sprite
   {
       
      public var swf:Swf;
      
      public var panel:ScrollContainer;
      
      public var spr_rank:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var rankList:List;
      
      public var spr_myRank:SwfSprite;
      
      private var myRankText:TextField;
      
      private var myRankInfoText:TextField;
      
      private var image:Image;
      
      private var img:SwfImage;
      
      public function RanklistUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addList();
         addMyRank();
         addPanel();
      }
      
      private function addMyRank() : void
      {
         spr_myRank = swf.createSprite("spr_myRank_s");
         myRankText = new TextField(200,60,"","img_rank",50,16777215,true);
         myRankText.autoSize = "horizontal";
         myRankText.x = 40;
         myRankText.y = 25;
         spr_myRank.addChild(myRankText);
         myRankInfoText = new TextField(350,100,"","1",25,9713664,true);
         myRankInfoText.hAlign = "left";
         myRankInfoText.vAlign = "center";
         myRankInfoText.x = 330;
         spr_myRank.addChild(myRankInfoText);
         spr_myRank.x = 227;
         spr_myRank.y = 88;
         spr_rank.addChildAt(spr_myRank,2);
      }
      
      private function addList() : void
      {
         rankList = new List();
         rankList.width = 660;
         rankList.height = 420;
         rankList.x = 245;
         rankList.y = 188;
         rankList.isSelectable = false;
         spr_rank.addChildAt(rankList,1);
      }
      
      private function scrollListComplete() : void
      {
         var _loc2_:* = null;
         var _loc1_:Tween = new Tween(spr_myRank,0.5);
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",1,0.5);
         if(rankList.verticalScrollPosition == 0)
         {
            _loc2_ = new Tween(rankList,0.3);
            _loc2_.animate("y",188);
            _loc2_.onUpdate = update;
            _loc2_.onUpdateArgs = [_loc2_];
            Starling.juggler.add(_loc2_);
         }
      }
      
      private function update(param1:Tween) : void
      {
         rankList.height = 520 - (rankList.y - 88);
      }
      
      private function startScrollList() : void
      {
         var _loc1_:Tween = new Tween(spr_myRank,0.2);
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",0.5,1);
         rankList.height = 520;
         rankList.y = 88;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("ranklist");
         spr_rank = swf.createSprite("spr_rank");
         btn_close = spr_rank.getButton("btn_close");
         spr_rank.x = 1136 - spr_rank.width >> 1;
         spr_rank.y = 640 - spr_rank.height >> 1;
         addChild(spr_rank);
      }
      
      private function addPanel() : void
      {
         panel = new ScrollContainer();
         spr_rank.addChild(panel);
         panel.width = 185;
         panel.height = 500;
         panel.x = 30;
         panel.y = 100;
         panel.addEventListener("scrollStart",startScroll);
         panel.addEventListener("scrollComplete",scrollComplete);
      }
      
      public function myRank(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:* = null;
         if(image)
         {
            GetpropImage.clean(image);
         }
         image = GetPlayerRelatedPicFactor.getHeadPic(PlayerVO.headPtId,0.75);
         image.x = 222;
         image.y = 10;
         spr_myRank.addChild(image);
         if(PlayerVO.vipRank > 0)
         {
            _loc4_ = GetCommon.getVipIcon(PlayerVO.vipRank);
            _loc4_.x = image.x - 5;
            _loc4_.y = image.y - 5;
            spr_myRank.addChild(_loc4_);
         }
         if(param1 > 0 && param1 <= 3)
         {
            if(img)
            {
               ElfFrontImageManager.getInstance().disposeImg(img);
            }
            img = getImage("img_pp" + param1);
            var _loc6_:* = 0.8;
            img.scaleY = _loc6_;
            img.scaleX = _loc6_;
            img.x = 40;
            img.y = 15 + (param1 - 1) * 10;
            spr_myRank.addChild(img);
            myRankText.text = "";
         }
         else if(param1 < 1)
         {
            if(img)
            {
               ElfFrontImageManager.getInstance().disposeImg(img);
            }
            myRankText.fontSize = 30;
            myRankText.fontName = "FZCuYuan-M03S";
            myRankText.color = 9845764;
            myRankText.text = "暂未上榜";
         }
         else
         {
            if(img)
            {
               ElfFrontImageManager.getInstance().disposeImg(img);
            }
            myRankText.fontSize = 50;
            myRankText.fontName = "img_rank";
            myRankText.color = 16777215;
            myRankText.text = param1.toString();
         }
         var _loc5_:String = "Lv." + PlayerVO.lv + "   " + PlayerVO.nickName;
         if(param2 == 2 || param2 == 3 || param2 == 4 || param2 == 5 || param2 == 6)
         {
            _loc5_ = _loc5_ + (RanklistMedia.decArr[param2] + param3);
         }
         myRankInfoText.text = _loc5_;
      }
      
      private function scrollComplete() : void
      {
         RanklistMedia.isScrolling = false;
      }
      
      private function startScroll() : void
      {
         RanklistMedia.isScrolling = true;
      }
      
      public function cleanImg() : void
      {
         if(img)
         {
            ElfFrontImageManager.getInstance().disposeImg(img);
            img = null;
         }
         if(image)
         {
            GetpropImage.clean(image);
            image = null;
         }
         myRankInfoText.removeFromParent(true);
         myRankText.removeFromParent(true);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
