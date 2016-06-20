package com.mvc.views.uis.mainCity.miracle
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiracleUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_miracle:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_autoAddBtn:SwfButton;
      
      public var btn_miracleBtn:SwfButton;
      
      public var tf_payMoney:TextField;
      
      private var spr_elfShadow:SwfSprite;
      
      public var tf_tips:TextField;
      
      public function MiracleUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("miracle");
         spr_miracle = swf.createSprite("spr_miracle");
         spr_miracle.x = 1136 - spr_miracle.width >> 1;
         spr_miracle.y = 640 - spr_miracle.height >> 1;
         addChild(spr_miracle);
         spr_elfShadow = spr_miracle.getSprite("elfShadowSpr");
         btn_close = spr_miracle.getButton("btn_close");
         btn_autoAddBtn = spr_miracle.getButton("btn_autoAddBtn");
         btn_miracleBtn = spr_miracle.getButton("btn_miracleBtn");
         tf_payMoney = spr_miracle.getTextField("tf_payMoney");
         tf_tips = spr_miracle.getTextField("tf_tips");
         tf_tips.text = "稀有度在\"稀有\"以上的精灵才能进行奇迹交换，一次使用四只稀有度相同的精灵\n随机获得一只精灵，选择的精灵稀有度越高可能得到的精灵稀有度就越高\n背包、训练中，防守中的精灵不可以用于奇迹交换。";
      }
      
      public function addTargetImg(param1:Image) : void
      {
         param1.alignPivot("center","bottom");
         param1.x = 780;
         param1.y = 345;
         var _loc2_:* = 0.8;
         param1.scaleY = _loc2_;
         param1.scaleX = _loc2_;
         addChild(param1);
      }
   }
}
