package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntingTaskUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class HuntingTaskMedia extends Mediator
   {
      
      public static const NAME:String = "HuntingTaskMedia";
       
      public var huntingTask:HuntingTaskUI;
      
      public function HuntingTaskMedia(param1:Object = null)
      {
         super("HuntingTaskMedia",param1);
         huntingTask = param1 as HuntingTaskUI;
         huntingTask.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(huntingTask.btn_close !== _loc3_)
         {
            if(huntingTask.btn_f5 !== _loc3_)
            {
               if(huntingTask.btn_get === _loc3_)
               {
                  (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4103();
               }
            }
            else if(HuntPartyVO.catchElfObj.lessTime > 0)
            {
               _loc2_ = Alert.show("捕获精灵正在进行中，此时刷新需要消耗300钻石，确认刷新？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",alertHander);
            }
            else
            {
               (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4106();
            }
         }
         else
         {
            huntingTask.removeHandle();
            WinTweens.closeWin(huntingTask.spr_task,dispose);
         }
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4106();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_GOALELF_UI","UPDATE_GOALELF_CDTIME"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_GOALELF_UI" !== _loc2_)
         {
            if("UPDATE_GOALELF_CDTIME" === _loc2_)
            {
               huntingTask.updateTime();
            }
         }
         else
         {
            huntingTask.setInfo();
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("HuntingTaskMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
