package com.mvc.views.uis.mainCity.train
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class SeleTrainElfUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      private var spr_seleteElf:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var elfContainList:List;
      
      public function SeleTrainElfUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("train");
         spr_seleteElf = swf.createSprite("spr_seleteElf");
         btn_close = spr_seleteElf.getButton("btn_close");
         spr_seleteElf.x = 1136 - spr_seleteElf.width >> 1;
         spr_seleteElf.y = 640 - spr_seleteElf.height >> 1;
         addChild(spr_seleteElf);
      }
      
      private function addList() : void
      {
         elfContainList = new List();
         elfContainList.width = 770;
         elfContainList.height = 445;
         elfContainList.x = 10;
         elfContainList.y = 90;
         elfContainList.isSelectable = false;
         elfContainList.itemRendererProperties.stateToSkinFunction = null;
         spr_seleteElf.addChild(elfContainList);
         elfContainList.addEventListener("scrollStart",startScroll);
         elfContainList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
         elfContainList.dataViewPort.touchable = true;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
         elfContainList.dataViewPort.touchable = false;
      }
   }
}
