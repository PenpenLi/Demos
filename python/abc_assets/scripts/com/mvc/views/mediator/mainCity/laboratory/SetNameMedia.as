package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.laboratory.SetNameUI;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.xmlVOHandler.GetNickNameFactor;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ElfFrontImageManager;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class SetNameMedia extends Mediator
   {
      
      public static const NAME:String = "SetNameMedia";
       
      public var setName:SetNameUI;
      
      public function SetNameMedia(param1:Object = null)
      {
         super("SetNameMedia",param1);
         setName = param1 as SetNameUI;
         setName.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(setName.btn_ok !== _loc3_)
         {
            if(setName.btn_return !== _loc3_)
            {
               if(setName.btn_round !== _loc3_)
               {
                  if(setName.btn_seleElf !== _loc3_)
                  {
                     if(setName.btn_help !== _loc3_)
                     {
                     }
                  }
                  else
                  {
                     setName.seleElf();
                  }
               }
               else
               {
                  if(setName.btn_seleElf.visible)
                  {
                     Tips.show("还未选择精灵");
                     return;
                  }
                  setName.textput.text = GetNickNameFactor.getNickName();
               }
            }
         }
         else
         {
            if(setName.btn_seleElf.visible)
            {
               Tips.show("还未选择精灵");
               return;
            }
            if(setName.textput.text != "")
            {
               if(setName.textput.text == setName.myElfVo.nickName)
               {
                  return Tips.show("昵称没有修改");
               }
               _loc2_ = Alert.show("修改精灵昵称需要消耗1000金币，确定修改么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",changeNameSureHandler);
            }
            else
            {
               Tips.show("还未设置昵称");
            }
         }
      }
      
      private function changeNameSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("AmusePro") as AmusePro).write2014(setName.myElfVo,setName.textput.text,false,true);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_SETENAME_ELF" !== _loc2_)
         {
            if("CLOSE_SETENAME_ELF" !== _loc2_)
            {
               if("UPDATE_NAME_ELF" === _loc2_)
               {
                  setName.elfName.text = setName.textput.text;
               }
            }
            else
            {
               if(setName.image != null)
               {
                  ElfFrontImageManager.getInstance().disposeImg(setName.image);
                  setName.image = null;
               }
               dispose();
               sendNotification("SHOW_MENU");
            }
         }
         else
         {
            SelectElfUI.getIntance().removeFromParent();
            setName.myElfVo = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_SETENAME_ELF","CLOSE_SETENAME_ELF","UPDATE_NAME_ELF"];
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
         facade.removeMediator("SetNameMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
