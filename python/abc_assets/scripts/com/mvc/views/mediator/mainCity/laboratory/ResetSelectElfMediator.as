package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.laboratory.ResetSelectElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import lzm.starling.display.Button;
   import com.common.util.WinTweens;
   import com.common.util.NullContentTip;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class ResetSelectElfMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ResetSelectElfMediator";
       
      public var resetSelectElfUI:ResetSelectElfUI;
      
      private var resetElfVec:Vector.<ElfVO>;
      
      public function ResetSelectElfMediator(param1:Object = null)
      {
         super("ResetSelectElfMediator",param1);
         resetSelectElfUI = param1 as ResetSelectElfUI;
         resetSelectElfUI.addEventListener("triggered",triggeredHandler);
         resetSelectElfUI.elfBtnList.addEventListener("triggered",scroll_triggeredHandler);
      }
      
      private function scroll_triggeredHandler(param1:Event) : void
      {
         if(resetSelectElfUI.elfBtnList.isScrolling)
         {
            return;
         }
         var _loc2_:int = (param1.target as Button).name;
         sendNotification("select_elf_complete_send_elfvo",resetElfVec[_loc2_]);
         resetSelectElfUI.elfBtnList.removeFromParent();
         WinTweens.closeWin(resetSelectElfUI.spr_selectElf,removeWindow);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(resetSelectElfUI.btn_close === _loc2_)
         {
            resetSelectElfUI.elfBtnList.removeFromParent();
            WinTweens.closeWin(resetSelectElfUI.spr_selectElf,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         WinTweens.showCity();
         sendNotification("switch_win",null);
         if(resetElfVec.length == 0)
         {
            if(NullContentTip.instance)
            {
               NullContentTip.getInstance().disposeNullMailTip();
            }
         }
         resetSelectElfUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("resetelf_update_list" === _loc2_)
         {
            resetElfVec = param1.getBody() as Vector.<ElfVO>;
            if(resetElfVec.length == 0)
            {
               NullContentTip.getInstance().showNullMailTip("没有可选精灵。",resetSelectElfUI.spr_selectElf,-100);
            }
            else
            {
               resetSelectElfUI.addElfBtn(resetElfVec);
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["resetelf_update_list"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         resetSelectElfUI.removeHeadBtn();
         resetSelectElfUI.elfBtnVec = null;
         facade.removeMediator("ResetSelectElfMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
