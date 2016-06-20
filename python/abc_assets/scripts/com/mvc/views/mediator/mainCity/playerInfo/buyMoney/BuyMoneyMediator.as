package com.mvc.views.mediator.mainCity.playerInfo.buyMoney
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.buyMoney.BuyMoneyUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mainCity.playerInfo.PlayInfoBarMediator;
   import com.mvc.views.uis.mainCity.playerInfo.PlayInfoBarUI;
   import starling.display.DisplayObject;
   
   public class BuyMoneyMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "BuyMoneyMediator";
      
      public static var useTimes:int;
       
      private var buyMoneyUI:BuyMoneyUI;
      
      public function BuyMoneyMediator(param1:Object = null)
      {
         super("BuyMoneyMediator",param1);
         buyMoneyUI = param1 as BuyMoneyUI;
         buyMoneyUI.addEventListener("triggered",buyMoneyUI_triggeredHandler);
         useTimes = PlayerVO.vipInfoVO.goldFinger - PlayerVO.vipInfoVO.remainGoldFinger;
      }
      
      private function buyMoneyUI_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(buyMoneyUI.buyCloseBtn !== _loc2_)
         {
            if(buyMoneyUI.useBtn === _loc2_)
            {
               if(buyMoneyUI.remainTimeTf.text >= 1)
               {
                  if(PlayerVO.diamond < buyMoneyUI.payDiamondTf.text)
                  {
                     buyDiamondSure();
                  }
                  else
                  {
                     (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1103(buyMoneyUI.payDiamondTf.text);
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
            WinTweens.closeWin(buyMoneyUI.buyMoneySpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         buyMoneyUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_buy_money_panel"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_buy_money_panel" === _loc2_)
         {
            BuyMoneyMediator.useTimes = PlayerVO.vipInfoVO.goldFinger - PlayerVO.vipInfoVO.remainGoldFinger;
            buyMoneyUI.remainTimeTf.text = PlayerVO.vipInfoVO.remainGoldFinger;
            buyMoneyUI.calculatePayAndGet(useTimes);
         }
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
            sendNotification("switch_win",null,"load_diamond_panel");
            removeWindow();
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("BuyMoneyMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
