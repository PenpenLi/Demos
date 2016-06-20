package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.home.HomeMedia;
   import com.common.util.xmlVOHandler.GetHomeSpace;
   import starling.display.Quad;
   
   public class ComLockUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.home.ComLockUI;
       
      private var swf:Swf;
      
      public var spr_lockBg:SwfSprite;
      
      public var btn_lockClose:SwfButton;
      
      public var btn_diamond:SwfButton;
      
      public var btn_silver:SwfButton;
      
      public var lockLv:TextField;
      
      public var lockSilver:TextField;
      
      public var lockDiamond:TextField;
      
      private var _lv:int;
      
      private var nowSpace:TextField;
      
      private var nextSpace:TextField;
      
      private var parentPage:Sprite;
      
      private var _capacity:int;
      
      private var obj:Object;
      
      public function ComLockUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         this.addEventListener("triggered",clickHandler);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.home.ComLockUI
      {
         if(!instance)
         {
            instance = new com.mvc.views.uis.mainCity.home.ComLockUI();
         }
         return instance;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_lockClose !== _loc2_)
         {
            if(btn_diamond !== _loc2_)
            {
               if(btn_silver === _loc2_)
               {
                  if(PlayerVO.lv < obj.playerLv)
                  {
                     return Tips.show("等级不够");
                  }
                  if(PlayerVO < obj.money)
                  {
                     return Tips.show("金币不足");
                  }
                  EventCenter.addEventListener("UNLOCK_COM_SUCCESS",remove2);
                  (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write1105(false);
               }
            }
            else
            {
               if(PlayerVO.diamond < obj.diamond)
               {
                  return Tips.show("钻石不足");
               }
               EventCenter.addEventListener("UNLOCK_COM_SUCCESS",remove2);
               (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write1105(true);
            }
         }
         else
         {
            WinTweens.closeWin(spr_lockBg,remove);
         }
      }
      
      public function remove() : void
      {
         instance = null;
         try
         {
            removeFromParent(true);
            return;
         }
         catch(error:Error)
         {
            trace("父界面已经移除");
            return;
         }
      }
      
      public function remove2() : void
      {
         EventCenter.removeEventListener("UNLOCK_COM_SUCCESS",remove2);
         WinTweens.closeWin(spr_lockBg,remove);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("home");
         spr_lockBg = swf.createSprite("spr_lockBg");
         btn_lockClose = spr_lockBg.getButton("btn_lockClose");
         btn_silver = spr_lockBg.getButton("btn_silver");
         btn_diamond = spr_lockBg.getButton("btn_diamond");
         lockLv = spr_lockBg.getTextField("lockLv");
         lockSilver = spr_lockBg.getTextField("lockSilver");
         lockDiamond = spr_lockBg.getTextField("lockDiamond");
         nowSpace = spr_lockBg.getTextField("nowSpace");
         nextSpace = spr_lockBg.getTextField("nextSpace");
         spr_lockBg.x = 1136 - spr_lockBg.width >> 1;
         spr_lockBg.y = 640 - spr_lockBg.height >> 1;
         addChild(spr_lockBg);
      }
      
      public function show() : void
      {
         parentPage = (Facade.getInstance().retrieveMediator("HomeMedia") as HomeMedia).home;
         parentPage.addChildAt(this,parentPage.numChildren - 1);
         comLv(GetHomeSpace.getComLv() + 1);
         WinTweens.openWin(spr_lockBg);
      }
      
      public function comLv(param1:int) : void
      {
         obj = GetHomeSpace.getComNeed(param1);
         lockLv.text = "玩家等级" + obj.playerLv + "级";
         lockSilver.text = obj.money;
         lockDiamond.text = obj.diamond;
         nowSpace.text = GetHomeSpace.getComSpace(param1 - 1);
         nextSpace.text = obj.capacity;
         _capacity = obj.capacity;
      }
      
      public function get nowComSpace() : int
      {
         return _capacity;
      }
   }
}
