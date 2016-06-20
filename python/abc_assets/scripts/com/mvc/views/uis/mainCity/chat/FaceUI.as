package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FaceUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.chat.FaceUI;
      
      public static var faceStrArr:Array = ["/嘻嘻","/被扁","/被打","/黑客","/偷窥","/吃饭","/抽烟","/大汗","/大惊","/大哭","/恶魔","/发怒","/犯困","/感冒","/憨笑","/好冷","/呵呵","/哼哼","/欢乐","/活该","/惊讶","/可怜","/狂哭","/狂喷","/藐视","/难受","/你懂","/强大","/烧香","/生气","/是么","/投降","/威武","/委屈","/呀呀","/眼红","/银荡","/悠闲","/砸砖","/挨打","/傲慢","/不懂","/财迷","/超人","/聪明","/发呆","/发毛","/尴尬","/羞羞","/嘿嘿","/好爽","/惊呆","/开怀","/抗议","/脸红","/流汗","/纳尼","/怒火","/噢耶","/死亡","/贪吃","/微笑","/银笑","/贼笑"];
       
      private var swf:Swf;
      
      private var spr_face:SwfSprite;
      
      private var faceBg:SwfScale9Image;
      
      public function FaceUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         faceBg = swf.createS9Image("s9_faceBg");
         faceBg.width = 1030;
         faceBg.height = 260;
         faceBg.touchable = false;
         addChild(faceBg);
         addFace();
         this.pivotY = this.height;
         this.pivotX = this.width * 0.8;
         this.x = 875;
         this.y = 541;
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.chat.FaceUI
      {
         return instance || new com.mvc.views.uis.mainCity.chat.FaceUI();
      }
      
      private function addFace() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:* = null;
         var _loc2_:* = 18;
         _loc3_ = 0;
         while(_loc3_ < faceStrArr.length)
         {
            if(_loc3_ % _loc2_ == 0 && _loc3_ != 0)
            {
               _loc4_ = _loc4_ + 1;
            }
            _loc1_ = swf.createImage("img_face" + _loc3_);
            _loc1_.x = _loc3_ % _loc2_ * 55 + 25;
            _loc1_.y = 55 * _loc4_ + 25;
            _loc1_.name = faceStrArr[_loc3_];
            addChild(_loc1_);
            _loc1_.addEventListener("touch",onclick);
            _loc3_++;
         }
      }
      
      private function onclick(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as Image);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            LogUtil("e.target = " + (param1.target as Image).name);
            Facade.getInstance().sendNotification("SEND_CHAT_FACE",(param1.target as Image).name);
            remove();
         }
      }
      
      public function show(param1:Sprite) : void
      {
         if(this.parent)
         {
            LogUtil("移除");
            cartoon(1,0);
         }
         else
         {
            LogUtil("添加");
            param1.addChild(this);
            cartoon(0,1);
         }
      }
      
      public function remove() : void
      {
         if(this.parent)
         {
            cartoon(1,0);
         }
      }
      
      private function cartoon(param1:Number, param2:Number) : void
      {
         start = param1;
         end = param2;
         var t:Tween = new Tween(this,0.2);
         Starling.juggler.add(t);
         t.animate("scaleX",end,start);
         t.animate("scaleY",end,start);
         t.animate("alpha",end,start);
         t.onComplete = function():void
         {
            if(end == 0)
            {
               FaceUI.getInstance().removeFromParent();
            }
         };
      }
   }
}
