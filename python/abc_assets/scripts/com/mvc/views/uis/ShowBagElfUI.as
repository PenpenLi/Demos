package com.mvc.views.uis
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.Finger;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ShowBagElfUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.ShowBagElfUI;
       
      private var swf:Swf;
      
      private var rootClass:Game;
      
      private var btn_bag:SwfButton;
      
      private var btn_elf:SwfButton;
      
      private var startDrop:Boolean;
      
      private var btn_home:SwfButton;
      
      private var isScoll:Boolean;
      
      private var startPointX:int;
      
      private var startPointY:int;
      
      private var btn_task:SwfButton;
      
      public var taskNews:Image;
      
      private var btn_chat:SwfButton;
      
      public var chatNews:SwfImage;
      
      public function ShowBagElfUI()
      {
         super();
         rootClass = Config.starling.root as Game;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         btn_bag = swf.createButton("btn_backpack_b");
         btn_home = swf.createButton("btn_home");
         btn_elf = swf.createButton("btn_spirit");
         btn_elf.name = "btn_elf";
         btn_task = swf.createButton("btn_task_b");
         btn_chat = swf.createButton("btn_btnChat_b");
         var _loc1_:* = 0.8;
         btn_task.scaleY = _loc1_;
         btn_task.scaleX = _loc1_;
         _loc1_ = 0.8;
         btn_bag.scaleY = _loc1_;
         btn_bag.scaleX = _loc1_;
         _loc1_ = 0.8;
         btn_home.scaleY = _loc1_;
         btn_home.scaleX = _loc1_;
         _loc1_ = 0.8;
         btn_elf.scaleY = _loc1_;
         btn_elf.scaleX = _loc1_;
         _loc1_ = 0.8;
         btn_chat.scaleY = _loc1_;
         btn_chat.scaleX = _loc1_;
         btn_elf.y = 70;
         btn_bag.y = 140;
         btn_task.y = 215;
         btn_chat.y = 290;
         taskNews = swf.createImage("img_new");
         _loc1_ = 0.8;
         taskNews.scaleY = _loc1_;
         taskNews.scaleX = _loc1_;
         taskNews.touchable = false;
         taskNews.visible = false;
         taskNews.x = btn_task.x;
         taskNews.y = btn_task.y;
         chatNews = swf.createImage("img_new");
         _loc1_ = 0.8;
         chatNews.scaleY = _loc1_;
         chatNews.scaleX = _loc1_;
         chatNews.touchable = false;
         chatNews.visible = false;
         chatNews.x = btn_chat.x;
         chatNews.y = btn_chat.y;
         this.addChild(btn_home);
         this.addChild(btn_bag);
         this.addChild(btn_elf);
         this.addChild(btn_task);
         this.addChild(taskNews);
         this.addChild(btn_chat);
         this.addChild(chatNews);
         rootClass.addEventListener("touch",touchHandler);
      }
      
      public static function getInstance() : com.mvc.views.uis.ShowBagElfUI
      {
         return instance || new com.mvc.views.uis.ShowBagElfUI();
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(!_loc2_ || Config.isOpenBeginner)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            startDrop = true;
            startPointX = this.x;
            startPointY = this.y;
         }
         if(_loc2_.phase == "moved")
         {
            if(startDrop)
            {
               this.y = this.y + (_loc2_.globalY - _loc2_.previousGlobalY) / Config.scaleY;
               this.x = this.x + (_loc2_.globalX - _loc2_.previousGlobalX) / Config.scaleX;
               if(this.x < this.width >> 1)
               {
                  this.x = this.width >> 1;
               }
               if(this.x > 1136 - (this.width >> 1))
               {
                  this.x = 1136 - (this.width >> 1);
               }
               if(this.y < this.height >> 1)
               {
                  this.y = this.height >> 1;
               }
               if(this.y > 640 - (this.height >> 1))
               {
                  this.y = 640 - (this.height >> 1);
               }
            }
            if(Math.abs(this.x - startPointX) > 10 || Math.abs(this.y - startPointY) > 10)
            {
               isScoll = true;
            }
         }
         if(_loc2_.phase == "ended")
         {
            LogUtil("停止拖动");
            isScoll = false;
            startDrop = false;
         }
      }
      
      private function click(param1:Event) : void
      {
         LogUtil(isScoll + "点击无反应啊大爷" + param1.target);
         if(isScoll)
         {
            return;
         }
         var _loc2_:* = param1.target;
         if(btn_bag !== _loc2_)
         {
            if(btn_elf !== _loc2_)
            {
               if(btn_task !== _loc2_)
               {
                  if(btn_home !== _loc2_)
                  {
                     if(btn_chat === _loc2_)
                     {
                        Facade.getInstance().sendNotification("switch_win",null,"LOAD_CHAT");
                        if(ChatBtnUI.getInstance().chatNews.visible)
                        {
                           Facade.getInstance().sendNotification("SHOW_CHAT_INDEX",1);
                        }
                     }
                  }
                  else
                  {
                     if(Finger.getInstance().parent)
                     {
                        LogUtil("手指指向动画");
                        Finger.getInstance().removeFromParent();
                     }
                     if(MyElfMedia.isJumpPage || EvoStoneGuideUI.parentPage == "MyElfMedia")
                     {
                        Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELF_WIN");
                        return;
                     }
                     if(EvoStoneGuideUI.parentPage == "BackPackMedia")
                     {
                        Facade.getInstance().sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
                        return;
                     }
                     CityMapMeida.recordMainAdvance = null;
                     CityMapMeida.recordExtenAdvance = null;
                     if(Finger.getInstance().parent)
                     {
                        Finger.getInstance().removeFromParent();
                     }
                     Facade.getInstance().sendNotification("switch_page","load_maincity_page");
                  }
               }
               else
               {
                  Facade.getInstance().sendNotification("switch_win",null,"LOAD_TASK");
               }
            }
            else
            {
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELF_WIN");
            }
         }
         else
         {
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
         }
      }
      
      public function show() : void
      {
         if(this.parent != null)
         {
            this.removeFromParent();
         }
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.x = 1098 - 2;
         this.y = 450 - 2;
         rootClass.addChild(this);
         this.visible = true;
         if(!this.hasEventListener("triggered"))
         {
            this.addEventListener("triggered",click);
         }
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
         }
      }
   }
}
