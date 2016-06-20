package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.chat.RoomChatUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.strHandler.StrHandle;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.util.GetCommon;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.chat.ChatlistUnitUI;
   import com.mvc.views.uis.mainCity.chat.MyListUnitUI;
   import feathers.data.ListCollection;
   
   public class RoomChatMediaotr extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "RoomChatMediaotr";
       
      public var roomChatUI:RoomChatUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function RoomChatMediaotr(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("RoomChatMediaotr",param1);
         roomChatUI = param1 as RoomChatUI;
         roomChatUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(roomChatUI.btn_send !== _loc2_)
         {
            if(roomChatUI.btn_face === _loc2_)
            {
               FaceUI.getInstance().show(roomChatUI);
            }
         }
         else
         {
            if(roomChatUI.myChatVo)
            {
               if(StrHandle.isAllSpace(roomChatUI.roomInput.text))
               {
                  Tips.show("请输入内容");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(roomChatUI.roomInput.text))
               {
                  Tips.show("不能有敏感词哦。");
                  return;
               }
               if(roomChatUI.roomInput.text != "")
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9003(roomChatUI.myChatVo,roomChatUI.roomInput.text);
                  roomChatUI.roomInput.text = "";
               }
               else
               {
                  Tips.show("请输入内容");
               }
            }
            else
            {
               Tips.show("还没有人进来呢");
            }
            FaceUI.getInstance().remove();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("send_roomchat_data" !== _loc3_)
         {
            if("show_room_chat" !== _loc3_)
            {
               if("SEND_CHAT_FACE" === _loc3_)
               {
                  if(!roomChatUI.parent)
                  {
                     return;
                  }
                  _loc2_ = param1.getBody() as String;
                  if(roomChatUI.roomInput.text.length + _loc2_.length <= 45)
                  {
                     roomChatUI.roomInput.text = roomChatUI.roomInput.text + _loc2_;
                  }
                  LogUtil("\troomChatUI.roomInput.text= ",roomChatUI.roomInput.text);
               }
            }
            else
            {
               if(GetCommon.isIOSDied())
               {
                  return;
               }
               showList();
               if(roomChatUI.roomChatList.dataProvider)
               {
                  roomChatUI.roomChatList.scrollToDisplayIndex(GetPrivateDate.roomChatVoVec.length - 1);
               }
            }
         }
         else
         {
            if(param1.getBody() == null)
            {
               roomChatUI.myChatVo = null;
               return;
            }
            roomChatUI.myChatVo = param1.getBody() as ChatVO;
            LogUtil("房间聊天对方的数据====",roomChatUI.myChatVo.userName);
         }
      }
      
      private function showList() : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(roomChatUI.roomChatList.dataProvider)
         {
            roomChatUI.roomChatList.dataProvider.removeAll();
            roomChatUI.roomChatList.dataProvider = null;
         }
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ <= GetPrivateDate.roomChatVoVec.length - 1)
         {
            LogUtil(GetPrivateDate.roomChatVoVec[_loc5_].userName,"==GetPrivateDate.roomChatVoVec[i].userName");
            if(GetPrivateDate.roomChatVoVec[_loc5_].userId != PlayerVO.userId)
            {
               _loc2_ = new ChatlistUnitUI();
               _loc2_.myChatVo = GetPrivateDate.roomChatVoVec[_loc5_];
               _loc1_.unshift({
                  "icon":_loc2_,
                  "label":""
               });
               displayVec.push(_loc2_);
            }
            else
            {
               _loc3_ = new MyListUnitUI();
               _loc3_.myChatVo = GetPrivateDate.roomChatVoVec[_loc5_];
               _loc1_.unshift({
                  "icon":_loc3_,
                  "label":""
               });
               displayVec.push(_loc3_);
            }
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         roomChatUI.roomChatList.dataProvider = _loc4_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["send_roomchat_data","show_room_chat","SEND_CHAT_FACE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         roomChatUI.clean();
         facade.removeMediator("RoomChatMediaotr");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
