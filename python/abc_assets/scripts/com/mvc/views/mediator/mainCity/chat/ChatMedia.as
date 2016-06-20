package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.chat.ChatUI;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.mvc.views.uis.ShowBagElfUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.common.util.strHandler.StrHandle;
   import starling.display.DisplayObject;
   
   public class ChatMedia extends Mediator
   {
      
      public static const NAME:String = "ChatMedia";
      
      private static var mainChatVec:Vector.<ChatVO> = new Vector.<ChatVO>([]);
       
      public var chat:ChatUI;
      
      public function ChatMedia(param1:Object = null)
      {
         super("ChatMedia",param1);
         chat = param1 as ChatUI;
         chat.addEventListener("triggered",clickHandler);
         chat.bg.addEventListener("touch",onClose);
         chat.switchNews(4);
         chat.switchNews(3);
         chat.switchNews(1);
         chat.switchNews(0);
      }
      
      public static function getChatVec(param1:ChatVO) : void
      {
         mainChatVec.push(param1);
         if(mainChatVec.length > 4)
         {
            mainChatVec.splice(0,1);
         }
      }
      
      public static function shieldingUpdate() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < mainChatVec.length)
         {
            if(GetPrivateDate.shieldingArr.indexOf(mainChatVec[_loc1_].userId) != -1)
            {
               mainChatVec.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < ChatPro.worldChatVec.length)
         {
            if(mainChatVec.length < 4)
            {
               if(GetPrivateDate.shieldingArr.indexOf(ChatPro.worldChatVec[_loc2_].userId) == -1 && mainChatVec.indexOf(ChatPro.worldChatVec[_loc2_]) == -1)
               {
                  mainChatVec.unshift(ChatPro.worldChatVec[_loc2_]);
               }
               _loc2_++;
               continue;
            }
            break;
         }
         Facade.getInstance().sendNotification("UPDATE_MAINCITYCHAT_NEWS");
      }
      
      private function onClose(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(chat.bg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               close();
            }
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(chat.btn_close === _loc2_)
         {
            close();
         }
      }
      
      private function close() : void
      {
         (facade.retrieveMediator("WorldChatMedia") as WorldChatMedia).close();
         if(facade.hasMediator("UnionChatMedia"))
         {
            (facade.retrieveMediator("UnionChatMedia") as UnionChatMedia).close();
         }
         sendNotification("switch_win",null);
         FaceUI.getInstance().remove();
         ChatBtnUI.getInstance().chatNews.visible = false;
         ShowBagElfUI.getInstance().chatNews.visible = false;
         chat.recoverAni();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = false;
         var _loc3_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = param1.getName();
         if("SHOW_CHAT_INDEX" !== _loc6_)
         {
            if("OPEN_PRIVATE_LIST" !== _loc6_)
            {
               if("OPEN_CHAT" !== _loc6_)
               {
                  if("CLOSE_CHAT" !== _loc6_)
                  {
                     if("SEND_WORLD_NOTE" !== _loc6_)
                     {
                        if("SEND_PRIVATE_NOTE" !== _loc6_)
                        {
                           if("UPDATE_MAINCITYCHAT_NEWS" !== _loc6_)
                           {
                              if("close_chat_before_pvp" === _loc6_)
                              {
                                 LogUtil("跳转到pvp，需要关闭聊天界面");
                                 close();
                              }
                           }
                           else
                           {
                              if(GetCommon.isIOSDied())
                              {
                                 return;
                              }
                              if(ChatBtnUI.getInstance().visible == true && ChatBtnUI.getInstance().parent != null)
                              {
                                 LogUtil("=======更新主城显示的聊天消息===========");
                                 ChatBtnUI.getInstance().label.text = "";
                                 _loc3_ = "";
                                 _loc5_ = 0;
                                 while(_loc5_ < mainChatVec.length)
                                 {
                                    _loc3_ = _loc3_ + (StrHandle.chatOvertop(mainChatVec[_loc5_]) + "\n");
                                    _loc5_++;
                                 }
                                 ChatBtnUI.getInstance().label.text = _loc3_;
                              }
                           }
                        }
                        else
                        {
                           chat.notReadP.text = param1.getBody() as int;
                        }
                     }
                     else
                     {
                        chat.notReadW.text = param1.getBody() as int;
                     }
                  }
                  else
                  {
                     chat.recoverAni();
                  }
               }
            }
            else
            {
               chat.addPrivateChat();
            }
         }
         else
         {
            _loc4_ = param1.getBody() as int;
            if(param1.getType() == "true")
            {
               _loc2_ = true;
            }
            chat.tabs.selectedIndex = _loc4_;
            chat.switchNews(_loc4_,_loc2_);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_CHAT_INDEX","OPEN_PRIVATE_LIST","OPEN_CHAT","SEND_WORLD_NOTE","SEND_PRIVATE_NOTE","CLOSE_CHAT","UPDATE_MAINCITYCHAT_NEWS","close_chat_before_pvp"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
