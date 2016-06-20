package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import flash.utils.Timer;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.mainCity.elfSeries.SeriesVO;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   
   public class ElfSeriesUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_elfSeriesBg:SwfSprite;
      
      public var btn_rule:SwfButton;
      
      public var btn_exChangeScore:SwfButton;
      
      public var btn_close:SwfButton;
      
      public var btn_rank:SwfButton;
      
      public var btn_pvpRecord:SwfButton;
      
      public var btn_change:SwfButton;
      
      public var myRank:TextField;
      
      public var powerNum:TextField;
      
      public var remainNum:TextField;
      
      public var CDtext:TextField;
      
      public var elfSprite:Sprite;
      
      public var rivalSprite:Sprite;
      
      public var rivalUnitVec:Vector.<com.mvc.views.uis.mainCity.elfSeries.RivalUnitUI>;
      
      public var countDownTimer:Timer;
      
      public var spr_restar:SwfSprite;
      
      public var diamon:TextField;
      
      public var btn_reStart:SwfButton;
      
      public var formationConVec:Vector.<ElfBgUnitUI>;
      
      public var btn_formation:SwfButton;
      
      public var spr_mainPage:SwfSprite;
      
      public var btn_buyCount:SwfButton;
      
      public var pvpNews:Image;
      
      public function ElfSeriesUI()
      {
         rivalUnitVec = new Vector.<com.mvc.views.uis.mainCity.elfSeries.RivalUnitUI>([]);
         countDownTimer = new Timer(1000);
         formationConVec = new Vector.<ElfBgUnitUI>([]);
         super();
         init();
         showRivaol();
         initFormation();
         countDownTimer.addEventListener("timer",countDownEvent);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfSeries");
         spr_elfSeriesBg = swf.createSprite("spr_elfSeriesBg");
         spr_mainPage = spr_elfSeriesBg.getSprite("spr_mainPage");
         btn_close = spr_mainPage.getButton("btn_close");
         btn_rule = spr_mainPage.getButton("btn_rule");
         btn_rank = spr_mainPage.getButton("btn_rank");
         btn_exChangeScore = spr_mainPage.getButton("btn_exChangeScore");
         btn_pvpRecord = spr_mainPage.getButton("btn_pvpRecord");
         btn_formation = spr_mainPage.getButton("btn_formation");
         btn_change = spr_mainPage.getButton("btn_change");
         btn_buyCount = spr_mainPage.getButton("btn_buyCount");
         myRank = spr_mainPage.getTextField("myRank");
         powerNum = spr_mainPage.getTextField("powerNum");
         remainNum = spr_mainPage.getTextField("remainNum");
         CDtext = spr_mainPage.getTextField("CDtext");
         spr_restar = spr_mainPage.getSprite("spr_restar");
         diamon = spr_restar.getTextField("diamon");
         btn_reStart = spr_restar.getButton("btn_reStart");
         pvpNews = GetCommon.getNews(btn_pvpRecord,1,0,10,1);
         spr_restar.visible = false;
         addChild(spr_elfSeriesBg);
         elfSprite = new Sprite();
         elfSprite.x = 190;
         elfSprite.y = 247;
         spr_mainPage.x = 40;
         spr_mainPage.addChild(elfSprite);
         rivalSprite = new Sprite();
         rivalSprite.x = 280;
         rivalSprite.y = 440;
         spr_mainPage.addChild(rivalSprite);
         myRank.autoSize = "horizontal";
         myRank.fontName = "img_series";
         powerNum.fontName = "img_series";
         remainNum.fontName = "img_series";
         myRank.color = 16777215;
         powerNum.color = 16777215;
         remainNum.color = 16777215;
         CDtext.fontName = "img_font";
      }
      
      public function initFormation() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         formationConVec.length = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.FormationElfVec.length)
         {
            _loc1_ = new ElfBgUnitUI();
            _loc1_.identify = "联盟";
            _loc1_.touchable = false;
            _loc1_.x = 113 * _loc2_;
            _loc1_.switchContain(false);
            elfSprite.addChild(_loc1_);
            formationConVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function showRivaol() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new com.mvc.views.uis.mainCity.elfSeries.RivalUnitUI();
            _loc2_.x = 240 * _loc1_;
            _loc2_.name = "rivalUnit" + _loc1_;
            rivalSprite.addChild(_loc2_);
            rivalUnitVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function showSeries() : void
      {
         updateCount();
         myRank.text = SeriesVO.rank;
         if(SeriesVO.surplusTime > 0)
         {
            LogUtil("联盟大赛的计时器开启");
            countDownTimer.start();
            if(PlayerVO.vipRank >= 3)
            {
               switchBtn(true);
            }
         }
      }
      
      public function updateCount() : void
      {
         remainNum.text = SeriesVO.fightTime;
         if(SeriesVO.fightTime <= 0 && SeriesVO.remainCount > 0)
         {
            btn_buyCount.visible = true;
         }
         else
         {
            btn_buyCount.visible = false;
         }
      }
      
      public function showRival() : void
      {
         var _loc1_:* = 0;
         if(SeriesVO.rank == 1)
         {
            rivalSprite.visible = false;
         }
         _loc1_ = 0;
         while(_loc1_ < SeriesVO.rivalVec.length)
         {
            if(SeriesVO.rivalVec[_loc1_] != null)
            {
               rivalUnitVec[_loc1_].myRivalVo = SeriesVO.rivalVec[_loc1_];
            }
            else
            {
               rivalUnitVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function countDownEvent(param1:TimerEvent) : void
      {
         §§dup(SeriesVO).surplusTime--;
         CDtext.text = TimeUtil.convertStringToDate(SeriesVO.surplusTime);
         if(SeriesVO.surplusTime <= 0)
         {
            countDownTimer.stop();
            switchBtn(false);
            LogUtil("联盟大赛的计时器关闭countDownEvent");
         }
      }
      
      public function stopCD() : void
      {
         CDtext.text = "";
         SeriesVO.surplusTime = 0;
         countDownTimer.stop();
         switchBtn(false);
      }
      
      public function switchBtn(param1:Boolean) : void
      {
         spr_restar.visible = param1;
         btn_change.visible = !param1;
      }
      
      public function removeTime() : void
      {
         LogUtil("联盟大赛的计时器关闭removeTime");
         countDownTimer.stop();
         countDownTimer.removeEventListener("timer",countDownEvent);
         countDownTimer = null;
      }
   }
}
