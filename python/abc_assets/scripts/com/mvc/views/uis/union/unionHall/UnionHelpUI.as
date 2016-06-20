package com.mvc.views.uis.union.unionHall
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionHelpUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.union.unionHall.UnionHelpUI;
       
      private var swf:Swf;
      
      private var spr_help:SwfSprite;
      
      private var tipTf:TextField;
      
      public function UnionHelpUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionHall");
         spr_help = swf.createSprite("spr_help");
         spr_help.x = 1136 - spr_help.width >> 1;
         spr_help.y = 640 - spr_help.height >> 1;
         tipTf = spr_help.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         tipTf.text = "公会升级计算玩家的活跃度，这个活跃度有三个计算方式：\n\n1、体力消耗\n消耗1点体力，就有1点活跃度 每天上限800\n\n2、王者之路\n在王者之路中，每通一关获得50点的活跃度，每天上限1000 \n\n3、精灵联盟大赛\n每天挑战一次精灵联盟大赛或者在线pvp大赛可获得20点活跃度，每天上限500";
         addChild(spr_help);
         this.addEventListener("touch",close);
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionHall.UnionHelpUI
      {
         return instance || new com.mvc.views.uis.union.unionHall.UnionHelpUI();
      }
      
      private function close(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            remove();
         }
      }
      
      public function remove() : void
      {
         getInstance().removeFromParent(true);
         instance = null;
      }
   }
}
