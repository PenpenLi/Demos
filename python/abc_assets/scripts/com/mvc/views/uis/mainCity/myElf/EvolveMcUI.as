package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfMovieClip;
   import feathers.controls.Label;
   import starling.display.Quad;
   import lzm.starling.swf.Swf;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import extend.SoundEvent;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import starling.filters.ColorMatrixFilter;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   
   public class EvolveMcUI extends Sprite
   {
       
      private var lastElfVO:ElfVO;
      
      private var beforeElfVo:ElfVO;
      
      public var beforeImg:Image;
      
      public var lastImg:Image;
      
      private var beforeImgHeight:Number;
      
      private var lastImgHeight:Number;
      
      private var evolveBgMc:SwfMovieClip;
      
      private var lightCirMc:SwfMovieClip;
      
      private var label:Label;
      
      private var _touch:Boolean;
      
      private var bg:Quad;
      
      private var bg1:Quad;
      
      private var bg2:Quad;
      
      private var swf:Swf;
      
      public function EvolveMcUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfEvolveMc");
         evolveBgMc = swf.createMovieClip("mc_evolveBgMc");
         lightCirMc = swf.createMovieClip("mc_bomb");
         lightCirMc.loop = false;
         lightCirMc.stop();
         lightCirMc.scaleX = 3;
         lightCirMc.scaleY = 3;
         evolveBgMc.gotoAndPlay("slow");
         bg1 = new Quad(1136,80,0);
         addChild(bg1);
         bg2 = new Quad(1136,90,0);
         addChild(bg2);
         var _loc1_:Tween = new Tween(bg1,0.5,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("y",0,-80);
         var _loc2_:Tween = new Tween(bg2,0.5,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("y",640 - 90,640);
         label = new Label();
         var _loc3_:TextFormat = new TextFormat("FZCuYuan-M03S",22,4728603);
         _loc3_.align = "center";
         label.textRendererProperties.isHTML = true;
         label.textRendererProperties.textFormat = _loc3_;
         label.width = 1000;
         label.x = 1136 - label.width >> 1;
         label.y = 640 - 75;
         this.addEventListener("touch",touchHanler);
         _touch = false;
      }
      
      public function showEvolveMc() : void
      {
         LogUtil("展示精灵进化动画");
         bg = new Quad(1136,640,0);
         addChild(bg);
         var tweenBg1:Tween = new Tween(bg,0.7,"easeIn");
         Starling.juggler.add(tweenBg1);
         tweenBg1.animate("alpha",1,0);
         tweenBg1.onComplete = function():void
         {
            var _loc2_:* = 0;
            var _loc1_:Game = Config.starling.root as Game;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren - 1)
            {
               _loc1_.getChildAt(_loc2_).visible = false;
               _loc2_++;
            }
            addChildAt(evolveBgMc,numChildren - 3);
         };
         var tweenBg2:Tween = new Tween(bg,0.5,"easeIn");
         tweenBg2.animate("alpha",0,1);
         tweenBg1.nextTween = tweenBg2;
         tweenBg2.onComplete = function():void
         {
            bg.removeFromParent();
            showBeforeImg();
         };
      }
      
      public function createEvolveImg(param1:ElfVO) : void
      {
         beforeElfVo = param1;
         lastElfVO = GetElfFactor.getElfVO(param1.evolveId,false);
         ElfFrontImageManager.getInstance().getImg([param1.imgName,lastElfVO.imgName],showElfImage);
      }
      
      private function showElfImage() : void
      {
         beforeImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(beforeElfVo.imgName));
         setPivot(beforeImg);
         beforeImgHeight = beforeImg.height;
         lastImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(lastElfVO.imgName));
         setPivot(lastImg);
         lastImgHeight = lastImg.height;
         showEvolveMc();
      }
      
      public function showBeforeImg() : void
      {
         LogUtil("展示进化前的精灵");
         addChild(beforeImg);
         beforeImg.alpha = 0;
         label.text = "<font size=\'25\' color=\'#ffffff\'><strong>什么？" + beforeElfVo.nickName + "要进化了！</strong></font>\n" + "<font size=\'22\' color=\'#ffffff\'><strong>what?It is evolving!</strong></font>";
         var t:Tween = new Tween(beforeImg,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("alpha",1,0);
         t.delay = 0.3;
         t.onStart = function():void
         {
            addChild(label);
         };
         t.onComplete = function():void
         {
            Starling.juggler.delayCall(changeAniOfBefore,1.5,beforeImg);
         };
      }
      
      private function changeAniOfBefore(param1:Image) : void
      {
         target = param1;
         addChild(lightCirMc);
         lightCirMc.gotoAndPlay("recover");
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","recoverP");
         lightCirMc.completeFunction = onComplete;
         lightCirMc.x = beforeImg.x;
         lightCirMc.y = beforeImg.y;
         addChildAt(bg,numChildren - 3);
         bg.alpha = 0;
         var tweenBg1:Tween = new Tween(bg,0.3,"easeIn");
         Starling.juggler.add(tweenBg1);
         tweenBg1.animate("alpha",1,0);
         tweenBg1.onComplete = function():void
         {
            evolveBgMc.removeFromParent();
         };
      }
      
      private function onComplete(param1:SwfMovieClip) : void
      {
         setColorFiler(beforeImg);
         param1.completeFunction = null;
         param1.removeFromParent();
         label.text = "";
         changeAni2();
      }
      
      private function changeAni2() : void
      {
         var t:Tween = new Tween(beforeImg,0.3,"easeOut");
         Starling.juggler.add(t);
         t.onComplete = function():void
         {
            ElfFrontImageManager.getInstance().disposeImg(beforeImg);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","bomb");
            addParticle(100);
            Starling.juggler.delayCall(function():void
            {
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","recoverP2");
            },1.2);
            Starling.juggler.delayCall(showLastElfImg,2.2);
         };
      }
      
      private function onComplete2(param1:SwfMovieClip) : void
      {
         label.text = "<font size=\'25\' color=\'#ffffff\'><strong>" + beforeElfVo.name + "进化成了" + lastElfVO.name + "</strong></font>\n" + "<font size=\'22\' color=\'#ffffff\'><strong>It evolutionary success!</strong></font>";
         param1.completeFunction = null;
         param1.stop(true);
         param1.removeFromParent(true);
         _touch = true;
      }
      
      private function showLastElfImg() : void
      {
         addChild(lastImg);
         setColorFiler(lastImg);
         lastImg.scaleX = 0;
         lastImg.scaleY = 0;
         var _loc1_:Tween = new Tween(lastImg,0.3,"easeIn");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1,0);
         _loc1_.animate("scaleY",1,0);
         _loc1_.onComplete = changeAniOfLast;
      }
      
      private function changeAniOfLast() : void
      {
         var whiteBg:Quad = new Quad(1136,640,16777215);
         addChild(whiteBg);
         whiteBg.alpha = 0;
         var t:Tween = new Tween(whiteBg,0.2,"easeIn");
         Starling.juggler.add(t);
         t.delay = 0.3;
         t.animate("alpha",1,0);
         var t2:Tween = new Tween(whiteBg,0.3,"easeOut");
         t2.animate("alpha",0,1);
         t2.delay = 0.1;
         t.nextTween = t2;
         t.onComplete = function():void
         {
            lastImg.filter.dispose();
            lastImg.filter = null;
            var _loc1_:Tween = new Tween(bg1,0.5,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("y",0,-80);
            var _loc2_:Tween = new Tween(bg2,0.5,"easeOut");
            Starling.juggler.add(_loc2_);
            _loc2_.animate("y",640 - 90,640);
            addChildAt(evolveBgMc,0);
            lightCirMc.x = beforeImg.x;
            lightCirMc.y = beforeImg.y;
            addChild(lightCirMc);
            lightCirMc.gotoAndPlay("bomb");
            lightCirMc.scaleX = 7;
            lightCirMc.scaleY = 2.5;
            lightCirMc.completeFunction = onComplete2;
            bg.removeFromParent();
            SoundEvent.addEventListener("PLAY_ONCE_COMPLETE",playElfVoice);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","evoSuccess");
         };
      }
      
      private function playElfVoice() : void
      {
         SoundEvent.removeEventListener("PLAY_ONCE_COMPLETE",playElfVoice);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + lastElfVO.sound);
      }
      
      private function touchHanler(param1:TouchEvent) : void
      {
         if(!_touch)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            lastImg.removeFromParent(true);
            EventCenter.dispatchEvent("elf_evolve_mc_complete");
            BeginnerGuide.playBeginnerGuide();
         }
      }
      
      public function addParticle(param1:int) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc2_:* = NaN;
         _loc4_ = 0;
         while(_loc4_ < param1)
         {
            _loc3_ = swf.createImage("img_p");
            _loc3_.scaleX = 1.5;
            _loc3_.scaleY = 1.5;
            _loc3_.x = beforeImg.x;
            _loc3_.y = beforeImg.y;
            addChild(_loc3_);
            _loc5_ = new Tween(_loc3_,1,"easeOut");
            Starling.juggler.add(_loc5_);
            _loc2_ = Math.random() - 0.5;
            _loc5_.animate("y",_loc3_.y + _loc2_ * 800);
            _loc2_ = Math.random() - 0.5;
            _loc5_.animate("x",_loc3_.x + _loc2_ * 1500);
            _loc5_.scaleTo(0);
            _loc5_.onComplete = recoverQuad;
            _loc5_.onCompleteArgs = [_loc3_];
            _loc4_++;
         }
      }
      
      private function recoverQuad(param1:Quad) : void
      {
         var _loc3_:Tween = new Tween(param1,1,"easeIn");
         Starling.juggler.add(_loc3_);
         _loc3_.delay = Math.random() * 0.6;
         var _loc2_:Number = Math.random() - 0.5;
         param1.y = lastImg.y + _loc2_ * 800;
         _loc2_ = Math.random() - 0.5;
         param1.x = lastImg.x + _loc2_ * 1500;
         _loc3_.animate("x",lastImg.x);
         _loc3_.animate("y",lastImg.y);
         _loc3_.scaleTo(1);
         _loc3_.onComplete = disposeQuad;
         _loc3_.onCompleteArgs = [param1];
      }
      
      private function disposeQuad(param1:Quad) : void
      {
         param1.removeFromParent(true);
      }
      
      private function setColorFiler(param1:Image) : void
      {
         var _loc3_:Vector.<Number> = new Vector.<Number>([]);
         _loc3_.push(0,0,0,0,255,0,0,0,0,255,0,0,0,0,255,0,0,0,1,0);
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter(_loc3_);
         param1.filter = _loc2_;
         _loc2_.dispose();
         _loc2_ = null;
         _loc3_.length = 0;
         _loc3_ = null;
      }
      
      private function setPivot(param1:DisplayObject) : void
      {
         param1.pivotX = param1.width >> 1;
         param1.pivotY = param1.height >> 1;
         param1.x = 568;
         param1.y = 320;
      }
   }
}
