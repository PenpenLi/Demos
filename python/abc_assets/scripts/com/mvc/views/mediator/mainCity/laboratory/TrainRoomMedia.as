package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.laboratory.TrainRoomUI;
   import starling.events.Event;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class TrainRoomMedia extends Mediator
   {
      
      public static const NAME:String = "TrainRoomMedia";
       
      public var trainRoom:TrainRoomUI;
      
      public function TrainRoomMedia(param1:Object = null)
      {
         super("TrainRoomMedia",param1);
         trainRoom = param1 as TrainRoomUI;
         trainRoom.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(trainRoom.btn_help !== _loc2_)
         {
            if(trainRoom.btn_return !== _loc2_)
            {
               if(trainRoom.btn_seleElf !== _loc2_)
               {
                  if(trainRoom.btn_train === _loc2_)
                  {
                     if(trainRoom.btn_seleElf.visible)
                     {
                        Tips.show("还未选择精灵");
                        return;
                     }
                     if(trainRoom.typeRadio && trainRoom.typeGroup.selectedIndex != -1)
                     {
                        Tips.show("还不可以培训，哈哈");
                     }
                     else
                     {
                        Tips.show("请选择培训类型");
                     }
                  }
               }
               else
               {
                  SelectElfUI.getIntance().createSeleElf();
                  SelectElfUI.getIntance().title.text = "选择培训的精灵";
                  trainRoom.addChild(SelectElfUI.getIntance());
               }
            }
            else
            {
               if(trainRoom.image != null)
               {
                  ElfFrontImageManager.getInstance().disposeImg(trainRoom.image);
               }
               dispose();
               sendNotification("SHOW_MENU");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_TRAIN_ELF" === _loc2_)
         {
            SelectElfUI.getIntance().removeFromParent();
            trainRoom.myElfVo = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_TRAIN_ELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("TrainRoomMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
