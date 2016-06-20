package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.laboratory.ResetCharacterUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class ResetCharacterMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ResetCharacterMediator";
       
      private var resetCharacterUI:ResetCharacterUI;
      
      private var selectedElfVO:ElfVO;
      
      public function ResetCharacterMediator(param1:Object = null)
      {
         super("ResetCharacterMediator",param1);
         resetCharacterUI = param1 as ResetCharacterUI;
         resetCharacterUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(resetCharacterUI.btn_close !== _loc3_)
         {
            if(resetCharacterUI.btn_previewCharacter !== _loc3_)
            {
               if(resetCharacterUI.btn_addElfBtn !== _loc3_)
               {
                  if(resetCharacterUI.btn_changeCharacter === _loc3_)
                  {
                     if(!selectedElfVO)
                     {
                        return Tips.show("亲，还没选择精灵哦。");
                     }
                     if(!resetCharacterUI.propVO || resetCharacterUI.propVO.count < 1)
                     {
                        return Tips.show("亲，洗炼石不足哦。");
                     }
                     _loc2_ = Alert.show("是否让\"<font color = \'#004c8c\'>" + selectedElfVO.nickName + "</font>\"洗炼性格\n需要消耗一块：<font color = \'#004c8c\'>洗炼石</font>","",new ListCollection([{"label":"好的"},{"label":"不用了"}]));
                     _loc2_.addEventListener("close",usePropAlert_closeHandler);
                  }
               }
               else
               {
                  resetCharacterUI.seleElf();
               }
            }
            else
            {
               Tips.show("敬请期待。");
            }
         }
      }
      
      private function usePropAlert_closeHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "好的")
         {
            (facade.retrieveProxy("MyElfPro") as MyElfPro).write2028(selectedElfVO.id,resetCharacterUI.propVO.id);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("close_resetcharacter" !== _loc3_)
         {
            if("close_resetcharacter_elf" !== _loc3_)
            {
               if("update_resetcharacter_info" === _loc3_)
               {
                  GetPropFactor.addOrLessProp(resetCharacterUI.propVO,false);
                  resetCharacterUI.updatePropNum();
                  _loc2_ = param1.getBody() as ElfVO;
                  resetCharacterUI.updateAttributeTf(_loc2_);
               }
            }
            else
            {
               SelectElfUI.getIntance().removeFromParent();
               selectedElfVO = param1.getBody() as ElfVO;
               resetCharacterUI.myElfVO(selectedElfVO);
            }
         }
         else
         {
            remove();
         }
      }
      
      private function remove() : void
      {
         dispose();
         sendNotification("SHOW_MENU");
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["close_resetcharacter","close_resetcharacter_elf","update_resetcharacter_info"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            SelectElfUI.getIntance().removeFromParent();
         }
         facade.removeMediator("ResetCharacterMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
