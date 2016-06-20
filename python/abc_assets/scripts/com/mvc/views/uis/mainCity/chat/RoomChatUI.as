package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.display.DisplayObject;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.data.ListCollection;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class RoomChatUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_roomChatBg:SwfSprite;
      
      public var roomInput:FeathersTextInput;
      
      public var btn_send:SwfButton;
      
      public var roomChatList:List;
      
      public var btn_face:SwfButton;
      
      private var _chatVo:ChatVO;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function RoomChatUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_roomChatBg = swf.createSprite("spr_worldChatBg");
         btn_send = spr_roomChatBg.getButton("btn_send");
         btn_face = spr_roomChatBg.getButton("btn_face");
         roomInput = spr_roomChatBg.getChildByName("worldInput") as FeathersTextInput;
         roomInput.width = 660;
         roomInput.height = 60;
         roomInput.maxChars = 45;
         roomInput.paddingLeft = 10;
         roomInput.paddingTop = 11;
         roomInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         spr_roomChatBg.y = 520;
         spr_roomChatBg.x = 30;
         addChild(spr_roomChatBg);
         addList();
      }
      
      public function addList() : void
      {
         roomChatList = new List();
         roomChatList.width = 1136;
         roomChatList.height = 470;
         roomChatList.y = 60;
         roomChatList.isSelectable = false;
         roomChatList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         roomChatList.itemRendererProperties.paddingBottom = _loc1_;
         roomChatList.itemRendererProperties.paddingTop = _loc1_;
         addChild(roomChatList);
      }
      
      public function set myChatVo(param1:ChatVO) : void
      {
         _chatVo = param1;
      }
      
      public function get myChatVo() : ChatVO
      {
         return _chatVo;
      }
      
      public function set myPrivateVec(param1:Vector.<ChatVO>) : void
      {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:Array = [];
         LogUtil("privateVec" + param1.length);
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc6_ = 0;
         while(_loc6_ < param1.length - 1)
         {
            if(param1[_loc6_].userId != PlayerVO.userId)
            {
               _loc3_ = new ChatlistUnitUI();
               _loc3_.myChatVo = param1[_loc6_];
               _loc2_.unshift({
                  "icon":_loc3_,
                  "label":""
               });
               displayVec.push(_loc3_);
            }
            else
            {
               _loc4_ = new MyListUnitUI();
               _loc4_.myChatVo = param1[_loc6_];
               _loc2_.unshift({
                  "icon":_loc4_,
                  "label":""
               });
               displayVec.push(_loc4_);
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc2_);
         roomChatList.dataProvider = _loc5_;
      }
      
      public function clean() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
      }
   }
}
