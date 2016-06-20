package com.mvc.views.mediator.mainCity.playerInfo.infoPanel
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeTrainerUI;
   import starling.events.Event;
   import lzm.starling.display.Button;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.common.themes.Tips;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class ChangeTrainerMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "ChangeTrainerMediator";
       
      public var changeTrainerUI:ChangeTrainerUI;
      
      public function ChangeTrainerMediator(param1:Object = null)
      {
         super("ChangeTrainerMediator",param1);
         changeTrainerUI = param1 as ChangeTrainerUI;
         changeTrainerUI.addEventListener("triggered",changeTrainer_triggeredHandler);
         changeTrainerUI.trainerBtnList.addEventListener("triggered",scroll_triggeredHandler);
      }
      
      private function scroll_triggeredHandler(param1:Event) : void
      {
         if(changeTrainerUI.trainerBtnList.isScrolling)
         {
            return;
         }
         var _loc2_:int = (param1.target as Button).name;
         if(_loc2_ != PlayerVO.trainPtId)
         {
            if(InfoPanelMediator.isCancelPokeBtn)
            {
               sendNotification("update_trainerPic",_loc2_);
               sendNotification("update_headpic",_loc2_);
               (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(_loc2_,PlayerVO.nickName,_loc2_);
            }
            else
            {
               sendNotification("update_trainerPic",_loc2_);
               (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(PlayerVO.headPtId,PlayerVO.nickName,_loc2_);
            }
         }
         else
         {
            Tips.show("训练师没有修改");
         }
      }
      
      private function changeTrainer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(changeTrainerUI.headCloseBtn === _loc2_)
         {
            WinTweens.closeWin(changeTrainerUI.changeTrainerSpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         changeTrainerUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_trainerpic_panel" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_trainerpic_panel"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ChangeTrainerMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
