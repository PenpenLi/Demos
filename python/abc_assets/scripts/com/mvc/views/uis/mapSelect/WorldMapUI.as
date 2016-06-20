package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import lzm.starling.swf.display.SwfMovieClip;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.events.Event;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.display.Image;
   
   public class WorldMapUI extends Sprite
   {
       
      public var mySpr:SwfSprite;
      
      private var swf:Swf;
      
      public var returnMainCityBtn:Button;
      
      public var mapMark:SwfMovieClip;
      
      public var scrollContainer:ScrollContainer;
      
      public var btn_local:SwfButton;
      
      public function WorldMapUI()
      {
         super();
         initScrollContainer();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("worldMap");
         mySpr = swf.createSprite("spr_background_s");
         mapMark = swf.createMovieClip("mc_mark");
         mapMark.stop(true);
         mapMark.touchable = false;
         mySpr.addChild(mapMark);
         returnMainCityBtn = mySpr.getButton("returnMainCityBtn");
         returnMainCityBtn = swf.createButton("btn_X_b");
         returnMainCityBtn.x = 1066;
         addChild(returnMainCityBtn);
         var _loc1_:SwfScale9Image = LoadSwfAssetsManager.getInstance().assets.getSwf("loading").createS9Image("s9_BG");
         _loc1_.touchable = false;
         _loc1_.width = 95;
         _loc1_.height = 83;
         _loc1_.y = 561;
         addChild(_loc1_);
         btn_local = swf.createButton("btn_local");
         btn_local.x = 15;
         btn_local.y = 565;
         addChild(btn_local);
         scrollContainer.addChild(mySpr);
         updateOpen();
      }
      
      private function initScrollContainer() : void
      {
         scrollContainer = new ScrollContainer();
         addChild(scrollContainer);
         scrollContainer.width = 1136;
         scrollContainer.height = 640;
         scrollContainer.addEventListener("scroll",onScroll);
         scrollContainer.addEventListener("scrollStart",startScroll);
      }
      
      private function startScroll() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 1;
         while(_loc1_ <= 15)
         {
            mySpr.getButton("map" + _loc1_).resetContents();
            _loc1_++;
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         limitPoint();
      }
      
      private function limitPoint() : void
      {
         if(scrollContainer.horizontalScrollPosition >= 1476 - 1136)
         {
            scrollContainer.horizontalScrollPosition = 1476 - 1136;
         }
         if(scrollContainer.horizontalScrollPosition <= 0)
         {
            scrollContainer.horizontalScrollPosition = 0;
         }
         if(scrollContainer.verticalScrollPosition <= 0)
         {
            scrollContainer.verticalScrollPosition = 0;
         }
         if(scrollContainer.verticalScrollPosition >= 832 - 640)
         {
            scrollContainer.verticalScrollPosition = 832 - 640;
         }
      }
      
      public function updateOpen() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc1_:int = FightingConfig.openCity > 15?15:FightingConfig.openCity;
         _loc2_ = _loc1_ + 1;
         while(_loc2_ <= 15)
         {
            if(mySpr.getButton("map" + _loc2_))
            {
               mySpr.getButton("map" + _loc2_).touchable = false;
               mySpr.getButton("map" + _loc2_).visible = false;
            }
            _loc2_++;
         }
         _loc3_ = 1;
         while(_loc3_ <= _loc1_)
         {
            mySpr.getButton("map" + _loc3_).touchable = true;
            mySpr.getButton("map" + _loc3_).visible = true;
            if((mySpr.getButton("map" + _loc3_).skin as Sprite).getChildByName("doubel"))
            {
               ((mySpr.getButton("map" + _loc3_).skin as Sprite).getChildByName("doubel") as Image).removeFromParent(true);
            }
            if(FightingConfig.cityIdArr.indexOf(_loc3_) != -1)
            {
               _loc4_ = swf.createImage("img_double");
               _loc4_.x = -20;
               _loc4_.y = -45;
               _loc4_.name = "doubel";
               (mySpr.getButton("map" + _loc3_).skin as Sprite).addChild(_loc4_);
            }
            if(_loc3_ == _loc1_)
            {
               mapMark.gotoAndPlay(0);
               mapMark.x = mySpr.getButton("map" + _loc3_).x + mySpr.getButton("map" + _loc3_).width / 2 - mapMark.width / 2;
               mapMark.y = mySpr.getButton("map" + _loc3_).y - 50;
               if(mySpr.getButton("map" + _loc3_).y > 640 - 150)
               {
                  scrollContainer.verticalScrollPosition = 832;
               }
               if(mySpr.getButton("map" + _loc3_).x > 1136 - 250)
               {
                  scrollContainer.horizontalScrollPosition = 1476;
               }
               limitPoint();
            }
            _loc3_++;
         }
      }
   }
}
