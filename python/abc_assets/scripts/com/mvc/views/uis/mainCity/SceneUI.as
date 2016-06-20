package com.mvc.views.uis.mainCity
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.QuadBatch;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.MCitySceneManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.util.GetCommon;
   import starling.events.Event;
   
   public class SceneUI extends Sprite
   {
       
      private var mainScene:Sprite;
      
      private var btnSpr:SwfSprite;
      
      private var bgScene1:SwfSprite;
      
      private var bgScene2:SwfSprite;
      
      private var cloundScene:Sprite;
      
      private var cloundSpeed:Number = 0.25;
      
      private var vistaScene:QuadBatch;
      
      public var scrollContainer:ScrollContainer;
      
      private var swf:Swf;
      
      public var homeBtn:Button;
      
      public var eleCenterBtn:Button;
      
      public var shopBtn:Button;
      
      public var playgroundBtn:Button;
      
      public var studyBtn:Button;
      
      public var huntingBtn:Button;
      
      public var btn_fourKing:SwfButton;
      
      public var btn_elfSeries:SwfButton;
      
      public var elfSeriesNews:Image;
      
      public var btn_elfPVP:SwfButton;
      
      public var btn_union:SwfButton;
      
      public var advanceBtn:Button;
      
      public var freeDraw:Image;
      
      public var huntingNew:Image;
      
      public var btn_mine:SwfButton;
      
      public var miningNews:Image;
      
      public var btn_huntParty:SwfButton;
      
      public function SceneUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mainCity");
         initVistaScene();
         initBg2Scene();
         initBg1Scene();
         initCloundScene();
         initScrollContainer();
         initMainScene();
         this.addEventListener("enterFrame",cloundAni);
      }
      
      private function cloundAni() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < cloundScene.numChildren)
         {
            _loc1_ = cloundScene.getChildAt(_loc2_) as Image;
            _loc1_.x = _loc1_.x - cloundSpeed;
            if(_loc1_.x < -180)
            {
               _loc1_.x = 2474;
            }
            _loc2_++;
         }
      }
      
      private function initBg1Scene() : void
      {
         bgScene1 = swf.createSprite("spr_moutain1");
         bgScene1.y = 0;
         addChild(bgScene1);
      }
      
      private function initBg2Scene() : void
      {
         bgScene2 = swf.createSprite("spr_moutain2");
         bgScene2.y = 30;
         addChild(bgScene2);
      }
      
      private function initCloundScene() : void
      {
         cloundScene = swf.createSprite("spr_clound");
         addChild(cloundScene);
         var _loc1_:* = 0.7;
         cloundScene.scaleY = _loc1_;
         cloundScene.scaleX = _loc1_;
         cloundScene.touchable = false;
      }
      
      private function initVistaScene() : void
      {
         var _loc2_:* = 0;
         vistaScene = new QuadBatch();
         var _loc1_:Image = MCitySceneManager.getInstance().getImg("sky");
         _loc2_ = 0;
         while(_loc2_ < 52)
         {
            _loc1_.x = 22 * _loc2_;
            vistaScene.addImage(_loc1_);
            _loc2_++;
         }
         vistaScene.touchable = false;
         addChild(vistaScene);
         _loc1_.dispose();
         _loc1_ = null;
         vistaScene.blendMode = "none";
      }
      
      private function initMainScene() : void
      {
         var _loc1_:* = null;
         mainScene = new Sprite();
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         mainScene.addChild(_loc1_);
         _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common2"));
         _loc1_.x = 1105;
         mainScene.addChild(_loc1_);
         btnSpr = swf.createSprite("spr_btns");
         btnSpr.blendMode = "none";
         mainScene.addChild(btnSpr);
         initBtn();
         scrollContainer.addChild(mainScene);
      }
      
      private function initBtn() : void
      {
         homeBtn = btnSpr.getButton("homeBtn");
         eleCenterBtn = btnSpr.getButton("eleCenterBtn");
         shopBtn = btnSpr.getButton("shopBtn");
         playgroundBtn = btnSpr.getButton("playgroundBtn");
         studyBtn = btnSpr.getButton("studyBtn");
         huntingBtn = btnSpr.getButton("btn_hunting");
         btn_fourKing = btnSpr.getButton("btn_fourKing");
         btn_elfSeries = btnSpr.getButton("btn_elfSeries");
         btn_elfPVP = btnSpr.getButton("btn_elfPVP");
         btn_union = btnSpr.getButton("btn_union");
         btn_mine = btnSpr.getButton("btn_mine");
         btn_huntParty = btnSpr.getButton("btn_huntParty");
         elfSeriesNews = GetCommon.getNews(btn_elfSeries,0.9,75,-5);
         freeDraw = GetCommon.getNews(playgroundBtn,0.9,10,50);
         huntingNew = GetCommon.getNews(huntingBtn,0.9,60,-10);
         miningNews = GetCommon.getNews(btn_mine,0.9,5,25);
      }
      
      private function initScrollContainer() : void
      {
         scrollContainer = new ScrollContainer();
         addChild(scrollContainer);
         scrollContainer.width = 1136;
         scrollContainer.height = 640;
         scrollContainer.verticalScrollPolicy = "none";
         scrollContainer.addEventListener("scroll",onScroll);
         scrollContainer.addEventListener("scrollStart",startScroll);
         scrollContainer.addEventListener("scrollComplete",scrollComplete);
      }
      
      public function scrollComplete() : void
      {
         mainScene.touchable = true;
         mainScene.unflatten();
      }
      
      private function startScroll() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         mainScene.touchable = false;
         mainScene.flatten();
         _loc1_ = 0;
         while(_loc1_ < btnSpr.numChildren)
         {
            _loc2_ = btnSpr.getChildAt(_loc1_) as SwfButton;
            _loc2_.resetContents();
            _loc1_++;
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         if(scrollContainer.horizontalScrollPosition >= 2293 - 1136)
         {
            scrollContainer.horizontalScrollPosition = 2293 - 1136;
            scrollComplete();
         }
         if(scrollContainer.horizontalScrollPosition <= 0)
         {
            scrollContainer.horizontalScrollPosition = 0;
            scrollComplete();
         }
         moveBg1();
         moveBg2();
         moveClund();
      }
      
      private function moveClund() : void
      {
         cloundScene.x = -scrollContainer.horizontalScrollPosition * 0.3;
      }
      
      private function moveBg2() : void
      {
         bgScene2.x = -scrollContainer.horizontalScrollPosition * 0.1;
      }
      
      private function moveBg1() : void
      {
         bgScene1.x = -scrollContainer.horizontalScrollPosition * 0.2;
      }
      
      public function disposeTexture() : void
      {
         vistaScene.texture.dispose();
         vistaScene.dispose();
         this.removeFromParent(true);
      }
   }
}
