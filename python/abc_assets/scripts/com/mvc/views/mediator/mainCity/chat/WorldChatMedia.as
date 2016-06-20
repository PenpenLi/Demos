package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.WorldChatUI;
   import starling.events.Event;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.strHandler.StrHandle;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.views.uis.mainCity.chat.FaceUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.mvc.views.uis.mainCity.chat.MyListUnitUI;
   import com.mvc.views.uis.mainCity.chat.ChatlistUnitUI;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   
   public class WorldChatMedia extends Mediator
   {
      
      public static const NAME:String = "WorldChatMedia";
      
      public static var worldNoteNum:int;
       
      public var worldChat:WorldChatUI;
      
      private var beforeMsg:String;
      
      public function WorldChatMedia(param1:Object = null)
      {
         super("WorldChatMedia",param1);
         worldChat = param1 as WorldChatUI;
         worldChat.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(worldChat.btn_send !== _loc2_)
         {
            if(worldChat.btn_face === _loc2_)
            {
               FaceUI.getInstance().show(worldChat);
            }
         }
         else
         {
            if(WorldTime.chatTime > 0)
            {
               return Tips.show("距离下一次发言还有 " + WorldTime.chatTime + " 秒");
            }
            if(beforeMsg == worldChat.worldInput.text)
            {
               if(PlayerVO.lv >= 15)
               {
                  WorldTime.chatTime = 10;
                  Tips.show("发现与上一次发送内容相同, 再等10秒");
               }
               else if(PlayerVO.lv < 15 && PlayerVO.lv >= 10)
               {
                  WorldTime.chatTime = 60;
                  Tips.show("发现与上一次发送内容相同, 再等60秒");
               }
               else if(PlayerVO.lv < 10)
               {
                  WorldTime.chatTime = 120;
                  Tips.show("发现与上一次发送内容相同, 再等120秒");
               }
               beforeMsg = "";
               return;
            }
            if(StrHandle.isAllSpace(worldChat.worldInput.text))
            {
               Tips.show("请输入内容");
               return;
            }
            if(CheckSensitiveWord.checkSensitiveWord(worldChat.worldInput.text))
            {
               Tips.show("不能有敏感词哦");
               return;
            }
            if(worldChat.worldInput.text != "")
            {
               (facade.retrieveProxy("ChatPro") as ChatPro).write9002(1,worldChat.worldInput.text);
               beforeMsg = worldChat.worldInput.text;
               worldChat.worldInput.text = "";
            }
            else
            {
               Tips.show("请输入内容");
            }
            FaceUI.getInstance().remove();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("SHOW_WORLD_LIST" !== _loc3_)
         {
            if("UPDATA_WORLD_COUNT" !== _loc3_)
            {
               if("SEND_CHAT_FACE" !== _loc3_)
               {
                  if("SHIELDING_UPDATE" === _loc3_)
                  {
                     close();
                     showList();
                     scrollList();
                  }
               }
               else
               {
                  if(!worldChat.parent)
                  {
                     return;
                  }
                  _loc2_ = param1.getBody() as String;
                  if(worldChat.worldInput.text.length + _loc2_.length <= 45)
                  {
                     worldChat.worldInput.text = worldChat.worldInput.text + _loc2_;
                  }
                  LogUtil("\tworldChat.worldInput.text= ",worldChat.worldInput.text);
               }
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
         LogUtil("ChatPro.worldChatVec.length - 1===",ChatPro.worldChatVec.length - 1);
         if(worldChat.worldChatList.dataProvider)
         {
            worldChat.worldChatList.scrollToDisplayIndex(ChatPro.worldChatVec.length - 1);
         }
      }
      
      private function showList() : void
      {
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(worldChat.worldChatList.dataProvider)
         {
            LogUtil("有多少条" + (worldChat.worldChatList.dataProvider.data as Array).length);
            if((worldChat.worldChatList.dataProvider.data as Array).length >= 20)
            {
               _loc4_ = worldChat.worldChatList.dataProvider.removeItemAt(0);
               _loc4_.icon.dispose();
            }
            addChatInfo();
            return;
         }
         var _loc1_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < ChatPro.worldChatVec.length)
         {
            if(GetPrivateDate.shieldingArr.indexOf(ChatPro.worldChatVec[_loc6_].userId) != -1)
            {
               ChatPro.worldChatVec.splice(_loc6_,1);
               _loc6_--;
            }
            else if(ChatPro.worldChatVec[_loc6_].userId == PlayerVO.userId)
            {
               _loc3_ = new MyListUnitUI();
               _loc3_.myChatVo = ChatPro.worldChatVec[_loc6_];
               _loc1_.unshift({
                  "icon":_loc3_,
                  "label":""
               });
            }
            else
            {
               _loc2_ = new ChatlistUnitUI();
               _loc2_.myChatVo = ChatPro.worldChatVec[_loc6_];
               _loc1_.unshift({
                  "icon":_loc2_,
                  "label":""
               });
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         worldChat.worldChatList.dataProvider = _loc5_;
      }
      
      private function addChatInfo() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(ChatPro.worldChatVec[0].userId == PlayerVO.userId)
         {
            _loc2_ = new MyListUnitUI();
            _loc2_.myChatVo = ChatPro.worldChatVec[0];
            worldChat.worldChatList.dataProvider.addItem({
               "icon":_loc2_,
               "label":""
            });
         }
         else
         {
            _loc1_ = new ChatlistUnitUI();
            _loc1_.myChatVo = ChatPro.worldChatVec[0];
            worldChat.worldChatList.dataProvider.addItem({
               "icon":_loc1_,
               "label":""
            });
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_WORLD_LIST","UPDATA_WORLD_COUNT","SEND_CHAT_FACE","SHIELDING_UPDATE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function close() : void
      {
         var _loc1_:* = null;
         if(!worldChat.worldChatList.dataProvider)
         {
            return;
         }
         while(worldChat.worldChatList.dataProvider.length > 0)
         {
            _loc1_ = worldChat.worldChatList.dataProvider.removeItemAt(0);
            _loc1_.icon.dispose();
         }
         worldChat.worldChatList.dataProvider = null;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("WorldChatMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
