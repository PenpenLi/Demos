package com.mvc.views.mediator.mainCity.home
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.home.HomeUI;
   import starling.events.Event;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.mainCity.home.ComLockUI;
   import com.common.managers.ElfFrontImageManager;
   
   public class HomeMedia extends Mediator
   {
      
      public static const NAME:String = "HomeMedia";
      
      public static var ifNewElf:Boolean;
       
      public var home:HomeUI;
      
      public function HomeMedia(param1:Object = null)
      {
         super("HomeMedia",param1);
         home = param1 as HomeUI;
         home.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(home.close !== _loc2_)
         {
            if(home.btn_playTip === _loc2_)
            {
               home.addHelp();
            }
         }
         else
         {
            sendNotification("CLEAN_BAG_TICK");
            sendNotification("CLEAN_COM_TICK");
            sendNotification("CLEAN_ELFINFO_CLOSE");
            if(LoadPageCmd.lastPage is HuntingPartyUI)
            {
               sendNotification("switch_page","LOAD_HUNTINGPARTY_PAGE");
            }
            else
            {
               sendNotification("switch_page","load_maincity_page");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_ELF_INFO" === _loc3_)
         {
            _loc2_ = 0;
            while(_loc2_ < PlayerVO.bagElfVec.length)
            {
               if(PlayerVO.bagElfVec[_loc2_] != null)
               {
                  (facade.retrieveMediator("HomeElfInfoMedia") as HomeElfInfoMedia).homeElfInfo.myElfVo = PlayerVO.bagElfVec[_loc2_];
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_ELF_INFO"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         home.clean();
         if(ComLockUI.instance)
         {
            ComLockUI.getInstance().remove();
         }
         facade.removeMediator("HomeMedia");
         UI.dispose();
         viewComponent = null;
         ElfFrontImageManager.getInstance().dispose();
      }
   }
}
