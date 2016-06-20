package com.mvc.views.uis.union.unionStudy
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class UnionStudyUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_study:SwfSprite;
      
      public var btn_hall:SwfButton;
      
      public var btn_train:SwfButton;
      
      public var btn_series:SwfButton;
      
      public var btn_close:SwfButton;
      
      public function UnionStudyUI()
      {
         super();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         var _loc3_:Image = _loc2_.createImage("img_bg0");
         addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionStudy");
         spr_study = swf.createSprite("spr_study");
         btn_hall = spr_study.getButton("btn_hall");
         btn_train = spr_study.getButton("btn_train");
         btn_series = spr_study.getButton("btn_series");
         btn_close = spr_study.getButton("btn_close");
         spr_study.x = 1136 - spr_study.width >> 1;
         spr_study.y = 640 - spr_study.height >> 1;
         addChild(spr_study);
         hideBtn();
      }
      
      public function showBtn() : void
      {
         var _loc1_:* = true;
         btn_train.visible = _loc1_;
         _loc1_ = _loc1_;
         btn_hall.visible = _loc1_;
         btn_series.visible = _loc1_;
      }
      
      public function hideBtn() : void
      {
         var _loc1_:* = false;
         btn_train.visible = _loc1_;
         _loc1_ = _loc1_;
         btn_hall.visible = _loc1_;
         btn_series.visible = _loc1_;
      }
   }
}
