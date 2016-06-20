package com.common.util.dialogue
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfSprite;
   import starling.animation.Tween;
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetStartChatFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.mvc.views.mediator.login.StartChatMedia;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.core.Starling;
   import extend.SoundEvent;
   
   public class StartDialogue extends Sprite
   {
      
      private static var TF:TextField;
      
      private static var NPCNameTF:TextField;
      
      private static var root:Sprite;
      
      public static var nextMark:SwfMovieClip;
      
      private static var leftNPC:SwfSprite;
      
      private static var instance:com.common.util.dialogue.StartDialogue;
       
      private var starChatSwf:Swf;
      
      public var rightNPC:SwfSprite;
      
      private var bg:Quad;
      
      private var spr:SwfSprite;
      
      private var mouth:SwfMovieClip;
      
      public var boshi:SwfMovieClip;
      
      private var mouth_x:SwfMovieClip;
      
      private var startDiaVec:Vector.<com.common.util.dialogue.StarVO>;
      
      public function StartDialogue()
      {
         super();
      }
      
      private static function playTextAni(param1:String, param2:Tween) : void
      {
         var _loc3_:int = param1.length * param2.progress;
         TF.text = param1.substr(0,_loc3_);
      }
      
      private static function removeNpcImage(param1:Image) : void
      {
         if(param1)
         {
            LogUtil("释放了");
            param1.texture.dispose();
            param1.removeFromParent(true);
            param1.dispose();
            var param1:Image = null;
         }
      }
      
      public static function getInstance() : com.common.util.dialogue.StartDialogue
      {
         return instance || new com.common.util.dialogue.StartDialogue();
      }
      
      private static function removeNextMark() : void
      {
         if(nextMark.isPlay)
         {
            nextMark.removeFromParent();
            nextMark.stop();
         }
      }
      
      public function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.75;
         this.addChild(bg);
         this.setChildIndex(bg,0);
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         starChatSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("startChat");
         spr = _loc2_.createSprite("spr_NPCDialogue_s");
         this.addChild(spr);
         TF = spr.getTextField("npcDialogue");
         NPCNameTF = spr.getTextField("npcName");
         spr.y = 420;
         TF.hAlign = "left";
         TF.autoSize = "vertical";
         TF.fontName = "1";
         this.addEventListener("touch",touchHandler);
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         mouth_x = _loc1_.createMovieClip("mc_xzuiba");
         mouth_x.x = -20;
         mouth_x.y = -191;
         nextMark = _loc1_.createMovieClip("mc_nextTips_ss");
         var _loc3_:* = 0.5;
         nextMark.scaleY = _loc3_;
         nextMark.scaleX = _loc3_;
         nextMark.stop();
         nextMark.x = 1019;
         nextMark.y = 580;
         _loc1_ = null;
         _loc2_ = null;
         startDiaVec = GetStartChatFactor.startDiaVec;
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.getTouch(this);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            LogUtil("startDiaVec.length=" + startDiaVec.length);
            if(startDiaVec.length == 0)
            {
               EventCenter.dispatchEvent("npc_dialogue_end");
            }
            else
            {
               playDialogue();
            }
         }
      }
      
      public function playDialogue() : void
      {
         if(startDiaVec.length == 0)
         {
            return;
         }
         NPCNameTF.text = startDiaVec[0].npcName;
         if(startDiaVec[0].npcName == "小茂")
         {
            if(leftNPC == null)
            {
               leftNPC = starChatSwf.createSprite("spr_xiaomao");
               leftNPC.x = 200;
               leftNPC.y = 320;
               leftNPC.scaleX = -1;
               leftNPC.addChild(mouth_x);
               mouth_x.play();
               this.addChild(leftNPC);
               this.setChildIndex(leftNPC,1);
            }
            else
            {
               leftNPC.visible = true;
               mouth_x.gotoAndPlay(0);
            }
            if(rightNPC)
            {
               rightNPC.visible = false;
            }
         }
         else
         {
            if(rightNPC == null)
            {
               rightNPC = starChatSwf.createSprite("spr_right");
               boshi = rightNPC.getMovie("mc_right");
               mouth = rightNPC.getMovie("mc_mouth");
               rightNPC.x = 905;
               rightNPC.y = 320;
               boshi.gotoAndPlay("renqiu");
               mouth.play();
               this.addChild(rightNPC);
               this.setChildIndex(rightNPC,1);
            }
            else
            {
               rightNPC.visible = true;
               mouth.gotoAndPlay(0);
            }
            if(leftNPC)
            {
               leftNPC.visible = false;
            }
         }
         LogUtil("DialogueArr[0]=",startDiaVec[0].dialogue);
         if(startDiaVec[0].dialogue.indexOf("bombb") != -1)
         {
            startDiaVec[0].dialogue = startDiaVec[0].dialogue.replace(new RegExp("bombb","g"),"");
            LogUtil(startDiaVec[0].dialogue);
            EventCenter.dispatchEvent("NPC_DIALOGUE_EVENT");
            return;
         }
         updateDialogue(startDiaVec[0].dialogue,startDiaVec[0].markStr,startDiaVec[0].sound);
         startDiaVec.splice(0,1);
      }
      
      private function updateDialogue(param1:String, param2:String, param3:String) : void
      {
         LogUtil("游戏开始对话内容:" + param1);
         this.addChild(nextMark);
         nextMark.gotoAndPlay(0);
         if(param1.indexOf("bomb") != -1)
         {
            var param1:String = param1.replace(new RegExp("bomb","g"),"");
            EventCenter.dispatchEvent("NPC_DIALOGUE_EVENT");
         }
         if(param1.indexOf("&") != -1)
         {
            param1 = param1.split("&")[StartChatMedia.fightResult];
         }
         var _loc5_:* = param2;
         if("#playername#" !== _loc5_)
         {
            if("#poke#" === _loc5_)
            {
               param1 = param1.replace(new RegExp("#poke#","g"),PlayerVO.enemyElfVec[0].nickName);
            }
         }
         else
         {
            param1 = param1.replace(new RegExp("#playername#","g"),PlayerVO.nickName);
         }
         Starling.juggler.removeTweens(TF);
         var _loc4_:Tween = new Tween(TF,0.5);
         Starling.juggler.add(_loc4_);
         _loc4_.onUpdate = playTextAni;
         _loc4_.onUpdateArgs = [param1,_loc4_];
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","dialogue");
         EventCenter.addEventListener("DIALOGUE_TALL_OVER",diaComplete);
         if(param3 == "beginDiaVoice_24")
         {
            SoundEvent.dispatchEvent("PLAY_DIALOGUE_AND_STOP_LAST","result" + StartChatMedia.fightResult);
         }
         else
         {
            SoundEvent.dispatchEvent("PLAY_DIALOGUE_AND_STOP_LAST",param3);
         }
      }
      
      private function diaComplete() : void
      {
         EventCenter.removeEventListener("DIALOGUE_TALL_OVER",diaComplete);
         if(mouth.isPlay)
         {
            mouth.gotoAndStop(0);
         }
         if(mouth_x)
         {
            if(mouth_x.isPlay)
            {
               mouth_x.gotoAndStop(0);
            }
         }
      }
      
      public function remove() : void
      {
         instance = null;
         removeNextMark();
         removeMouth();
         bg.removeFromParent();
         spr.removeFromParent();
         startDiaVec = null;
         if(rightNPC)
         {
            rightNPC.removeFromParent();
            rightNPC = null;
         }
         if(leftNPC)
         {
            leftNPC.removeFromParent();
            leftNPC = null;
         }
         this.removeFromParent(true);
      }
      
      private function removeMouth() : void
      {
         if(mouth)
         {
            if(mouth.isPlay)
            {
               mouth.stop();
            }
            mouth.removeFromParent();
         }
         if(mouth_x)
         {
            if(mouth_x.isPlay)
            {
               mouth_x.stop();
            }
            mouth_x.removeFromParent();
         }
      }
   }
}
