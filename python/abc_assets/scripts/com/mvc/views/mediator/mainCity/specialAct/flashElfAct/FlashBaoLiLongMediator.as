package com.mvc.views.mediator.mainCity.specialAct.flashElfAct
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.specialAct.flashElfAct.FlashBaoLiLongUI;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.util.TimeUtil;
   import com.common.consts.ConfigConst;
   import starling.display.DisplayObject;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class FlashBaoLiLongMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "FlashBaoLiLongMediator";
      
      public static var lessTime:int;
      
      public static var lightElfInfoObj:Object;
      
      public static var bgFlag:int = 1;
       
      public var flashBaoLiLongUI:FlashBaoLiLongUI;
      
      public function FlashBaoLiLongMediator(param1:Object = null)
      {
         super("FlashBaoLiLongMediator",param1);
         flashBaoLiLongUI = param1 as FlashBaoLiLongUI;
         flashBaoLiLongUI.addEventListener("triggered",triggeredHandler);
         flashBaoLiLongUI.btn_get.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(flashBaoLiLongUI.btn_close !== _loc2_)
         {
            if(flashBaoLiLongUI.btn_get === _loc2_)
            {
               (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1911();
            }
         }
         else
         {
            dispose();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if(ConfigConst.UPDATE_FLASHELF_INFO !== _loc3_)
         {
            if(ConfigConst.UPDATE_FLASHELF_STATE_INFO !== _loc3_)
            {
               if("update_flashelf_lesstime" === _loc3_)
               {
                  if(lessTime > 0)
                  {
                     flashBaoLiLongUI.tf_countDown.text = TimeUtil.convertStringToDate3(lessTime,"#ffee00");
                  }
                  else
                  {
                     flashBaoLiLongUI.tf_countDown.text = "亲，活动已结束了哦";
                  }
               }
            }
            else
            {
               flashBaoLiLongUI.btn_get.isEnabled = false;
            }
         }
         else
         {
            _loc2_ = param1.getBody();
            if(_loc2_.stateArr[0] == 1)
            {
               flashBaoLiLongUI.btn_get.isEnabled = true;
            }
            else
            {
               flashBaoLiLongUI.btn_get.isEnabled = false;
            }
            lessTime = _loc2_.actTime;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.UPDATE_FLASHELF_INFO,ConfigConst.UPDATE_FLASHELF_STATE_INFO,"update_flashelf_lesstime"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         lightElfInfoObj = null;
         facade.removeMediator("FlashBaoLiLongMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadOtherAssetsManager.getInstance().removeAsset(["act_flash" + FlashBaoLiLongMediator.bgFlag],false);
      }
   }
}
