package com.mvc.views.mediator.mainCity.playerInfo.buyPower
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.buyPower.BuyPowerUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mainCity.playerInfo.PlayInfoBarMediator;
   import com.mvc.views.uis.mainCity.playerInfo.PlayInfoBarUI;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class BuyPowerMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "buyPowerMediator";
      
      public static var useTimes:int;
       
      public var buyPowerUI:BuyPowerUI;
      
      public function BuyPowerMediator(param1:Object = null)
      {
         super("buyPowerMediator",param1);
         buyPowerUI = param1 as BuyPowerUI;
         buyPowerUI.addEventListener("triggered",buyPowerUI_triggeredHandler);
         useTimes = PlayerVO.vipInfoVO.buyAcFr - PlayerVO.vipInfoVO.remainBuyAcFr;
      }
      
      private function buyPowerUI_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(buyPowerUI.buyCloseBtn !== _loc2_)
         {
            if(buyPowerUI.useBtn === _loc2_)
            {
               if(buyPowerUI.remainTimeTf.text >= 1)
               {
                  if(PlayerVO.diamond < buyPowerUI.payDiamondTf.text)
                  {
                     buyDiamondSure();
                  }
                  else
                  {
                     (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1104(buyPowerUI.payDiamondTf.text);
                  }
               }
               else
               {
                  Tips.show("今日兑换次数已用完！");
               }
            }
         }
         else
         {
            WinTweens.closeWin(buyPowerUI.buyPowerSpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         buyPowerUI.removeFromParent();
      }
      
      private function buyDiamondSure() : void
      {
         var _loc1_:Alert = Alert.show("钻石不足，是否购买?","",new ListCollection([{"label":"购买"},{"label":"不用了"}]));
         _loc1_.addEventListener("close",buyDiamondSureHandler);
      }
      
      private function buyDiamondSureHandler(param1:Event, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.label == "购买")
         {
            _loc3_ = (facade.retrieveMediator("PlayInfoBarMediator") as PlayInfoBarMediator).UI as PlayInfoBarUI;
            sendNotification("switch_win",(_loc3_.parent as Game).page,"load_diamond_panel");
            removeWindow();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_buy_power_panel"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_buy_power_panel" === _loc2_)
         {
            BuyPowerMediator.useTimes = PlayerVO.vipInfoVO.buyAcFr - PlayerVO.vipInfoVO.remainBuyAcFr;
            LogUtil("兑换体力当前已用次数useTimes: " + BuyPowerMediator.useTimes);
            buyPowerUI.remainTimeTf.text = PlayerVO.vipInfoVO.remainBuyAcFr;
            buyPowerUI.calculatePayAndGet(useTimes);
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("buyPowerMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
