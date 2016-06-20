package com.mvc.views.uis.mainCity.mining
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import feathers.layout.HorizontalLayout;
   import lzm.starling.swf.display.SwfMovieClip;
   
   public class MiningFrameUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_miningFrame:SwfSprite;
      
      public var spr_littleIcon:SwfSprite;
      
      public var tf_pageTittle:TextField;
      
      public var tf_power:TextField;
      
      public var btn_close:SwfButton;
      
      public var btn_left:SwfButton;
      
      public var btn_right:SwfButton;
      
      public var btn_defendRecord:SwfButton;
      
      public var btn_rule:SwfButton;
      
      public var pageContainer:Sprite;
      
      public var iconScrollContainer:ScrollContainer;
      
      public var defendNews:Image;
      
      public function MiningFrameUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         pageContainer = new Sprite();
         addChild(pageContainer);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_miningFrame = swf.createSprite("spr_miningFrame");
         addChild(spr_miningFrame);
         spr_littleIcon = spr_miningFrame.getSprite("spr_littleIcon");
         tf_pageTittle = spr_miningFrame.getTextField("tf_pageTittle");
         tf_power = spr_miningFrame.getTextField("tf_power");
         btn_close = spr_miningFrame.getButton("btn_close");
         btn_left = spr_miningFrame.getButton("btn_left");
         btn_right = spr_miningFrame.getButton("btn_right");
         btn_defendRecord = spr_miningFrame.getButton("btn_defendRecord");
         btn_rule = spr_miningFrame.getButton("btn_rule");
         defendNews = GetCommon.getNews(btn_defendRecord,0.9,95,-5,1);
         createScrollContainer();
      }
      
      private function createScrollContainer() : void
      {
         if(iconScrollContainer)
         {
            return;
         }
         iconScrollContainer = new ScrollContainer();
         iconScrollContainer.width = spr_littleIcon.width;
         iconScrollContainer.height = spr_littleIcon.height;
         spr_littleIcon.addChild(iconScrollContainer);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 10;
         iconScrollContainer.layout = _loc1_;
         iconScrollContainer.verticalScrollPolicy = "off";
      }
      
      public function createMainPage() : MiningMainPage
      {
         var _loc1_:MiningMainPage = new MiningMainPage();
         return _loc1_;
      }
      
      public function addLittleIcon(param1:int, param2:Boolean = true) : SwfSprite
      {
         var _loc3_:* = null;
         switch(param1)
         {
            case 0:
               _loc3_ = swf.createSprite("spr_miningIcon");
               break;
            case 1:
               _loc3_ = swf.createSprite("spr_coinIcom");
               break;
            case 2:
               _loc3_ = swf.createSprite("spr_sweetIcon");
               break;
            case 3:
               _loc3_ = swf.createSprite("spr_dollIcom");
               break;
            case 4:
               _loc3_ = swf.createSprite("spr_exporeIcon");
               break;
         }
         if(param2)
         {
            iconScrollContainer.addChild(_loc3_);
         }
         else
         {
            iconScrollContainer.addChildAt(_loc3_,0);
         }
         return _loc3_;
      }
      
      public function createExportMc() : SwfMovieClip
      {
         mc_arrowDown_completeHandler = function():void
         {
            mc_export.removeFromParent(true);
         };
         var mc_export:SwfMovieClip = swf.createMovieClip("mc_export");
         addChild(mc_export);
         mc_export.addEventListener("complete",mc_arrowDown_completeHandler);
         return mc_export;
      }
   }
}
