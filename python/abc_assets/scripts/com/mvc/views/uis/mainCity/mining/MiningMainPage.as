package com.mvc.views.uis.mainCity.mining
{
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.mining.MiningFrameMediator;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   
   public class MiningMainPage extends SwitchPage
   {
       
      private var swf:Swf;
      
      private var spr_mainPage:SwfSprite;
      
      private var btn_mining:SwfButton;
      
      private var btn_loot:SwfButton;
      
      private var tf_lootPay:TextField;
      
      public function MiningMainPage()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_mainPage = swf.createSprite("spr_mainPage");
         addChild(spr_mainPage);
         btn_mining = spr_mainPage.getButton("btn_mining");
         btn_loot = spr_mainPage.getButton("btn_loot");
         var _loc1_:TextField = spr_mainPage.getTextField("tf_mining");
         var _loc2_:TextField = spr_mainPage.getTextField("tf_loot");
         tf_lootPay = spr_mainPage.getTextField("tf_lootPay");
         addEventListener("triggered",triggeredHandler);
         addBg("miningBg4");
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_mining !== _loc2_)
         {
            if(btn_loot === _loc2_)
            {
               if(MiningFrameMediator.breadNum < 2)
               {
                  return Tips.show("能量不足");
               }
               if(PlayerVO.silver < MiningFrameMediator.exportPay)
               {
                  return Tips.show("金币不足");
               }
               (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3904();
            }
         }
         else
         {
            Facade.getInstance().sendNotification("switch_win",null,"mining_load_select_type_win");
         }
      }
      
      public function updateInfo() : void
      {
         tf_lootPay.text = MiningFrameMediator.exportPay;
      }
   }
}
