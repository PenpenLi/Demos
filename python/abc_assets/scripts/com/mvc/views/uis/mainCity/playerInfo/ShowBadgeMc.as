package com.mvc.views.uis.mainCity.playerInfo
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class ShowBadgeMc extends Sprite
   {
      
      public static var badgeFlag:int = 0;
      
      private static var _instance:com.mvc.views.uis.mainCity.playerInfo.ShowBadgeMc;
       
      private var rootClass:Game;
      
      private var fireworksMc:SwfMovieClip;
      
      private var badgeImg:Image;
      
      private var bgQuad:Quad;
      
      public function ShowBadgeMc()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,16777215);
         addChild(_loc1_);
         bgQuad = new Quad(1136,640,0);
         addChild(bgQuad);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.playerInfo.ShowBadgeMc
      {
         return _instance || new com.mvc.views.uis.mainCity.playerInfo.ShowBadgeMc();
      }
      
      public function loadMC() : void
      {
         EventCenter.addEventListener("load_swf_asset_complete",load_badgeMc_completeHandler);
         LoadSwfAssetsManager.getInstance().addAssets(Config.badgeMcAssets);
      }
      
      private function load_badgeMc_completeHandler() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",load_badgeMc_completeHandler);
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("badgeMc");
         fireworksMc = _loc1_.createMovieClip("mc_badge");
         fireworksMc.x = 1136 >> 1;
         fireworksMc.y = 640 >> 1;
         addChild(fireworksMc);
         fireworksMc.gotoAndPlay(0);
         fireworksMc.completeFunction = onComplete;
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         badgeImg = _loc2_.createImage("img_badge" + badgeFlag);
         badgeImg.pivotX = badgeImg.width >> 1;
         badgeImg.pivotY = badgeImg.height >> 1;
         badgeImg.x = 1136 >> 1;
         badgeImg.y = 640 >> 1;
         showBadgeMc();
      }
      
      private function onComplete(param1:SwfMovieClip) : void
      {
         removeSource();
         Facade.getInstance().sendNotification("PLAY_NPC_DIALOGUE_AF_F");
      }
      
      private function showBadgeMc() : void
      {
         rootClass = Config.starling.root as Game;
         rootClass.addChild(this);
         showBadgeImg();
         showBg();
      }
      
      private function showBg() : void
      {
         var t1:Tween = new Tween(bgQuad,0.5);
         Starling.juggler.add(t1);
         t1.animate("alpha",0,1);
         t1.delay = 0.3;
         t1.onComplete = function():void
         {
            var _loc1_:Tween = new Tween(bgQuad,0.5);
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",1,0);
            _loc1_.delay = 0.3;
         };
      }
      
      private function showBadgeImg() : void
      {
         var t1:Tween = new Tween(badgeImg,0.25);
         Starling.juggler.add(t1);
         t1.animate("scaleX",1.5,1);
         t1.animate("scaleY",1.5,1);
         t1.animate("alpha",1,0);
         t1.delay = 0.3;
         t1.onStart = function():void
         {
            addChild(badgeImg);
         };
         t1.onComplete = function():void
         {
            var t2:Tween = new Tween(badgeImg,0.25);
            Starling.juggler.add(t2);
            t2.animate("scaleX",2,1.5);
            t2.animate("scaleY",2,1.5);
            t2.animate("alpha",0,1);
            t2.onComplete = function():void
            {
               var _loc1_:Tween = new Tween(badgeImg,0.25);
               Starling.juggler.add(_loc1_);
               _loc1_.delay = 0.3;
               _loc1_.animate("scaleX",1,5);
               _loc1_.animate("scaleY",1,5);
               _loc1_.animate("alpha",1,0);
            };
         };
      }
      
      private function removeSource() : void
      {
         badgeFlag = 0;
         badgeImg.removeFromParent(true);
         bgQuad.removeFromParent(true);
         this.removeFromParent(true);
         _instance = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.badgeMcAssets);
      }
   }
}
