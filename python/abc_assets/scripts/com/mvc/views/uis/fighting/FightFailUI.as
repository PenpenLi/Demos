package com.mvc.views.uis.fighting
{
   import starling.display.Sprite;
   import starling.display.DisplayObject;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import extend.SoundEvent;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import com.mvc.views.mediator.mainCity.trial.TrialBossInfoMediator;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import flash.utils.clearTimeout;
   import starling.display.Quad;
   
   public class FightFailUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.fighting.FightFailUI;
       
      private var rootClass:DisplayObject;
      
      private var swf:Swf;
      
      private var spr_fail:SwfSprite;
      
      private var btn_close:SwfButton;
      
      private var mc_fail:SwfMovieClip;
      
      private var btn_t1:SwfButton;
      
      private var btn_t2:SwfButton;
      
      private var btn_t3:SwfButton;
      
      private var btn_t4:SwfButton;
      
      private var delay:uint;
      
      public function FightFailUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.8;
         addChild(_loc1_);
         rootClass = (Config.starling.root as Game).page;
         EventCenter.addEventListener("load_swf_asset_complete",init);
         LoadSwfAssetsManager.getInstance().addAssets(["fightFail"],false,50);
      }
      
      public static function getInstance() : com.mvc.views.uis.fighting.FightFailUI
      {
         return instance || new com.mvc.views.uis.fighting.FightFailUI();
      }
      
      private function init() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",init);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("fightFail");
         spr_fail = swf.createSprite("spr_fail");
         btn_close = spr_fail.getButton("btn_close");
         mc_fail = spr_fail.getMovie("mc_fail");
         btn_t1 = spr_fail.getButton("btn_t1");
         btn_t1.alpha = 0;
         btn_t2 = spr_fail.getButton("btn_t2");
         btn_t2.alpha = 0;
         btn_t3 = spr_fail.getButton("btn_t3");
         btn_t3.alpha = 0;
         btn_t4 = spr_fail.getButton("btn_t4");
         btn_t4.alpha = 0;
         mc_fail.stop();
         mc_fail.loop = false;
         addChild(spr_fail);
         if(Config.isOpenBeginner)
         {
            btn_t1.enabled = false;
            btn_t2.enabled = false;
            btn_t3.enabled = false;
            btn_t4.enabled = false;
         }
         this.addEventListener("triggered",onclick);
         mc_fail.play();
         mc_fail.completeFunction = function():void
         {
            mc_fail.completeFunction = null;
            var _loc2_:Tween = new Tween(btn_t1,1,"easeOut");
            Starling.juggler.add(_loc2_);
            _loc2_.animate("alpha",1);
            var _loc3_:Tween = new Tween(btn_t2,1,"easeOut");
            Starling.juggler.add(_loc3_);
            _loc3_.animate("alpha",1);
            var _loc4_:Tween = new Tween(btn_t3,1,"easeOut");
            Starling.juggler.add(_loc4_);
            _loc4_.animate("alpha",1);
            var _loc1_:Tween = new Tween(btn_t4,1,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",1);
            SoundEvent.dispatchEvent("play_music_and_stop_bg",{
               "musicName":"fightFail",
               "isContinuePlayBGM":false
            });
         };
         delay = setTimeout(remove2,10000);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_close !== _loc2_)
         {
            if(btn_t1 !== _loc2_)
            {
               if(btn_t2 !== _loc2_)
               {
                  if(btn_t3 !== _loc2_)
                  {
                     if(btn_t4 === _loc2_)
                     {
                        remove();
                        Facade.getInstance().sendNotification("switch_page","RETURN_LAST","个体值");
                     }
                  }
                  else
                  {
                     remove();
                     Facade.getInstance().sendNotification("switch_page","RETURN_LAST","突破");
                  }
               }
               else
               {
                  remove();
                  Facade.getInstance().sendNotification("switch_page","RETURN_LAST");
               }
            }
            else
            {
               CityMapMeida.recordMainAdvance = null;
               CityMapMeida.recordExtenAdvance = null;
               remove();
               fightOver();
               Facade.getInstance().sendNotification("switch_page","LOAD_AMUSE_PAGE");
            }
         }
         else
         {
            remove2();
         }
      }
      
      private function fightOver() : void
      {
         if(LoadPageCmd.lastPage is KingKwanUI)
         {
            Config.isAutoFighting = LoadPageCmd.tempAutoFight;
            (Facade.getInstance().retrieveProxy("KingKwanPro") as KingKwanPro).write2303(LoadPageCmd.fightResult(),false);
         }
         else if(LoadPageCmd.lastPage is ElfSeriesUI)
         {
            (Facade.getInstance().retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5002(NPCVO.useId,LoadPageCmd.fightResult(),false);
         }
         else if(LoadPageCmd.lastPage is TrialUI)
         {
            (Facade.getInstance().retrieveProxy("TrialPro") as TrialPro).write2202(LoadPageCmd.fightResult(),TrialBossInfoMediator.difficultyId,TrialBossInfoMediator.bossId,false);
         }
         else if(LoadPageCmd.lastPage is MiningFrameUI)
         {
            (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3912(0,false);
         }
      }
      
      public function remove() : void
      {
         clearTimeout(delay);
         if(getInstance().parent)
         {
            NPCVO.dialougAfterFighting = [];
            this.removeFromParent(true);
            LoadSwfAssetsManager.getInstance().removeAsset(["fightFail"]);
         }
         instance = null;
      }
      
      public function remove2() : void
      {
         remove();
         Facade.getInstance().sendNotification("switch_page","RETURN_LAST");
      }
      
      public function show() : void
      {
         (rootClass as Sprite).addChild(this);
      }
   }
}
