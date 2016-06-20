package com.common.util.xmlVOHandler
{
   import com.common.util.dialogue.StarVO;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetStartChatFactor
   {
      
      public static var startDiaVec:Vector.<StarVO>;
       
      public function GetStartChatFactor()
      {
         super();
      }
      
      public static function getStartChat() : void
      {
         var _loc1_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_startChat");
         startDiaVec = new Vector.<StarVO>([]);
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_startChat;
         for each(var _loc3_ in _loc2_.sta_startChat)
         {
            _loc1_ = new StarVO();
            _loc1_.npcImgName = "img_" + _loc3_.@picId;
            _loc1_.npcName = _loc3_.@speaker;
            _loc1_.dialogue = _loc3_.@content;
            _loc1_.markStr = _loc3_.@markStr;
            _loc1_.sound = _loc3_.@voice;
            startDiaVec.push(_loc1_);
         }
      }
   }
}
