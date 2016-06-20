package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.SkillVO;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.core.Starling;
   import flash.geom.Point;
   import starling.display.Image;
   import starling.animation.Tween;
   
   public class SkillInfoTipsUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.SkillInfoTipsUI;
       
      private var swf:Swf;
      
      private var spr_skillTips:SwfSprite;
      
      private var tf_nature:TextField;
      
      private var tf_force:TextField;
      
      private var tf_sort:TextField;
      
      private var tf_pp:TextField;
      
      private var tf_hitRate:TextField;
      
      private var tf_skillDesc:TextField;
      
      public function SkillInfoTipsUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.SkillInfoTipsUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.SkillInfoTipsUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_skillTips = swf.createSprite("spr_skillTips");
         addChild(spr_skillTips);
         tf_nature = spr_skillTips.getTextField("tf_nature");
         tf_force = spr_skillTips.getTextField("tf_force");
         tf_sort = spr_skillTips.getTextField("tf_sort");
         tf_pp = spr_skillTips.getTextField("tf_pp");
         tf_hitRate = spr_skillTips.getTextField("tf_hitRate");
         tf_skillDesc = spr_skillTips.getTextField("tf_skillDesc");
         tf_skillDesc.autoScale = true;
      }
      
      public function showSkillTips(param1:SkillVO, param2:DisplayObject, param3:DisplayObjectContainer = null) : void
      {
         tf_nature.text = param1.property;
         if(param1.power == "0" || param1.power == "1")
         {
            tf_force.text = "0";
         }
         else
         {
            tf_force.text = param1.power + param1.lv;
         }
         tf_sort.text = param1.sort;
         tf_pp.text = param1.currentPP + "/" + param1.totalPP;
         var _loc4_:int = param1.hitRate < 100?param1.hitRate:100.0;
         if(_loc4_ == 100)
         {
            tf_hitRate.text = "--";
         }
         else
         {
            tf_hitRate.text = _loc4_;
         }
         tf_skillDesc.text = param1.descs;
         if(param3)
         {
            param3.addChild(this);
         }
         else
         {
            (Starling.current.root as Game).addChild(this);
         }
         this.x = param2.localToGlobal(new Point(0,0)).x / Config.scaleX - (this.width + 10);
         this.y = param2.localToGlobal(new Point(0,0)).y / Config.scaleY;
         (spr_skillTips.getChildAt(1) as Image).scaleX = 1;
         (spr_skillTips.getChildAt(1) as Image).x = 354;
         (spr_skillTips.getChildAt(1) as Image).y = 55;
         if(this.x < 0)
         {
            (spr_skillTips.getChildAt(1) as Image).scaleX = -1;
            (spr_skillTips.getChildAt(1) as Image).x = -10;
            (spr_skillTips.getChildAt(1) as Image).y = 45;
            this.x = param2.localToGlobal(new Point(0,0)).x / Config.scaleX + param2.width + 10;
         }
         this.alpha = 0;
         Starling.juggler.removeTweens(this);
         var _loc5_:Tween = new Tween(this,0.2);
         Starling.juggler.add(_loc5_);
         _loc5_.fadeTo(1);
      }
      
      public function removeSkillTips() : void
      {
         var _loc1_:Tween = new Tween(this,0.2);
         Starling.juggler.add(_loc1_);
         _loc1_.fadeTo(0);
         _loc1_.onComplete = onSkillTipsCompleteFun;
      }
      
      private function onSkillTipsCompleteFun() : void
      {
         this.removeFromParent();
      }
   }
}
