package com.mvc.views.uis.union.unionTrain
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class OtherTrainUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      public var spr_otherTrain:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var otherTrainList:List;
      
      public function OtherTrainUI()
      {
         super();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         var _loc3_:Image = _loc2_.createImage("img_bg0");
         addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionTrain");
         spr_otherTrain = swf.createSprite("spr_otherTrain");
         btn_close = spr_otherTrain.getButton("btn_close");
         spr_otherTrain.x = 1136 - spr_otherTrain.width >> 1;
         spr_otherTrain.y = 640 - spr_otherTrain.height >> 1;
         addChild(spr_otherTrain);
         isScrolling = false;
      }
      
      private function addList() : void
      {
         otherTrainList = new List();
         otherTrainList.width = 800;
         otherTrainList.height = 413;
         otherTrainList.x = 125;
         otherTrainList.y = 130;
         otherTrainList.isSelectable = false;
         otherTrainList.itemRendererProperties.stateToSkinFunction = null;
         otherTrainList.itemRendererProperties.paddingTop = 0;
         otherTrainList.itemRendererProperties.paddingBottom = 2;
         spr_otherTrain.addChild(otherTrainList);
         otherTrainList.addEventListener("scrollStart",startScroll);
         otherTrainList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
      }
   }
}
