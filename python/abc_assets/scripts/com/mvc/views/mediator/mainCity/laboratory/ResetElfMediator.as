package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.laboratory.ResetElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.common.managers.ElfFrontImageManager;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ResetElfMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ResetElfMediator";
       
      public var resetElfUI:ResetElfUI;
      
      private var selectElfVO:ElfVO;
      
      public function ResetElfMediator(param1:Object = null)
      {
         super("ResetElfMediator",param1);
         resetElfUI = param1 as ResetElfUI;
         resetElfUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(resetElfUI.btn_return !== _loc3_)
         {
            if(resetElfUI.btn_seleElf !== _loc3_)
            {
               if(resetElfUI.btn_resetBtn === _loc3_)
               {
                  if(!resetElfUI._elfVO)
                  {
                     Tips.show("亲，还没选择精灵呢。");
                     return;
                  }
                  _loc2_ = Alert.show("亲，是否花费200钻重置精灵？","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
                  _loc2_.addEventListener("close",isResetElfAlert_closeHandler);
               }
            }
            else
            {
               sendNotification("switch_win",resetElfUI,"load_resetelf_select_com_elf");
            }
         }
      }
      
      private function isResetElfAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "好的")
         {
            if(PlayerVO.diamond >= 200)
            {
               (facade.retrieveProxy("MyElfPro") as MyElfPro).write2026(selectElfVO.id);
            }
            else
            {
               Tips.show("亲，钻石不足哦。");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("select_elf_complete_send_elfvo" !== _loc2_)
         {
            if("resetelf_success" !== _loc2_)
            {
               if("CLOSE_RESETELF_SUCCESS" === _loc2_)
               {
                  dispose();
                  sendNotification("SHOW_MENU");
               }
            }
            else if(resetElfUI._elfVO)
            {
               resetElfUI.removeElfAndSwitchBtn();
            }
         }
         else
         {
            selectElfVO = param1.getBody() as ElfVO;
            resetElfUI.showElfImg(selectElfVO);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["select_elf_complete_send_elfvo","resetelf_success","CLOSE_RESETELF_SUCCESS"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(resetElfUI._elfVO)
         {
            ElfFrontImageManager.getInstance().disposeImg(resetElfUI.selectElfImg);
         }
         if(Facade.getInstance().hasMediator("ResetSelectElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("ResetSelectElfMediator") as ResetSelectElfMediator).dispose();
         }
         facade.removeMediator("ResetElfMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         resetElfUI.selectElfImg = null;
      }
   }
}
