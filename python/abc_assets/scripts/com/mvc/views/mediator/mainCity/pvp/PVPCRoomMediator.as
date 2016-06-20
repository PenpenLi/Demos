package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPCRoomUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class PVPCRoomMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPCRoomMediator";
       
      public var pvpCRoomUI:PVPCRoomUI;
      
      public function PVPCRoomMediator(param1:Object = null)
      {
         super("PVPCRoomMediator",param1);
         pvpCRoomUI = param1 as PVPCRoomUI;
         pvpCRoomUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpCRoomUI.canelBtn !== _loc2_)
         {
            if(pvpCRoomUI.sureBtn === _loc2_)
            {
               if(pvpCRoomUI.inputRoomName.text == "")
               {
                  Tips.show("亲，房间名不能为空哦。");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(pvpCRoomUI.inputRoomName.text))
               {
                  Tips.show("亲，房间名不能有敏感词哦。");
                  return;
               }
               if(pvpCRoomUI.inputRoomPsw.text == "")
               {
                  (facade.retrieveProxy("PVPPro") as PVPPro).write6202(pvpCRoomUI.inputRoomName.text,false,"");
               }
               else
               {
                  (facade.retrieveProxy("PVPPro") as PVPPro).write6202(pvpCRoomUI.inputRoomName.text,true,pvpCRoomUI.inputRoomPsw.text);
               }
               pvpCRoomUI.inputRoomName.text = "";
               pvpCRoomUI.inputRoomPsw.text = "";
            }
         }
         else
         {
            pvpCRoomUI.inputRoomName.text = "";
            pvpCRoomUI.inputRoomPsw.text = "";
            WinTweens.closeWin(pvpCRoomUI.spr_createRoom,removeWindow);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("remove_pvp_croom" === _loc2_)
         {
            WinTweens.closeWin(pvpCRoomUI.spr_createRoom,removeWindow);
            sendNotification("add_pvp_practice");
            sendNotification("update_pvp_myInfo",param1.getBody());
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         pvpCRoomUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["remove_pvp_croom"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PVPCRoomMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
