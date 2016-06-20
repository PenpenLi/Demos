package com.mvc.views.mediator.mainCity.home
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.home.HomeElfInfoUI;
   import starling.events.Event;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class HomeElfInfoMedia extends Mediator
   {
      
      public static const NAME:String = "HomeElfInfoMedia";
       
      public var homeElfInfo:HomeElfInfoUI;
      
      public function HomeElfInfoMedia(param1:Object = null)
      {
         super("HomeElfInfoMedia",param1);
         homeElfInfo = param1 as HomeElfInfoUI;
         homeElfInfo.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(homeElfInfo.btn_pkhead === _loc2_)
         {
            if(homeElfInfo.bigImage != null)
            {
               ElfDetailInfoMedia.showFreeBtn = true;
               ElfDetailInfoMedia.showSetNameBtn = false;
               sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
               sendNotification("SEND_ELF_DETAIL",homeElfInfo.myElfVo);
               BeginnerGuide.playBeginnerGuide();
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_COM_ELF" !== _loc2_)
         {
            if("CLEAN_ELFINFO_CLOSE" !== _loc2_)
            {
               if("home_update_big_elf_lock" === _loc2_)
               {
                  homeElfInfo.switchLock();
               }
            }
            else
            {
               homeElfInfo.cleanBigImage();
            }
         }
         else
         {
            homeElfInfo.myElfVo = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_COM_ELF","CLEAN_ELFINFO_CLOSE","home_update_big_elf_lock"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HomeElfInfoMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
