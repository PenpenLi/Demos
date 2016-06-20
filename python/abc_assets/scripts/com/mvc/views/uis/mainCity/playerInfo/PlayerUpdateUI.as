package com.mvc.views.uis.mainCity.playerInfo
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import starling.display.Quad;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.task.TaskUI;
   import com.common.managers.LoadSwfAssetsManager;
   import extend.SoundEvent;
   import com.massage.ane.UmengExtension;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.views.mediator.fighting.AniFactor;
   
   public class PlayerUpdateUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
       
      private var rootClass:Game;
      
      private var movic_light:SwfMovieClip;
      
      private var updateImage:Image;
      
      private var mySpr:SwfSprite;
      
      private var updateInfoSpr:SwfSprite;
      
      private var swf:Swf;
      
      private var lvBeforeTF:TextField;
      
      private var powerBeforeTF:TextField;
      
      private var maxPowerBeforeTF:TextField;
      
      private var lvAfterTF:TextField;
      
      private var powerAfterTF:TextField;
      
      private var maxPowerAfterTF:TextField;
      
      private var openTF:TextField;
      
      private var bg:Quad;
      
      private var isBeginGuide:Boolean;
      
      public function PlayerUpdateUI()
      {
         super();
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         rootClass = Config.starling.root as Game;
         init();
         this.addEventListener("touch",touchHanler);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI
      {
         return instance || new com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI();
      }
      
      private function touchHanler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Touch = param1.getTouch(this);
         if(_loc3_ && _loc3_.phase == "ended")
         {
            FightingConfig.isLvUp = false;
            remove();
            movic_light.stop();
            if(PlayerVO.isOpenPokeSpace)
            {
               _loc2_ = Alert.show("您打开了新的背包空间。","",new ListCollection([{"label":"我知道了"}]));
               PlayerVO.isOpenPokeSpace = false;
            }
            if(isBeginGuide)
            {
               CityMapMeida.recordMainAdvance = null;
               CityMapMeida.recordExtenAdvance = null;
               isBeginGuide = false;
               if(GameFacade.getInstance().hasMediator("TaskMedia"))
               {
                  LogUtil("在任务界面开始新手");
                  (GameFacade.getInstance().retrieveMediator("TaskMedia") as TaskMedia).removeTask();
               }
               if(!(rootClass.page is MainCityUI))
               {
                  GameFacade.getInstance().sendNotification("switch_page","load_maincity_page");
               }
               else
               {
                  BeginnerGuide.playBeginnerGuide();
               }
               return;
            }
            if(rootClass.page is CityMapUI)
            {
               if(!Facade.getInstance().hasMediator("TaskMedia"))
               {
                  GameFacade.getInstance().sendNotification("open_main_advance_list");
               }
               else if(Facade.getInstance().hasMediator("TaskMedia") && !((Facade.getInstance().retrieveMediator("TaskMedia") as TaskMedia).UI as TaskUI).parent)
               {
                  GameFacade.getInstance().sendNotification("open_main_advance_list");
               }
            }
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         mySpr = swf.createSprite("spr_UpDate_ss");
         movic_light = mySpr.getMovie("lightMC");
         updateImage = mySpr.getImage("updateLogo");
         updateInfoSpr = mySpr.getSprite("updateInfo");
         lvBeforeTF = updateInfoSpr.getTextField("lvBeforeTF");
         powerBeforeTF = updateInfoSpr.getTextField("powerBeforeTF");
         powerBeforeTF.autoScale = true;
         maxPowerBeforeTF = updateInfoSpr.getTextField("maxPowerBeforeTF");
         maxPowerBeforeTF.autoScale = true;
         lvAfterTF = updateInfoSpr.getTextField("lvAfterTF");
         powerAfterTF = updateInfoSpr.getTextField("powerAfterTF");
         powerAfterTF.autoScale = true;
         maxPowerAfterTF = updateInfoSpr.getTextField("maxPowerAfterTF");
         maxPowerAfterTF.autoScale = true;
         openTF = updateInfoSpr.getTextField("openTF");
         openTF.width = 180;
         openTF.autoScale = true;
         addChild(mySpr);
      }
      
      public function show() : void
      {
         if(this.parent)
         {
            return;
         }
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         lvBeforeTF.text = FightingConfig.lvBefore;
         powerBeforeTF.text = FightingConfig.powerBefore;
         maxPowerBeforeTF.text = FightingConfig.maxPowerBefore;
         lvAfterTF.text = lvBeforeTF.text;
         powerAfterTF.text = powerBeforeTF.text;
         maxPowerAfterTF.text = maxPowerBeforeTF.text;
         showOpenT();
         rootClass.addChild(this);
         movic_light.visible = false;
         showAni();
         Pocketmon.sdkTool.subInfo("2");
         UmengExtension.getInstance().UMAnalysic("setPlayerLevel|" + PlayerVO.lv);
      }
      
      private function showOpenT() : void
      {
         if(FightingConfig.lvBefore < 5 && PlayerVO.lv >= 5)
         {
            openTF.text = "加速x1";
            return;
         }
         if(FightingConfig.lvBefore < 6 && PlayerVO.lv >= 6)
         {
            openTF.text = "自动战斗";
            return;
         }
         if(FightingConfig.lvBefore < 8 && PlayerVO.lv >= 8)
         {
            openTF.text = "训练";
            BeginnerGuide.addTrain();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 9 && PlayerVO.lv >= 9)
         {
            openTF.text = "精英副本";
            return;
         }
         if(FightingConfig.lvBefore < 10 && PlayerVO.lv >= 10)
         {
            openTF.text = "扫荡";
            return;
         }
         if(FightingConfig.lvBefore < 11 && PlayerVO.lv >= 11)
         {
            openTF.text = "每日任务";
            return;
         }
         if(FightingConfig.lvBefore < 15 && PlayerVO.lv >= 15)
         {
            openTF.text = "精灵联盟大赛，加速x2";
            BeginnerGuide.addElfSeries();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 19 && PlayerVO.lv >= 19)
         {
            openTF.text = "金币试炼";
            BeginnerGuide.addTrial();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 20 && PlayerVO.lv >= 20)
         {
            openTF.text = "初级狩猎场";
            BeginnerGuide.addHunting();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 22 && PlayerVO.lv >= 22)
         {
            openTF.text = "王者之路";
            BeginnerGuide.addKingKwan();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 24 && PlayerVO.lv >= 24)
         {
            openTF.text = "精灵试炼";
            return;
         }
         if(FightingConfig.lvBefore < 25 && PlayerVO.lv >= 25)
         {
            openTF.text = "中级狩猎场";
            return;
         }
         if(FightingConfig.lvBefore < 28 && PlayerVO.lv >= 28)
         {
            openTF.text = "公会";
            BeginnerGuide.addUnion();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 30 && PlayerVO.lv >= 30)
         {
            openTF.text = "高级狩猎场";
            return;
         }
         if(FightingConfig.lvBefore < 32 && PlayerVO.lv >= 32)
         {
            openTF.text = "重置精灵";
            return;
         }
         if(FightingConfig.lvBefore < 35 && PlayerVO.lv >= 35)
         {
            openTF.text = "PVP";
            BeginnerGuide.addPvp();
            isBeginGuide = true;
            return;
         }
         if(FightingConfig.lvBefore < 48 && PlayerVO.lv >= 48)
         {
            openTF.text = "奇迹交换";
            BeginnerGuide.addMiracle();
            isBeginGuide = true;
            return;
         }
         openTF.text = "无";
      }
      
      private function showAni() : void
      {
         var t:Tween = new Tween(updateImage,0.7,"easeInBack");
         Starling.juggler.add(t);
         t.animate("scaleX",1,3);
         t.animate("scaleY",1,3);
         t.onComplete = function():void
         {
            movic_light.visible = true;
            movic_light.gotoAndPlay(0);
            AniFactor.numTfAni(lvAfterTF,PlayerVO.lv,1.2);
            AniFactor.numTfAni(powerAfterTF,PlayerVO.actionForce,1.2);
            AniFactor.numTfAni(maxPowerAfterTF,PlayerVO.maxActionForce,1.2);
         };
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
