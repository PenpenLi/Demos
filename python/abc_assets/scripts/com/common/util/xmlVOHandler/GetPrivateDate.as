package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.mvc.models.vos.login.PlayerVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.chat.PrivateChatMedia;
   
   public class GetPrivateDate
   {
      
      public static var privateChatVec:Vector.<Vector.<ChatVO>> = new Vector.<Vector.<ChatVO>>([]);
      
      private static var playerChatIdArr:Array = [];
      
      public static var roomChatVoVec:Vector.<ChatVO> = new Vector.<ChatVO>([]);
      
      public static var shieldingArr:Array = [];
       
      public function GetPrivateDate()
      {
         super();
      }
      
      public static function addChatList(param1:ChatVO) : Boolean
      {
         var _loc2_:* = undefined;
         if(playerChatIdArr.indexOf(param1.userId) == -1 && param1.userId != PlayerVO.userId)
         {
            LogUtil("私聊列表人数加==",param1.userName);
            _loc2_ = new Vector.<ChatVO>([]);
            playerChatIdArr.push(param1.userId);
            _loc2_.push(param1);
            privateChatVec.push(_loc2_);
            return true;
         }
         return false;
      }
      
      public static function getprivateChatVec(param1:ChatVO) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         addChatList(param1);
         _loc2_ = 0;
         while(_loc2_ < privateChatVec.length)
         {
            if(param1.userId == PlayerVO.userId)
            {
               LogUtil("推送给自己的=" + param1.msg);
               _loc3_ = getChatVec((Facade.getInstance().retrieveMediator("PrivateChatMedia") as PrivateChatMedia).privateChat.myChatVo.userId);
               LogUtil(_loc3_ + "—私聊列表的index");
               if(privateChatVec[_loc3_].length > 20)
               {
                  LogUtil(privateChatVec[_loc3_][1].msg + "--删掉的消息");
                  privateChatVec[_loc3_].splice(1,1);
               }
               privateChatVec[_loc3_].push(param1);
               return;
            }
            LogUtil(privateChatVec[_loc2_][0].userId + " == " + param1.userId);
            if(privateChatVec[_loc2_][0].userId == param1.userId)
            {
               LogUtil("已经存在的联系人 = ",param1.userName);
               if(privateChatVec[_loc2_].length > 20)
               {
                  LogUtil(privateChatVec[_loc2_][1].msg + "删掉的消息");
                  privateChatVec[_loc2_].splice(1,1);
               }
               privateChatVec[_loc2_].push(param1);
            }
            _loc2_++;
         }
      }
      
      public static function getChatVec(param1:String) : int
      {
         var _loc2_:int = playerChatIdArr.indexOf(param1);
         return _loc2_;
      }
      
      public static function getRoomChatVoVec(param1:ChatVO) : void
      {
         if(roomChatVoVec.length > 20)
         {
            roomChatVoVec.splice(roomChatVoVec.length - 1,1);
         }
         roomChatVoVec.unshift(param1);
      }
   }
}
