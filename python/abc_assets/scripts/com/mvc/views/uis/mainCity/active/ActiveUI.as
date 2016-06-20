package com.mvc.views.uis.mainCity.active
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class ActiveUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_bg:SwfSprite;
      
      public var mc_upDown:SwfMovieClip;
      
      public var btn_close:SwfButton;
      
      public var menuList:List;
      
      public var ActiveView:Sprite;
      
      public var isScrolling:Boolean;
      
      public function ActiveUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
         addMenu();
         addView();
      }
      
      private function addView() : void
      {
         ActiveView = new Sprite();
         ActiveView.x = 222;
         ActiveView.y = 140;
         spr_bg.addChild(ActiveView);
      }
      
      private function addMenu() : void
      {
         menuList = new List();
         spr_bg.addChild(menuList);
         menuList.width = 200;
         menuList.height = 489;
         menuList.y = 94;
         menuList.x = 7;
         menuList.isSelectable = false;
         menuList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = -3;
         menuList.itemRendererProperties.paddingBottom = _loc1_;
         menuList.itemRendererProperties.paddingTop = _loc1_;
         menuList.addEventListener("scrollStart",startScroll);
         menuList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
         menuList.dataViewPort.touchable = true;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
         menuList.dataViewPort.touchable = false;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("activity");
         spr_bg = swf.createSprite("spr_bg");
         mc_upDown = spr_bg.getMovie("mc_upDown");
         btn_close = spr_bg.getButton("btn_close");
         spr_bg.x = 1136 - spr_bg.width >> 1;
         spr_bg.y = (640 - spr_bg.height >> 1) - 10;
         addChild(spr_bg);
      }
   }
}
