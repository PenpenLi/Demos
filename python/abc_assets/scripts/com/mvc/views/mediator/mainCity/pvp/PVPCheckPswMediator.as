package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPCheckPswUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class PVPCheckPswMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPCheckPswMediator";
       
      private var roomId:String;
      
      private var psw:String;
      
      public var pvpCheckPswUI:PVPCheckPswUI;
      
      public function PVPCheckPswMediator(param1:Object = null)
      {
         super("PVPCheckPswMediator",param1);
         pvpCheckPswUI = param1 as PVPCheckPswUI;
         pvpCheckPswUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpCheckPswUI.canelBtn !== _loc2_)
         {
            if(pvpCheckPswUI.sureBtn === _loc2_)
            {
               if(pvpCheckPswUI.inputRoomPsw.text == psw)
               {
                  (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6204(roomId);
                  WinTweens.closeWin(pvpCheckPswUI.spr_inputPsw,removeWindow);
               }
               else
               {
                  Tips.show("密码不正确。");
               }
               pvpCheckPswUI.inputRoomPsw.text = "";
            }
         }
         else
         {
            pvpCheckPswUI.inputRoomPsw.text = "";
            WinTweens.closeWin(pvpCheckPswUI.spr_inputPsw,removeWindow);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("pvp_send_room_data" === _loc3_)
         {
            _loc2_ = param1.getBody();
            roomId = _loc2_.roomId;
            psw = _loc2_.psw;
            pvpCheckPswUI.tf_roomName.text = _loc2_.roomName;
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         pvpCheckPswUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["pvp_send_room_data"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PVPCheckPswMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
