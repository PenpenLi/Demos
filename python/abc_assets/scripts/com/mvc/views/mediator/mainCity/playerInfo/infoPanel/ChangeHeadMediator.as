package com.mvc.views.mediator.mainCity.playerInfo.infoPanel
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeHeadUI;
   import starling.events.Event;
   import lzm.starling.display.Button;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class ChangeHeadMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ChangeHeadMediator";
       
      private var changeHeadUI:ChangeHeadUI;
      
      public function ChangeHeadMediator(param1:Object = null)
      {
         super("ChangeHeadMediator",param1);
         changeHeadUI = param1 as ChangeHeadUI;
         changeHeadUI.addEventListener("triggered",changeName_triggeredHandler);
         changeHeadUI.headBtnList.addEventListener("triggered",scroll_triggeredHandler);
      }
      
      private function scroll_triggeredHandler(param1:Event) : void
      {
         if(changeHeadUI.headBtnList.isScrolling)
         {
            return;
         }
         var _loc2_:int = (param1.target as Button).name;
         if(_loc2_ != PlayerVO.headPtId)
         {
            LogUtil("头像id" + _loc2_);
            sendNotification("update_headpic",_loc2_);
            (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(_loc2_,PlayerVO.nickName,PlayerVO.trainPtId);
         }
         else
         {
            Tips.show("头像没有修改哦");
         }
      }
      
      private function changeName_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(changeHeadUI.headCloseBtn === _loc2_)
         {
            sendNotification("switch_win",null);
            changeHeadUI.removeFromParent();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_headpic_panel"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_headpic_panel" === _loc2_)
         {
            changeHeadUI.addPtHeadBtn();
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ChangeHeadMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
