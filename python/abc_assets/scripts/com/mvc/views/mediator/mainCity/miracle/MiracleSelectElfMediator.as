package com.mvc.views.mediator.mainCity.miracle
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.miracle.MiracleSelectElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import lzm.starling.display.Button;
   import com.common.util.WinTweens;
   import com.common.events.EventCenter;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class MiracleSelectElfMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiracleSelectElfMediator";
       
      public var miracleSelectElfUI:MiracleSelectElfUI;
      
      public var elfRarity:String;
      
      private var rarityElfVec:Vector.<ElfVO>;
      
      public function MiracleSelectElfMediator(param1:Object = null)
      {
         super("MiracleSelectElfMediator",param1);
         miracleSelectElfUI = param1 as MiracleSelectElfUI;
         miracleSelectElfUI.addEventListener("triggered",triggeredHandler);
         miracleSelectElfUI.elfBtnList.addEventListener("triggered",scroll_triggeredHandler);
      }
      
      private function scroll_triggeredHandler(param1:Event) : void
      {
         if(miracleSelectElfUI.elfBtnList.isScrolling)
         {
            return;
         }
         var _loc2_:int = (param1.target as Button).name;
         sendNotification("miracle_update_add_elf_btn",rarityElfVec[_loc2_]);
         miracleSelectElfUI.elfBtnList.removeFromParent();
         WinTweens.closeWin(miracleSelectElfUI.spr_selectElf,removeWindow);
      }
      
      private function loadSelectElfAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadSelectElfAfter);
         miracleSelectElfUI.addElfBtn(rarityElfVec);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(miracleSelectElfUI.btn_close === _loc2_)
         {
            miracleSelectElfUI.elfBtnList.removeFromParent();
            WinTweens.closeWin(miracleSelectElfUI.spr_selectElf,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         miracleSelectElfUI.removeFromParent();
         rarityElfVec = null;
         sendNotification("miracle_com_list_close_complete");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("miracle_update_com_elf_list" === _loc2_)
         {
            rarityElfVec = param1.getBody() as Vector.<ElfVO>;
            elfRarity = param1.getType();
            LogUtil("rarityElfVec: " + rarityElfVec + " elfrarity: " + elfRarity);
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadSelectElfAfter);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["miracle_update_com_elf_list"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         rarityElfVec = null;
         miracleSelectElfUI.removeHeadBtn();
         miracleSelectElfUI.elfBtnVec = null;
         facade.removeMediator("MiracleSelectElfMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
