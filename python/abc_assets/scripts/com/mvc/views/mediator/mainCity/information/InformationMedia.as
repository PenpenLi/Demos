package com.mvc.views.mediator.mainCity.information
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.information.InformationUI;
   import starling.events.Event;
   import com.common.util.NullContentTip;
   import com.common.util.WinTweens;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.worldHorn.WorldHorn;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class InformationMedia extends Mediator
   {
      
      public static const NAME:String = "InformationMedia";
      
      public static var isFirstOpenNews:Boolean = true;
       
      public var information:InformationUI;
      
      public function InformationMedia(param1:Object = null)
      {
         super("InformationMedia",param1);
         information = param1 as InformationUI;
         information.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(information.btn_close === _loc2_)
         {
            if(NullContentTip.instance)
            {
               NullContentTip.getInstance().disposeNullMailTip();
            }
            information.contain.removeChildren(0);
            if(Game.httpView != null)
            {
               Game.httpView.dispose();
               Game.httpView = null;
            }
            WinTweens.closeWin(information.spr_informationBg,remove);
            if(!InformationPro.isGetMail())
            {
               sendNotification("HIDE_INFOMATION_NEWS");
            }
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_INFORMATION_MENU" === _loc3_)
         {
            _loc2_ = param1.getBody() as int;
            if(_loc2_ == 2)
            {
               information.currentTab = 2;
            }
            information.tabs.selectedIndex = information.currentTab;
            information.switchNews(information.currentTab);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_INFORMATION_MENU"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         WorldHorn.getIntance().isNotShow = false;
         information.removeEventListener("triggered",clickHandler);
         if(facade.hasMediator("MailMedia"))
         {
            (facade.retrieveMediator("MailMedia") as MailMedia).dispose();
         }
         if(facade.hasMediator("GiftMedia"))
         {
            (facade.retrieveMediator("GiftMedia") as GiftMedia).dispose();
         }
         if(facade.hasMediator("FeedbackMedia"))
         {
            (facade.retrieveMediator("FeedbackMedia") as FeedbackMedia).dispose();
         }
         facade.removeMediator("InformationMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.informationAssets);
      }
   }
}
