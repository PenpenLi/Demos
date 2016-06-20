package com.mvc.views.uis.mainCity
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import flash.geom.Rectangle;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.core.Starling;
   import starling.animation.Tween;
   import starling.utils.deg2rad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.MenuMedia;
   import com.common.util.GetCommon;
   import starling.text.TextField;
   import lzm.util.TimeUtil;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   
   public class MenuUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var menuSpr:SwfSprite;
      
      public var menuHandlerBtn:Button;
      
      public var spr_menu_column:SwfSprite;
      
      private var columnRect:Rectangle;
      
      private var columnMenuSprWidth:int;
      
      private var columnMenuSprHeight:int;
      
      private var columnMenuY:Number;
      
      public var btn_eleBtn:Button;
      
      public var btn_backPackBtn:Button;
      
      public var btn_taskBtn:Button;
      
      public var btn_trainBtn:Button;
      
      public var btn_moreBtn:Button;
      
      public var spr_menu_row:SwfSprite;
      
      private var rowRect:Rectangle;
      
      private var rowMenuSprWidth:int;
      
      private var rowMenuSprHeight:int;
      
      private var rowMenuX:Number;
      
      public var btn_activityMenuBtn:Button;
      
      public var btn_informationBtn:Button;
      
      public var btn_trialBtn:Button;
      
      public var btn_miracleBtn:Button;
      
      public var btn_freeShopBtn:Button;
      
      public var btn_playerShopBtn:Button;
      
      public var btn_growthPlanBtn:Button;
      
      public var btn_activityBtn:Button;
      
      public var btn_lotteryBtn:SwfButton;
      
      public var spr_activity_menu_column:SwfSprite;
      
      private var activityColumnRect:Rectangle;
      
      private var activityColumnMenuSprWidth:int;
      
      private var activityColumnMenuSprHeight:int;
      
      private var activityColumnMenuY:Number;
      
      public var spr_moreBtn:SwfSprite;
      
      public var friendBtn:Button;
      
      public var IllustrationsBtn:Button;
      
      public var btn_labaBtn:Button;
      
      public var friendNews:Image;
      
      public var taskNews:Image;
      
      public var activityNews:Image;
      
      public var lotteryNews:Image;
      
      public var growthPlanNews:Image;
      
      public var signNews:Image;
      
      public var infoNews:Image;
      
      public var activityMenuNews:Image;
      
      public var moreBtnNews:Image;
      
      public var btn_rechargeBtn:Button;
      
      public var btn_firstRechargeBtn:SwfButton;
      
      public var btn_rankBtn:Button;
      
      public var btn_diamondUp:SwfButton;
      
      public var btn_signBtn:Button;
      
      public var spr_btn:SwfSprite;
      
      public var btn_vipGift:SwfButton;
      
      public var btn_aution:SwfButton;
      
      public var btn_lightElf:SwfButton;
      
      public var btn_dayHappy:SwfButton;
      
      public var btn_limitSpecialElfBtn:SwfButton;
      
      public const newSize:Number = 0.7;
      
      public var mc_ham:SwfMovieClip;
      
      public var vipGiftNews:Image;
      
      public var btn_preferBtn:SwfButton;
      
      public var btn_richGift:SwfButton;
      
      public var btn_onlineBtn:SwfButton;
      
      public var leftIntermittentSpr:SwfSprite;
      
      public var mc_online:SwfMovieClip;
      
      public var btn_exChange:SwfButton;
      
      public function MenuUI()
      {
         columnRect = new Rectangle();
         rowRect = new Rectangle();
         activityColumnRect = new Rectangle();
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mainCity");
         menuSpr = swf.createSprite("spr_menus");
         addChild(menuSpr);
         spr_menu_column = menuSpr.getSprite("spr_menu_column");
         columnMenuY = spr_menu_column.y;
         btn_eleBtn = spr_menu_column.getButton("btn_eleBtn");
         btn_backPackBtn = spr_menu_column.getButton("btn_backPackBtn");
         btn_taskBtn = spr_menu_column.getButton("btn_taskBtn");
         btn_trainBtn = spr_menu_column.getButton("btn_trainBtn");
         btn_trialBtn = spr_menu_column.getButton("brn_trialBtn");
         btn_moreBtn = spr_menu_column.getButton("btn_moreBtn");
         (btn_moreBtn.skin as Sprite).getChildByName("img_moreLeft").visible = false;
         btn_moreBtn.name = "bomb";
         columnMenuSprWidth = spr_menu_column.width;
         columnMenuSprHeight = spr_menu_column.height;
         spr_menu_row = menuSpr.getSprite("spr_menu_row");
         rowMenuX = spr_menu_row.x;
         btn_informationBtn = spr_menu_row.getButton("btn_informationBtn");
         btn_miracleBtn = spr_menu_row.getButton("btn_miracleBtn");
         btn_freeShopBtn = spr_menu_row.getButton("btn_freeShopBtn");
         btn_playerShopBtn = spr_menu_row.getButton("btn_playerShopBtn");
         btn_growthPlanBtn = spr_menu_row.getButton("btn_growthPlanBtn");
         btn_activityBtn = spr_menu_row.getButton("btn_activityBtn");
         btn_exChange = spr_menu_row.getButton("btn_exChange");
         rowMenuSprWidth = spr_menu_row.width;
         rowMenuSprHeight = spr_menu_row.height;
         menuHandlerBtn = menuSpr.getButton("menuHandlerBtn");
         menuHandlerBtn.pivotX = menuHandlerBtn.width >> 1;
         menuHandlerBtn.pivotY = menuHandlerBtn.height >> 1;
         menuHandlerBtn.x = menuHandlerBtn.x + (menuHandlerBtn.width >> 1);
         menuHandlerBtn.y = menuHandlerBtn.y + (menuHandlerBtn.height >> 1);
         menuHandlerBtn.name = "recover";
         spr_moreBtn = menuSpr.getSprite("spr_moreBtn");
         spr_moreBtn.pivotX = spr_moreBtn.width;
         spr_moreBtn.x = spr_moreBtn.x + spr_moreBtn.width;
         var _loc1_:* = 0;
         spr_moreBtn.scaleY = _loc1_;
         spr_moreBtn.scaleX = _loc1_;
         spr_moreBtn.alpha = 0;
         spr_moreBtn.visible = false;
         btn_labaBtn = spr_moreBtn.getButton("btn_labaBtn");
         friendBtn = spr_moreBtn.getButton("btn_eventsBtn");
         IllustrationsBtn = spr_moreBtn.getButton("btn_illustrationsBtn");
         spr_btn = menuSpr.getSprite("spr_btn");
         btn_rankBtn = spr_btn.getButton("btn_rankBtn");
         btn_rechargeBtn = spr_btn.getButton("btn_rechargeBtn");
         btn_signBtn = spr_btn.getButton("btn_signBtn");
         btn_vipGift = spr_btn.getButton("btn_vipGift");
         btn_aution = spr_btn.getButton("btn_aution");
         mc_ham = (btn_aution.skin as Sprite).getChildByName("mc_ham") as SwfMovieClip;
         mc_ham.gotoAndStop(0);
         spr_btn.pivotY = spr_btn.height;
         spr_btn.y = spr_btn.y + spr_btn.height;
         btn_firstRechargeBtn = swf.createButton("btn_firstRechargeBtn");
         btn_lotteryBtn = swf.createButton("btn_lottery_b");
         btn_diamondUp = swf.createButton("btn_diamondUpBtn");
         btn_lightElf = swf.createButton("btn_lightElf");
         btn_dayHappy = swf.createButton("btn_dayHappy");
         btn_limitSpecialElfBtn = swf.createButton("btn_limitSpecialElfBtn");
         btn_preferBtn = swf.createButton("btn_preferBtn");
         btn_richGift = swf.createButton("btn_richGiftBtn");
         if(!MenuMedia.isOpenDayHappy && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_dayHappy,0.7).visible = true;
         }
         if(!MenuMedia.isOpenDia && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_diamondUp,0.7).visible = true;
         }
         if(!MenuMedia.isOpenLightElf && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_lightElf,0.7).visible = true;
         }
         if(!MenuMedia.isOpenLimitSpecialElf && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_limitSpecialElfBtn,0.7).visible = true;
         }
         if(!MenuMedia.isOpenPrefer && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_preferBtn,0.7).visible = true;
         }
         if(!MenuMedia.isRichGift && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_richGift,0.7).visible = true;
         }
         if(!MenuMedia.isOpenLottery && !Config.isOpenBeginner)
         {
            GetCommon.getNews(btn_lotteryBtn,0.7).visible = true;
         }
         setBtnPivot(btn_diamondUp);
         setBtnPivot(btn_lotteryBtn);
         setBtnPivot(btn_firstRechargeBtn);
         setBtnPivot(btn_lightElf);
         setBtnPivot(btn_dayHappy);
         setBtnPivot(btn_limitSpecialElfBtn);
         setBtnPivot(btn_preferBtn);
         setBtnPivot(btn_richGift);
         leftIntermittentSpr = new SwfSprite();
         leftIntermittentSpr.x = 50;
         leftIntermittentSpr.y = 350;
         menuSpr.addChild(leftIntermittentSpr);
         btn_onlineBtn = swf.createButton("btn_onlineBtn");
         btn_onlineBtn.x = btn_onlineBtn.x - 13;
         ((btn_onlineBtn.skin as Sprite).getChildByName("tf_countdown") as TextField).fontName = "img_countdown";
         ((btn_onlineBtn.skin as Sprite).getChildByName("tf_countdown") as TextField).text = TimeUtil.convertStringToDate(SpecialActPro.onlineCountdown);
         mc_online = (btn_onlineBtn.skin as Sprite).getChildAt(0) as SwfMovieClip;
         mc_online.gotoAndStop("close");
         moreBtnNews = GetCommon.getNews(btn_moreBtn,0.7);
         friendNews = GetCommon.getNews(friendBtn,0.7);
         signNews = GetCommon.getNews(btn_signBtn,0.7);
         taskNews = GetCommon.getNews(btn_taskBtn,0.7);
         activityNews = GetCommon.getNews(btn_activityBtn,0.7);
         lotteryNews = GetCommon.getNews(btn_lotteryBtn,0.7);
         growthPlanNews = GetCommon.getNews(btn_growthPlanBtn,0.7);
         infoNews = GetCommon.getNews(btn_informationBtn,0.7);
         vipGiftNews = GetCommon.getNews(btn_vipGift,0.7);
      }
      
      public function recoverAni(param1:int) : void
      {
         Starling.juggler.removeTweens(spr_menu_column);
         var _loc2_:Tween = new Tween(spr_menu_column,0.7,"easeOutBack");
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = recoverAniUpdate;
         _loc2_.onUpdateArgs = [_loc2_,param1];
      }
      
      private function recoverAniUpdate(param1:Tween, param2:int) : void
      {
         if(param2 == 1)
         {
            spr_menu_column.clipRect = null;
            columnRect.width = columnMenuSprWidth;
            columnRect.height = columnMenuSprHeight * (1 - param1.progress);
            spr_menu_column.y = (columnMenuSprHeight + 55) * param1.progress + columnMenuY;
            spr_menu_column.clipRect = columnRect;
            rowRect.width = rowMenuSprWidth * (1 - param1.progress);
            rowRect.height = rowMenuSprHeight;
            spr_menu_row.x = (rowMenuSprWidth + 55) * param1.progress + rowMenuX;
            spr_menu_row.clipRect = rowRect;
            menuHandlerBtn.rotation = deg2rad(90) * param1.progress;
            var _loc3_:* = 0;
            spr_moreBtn.scaleY = _loc3_;
            spr_moreBtn.scaleX = _loc3_;
            spr_moreBtn.alpha = 0;
            btn_moreBtn.name = "bomb";
         }
         else if(param2 == 2)
         {
            activityColumnRect.width = activityColumnMenuSprWidth;
            activityColumnRect.height = activityColumnMenuSprHeight * (1 - param1.progress);
            spr_activity_menu_column.y = activityColumnMenuY - (activityColumnMenuSprHeight + 55) * (1 - param1.progress);
            spr_activity_menu_column.clipRect = activityColumnRect;
         }
      }
      
      public function bombAni(param1:int) : void
      {
         Starling.juggler.removeTweens(spr_menu_column);
         var _loc2_:Tween = new Tween(spr_menu_column,0.4,"easeOutBack");
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = bombAniUpdate;
         _loc2_.onUpdateArgs = [_loc2_,param1];
      }
      
      private function bombAniUpdate(param1:Tween, param2:int) : void
      {
         if(param2 == 1)
         {
            spr_menu_column.clipRect = null;
            columnRect.width = columnMenuSprWidth;
            columnRect.height = columnMenuSprHeight * param1.progress;
            spr_menu_column.y = (columnMenuSprHeight + 55) * (1 - param1.progress) + columnMenuY;
            spr_menu_column.clipRect = columnRect;
            rowRect.width = rowMenuSprWidth * param1.progress;
            rowRect.height = rowMenuSprHeight;
            spr_menu_row.x = (rowMenuSprWidth + 55) * (1 - param1.progress) + rowMenuX;
            spr_menu_row.clipRect = rowRect;
            menuHandlerBtn.rotation = deg2rad(90) * (1 - param1.progress);
         }
         else if(param2 == 2)
         {
            activityColumnRect.width = activityColumnMenuSprWidth;
            activityColumnRect.height = activityColumnMenuSprHeight * param1.progress;
            spr_activity_menu_column.y = activityColumnMenuY - (activityColumnMenuSprHeight + 55) * param1.progress;
            spr_activity_menu_column.clipRect = activityColumnRect;
         }
      }
      
      public function recoverMoreMenu() : void
      {
         Starling.juggler.removeTweens(spr_moreBtn);
         var t:Tween = new Tween(spr_moreBtn,0.2,"linear");
         Starling.juggler.add(t);
         t.fadeTo(0);
         t.scaleTo(0);
         t.onComplete = function():void
         {
            spr_moreBtn.visible = false;
         };
      }
      
      public function bombMoreMenu() : void
      {
         Starling.juggler.removeTweens(spr_moreBtn);
         var _loc1_:Tween = new Tween(spr_moreBtn,0.2,"linear");
         Starling.juggler.add(_loc1_);
         _loc1_.fadeTo(1);
         _loc1_.scaleTo(1);
      }
      
      public function disposeBtn() : void
      {
         removeBtn(btn_firstRechargeBtn);
         removeBtn(btn_lotteryBtn);
         removeBtn(btn_diamondUp);
         removeBtn(btn_lightElf);
         removeBtn(btn_dayHappy);
         removeBtn(btn_limitSpecialElfBtn);
         removeBtn(btn_preferBtn);
         removeBtn(btn_richGift);
         removeBtn(btn_onlineBtn);
      }
      
      private function removeBtn(param1:SwfButton) : void
      {
         if(param1)
         {
            param1.removeFromParent(true);
         }
      }
      
      private function setBtnPivot(param1:SwfButton) : void
      {
         param1.pivotY = param1.height;
      }
   }
}
