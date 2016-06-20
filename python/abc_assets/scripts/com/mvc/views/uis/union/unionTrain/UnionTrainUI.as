package com.mvc.views.uis.union.unionTrain
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import feathers.controls.Label;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.util.GetCommon;
   
   public class UnionTrainUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_unionTrain:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var trainList:List;
      
      public var speedUpCount:Label;
      
      public var speedUpState:Label;
      
      public function UnionTrainUI()
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
         speedUpCount = GetCommon.getLabel(spr_unionTrain,65,150);
         speedUpState = GetCommon.getLabel(spr_unionTrain,65,240);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionTrain");
         spr_unionTrain = swf.createSprite("spr_unionTrain");
         btn_close = spr_unionTrain.getButton("btn_close");
         spr_unionTrain.x = 1136 - spr_unionTrain.width >> 1;
         spr_unionTrain.y = 640 - spr_unionTrain.height >> 1;
         addChild(spr_unionTrain);
      }
      
      private function addList() : void
      {
         trainList = new List();
         trainList.width = 640;
         trainList.height = 432;
         trainList.x = 330;
         trainList.y = 135;
         trainList.isSelectable = false;
         trainList.itemRendererProperties.stateToSkinFunction = null;
         trainList.itemRendererProperties.paddingTop = 3;
         trainList.itemRendererProperties.paddingBottom = 0;
         spr_unionTrain.addChild(trainList);
      }
   }
}
