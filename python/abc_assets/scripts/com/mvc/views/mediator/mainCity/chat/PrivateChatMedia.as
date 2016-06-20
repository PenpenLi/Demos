package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.PrivateChatUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.strHandler.StrHandle;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.chat.ChatlistUnitUI;
   import com.mvc.views.uis.mainCity.chat.MyListUnitUI;
   import feathers.data.ListCollection;
   
   public class PrivateChatMedia extends Mediator
   {
      
      public static const NAME:String = "PrivateChatMedia";
      
      public static var privateNoteNum:int;
       
      public var privateChat:PrivateChatUI;
      
      private var leaveWord:String;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function PrivateChatMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PrivateChatMedia",param1);
         privateChat = param1 as PrivateChatUI;
         privateChat.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(privateChat.btn_send !== _loc2_)
         {
            if(privateChat.btn_left !== _loc2_)
            {
               if(privateChat.btn_face === _loc2_)
               {
                  FaceUI.getInstance().show(privateChat);
               }
            }
            else
            {
               privateChat.recoverAni();
               sendNotification("OPEN_PRIVATE_LIST");
            }
         }
         else
         {
            if(privateChat.myChatVo)
            {
               if(StrHandle.isAllSpace(privateChat.privateInput.text))
               {
                  Tips.show("请输入内容");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(privateChat.privateInput.text))
               {
                  Tips.show("不能有敏感词哦。");
                  return;
               }
               if(privateChat.privateInput.text != "")
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9003(privateChat.myChatVo,privateChat.privateInput.text);
                  leaveWord = privateChat.privateInput.text;
                  privateChat.privateInput.text = "";
               }
               else
               {
                  Tips.show("请输入内容");
               }
            }
            else
            {
               Tips.show("还没选择聊天对象");
            }
            FaceUI.getInstance().remove();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = param1.getName();
         if("SEND_PRIVATE_DATA" !== _loc4_)
         {
            if("SHOW_PRIVATE_ALONE" !== _loc4_)
            {
               if("SHOW_PRIVATE_CHAT" !== _loc4_)
               {
                  if("SEND_LEAVE_WORD" !== _loc4_)
                  {
                     if("SEND_CHAT_FACE" === _loc4_)
                     {
                        if(!privateChat.parent)
                        {
                           return;
                        }
                        _loc2_ = param1.getBody() as String;
                        if(privateChat.privateInput.text.length + _loc2_.length <= 45)
                        {
                           privateChat.privateInput.text = privateChat.privateInput.text + _loc2_;
                        }
                        LogUtil("privateChat.privateInput.text= ",privateChat.privateInput.text);
                     }
                  }
                  else
                  {
                     (facade.retrieveProxy("ChatPro") as ChatPro).write9006(privateChat.myChatVo.userId,leaveWord);
                  }
               }
               else
               {
                  _loc3_ = GetPrivateDate.getChatVec(privateChat.myChatVo.userId);
                  showList(_loc3_);
               }
            }
            else
            {
               privateChat.myPrivateVec = param1.getBody() as Vector.<ChatVO>;
            }
         }
         else
         {
            privateChat.myChatVo = param1.getBody() as ChatVO;
            LogUtil("发送私聊对象数据====",privateChat.myChatVo.userName);
         }
      }
      
      private function showList(param1:int) : void
      {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(privateChat.privateChatList.dataProvider)
         {
            privateChat.privateChatList.dataProvider.removeAll();
            privateChat.privateChatList.dataProvider = null;
         }
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc6_ = 1;
         while(_loc6_ < GetPrivateDate.privateChatVec[param1].length)
         {
            if(GetPrivateDate.privateChatVec[param1][_loc6_].userId != PlayerVO.userId)
            {
               _loc3_ = new ChatlistUnitUI();
               _loc3_.myChatVo = GetPrivateDate.privateChatVec[param1][_loc6_];
               _loc2_.push({
                  "icon":_loc3_,
                  "label":""
               });
               displayVec.push(_loc3_);
            }
            else
            {
               _loc4_ = new MyListUnitUI();
               _loc4_.myChatVo = GetPrivateDate.privateChatVec[param1][_loc6_];
               _loc2_.push({
                  "icon":_loc4_,
                  "label":""
               });
               displayVec.push(_loc4_);
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc2_);
         privateChat.privateChatList.dataProvider = _loc5_;
         LogUtil("滚动到私聊界面的最下面========",GetPrivateDate.privateChatVec[param1].length - 2);
         if(privateChat.privateChatList)
         {
            privateChat.privateChatList.scrollToDisplayIndex(GetPrivateDate.privateChatVec[param1].length - 2);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_PRIVATE_ALONE","SEND_PRIVATE_DATA","SHOW_PRIVATE_CHAT","SEND_LEAVE_WORD","SEND_CHAT_FACE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         privateChat.clean();
         facade.removeMediator("PrivateChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
