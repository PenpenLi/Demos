package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class RivalUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_playerBg:SwfSprite;
      
      private var spr_head:Image;
      
      private var palyerName:TextField;
      
      private var elfNum:TextField;
      
      private var rank:TextField;
      
      private var power:TextField;
      
      private var btn_chanllenge:SwfButton;
      
      private var _rivarVo:RivalVO;
      
      private var vipSpr:SwfSprite;
      
      public function RivalUnitUI()
      {
         super();
         init();
         btn_chanllenge.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         (Facade.getInstance().retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5013(myRivalVo);
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfSeries");
         spr_playerBg = swf.createSprite("spr_playerBg");
         palyerName = spr_playerBg.getTextField("palyerName");
         elfNum = spr_playerBg.getTextField("elfNum");
         rank = spr_playerBg.getTextField("rank");
         power = spr_playerBg.getTextField("power");
         btn_chanllenge = spr_playerBg.getButton("btn_chanllenge");
         palyerName.fontName = "1";
         addChild(spr_playerBg);
      }
      
      public function set myRivalVo(param1:RivalVO) : void
      {
         _rivarVo = param1;
         LogUtil(param1.headPtId + "==rivarVo.headPtId");
         if(spr_head != null)
         {
            GetpropImage.clean(spr_head);
         }
         spr_head = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId,0.7);
         spr_head.x = 75;
         spr_head.y = 5;
         spr_playerBg.addChild(spr_head);
         if(vipSpr && vipSpr.parent)
         {
            vipSpr.removeFromParent(true);
         }
         if(param1.vipRank > 0)
         {
            vipSpr = GetCommon.getVipIcon(param1.vipRank);
            vipSpr.x = 75;
            spr_playerBg.addChild(vipSpr);
         }
         palyerName.text = param1.userName;
         elfNum.text = param1.elfVec.length;
         rank.text = param1.rank;
         power.text = GetElfFactor.powerCalculate(param1.elfVec).toString();
         spr_head.addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_head);
         if(_loc2_ && _loc2_.phase == "began")
         {
            Facade.getInstance().sendNotification("switch_win",this.parent.parent,"LOAD_RIVAL_INFO");
            Facade.getInstance().sendNotification("SEND_RIVAL_INFO",myRivalVo);
         }
      }
      
      public function get myRivalVo() : RivalVO
      {
         return _rivarVo;
      }
   }
}
