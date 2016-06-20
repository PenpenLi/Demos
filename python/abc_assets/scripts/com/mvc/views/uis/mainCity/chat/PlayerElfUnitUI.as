package com.mvc.views.uis.mainCity.chat
{
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.home.ElfDetailInfoUI;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   
   public class PlayerElfUnitUI extends ElfBgUnitUI
   {
       
      public var _chatVo:ChatVO;
      
      public function PlayerElfUnitUI()
      {
         super();
      }
      
      override public function initEvent() : void
      {
         addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(img);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               ElfDetailInfoMedia.showFreeBtn = false;
               ElfDetailInfoMedia.showSetNameBtn = false;
               if(!Facade.getInstance().hasMediator("ElfDetailInfoMedia"))
               {
                  Facade.getInstance().registerMediator(new ElfDetailInfoMedia(new ElfDetailInfoUI()));
               }
               if(_elfVO.isDetail)
               {
                  Facade.getInstance().sendNotification("SEND_ELF_DETAIL",_elfVO);
               }
               else
               {
                  (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2022(_elfVO.id,_chatVo);
               }
            }
         }
      }
   }
}
