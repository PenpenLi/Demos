package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Label;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.display.GridMask;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.events.Event;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class HuntingPartyUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_huntingParty:SwfSprite;
      
      public var scrollContainer:ScrollContainer;
      
      public var btn_home:SwfButton;
      
      public var spr_btn1:SwfSprite;
      
      public var btn_elf:SwfButton;
      
      public var btn_rank:SwfButton;
      
      public var btn_bag:SwfButton;
      
      public var btn_reward:SwfButton;
      
      public var buffIcon:com.mvc.views.uis.huntingParty.TimeBtnUnit;
      
      public var targetElf:com.mvc.views.uis.huntingParty.TimeBtnUnit;
      
      public var spr_catchTime:SwfSprite;
      
      public var catchCount:Label;
      
      public var spr_hunting:SwfSprite;
      
      public var spr_Sorce:SwfSprite;
      
      public var sorceNum:TextField;
      
      public var cloundScene:SwfSprite;
      
      public var cloundSpeed:Array;
      
      public var sunImg:SwfImage;
      
      public var btn_addTime:SwfButton;
      
      public var btn_myHome:SwfButton;
      
      public var icon_count:SwfImage;
      
      public var spr_countLess:SwfSprite;
      
      public var countTime:TextField;
      
      public var mc_mark:SwfMovieClip;
      
      public var scoreIcon:com.mvc.views.uis.huntingParty.TimeBtnUnit;
      
      private var gridMask:GridMask;
      
      public function HuntingPartyUI()
      {
         cloundSpeed = [0.1,0.3,0.3];
         super();
         initScrollContainer();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         addBg();
         addNode();
         addSun();
         addCloundScene();
         addBtn();
         addCDtime();
         this.addEventListener("enterFrame",sceneAni);
      }
      
      private function addMark() : void
      {
         mc_mark = swf.createMovieClip("mc_mark");
         mc_mark.stop(true);
         mc_mark.touchable = false;
         scrollContainer.addChild(mc_mark);
      }
      
      private function addCDtime() : void
      {
         spr_countLess = swf.createSprite("spr_countLess");
         countTime = spr_countLess.getTextField("prompt");
         countTime.text = "下点恢复: 00:00:00";
         spr_countLess.x = spr_catchTime.x + 100;
         spr_countLess.y = spr_catchTime.y + 100;
      }
      
      private function sceneAni() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < cloundScene.numChildren)
         {
            _loc1_ = cloundScene.getImage("clound" + (_loc2_ + 1));
            _loc1_.x = _loc1_.x + cloundSpeed[_loc2_];
            if(_loc1_.x > 1136)
            {
               _loc1_.x = -_loc1_.width;
            }
            _loc2_++;
         }
         sunImg.rotation = sunImg.rotation + 0.001;
      }
      
      private function addCloundScene() : void
      {
         cloundScene = swf.createSprite("spr_clound");
         addChild(cloundScene);
         cloundScene.touchable = false;
      }
      
      private function addSun() : void
      {
         sunImg = swf.createImage("img_sun");
         sunImg.pivotX = sunImg.width / 2;
         sunImg.pivotY = sunImg.height / 2;
         var _loc1_:* = 4;
         sunImg.scaleY = _loc1_;
         sunImg.scaleX = _loc1_;
         _loc1_ = -110;
         sunImg.y = _loc1_;
         sunImg.x = _loc1_;
         sunImg.touchable = false;
         addChild(sunImg);
      }
      
      private function addBtn() : void
      {
         spr_btn1 = swf.createSprite("spr_btn1");
         btn_elf = spr_btn1.getButton("btn_elf");
         btn_rank = spr_btn1.getButton("btn_rank");
         btn_bag = spr_btn1.getButton("btn_bag");
         btn_reward = spr_btn1.getButton("btn_reward");
         btn_home = spr_btn1.getButton("btn_home");
         spr_btn1.x = 1136 - spr_btn1.width >> 1;
         spr_btn1.y = 630;
         addChild(spr_btn1);
         spr_catchTime = swf.createSprite("spr_catchTime");
         btn_addTime = spr_catchTime.getButton("btn_addTime");
         icon_count = spr_catchTime.getImage("icon");
         catchCount = GetCommon.getLabel(spr_catchTime,70,16,18,"",16777215);
         spr_catchTime.x = 225;
         spr_catchTime.y = 10;
         addChild(spr_catchTime);
         spr_Sorce = swf.createSprite("spr_Sorce");
         sorceNum = spr_Sorce.getTextField("sorceNum");
         spr_Sorce.y = -7;
         spr_Sorce.x = 20;
         addChild(spr_Sorce);
         btn_myHome = swf.createButton("btn_myHome_b");
         btn_myHome.x = 50;
         btn_myHome.y = 110;
         scrollContainer.addChild(btn_myHome);
      }
      
      private function addNode() : void
      {
         spr_hunting = swf.createSprite("spr_hunting");
         scrollContainer.addChild(spr_hunting);
      }
      
      private function addBg() : void
      {
         var _loc1_:* = null;
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty1"));
         scrollContainer.addChild(_loc1_);
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty2"));
         _loc1_.x = 898;
         scrollContainer.addChild(_loc1_);
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty3"));
         _loc1_.y = 521;
         scrollContainer.addChild(_loc1_);
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty4"));
         _loc1_.x = 898;
         _loc1_.y = 521;
         scrollContainer.addChild(_loc1_);
      }
      
      private function initScrollContainer() : void
      {
         scrollContainer = new ScrollContainer();
         addChild(scrollContainer);
         scrollContainer.width = 1136;
         scrollContainer.height = 640;
         scrollContainer.addEventListener("scroll",onScroll);
         scrollContainer.addEventListener("scrollStart",startScroll);
      }
      
      private function startScroll() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < spr_hunting.numChildren)
         {
            spr_hunting.getButton("btn" + (_loc1_ + 1)).resetContents();
            _loc1_++;
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         limitPoint();
      }
      
      private function limitPoint() : void
      {
         if(scrollContainer.horizontalScrollPosition >= 1800 - 1136)
         {
            scrollContainer.horizontalScrollPosition = 1800 - 1136;
         }
         if(scrollContainer.horizontalScrollPosition <= 0)
         {
            scrollContainer.horizontalScrollPosition = 0;
         }
         if(scrollContainer.verticalScrollPosition <= 0)
         {
            scrollContainer.verticalScrollPosition = 0;
         }
         if(scrollContainer.verticalScrollPosition >= 1014 - 640)
         {
            scrollContainer.verticalScrollPosition = 1014 - 640;
         }
      }
      
      public function setInfo() : void
      {
         if(!HuntPartyVO.isOpen)
         {
            Tips.show("捕虫大会活动已结束, 请关注排行榜信息");
         }
         if(HuntPartyVO.lastNodeId < GetHuntingParty.nodeVec.length)
         {
            addMark();
         }
         catchCount.text = HuntPartyVO.catchCount + "<font color=\'#ffff00\' sizer=\'18\'>/" + HuntPartyVO.maxCatchCount + "</font>";
         updateBuff();
         updateElf();
         updateScore();
         ElfFrontImageManager.tempNoRemoveTexture = HuntingPartyPro.bossName;
         ElfFrontImageManager.getInstance().getImg(HuntingPartyPro.bossName,initNode);
         icon_count.addEventListener("touch",touch);
      }
      
      private function touch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(icon_count);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               addChild(spr_countLess);
            }
            if(_loc2_.phase == "ended")
            {
               spr_countLess.removeFromParent();
            }
         }
      }
      
      public function updateElf() : void
      {
         if(!HuntPartyVO.catchElfObj)
         {
            return;
         }
         if(targetElf)
         {
            targetElf.removeFromParent(true);
            targetElf = null;
         }
         targetElf = new com.mvc.views.uis.huntingParty.TimeBtnUnit(1021,12,HuntPartyVO.catchElfObj.goalElfVo.imgName,this,"elf",HuntPartyVO.catchElfObj.lessTime,0.8888888888888888);
      }
      
      public function updateBuff() : void
      {
         if(buffIcon)
         {
            buffIcon.removeFromParent(true);
            buffIcon = null;
         }
         if(HuntPartyVO.buffObj)
         {
            buffIcon = new com.mvc.views.uis.huntingParty.TimeBtnUnit(910,10,"img_buff" + HuntPartyVO.buffObj.id,this,"buff",HuntPartyVO.buffObj.time,0.9);
         }
         else if(HuntPartyVO.isOpen)
         {
            buffIcon = new com.mvc.views.uis.huntingParty.TimeBtnUnit(910,10,"img_icon_buuf_jh",this,"buff",0,0.9);
         }
      }
      
      public function updateScore() : void
      {
         if(scoreIcon)
         {
            scoreIcon.removeFromParent(true);
            scoreIcon = null;
         }
         if(HuntPartyVO.scorePropVo)
         {
            if(HuntPartyVO.scorePropVo.id == "869")
            {
               scoreIcon = new com.mvc.views.uis.huntingParty.TimeBtnUnit(800,10,"img_icon_jf1",this,"buff",HuntPartyVO.scoreLessTime,0.9);
            }
            if(HuntPartyVO.scorePropVo.id == "870")
            {
               scoreIcon = new com.mvc.views.uis.huntingParty.TimeBtnUnit(800,10,"img_icon_jf2",this,"buff",HuntPartyVO.scoreLessTime,0.9);
            }
         }
      }
      
      private function initNode() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         _loc2_ = 0;
         while(_loc2_ < GetHuntingParty.nodeVec.length)
         {
            (§§dup((spr_hunting.getButton("btn" + (_loc2_ + 1)).skin as Sprite).getChildByName("nameTxt") as TextField)).y++;
            ((spr_hunting.getButton("btn" + (_loc2_ + 1)).skin as Sprite).getChildByName("nameTxt") as TextField).text = GetHuntingParty.nodeVec[_loc2_].name;
            if(GetHuntingParty.nodeVec[_loc2_].type == 1)
            {
               _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(HuntingPartyPro.bossName[0]));
               ElfFrontImageManager.getInstance().autoZoom(_loc1_,100);
               _loc1_.x = 50;
               _loc1_.y = 55;
               (spr_hunting.getButton("btn" + (_loc2_ + 1)).skin as Sprite).addChild(_loc1_);
               HuntingPartyPro.bossName.splice(0,1);
            }
            _loc2_++;
         }
         updateNode();
      }
      
      public function updateNode() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < GetHuntingParty.nodeVec.length)
         {
            spr_hunting.getButton("btn" + (_loc2_ + 1)).touchable = true;
            ((spr_hunting.getButton("btn" + (_loc2_ + 1)).skin as Sprite).getChildAt(1) as Image).color = 16777215;
            if(GetHuntingParty.nodeVec[_loc2_].type == 1)
            {
               ((spr_hunting.getButton("btn" + (_loc2_ + 1)).skin as Sprite).getChildAt(4) as Image).color = 16777215;
            }
            _loc2_++;
         }
         _loc1_ = HuntPartyVO.lastNodeId;
         while(_loc1_ < GetHuntingParty.nodeVec.length)
         {
            if(HuntPartyVO.lastNodeId == _loc1_ && HuntPartyVO.isOpen)
            {
               LogUtil("最新节点=",HuntPartyVO.lastNodeId);
               mc_mark.gotoAndPlay(0);
               mc_mark.x = spr_hunting.getButton("btn" + (_loc1_ + 1)).x + spr_hunting.getButton("btn" + (_loc1_ + 1)).width / 2 - mc_mark.width / 2;
               mc_mark.y = spr_hunting.getButton("btn" + (_loc1_ + 1)).y - 70;
            }
            else
            {
               spr_hunting.getButton("btn" + (_loc1_ + 1)).touchable = false;
               ((spr_hunting.getButton("btn" + (_loc1_ + 1)).skin as Sprite).getChildAt(1) as Image).color = 10066329;
               if(GetHuntingParty.nodeVec[_loc1_].type == 1)
               {
                  ((spr_hunting.getButton("btn" + (_loc1_ + 1)).skin as Sprite).getChildAt(4) as Image).color = 10066329;
               }
            }
            _loc1_++;
         }
      }
   }
}
