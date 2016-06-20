package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.events.Event;
   import starling.display.Image;
   import com.mvc.models.vos.fighting.FightingConfig;
   
   public class WorldMapTwoUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_worldMap:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var scrollContainer:ScrollContainer;
      
      public var mapMark:SwfMovieClip;
      
      public const startId:int = 16;
      
      public const nodeIdNum:int = 15;
      
      public const openNum:int = 2;
      
      public var btn_local:SwfButton;
      
      public function WorldMapTwoUI()
      {
         super();
         initScrollContainer();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("worldMapTwo");
         spr_worldMap = swf.createSprite("spr_worldMap2_s");
         mapMark = swf.createMovieClip("mc_mark");
         spr_worldMap.addChild(mapMark);
         btn_close = swf.createButton("btn_close");
         btn_close.x = 1066;
         addChild(btn_close);
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
         scrollContainer.addChild(spr_worldMap);
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
         _loc1_ = 16;
         while(_loc1_ < 16 + 2)
         {
            spr_worldMap.getButton("map" + _loc1_).resetContents();
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
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         _loc1_ = 16;
         while(_loc1_ < 16 + 15)
         {
            if(spr_worldMap.getButton("map" + _loc1_))
            {
               spr_worldMap.getButton("map" + _loc1_).touchable = false;
               ((spr_worldMap.getButton("map" + _loc1_).skin as Sprite).getChildByName("title") as Image).visible = false;
            }
            _loc1_++;
         }
         _loc2_ = 16;
         while(_loc2_ <= FightingConfig.openCity)
         {
            spr_worldMap.getButton("map" + _loc2_).touchable = true;
            ((spr_worldMap.getButton("map" + _loc2_).skin as Sprite).getChildByName("title") as Image).visible = true;
            if((spr_worldMap.getButton("map" + _loc2_).skin as Sprite).getChildByName("doubel"))
            {
               ((spr_worldMap.getButton("map" + _loc2_).skin as Sprite).getChildByName("doubel") as Image).removeFromParent(true);
            }
            if(FightingConfig.cityIdArr.indexOf(_loc2_) != -1)
            {
               _loc3_ = swf.createImage("img_double");
               _loc3_.x = -20;
               _loc3_.y = -45;
               _loc3_.name = "doubel";
               (spr_worldMap.getButton("map" + _loc2_).skin as Sprite).addChild(_loc3_);
            }
            if(_loc2_ == FightingConfig.openCity)
            {
               mapMark.gotoAndPlay(0);
               mapMark.x = spr_worldMap.getButton("map" + _loc2_).x + spr_worldMap.getButton("map" + _loc2_).width / 2 - mapMark.width / 2;
               mapMark.y = spr_worldMap.getButton("map" + _loc2_).y - 50;
               if(spr_worldMap.getButton("map" + _loc2_).y > 640 - 150)
               {
                  scrollContainer.verticalScrollPosition = 832;
               }
               if(spr_worldMap.getButton("map" + _loc2_).x > 1136 - 250)
               {
                  scrollContainer.horizontalScrollPosition = 1476;
               }
               limitPoint();
            }
            _loc2_++;
         }
      }
   }
}
