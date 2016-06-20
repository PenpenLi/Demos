package com.mvc.views.uis.mainCity.information
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.TabBar;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import lzm.util.OSUtil;
   import com.massage.ane.UmengExtension;
   import flash.media.StageWebView;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.information.MailMedia;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.mvc.views.mediator.mainCity.information.GiftMedia;
   import com.mvc.views.mediator.mainCity.information.FeedbackMedia;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class InformationUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_informationBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var tabs:TabBar;
      
      public var contain:Sprite;
      
      public var currentTab:int = 0;
      
      public function InformationUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addTars();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("information");
         spr_informationBg = swf.createSprite("spr_informationBg_s");
         btn_close = spr_informationBg.getButton("btn_close");
         spr_informationBg.x = 1136 - spr_informationBg.width >> 1;
         spr_informationBg.y = 30;
         addChild(spr_informationBg);
         contain = new Sprite();
         contain.x = 20;
         contain.y = 100;
         spr_informationBg.addChild(contain);
      }
      
      private function addTars() : void
      {
         tabs = new TabBar();
         if(Pocketmon._description == "mz")
         {
            tabs.dataProvider = new ListCollection([{"label":"官方活动"},{"label":"官方公告"},{"label":"系统邮件"},{"label":"礼包兑换"}]);
         }
         else
         {
            tabs.dataProvider = new ListCollection([{"label":"官方活动"},{"label":"官方公告"},{"label":"系统邮件"},{"label":"礼包兑换"},{"label":"玩家反馈"}]);
         }
         tabs.x = 20;
         tabs.y = 20;
         spr_informationBg.addChild(tabs);
         tabs.addEventListener("change",tabs_changeHandler);
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         if(Game.httpView != null)
         {
            Game.httpView.dispose();
            Game.httpView = null;
         }
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(_loc2_.selectedIndex == 4 && OSUtil.isAndriod())
         {
            UmengExtension.getInstance().UMFeedBack("1");
            _loc2_.selectedIndex = currentTab;
            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-反馈");
            return;
         }
         if(_loc2_.selectedIndex != currentTab)
         {
            switchNews(_loc2_.selectedIndex);
         }
         currentTab = _loc2_.selectedIndex;
      }
      
      public function switchNews(param1:int) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         contain.removeChildren(0);
         switch(param1)
         {
            case 0:
               if(Game.activityHttp != "")
               {
                  Game.httpView = new StageWebView();
                  Game.httpView.stage = Config.starling.nativeStage;
                  Game.httpView.loadURL(Game.activityHttp);
                  Game.httpView.viewPort = Game.officialRect;
               }
               else if(Game.httpView != null)
               {
                  Game.httpView.dispose();
                  Game.httpView = null;
               }
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-官方活动");
               break;
            case 1:
               if(Game.noticeHttp != "")
               {
                  Game.httpView = new StageWebView();
                  Game.httpView.stage = Config.starling.nativeStage;
                  Game.httpView.loadURL(Game.noticeHttp);
                  Game.httpView.viewPort = Game.officialRect;
               }
               else if(Game.httpView != null)
               {
                  Game.httpView.dispose();
                  Game.httpView = null;
               }
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-官方公告");
               break;
            case 2:
               if(!Facade.getInstance().hasMediator("MailMedia"))
               {
                  Facade.getInstance().registerMediator(new MailMedia(new MailUI()));
               }
               _loc4_ = (Facade.getInstance().retrieveMediator("MailMedia") as MailMedia).UI as MailUI;
               contain.addChild(_loc4_);
               if(MailMedia.isNew)
               {
                  (Facade.getInstance().retrieveProxy("InformationPro") as InformationPro).write4200();
               }
               else
               {
                  Facade.getInstance().sendNotification("SHOW_MAIL");
               }
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-邮件");
               break;
            case 3:
               if(!Facade.getInstance().hasMediator("GiftMedia"))
               {
                  Facade.getInstance().registerMediator(new GiftMedia(new GiftUI()));
               }
               _loc2_ = (Facade.getInstance().retrieveMediator("GiftMedia") as GiftMedia).UI as GiftUI;
               contain.addChild(_loc2_);
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-礼包");
               break;
            case 4:
               if(!Facade.getInstance().hasMediator("FeedbackMedia"))
               {
                  Facade.getInstance().registerMediator(new FeedbackMedia(new FeedbackUI()));
               }
               _loc3_ = (Facade.getInstance().retrieveMediator("FeedbackMedia") as FeedbackMedia).UI as FeedbackUI;
               contain.addChild(_loc3_);
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|消息-反馈");
               break;
         }
      }
   }
}
