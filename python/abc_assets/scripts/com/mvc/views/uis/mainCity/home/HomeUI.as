package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.home.BagElfMedia;
   import com.mvc.views.mediator.mainCity.home.ComElfMedia;
   import com.mvc.views.mediator.mainCity.home.HomeElfInfoMedia;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class HomeUI extends Sprite
   {
       
      private var mySpr:SwfSprite;
      
      public var close:Button;
      
      private var swf:Swf;
      
      public var spr_playTipBg_s:SwfSprite;
      
      private var tipTf:TextField;
      
      public var btn_playTip:Button;
      
      private var helpBg:Quad;
      
      public function HomeUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addBag();
         addCom();
         addElfInfo();
      }
      
      public function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("home");
         mySpr = swf.createSprite("spr_home_s");
         spr_playTipBg_s = swf.createSprite("spr_playTipBg_s");
         tipTf = spr_playTipBg_s.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         tipTf.text = "你能在这里把背包中的精灵放进电脑存放，也能把电脑中的精灵放到背包中。\n\n如果你的背包满了，那么所抓的精灵会自动放进电脑，记得来查看哦。\n\n放生精灵可返还大量的神秘积分，神秘积分可以在神秘商店兑换稀有道具，按照放生精灵的稀有度计算神秘积分，稀有度越高产出的神秘积分越多";
         close = swf.createButton("btn_close_b");
         close.name = "btn_close";
         btn_playTip = swf.createButton("btn_playTipBtn_b");
         addChild(mySpr);
         close.x = 1065;
         close.y = 0;
         addChild(btn_playTip);
         addChild(close);
      }
      
      private function addBag() : void
      {
         if(!GameFacade.getInstance().hasMediator("BagElfMedia"))
         {
            GameFacade.getInstance().registerMediator(new BagElfMedia(new BagElfUI()));
         }
         var _loc1_:BagElfUI = (GameFacade.getInstance().retrieveMediator("BagElfMedia") as BagElfMedia).UI as BagElfUI;
         _loc1_.x = 12;
         _loc1_.y = 10;
         mySpr.addChild(_loc1_);
      }
      
      private function addCom() : void
      {
         if(!GameFacade.getInstance().hasMediator("ComElfMedia"))
         {
            GameFacade.getInstance().registerMediator(new ComElfMedia(new ComElfUI()));
         }
         var _loc1_:ComElfUI = (GameFacade.getInstance().retrieveMediator("ComElfMedia") as ComElfMedia).UI as ComElfUI;
         _loc1_.x = 616;
         _loc1_.y = 10;
         mySpr.addChild(_loc1_);
      }
      
      private function addElfInfo() : void
      {
         if(!GameFacade.getInstance().hasMediator("HomeElfInfoMedia"))
         {
            GameFacade.getInstance().registerMediator(new HomeElfInfoMedia(new HomeElfInfoUI()));
         }
         var _loc1_:HomeElfInfoUI = (GameFacade.getInstance().retrieveMediator("HomeElfInfoMedia") as HomeElfInfoMedia).UI as HomeElfInfoUI;
         _loc1_.x = 325;
         _loc1_.y = 24;
         mySpr.addChild(_loc1_);
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
