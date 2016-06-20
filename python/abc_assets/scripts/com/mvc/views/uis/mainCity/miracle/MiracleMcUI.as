package com.mvc.views.uis.mainCity.miracle
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.core.Starling;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   
   public class MiracleMcUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.miracle.MiracleMcUI;
      
      public static var callBack:Function;
       
      private var swf:Swf;
      
      private var mc_fire:SwfMovieClip;
      
      private var mc_bomb:SwfMovieClip;
      
      private var bgQuad:Quad;
      
      private var targetElfImg:Image;
      
      private var targetElfVO:ElfVO;
      
      public function MiracleMcUI()
      {
         super();
         EventCenter.addEventListener("load_swf_asset_complete",loadMiracleMc_completeHandler);
         LoadSwfAssetsManager.getInstance().addAssets(Config.miracleMcAssets);
      }
      
      public static function getInstances(param1:Function = null) : com.mvc.views.uis.mainCity.miracle.MiracleMcUI
      {
         if(!callBack)
         {
            callBack = param1;
         }
         return instance || new com.mvc.views.uis.mainCity.miracle.MiracleMcUI();
      }
      
      private function loadMiracleMc_completeHandler(param1:Event) : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",loadMiracleMc_completeHandler);
         init();
      }
      
      private function init() : void
      {
         bgQuad = new Quad(1136,640,0);
         bgQuad.alpha = 0;
         addChild(bgQuad);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("miracleMc");
         mc_fire = swf.createMovieClip("mc_fire");
         var _loc1_:* = 2;
         mc_fire.scaleY = _loc1_;
         mc_fire.scaleX = _loc1_;
         mc_fire.x = -320;
         mc_fire.y = -240;
         mc_bomb = swf.createMovieClip("mc_bomb");
         _loc1_ = 2;
         mc_bomb.scaleY = _loc1_;
         mc_bomb.scaleX = _loc1_;
         mc_bomb.x = -800;
         mc_bomb.y = -315;
         if(callBack)
         {
            callBack();
         }
      }
      
      public function showMiracleMc(param1:ElfVO) : void
      {
         elfVo = param1;
         LogUtil("奇迹交换动画准备播放");
         addChild(mc_fire);
         mc_fire.gotoAndPlay(0);
         playMc(mc_fire);
         mc_fire.completeFunction = function():void
         {
            Facade.getInstance().sendNotification("miracle_firemc_complete");
            mc_fire.removeFromParent();
            addChild(mc_bomb);
            mc_bomb.gotoAndPlay(0);
            playMc(mc_bomb);
            showElfImg(elfVo);
         };
         (Starling.current.root as Game).addChild(this);
      }
      
      private function playMc(param1:SwfMovieClip) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is SwfMovieClip)
            {
               playMc(param1.getChildAt(_loc2_) as SwfMovieClip);
               (param1.getChildAt(_loc2_) as SwfMovieClip).gotoAndPlay(0);
            }
            _loc2_++;
         }
      }
      
      private function showElfImg(param1:ElfVO) : void
      {
         targetElfVO = param1;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showTargetElf);
      }
      
      private function showTargetElf() : void
      {
         targetElfImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(targetElfVO.imgName));
         targetElfImg.alignPivot("center","bottom");
         var _loc2_:* = 0;
         targetElfImg.scaleY = _loc2_;
         targetElfImg.scaleX = _loc2_;
         targetElfImg.alpha = 0;
         targetElfImg.x = 780;
         targetElfImg.y = 345;
         this.addChild(targetElfImg);
         var _loc1_:Tween = new Tween(targetElfImg,0.5,"easeOut");
         Starling.current.juggler.add(_loc1_);
         _loc1_.scaleTo(0.8);
         _loc1_.fadeTo(1);
         _loc1_.delay = 0.5;
         _loc1_.onComplete = completeHandler;
      }
      
      private function completeHandler() : void
      {
         targetElfImg.removeFromParent(true);
         mc_bomb.removeFromParent();
         this.removeFromParent();
         Facade.getInstance().sendNotification("miracle_miraclemc_complete");
      }
      
      public function disposeMiracleMc() : void
      {
         this.removeFromParent(true);
         callBack = null;
         instance = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.miracleMcAssets);
      }
   }
}
