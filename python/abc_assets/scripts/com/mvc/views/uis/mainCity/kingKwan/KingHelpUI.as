package com.mvc.views.uis.mainCity.kingKwan
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class KingHelpUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_helpSpr:SwfSprite;
      
      public var btn_helpClose:SwfButton;
      
      private var helpTxt:TextField;
      
      public function KingHelpUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("kingKwan");
         spr_helpSpr = swf.createSprite("spr_helpSpr");
         btn_helpClose = spr_helpSpr.getButton("btn_helpClose");
         helpTxt = spr_helpSpr.getTextField("helpTxt");
         spr_helpSpr.x = 1136 - spr_helpSpr.width >> 1;
         spr_helpSpr.y = 640 - spr_helpSpr.height >> 1;
         addChild(spr_helpSpr);
         helpTxt.kerning = true;
         helpTxt.text = "1.玩家等级达到22级或以上才能参加王者之路。\n2.只有等级在15或者以上的精灵才能参与王者之路的战斗。\n3.在王者之路的过程中，双方都不能使用任何道具。\n4.在王者之路的过程中，已濒死的精灵不能复活。\n5.玩家从挑战完第一关开始，精灵的数量和种类已经确定下来了，之后新增的精灵不能参加当前的王者之路。\n6.玩家每天可以参与一次王者之路，vip10以上的玩家每天可以多参与一次，但第二次王者之路不掉落王者积分。\n7.玩家每挑战成功一波敌人，都可以领取到大量的奖励，包括金币，\n   道具，王者积分，也有一定几率获得精灵。\n8.每天凌晨4点重置挑战次数。";
      }
   }
}
