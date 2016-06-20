package com.mvc.views.mediator.mainCity.amuse
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.amuse.AmuseElfInfoUI;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import com.common.util.WinTweens;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class AmuseElfInfoMedia extends Mediator
   {
      
      public static const NAME:String = "AmuseElfInfoMedia";
       
      public var elfInfoUI:AmuseElfInfoUI;
      
      public function AmuseElfInfoMedia(param1:Object = null)
      {
         super("AmuseElfInfoMedia",param1);
         elfInfoUI = param1 as AmuseElfInfoUI;
         elfInfoUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(elfInfoUI.btn_oneClose !== _loc3_)
         {
            if(elfInfoUI.btn_sePetName === _loc3_)
            {
               BeginnerGuide.removeFromParent();
               sendNotification("switch_win",elfInfoUI,"LOAD_ELFNAME_WIN");
               sendNotification("SEND_SETNAME_ELF",elfInfoUI.myElfVO);
            }
         }
         else
         {
            sendNotification("switch_win",null);
            _loc2_ = Config.starling.root as Game;
            elfInfoUI.cleanImg();
            elfInfoUI.removeSkill();
            elfInfoUI.removeFromParent();
            EventCenter.dispatchEvent("amuse_send_reward");
            WinTweens.showCity();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("send_draw_elf_data" === _loc2_)
         {
            elfInfoUI.myElfVO = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["send_draw_elf_data"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         elfInfoUI.skillBgVec = null;
         elfInfoUI.skillTfVec = null;
         facade.removeMediator("AmuseElfInfoMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
