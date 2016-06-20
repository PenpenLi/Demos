package com.common.util.beginnerGuide
{
   import starling.text.TextField;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   import com.common.events.EventCenter;
   import starling.animation.Tween;
   import starling.core.Starling;
   import extend.SoundEvent;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class BeginnerGuideDia
   {
      
      private static var TF:TextField;
      
      private static var container:Sprite;
      
      private static var root:Sprite;
      
      private static var _object:Object;
      
      private static var _collectDialogueVec:Vector.<String> = new Vector.<String>([]);
      
      private static var isPlayingDia:Boolean;
      
      private static var callBackVec:Vector.<Function> = new Vector.<Function>([]);
      
      private static var touchable:Boolean;
      
      private static var nextMark:SwfMovieClip;
      
      private static var guideGirl:SwfSprite;
      
      private static var swfCommon:Swf;
       
      public function BeginnerGuideDia()
      {
         super();
      }
      
      public static function init() : void
      {
         root = Config.starling.root as Game;
         swfCommon = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         container = new Sprite();
         var _loc5_:Quad = new Quad(1136,640,0);
         _loc5_.alpha = 0.75;
         container.addChild(_loc5_);
         var _loc6_:SwfSprite = swfCommon.createSprite("spr_GuideDia");
         container.addChild(_loc6_);
         TF = _loc6_.getTextField("dialogue");
         container.addEventListener("touch",touchHandler);
         guideGirl = swfCommon.createSprite("spr_guideGirl");
         guideGirl.y = 196;
         guideGirl.x = 10;
         var _loc4_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         var _loc2_:SwfMovieClip = _loc4_.createMovieClip("mc_yayiMouth");
         _loc2_.gotoAndPlay(0);
         _loc2_.x = 142;
         _loc2_.y = 157;
         _loc2_.name = "mouth";
         guideGirl.addChild(_loc2_);
         var _loc1_:SwfMovieClip = _loc4_.createMovieClip("mc_yayiEye");
         _loc1_.gotoAndPlay(0);
         _loc1_.x = 92;
         _loc1_.y = 90;
         _loc1_.name = "eye";
         guideGirl.addChild(_loc1_);
         container.addChild(guideGirl);
         var _loc3_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         nextMark = _loc3_.createMovieClip("mc_nextTips_ss");
         nextMark.stop();
         var _loc7_:* = 0.5;
         nextMark.scaleY = _loc7_;
         nextMark.scaleX = _loc7_;
         nextMark.x = 1050;
         nextMark.y = 580;
         _loc3_ = null;
         EventCenter.addEventListener("DIALOGUE_TALL_OVER",diaComplete);
      }
      
      private static function diaComplete() : void
      {
         (guideGirl.getChildByName("mouth") as SwfMovieClip).gotoAndStop(0);
      }
      
      public static function updateDialogue(param1:String, param2:Boolean = true, param3:Boolean = false) : void
      {
         str = param1;
         setTouch = param2;
         isStopVoiceByHandler = param3;
         if(root == null)
         {
            init();
         }
         if(!container.parent)
         {
            root.addChild(container);
         }
         LogUtil("是否可点击:" + touchable);
         LogUtil("对话内容:" + str);
         touchable = setTouch;
         Starling.juggler.removeTweens(TF);
         var t:Tween = new Tween(TF,0.5);
         Starling.juggler.add(t);
         t.onUpdate = playTextAni;
         t.onUpdateArgs = [str,t];
         if(isStopVoiceByHandler)
         {
            t.onComplete = function():void
            {
               (guideGirl.getChildByName("mouth") as SwfMovieClip).gotoAndStop(0);
            };
         }
         (guideGirl.getChildByName("mouth") as SwfMovieClip).gotoAndPlay(0);
         if(touchable)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","dialogue");
            container.addChild(nextMark);
            nextMark.gotoAndPlay(0);
         }
         else
         {
            removeNextMark();
         }
         root.touchable = false;
         Starling.juggler.delayCall(function():void
         {
            root.touchable = true;
         },0.1);
      }
      
      private static function playTextAni(param1:String, param2:Tween) : void
      {
         var _loc3_:int = param1.length * param2.progress;
         if(TF)
         {
            TF.text = param1.substr(0,_loc3_);
         }
      }
      
      private static function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!touchable)
         {
            return;
         }
         _loc2_ = param1.getTouch(container);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            touchable = false;
            removeFormParent();
            BeginnerGuide.playBeginnerGuide();
         }
      }
      
      public static function removeFormParent() : void
      {
         LogUtil("移除对话" + touchable);
         if(container.parent && !touchable)
         {
            container.removeFromParent();
            removeNextMark();
         }
         _collectDialogueVec = Vector.<String>([]);
      }
      
      private static function removeNextMark() : void
      {
         if(nextMark.isPlay)
         {
            nextMark.removeFromParent();
            nextMark.stop();
         }
      }
      
      public static function dispose() : void
      {
         if(root == null)
         {
            return;
         }
         Starling.juggler.removeTweens(TF);
         nextMark.stop();
         nextMark.removeFromParent(true);
         container.removeFromParent(true);
         root = null;
         EventCenter.removeEventListener("DIALOGUE_TALL_OVER",diaComplete);
      }
   }
}
