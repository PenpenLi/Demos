package com.mvc.views.uis.fighting
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.animation.Tween;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.core.Starling;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.textures.Texture;
   
   public class FightVS extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.fighting.FightVS;
       
      private var rootClass:Game;
      
      private var swf:Swf;
      
      private var mc_vs:SwfMovieClip;
      
      private var clubName:String;
      
      private var clubImage:Image;
      
      private var clubImageBig:Image;
      
      private var bg1:Quad;
      
      private var bg2:Quad;
      
      private var callBack:Function;
      
      private var bg:Quad;
      
      public function FightVS()
      {
         var _loc1_:* = null;
         super();
         rootClass = Config.starling.root as Game;
         if(FightingConfig.selectMap)
         {
            _loc1_ = LoadOtherAssetsManager.getInstance().assets.getTexture(FightingConfig.selectMap.sceneName);
         }
         else
         {
            _loc1_ = LoadOtherAssetsManager.getInstance().assets.getTexture(FightingConfig.sceneName);
         }
         LogUtil("texture=======",_loc1_);
         bg = new Image(_loc1_);
         this.addChild(bg);
      }
      
      public static function getInstance() : com.mvc.views.uis.fighting.FightVS
      {
         return instance || new com.mvc.views.uis.fighting.FightVS();
      }
      
      public function show(param1:String, param2:Function) : void
      {
         rootClass.addChild(this);
         clubName = param1;
         EventCenter.addEventListener("load_swf_asset_complete",loadFightVS);
         LoadSwfAssetsManager.getInstance().addAssets(Config.fightVSAssets);
         callBack = param2;
      }
      
      private function loadFightVS() : void
      {
         LogUtil("播放动画");
         EventCenter.removeEventListener("load_swf_asset_complete",loadFightVS);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("fightVS");
         mc_vs = swf.createMovieClip("mc_vs");
         mc_vs.name = "mc_vs";
         addChild(mc_vs);
         mc_vs.play();
         mc_vs.completeFunction = onComplete;
         clubImageBig = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(clubName));
         var _loc1_:* = 2;
         clubImageBig.scaleY = _loc1_;
         clubImageBig.scaleX = _loc1_;
         clubImageBig.alpha = 0;
         clubImageBig.y = 20;
         clubImageBig.x = -300;
         clubImageBig.smoothing = "bilinear";
         addChild(clubImageBig);
         clubImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(clubName));
         _loc1_ = 1.5;
         clubImage.scaleY = _loc1_;
         clubImage.scaleX = _loc1_;
         clubImage.y = 80;
         clubImage.x = -300;
         clubImage.alpha = 0;
         addChild(clubImage);
         upDownOpen();
         var t:Tween = new Tween(clubImage,0.5);
         Starling.juggler.add(t);
         t.delay = 1;
         t.animate("x",750);
         t.animate("alpha",1,0);
         t.onComplete = function():void
         {
            var t2:Tween = new Tween(clubImageBig,0.5);
            Starling.juggler.add(t2);
            t2.animate("x",450);
            t2.animate("alpha",0.4,0);
            t2.onComplete = function():void
            {
               Starling.juggler.removeTweens(clubImageBig);
               var t3:Tween = new Tween(clubImageBig,2.5);
               Starling.juggler.add(t3);
               t3.animate("x",500,450);
               t3.onComplete = function():void
               {
                  upDownClose();
                  AniFactor.fadeOutOrIn(clubImage,0,1,0.5);
                  AniFactor.fadeOutOrIn(clubImageBig,0,0.4,0.5);
               };
            };
         };
      }
      
      private function onComplete(param1:SwfMovieClip) : void
      {
         LogUtil("播放完毕");
         disposeSelf(true);
      }
      
      public function disposeSelf(param1:Boolean) : void
      {
         if(mc_vs != null)
         {
            mc_vs.gotoAndStop(0);
            mc_vs.stop(true);
            mc_vs.completeFunction = null;
            Starling.juggler.removeTweens(clubImageBig);
            Starling.juggler.removeTweens(clubImage);
            clubImage.removeFromParent(true);
            clubImageBig.removeFromParent(true);
         }
         Starling.juggler.removeTweens(bg1);
         Starling.juggler.removeTweens(bg2);
         bg1.removeFromParent(true);
         bg1 = null;
         bg2.removeFromParent(true);
         bg2 = null;
         this.removeFromParent(true);
         LoadSwfAssetsManager.getInstance().removeAsset(Config.fightVSAssets);
         bg.removeFromParent(true);
         if(param1)
         {
            callBack();
         }
         else
         {
            callBack = null;
         }
         instance = null;
      }
      
      private function upDownOpen() : void
      {
         bg1 = new Quad(1136,40,0);
         addChild(bg1);
         bg2 = new Quad(1136,80,0);
         addChild(bg2);
         var t:Tween = new Tween(bg1,0.5,"easeOut");
         Starling.juggler.add(t);
         t.animate("y",0,-40);
         var t2:Tween = new Tween(bg2,0.5,"easeOut");
         Starling.juggler.add(t2);
         t2.animate("y",640 - 80,640);
         t.onComplete = function():void
         {
            bg.visible = false;
         };
      }
      
      private function upDownClose() : void
      {
         bg.visible = true;
         var _loc1_:Tween = new Tween(bg1,0.5,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("y",-40,0);
         var _loc2_:Tween = new Tween(bg2,0.5,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("y",640,640 - 80);
      }
   }
}
