package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.HornUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.util.strHandler.StrHandle;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class HornMedia extends Mediator
   {
      
      public static const NAME:String = "HornMedia";
       
      public var horn:HornUI;
      
      public function HornMedia(param1:Object = null)
      {
         super("HornMedia",param1);
         horn = param1 as HornUI;
         horn.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(horn.btn_hornClose !== _loc2_)
         {
            if(horn.btn_send === _loc2_)
            {
               if(StrHandle.isAllSpace(horn.input_horn.text))
               {
                  Tips.show("请输入内容");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(horn.input_horn.text))
               {
                  Tips.show("喇叭内容不能有敏感词哦。");
                  return;
               }
               if(horn.input_horn.text != "")
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9002(3,horn.input_horn.text);
                  WinTweens.closeWin(horn.spr_horn,remove);
               }
               else
               {
                  Tips.show("请输入内容");
               }
               horn.input_horn.text = "";
            }
         }
         else
         {
            WinTweens.closeWin(horn.spr_horn,remove);
            horn.input_horn.text = "";
         }
      }
      
      private function remove() : void
      {
         horn.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HornMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
