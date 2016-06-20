package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.UnionChatUI;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.themes.Tips;
   import com.common.util.strHandler.StrHandle;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.chat.MyListUnitUI;
   import com.mvc.views.uis.mainCity.chat.ChatlistUnitUI;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   
   public class UnionChatMedia extends Mediator
   {
      
      public static const NAME:String = "UnionChatMedia";
       
      public var unionChat:UnionChatUI;
      
      private var beforeMsg:String;
      
      public function UnionChatMedia(param1:Object = null)
      {
         super("UnionChatMedia",param1);
         unionChat = param1 as UnionChatUI;
         unionChat.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(unionChat.btn_face !== _loc2_)
         {
            if(unionChat.btn_send === _loc2_)
            {
               if(WorldTime.unionChatTime > 0)
               {
                  return Tips.show("距离下一次发言还有 " + WorldTime.unionChatTime + " 秒");
               }
               if(beforeMsg == unionChat.unionInput.text)
               {
                  WorldTime.unionChatTime = 10;
                  beforeMsg = "";
                  Tips.show("发现与上一次的内容相同, 再等10秒");
                  return;
               }
               if(StrHandle.isAllSpace(unionChat.unionInput.text))
               {
                  Tips.show("请输入内容");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(unionChat.unionInput.text))
               {
                  Tips.show("不能有敏感词哦");
                  return;
               }
               if(unionChat.unionInput.text != "")
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9002(4,unionChat.unionInput.text);
                  beforeMsg = unionChat.unionInput.text;
                  unionChat.unionInput.text = "";
               }
               else
               {
                  Tips.show("请输入内容");
               }
               FaceUI.getInstance().remove();
            }
         }
         else
         {
            FaceUI.getInstance().show(unionChat);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("SHOW_UNION_CHAT" !== _loc3_)
         {
            if("SEND_CHAT_FACE" === _loc3_)
            {
               if(!unionChat.parent)
               {
                  return;
               }
               _loc2_ = param1.getBody() as String;
               if(unionChat.unionInput.text.length + _loc2_.length <= 45)
               {
                  unionChat.unionInput.text = unionChat.unionInput.text + _loc2_;
               }
               LogUtil("unionChat.unionInput.text= ",unionChat.unionInput.text);
            }
         }
         else
         {
            if(GetCommon.isIOSDied())
            {
               return;
            }
            if((facade.retrieveMediator("ChatMedia") as ChatMedia).chat.parent != null)
            {
               showList();
               scrollList();
            }
         }
      }
      
      private function scrollList() : void
      {
         if(unionChat.unionChatList.dataProvider)
         {
            unionChat.unionChatList.scrollToDisplayIndex(ChatPro.unionChatVec.length - 1);
         }
      }
      
      private function showList() : void
      {
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(unionChat.unionChatList.dataProvider)
         {
            LogUtil("有多少条" + (unionChat.unionChatList.dataProvider.data as Array).length);
            if((unionChat.unionChatList.dataProvider.data as Array).length >= 20)
            {
               _loc4_ = unionChat.unionChatList.dataProvider.removeItemAt(0);
               _loc4_.icon.dispose();
            }
            if(ChatPro.unionChatVec.length > 0)
            {
               addChatInfo();
            }
            return;
         }
         LogUtil(" 公会聊天数目  =======",ChatPro.unionChatVec.length);
         var _loc1_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < ChatPro.unionChatVec.length)
         {
            if(ChatPro.unionChatVec[_loc6_].userId == PlayerVO.userId)
            {
               _loc3_ = new MyListUnitUI();
               _loc3_.myChatVo = ChatPro.unionChatVec[_loc6_];
               _loc1_.unshift({
                  "icon":_loc3_,
                  "label":""
               });
            }
            else
            {
               _loc2_ = new ChatlistUnitUI();
               _loc2_.myChatVo = ChatPro.unionChatVec[_loc6_];
               _loc1_.unshift({
                  "icon":_loc2_,
                  "label":""
               });
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         unionChat.unionChatList.dataProvider = _loc5_;
      }
      
      private function addChatInfo() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(ChatPro.unionChatVec[0].userId == PlayerVO.userId)
         {
            _loc2_ = new MyListUnitUI();
            _loc2_.myChatVo = ChatPro.unionChatVec[0];
            unionChat.unionChatList.dataProvider.addItem({
               "icon":_loc2_,
               "label":""
            });
         }
         else
         {
            _loc1_ = new ChatlistUnitUI();
            _loc1_.myChatVo = ChatPro.unionChatVec[0];
            unionChat.unionChatList.dataProvider.addItem({
               "icon":_loc1_,
               "label":""
            });
         }
      }
      
      public function close() : void
      {
         var _loc1_:* = null;
         if(!unionChat.unionChatList.dataProvider)
         {
            return;
         }
         while(unionChat.unionChatList.dataProvider.length > 0)
         {
            _loc1_ = unionChat.unionChatList.dataProvider.removeItemAt(0);
            _loc1_.icon.dispose();
         }
         unionChat.unionChatList.dataProvider = null;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_UNION_CHAT","SEND_CHAT_FACE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("UnionChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
