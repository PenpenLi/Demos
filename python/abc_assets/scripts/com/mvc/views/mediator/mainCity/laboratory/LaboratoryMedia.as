package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.laboratory.LaboratoryUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class LaboratoryMedia extends Mediator
   {
      
      public static const NAME:String = "LaboratoryMedia";
       
      public var laboratory:LaboratoryUI;
      
      public function LaboratoryMedia(param1:Object = null)
      {
         super("LaboratoryMedia",param1);
         laboratory = param1 as LaboratoryUI;
         laboratory.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(laboratory.btn_close === _loc2_)
         {
            if(facade.hasMediator("ResetElfMediator"))
            {
               sendNotification("CLOSE_RESETELF_SUCCESS");
               return;
            }
            if(facade.hasMediator("SetNameMedia"))
            {
               sendNotification("CLOSE_SETENAME_ELF");
               return;
            }
            if(facade.hasMediator("ReCallSkillMedia"))
            {
               sendNotification("CLOSE_RECALLSKILL");
               return;
            }
            if(facade.hasMediator("HJCompoundMediator"))
            {
               sendNotification("close_hjcompound");
               return;
            }
            if(facade.hasMediator("ResetCharacterMediator"))
            {
               sendNotification("close_resetcharacter");
               return;
            }
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_MENU" === _loc2_)
         {
            laboratory.panel.visible = true;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_MENU"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("LaboratoryMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.laboratoryAssets);
      }
   }
}
