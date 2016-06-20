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
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.data.ListCollection;
   import starling.core.Starling;
   import starling.animation.Tween;
   
   public class PrivateChatUI extends Sprite
   {
       
      public var swf:Swf;
      
      public var spr_privateChat:SwfSprite;
      
      public var privateInput:FeathersTextInput;
      
      public var btn_send:SwfButton;
      
      public var privateChatList:List;
      
      public var btn_left:SwfButton;
      
      private var _chatVo:ChatVO;
      
      public var btn_face:SwfButton;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function PrivateChatUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_privateChat = swf.createSprite("spr_privateChat_s");
         btn_send = spr_privateChat.getButton("btn_send");
         btn_left = spr_privateChat.getButton("btn_left");
         btn_face = spr_privateChat.getButton("btn_face");
         privateInput = spr_privateChat.getChildByName("privateInput") as FeathersTextInput;
         privateInput.width = 660;
         privateInput.height = 60;
         privateInput.maxChars = 45;
         privateInput.paddingLeft = 10;
         privateInput.paddingTop = 11;
         privateInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         spr_privateChat.y = 520;
         spr_privateChat.x = 30;
         addChild(spr_privateChat);
      }
      
      private function addList() : void
      {
         privateChatList = new List();
         privateChatList.width = 1136;
         privateChatList.height = 470;
         privateChatList.y = 60;
         privateChatList.isSelectable = false;
         privateChatList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         privateChatList.itemRendererProperties.paddingBottom = _loc1_;
         privateChatList.itemRendererProperties.paddingTop = _loc1_;
         addChild(privateChatList);
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
         _loc6_ = 1;
         while(_loc6_ < param1.length)
         {
            if(param1[_loc6_].userId != PlayerVO.userId)
            {
               _loc3_ = new ChatlistUnitUI();
               _loc3_.myChatVo = param1[_loc6_];
               _loc2_.push({
                  "icon":_loc3_,
                  "label":""
               });
               displayVec.push(_loc3_);
            }
            else
            {
               _loc4_ = new MyListUnitUI();
               _loc4_.myChatVo = param1[_loc6_];
               _loc2_.push({
                  "icon":_loc4_,
                  "label":""
               });
               displayVec.push(_loc4_);
            }
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc2_);
         privateChatList.dataProvider = _loc5_;
         if(privateChatList.dataProvider)
         {
            privateChatList.scrollToDisplayIndex(param1.length - 2);
         }
      }
      
      public function clean() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
      }
      
      public function bombAni() : void
      {
         this.x = 0;
      }
      
      public function recoverAni() : void
      {
         Starling.juggler.removeTweens(this);
         var _loc1_:Tween = new Tween(this,0);
         _loc1_.moveTo(-500,0);
         Starling.juggler.add(_loc1_);
         _loc1_.onComplete = complete;
      }
      
      private function complete() : void
      {
         this.removeFromParent();
      }
   }
}
