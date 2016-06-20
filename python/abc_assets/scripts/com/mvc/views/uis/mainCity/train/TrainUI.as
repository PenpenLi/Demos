package com.mvc.views.uis.mainCity.train
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class TrainUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      public var spr_train:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var spr_propContain:SwfSprite;
      
      public var elfContainList:List;
      
      public var propmpt:TextField;
      
      private var spr_elfContain:SwfScale9Image;
      
      public function TrainUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("train");
         spr_train = swf.createSprite("spr_train_s");
         btn_close = spr_train.getButton("btn_close");
         spr_elfContain = spr_train.getScale9Image("spr_elfContain");
         spr_propContain = spr_train.getSprite("spr_propContain");
         propmpt = spr_train.getTextField("prompt");
         spr_train.x = 1136 - spr_train.width >> 1;
         spr_train.y = 640 - spr_train.height >> 1;
         addChild(spr_train);
      }
      
      private function addList() : void
      {
         elfContainList = new List();
         elfContainList.width = 770;
         elfContainList.height = 440;
         elfContainList.x = spr_elfContain.x + 5;
         elfContainList.y = spr_elfContain.y + 10;
         elfContainList.isSelectable = false;
         elfContainList.itemRendererProperties.stateToSkinFunction = null;
         spr_train.addChild(elfContainList);
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
