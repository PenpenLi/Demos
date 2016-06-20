package com.mvc.views.mediator.mainCity.playerInfo.infoPanel
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeNameUI;
   import starling.events.Event;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.common.themes.Tips;
   import com.common.util.strHandler.StrHandle;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.xmlVOHandler.GetNickNameFactor;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class ChangeNameMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ChangeNameMediator";
       
      private var changeNameUI:ChangeNameUI;
      
      public function ChangeNameMediator(param1:Object = null)
      {
         super("ChangeNameMediator",param1);
         changeNameUI = param1 as ChangeNameUI;
         changeNameUI.addEventListener("triggered",changeName_triggeredHandler);
      }
      
      private function changeName_triggeredHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("target: " + param1.target);
         var _loc4_:* = param1.target;
         if(changeNameUI.canelBtn !== _loc4_)
         {
            if(changeNameUI.sureBtn !== _loc4_)
            {
               if(changeNameUI.randomBtn === _loc4_)
               {
                  changeNameUI.inputNameTf.text = GetNickNameFactor.getNickName();
               }
            }
            else
            {
               _loc3_ = changeNameUI.inputNameTf.text;
               if(CheckSensitiveWord.checkSensitiveWord(_loc3_))
               {
                  Tips.show("昵称不能有敏感词哦。");
                  return;
               }
               if(StrHandle.isAllSpace(_loc3_))
               {
                  Tips.show("昵称不能为空哦。");
                  return;
               }
               if(_loc3_ == PlayerVO.nickName)
               {
                  sendNotification("close_nickname_panel");
                  Tips.show("昵称没有修改");
                  return;
               }
               if(_loc3_ != "" && _loc3_ != PlayerVO.nickName && !CheckSensitiveWord.checkSensitiveWord(_loc3_))
               {
                  if(PlayerVO.isFirstChangeName)
                  {
                     (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(PlayerVO.headPtId,changeNameUI.inputNameTf.text,PlayerVO.trainPtId);
                     return;
                  }
                  _loc2_ = Alert.show("是否花费100钻石修改昵称？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",alertSure_closeHandler);
               }
            }
         }
         else
         {
            removeWindow();
            changeNameUI.inputNameTf.text = "";
         }
      }
      
      private function alertSure_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(PlayerVO.headPtId,changeNameUI.inputNameTf.text,PlayerVO.trainPtId);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         changeNameUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["close_nickname_panel"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("close_nickname_panel" === _loc2_)
         {
            LogUtil("关闭修改昵称面板");
            removeWindow();
            changeNameUI.inputNameTf.text = "";
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ChangeNameMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
