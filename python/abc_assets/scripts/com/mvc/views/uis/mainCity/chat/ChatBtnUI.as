package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Label;
   import starling.display.Image;
   import flash.text.TextFormat;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.chat.ChatMedia;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.mediator.mainCity.pvp.PVPBgMediator;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ChatBtnUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.chat.ChatBtnUI;
       
      private var swf:Swf;
      
      private var rootClass:Game;
      
      private var spr_chat:SwfSprite;
      
      private var chatBtn:SwfButton;
      
      public var label:Label;
      
      public var chatNews:Image;
      
      public function ChatBtnUI()
      {
         super();
         rootClass = Config.starling.root as Game;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         initChat();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.chat.ChatBtnUI
      {
         return instance || new com.mvc.views.uis.mainCity.chat.ChatBtnUI();
      }
      
      private function initChat() : void
      {
         spr_chat = swf.createSprite("spr_chat");
         chatBtn = spr_chat.getButton("chatBtn");
         label = new Label();
         label.textRendererProperties.isHTML = true;
         label.textRendererProperties.textFormat = new TextFormat("FZCuYuan-M03S",15,16777215);
         label.text = "\n亲爱的玩家，欢迎进入口袋妖怪\n的世界，请尽情聊天吧！";
         label.touchable = false;
         label.x = 93;
         label.y = 12;
         spr_chat.addChild(label);
         spr_chat.x = 5;
         spr_chat.y = 550;
         addChild(spr_chat);
         chatNews = swf.createImage("img_new");
         chatNews.touchable = false;
         chatNews.visible = false;
         chatNews.x = spr_chat.x;
         chatNews.y = spr_chat.y;
         addChild(chatNews);
         chatBtn.addEventListener("triggered",openChat);
         if(!Facade.getInstance().hasMediator("ChatMedia"))
         {
            Facade.getInstance().registerMediator(new ChatMedia(new ChatUI()));
         }
         (Facade.getInstance().retrieveProxy("ChatPro") as ChatPro).write9007();
      }
      
      private function openChat() : void
      {
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_CHAT");
         if((Starling.current.root as Game).page is PVPBgUI && PVPBgMediator.isEnterRoom && GetPrivateDate.roomChatVoVec.length)
         {
            Facade.getInstance().sendNotification("SHOW_CHAT_INDEX",2);
            return;
         }
         if(chatNews.visible)
         {
            if(GetPrivateDate.privateChatVec.length > 1)
            {
               Facade.getInstance().sendNotification("SHOW_CHAT_INDEX",1,"true");
            }
            else
            {
               Facade.getInstance().sendNotification("SHOW_CHAT_INDEX",1);
            }
         }
      }
      
      public function show() : void
      {
         LogUtil("添加到舞台-",Config.isOpenBeginner);
         if(Config.isOpenBeginner && !(rootClass.page is PVPBgUI))
         {
            return;
         }
         if(com.mvc.views.uis.mainCity.chat.ChatBtnUI.getInstance().parent)
         {
            com.mvc.views.uis.mainCity.chat.ChatBtnUI.getInstance().removeFromParent();
         }
         LogUtil("添加到舞台");
         rootClass.addChild(com.mvc.views.uis.mainCity.chat.ChatBtnUI.getInstance());
         com.mvc.views.uis.mainCity.chat.ChatBtnUI.getInstance().visible = true;
         if(!Facade.getInstance().hasMediator("ChatMedia"))
         {
            Facade.getInstance().registerMediator(new ChatMedia(new ChatUI()));
         }
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            LogUtil("从舞台上移除");
            getInstance().removeFromParent();
         }
      }
   }
}
