package com.mvc.views.uis.union.unionStudy
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.events.TouchEvent;
   import starling.display.Quad;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.DisplayObjectContainer;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class MedalUpUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.union.unionStudy.MedalUpUI;
       
      private var swf:Swf;
      
      private var spr_medalUp:SwfSprite;
      
      public function MedalUpUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         _loc1_.addEventListener("touch",close);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionStudy.MedalUpUI
      {
         return instance || new com.mvc.views.uis.union.unionStudy.MedalUpUI();
      }
      
      private function close(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as Quad);
         if(_loc2_ && _loc2_.phase == "began")
         {
            remove();
         }
      }
      
      private function remove() : void
      {
         removeFromParent(true);
         instance = null;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionMedal");
         spr_medalUp = swf.createSprite("spr_medalUp");
         spr_medalUp.x = 1136 - spr_medalUp.width >> 1;
         spr_medalUp.y = 640 - spr_medalUp.height >> 1;
         addChild(spr_medalUp);
      }
      
      public function show(param1:DisplayObjectContainer) : void
      {
         GetUnionMedal.getMedalIcon(80,200,PlayerVO.medalLv - 1,spr_medalUp,25);
         GetUnionMedal.getMedalIcon(265,200,PlayerVO.medalLv,spr_medalUp,25);
         param1.addChild(this);
      }
   }
}
