package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.controls.ScrollContainer;
   import feathers.controls.List;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Image;
   import com.mvc.views.mediator.mainCity.home.ComElfMedia;
   
   public class ComElfUI extends Sprite
   {
       
      public var putBugBtn:Button;
      
      private var swf:Swf;
      
      private var mySpr:SwfSprite;
      
      public var panel:ScrollContainer;
      
      public var comList:List;
      
      public var nowSpace:TextField;
      
      public var allSpace:TextField;
      
      public var btn_free:SwfButton;
      
      public var btn_sortLv:SwfButton;
      
      public var btn_sortRare:SwfButton;
      
      public function ComElfUI()
      {
         super();
         init();
         comList.addEventListener("scrollStart",startScroll);
         comList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         ElfBgUnitUI.isScrolling = false;
         comList.dataViewPort.touchable = true;
      }
      
      private function startScroll() : void
      {
         ElfBgUnitUI.isScrolling = true;
         comList.dataViewPort.touchable = false;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("home");
         mySpr = swf.createSprite("spr_computer_s");
         putBugBtn = mySpr.getButton("putBugBtn");
         nowSpace = mySpr.getTextField("nowSpace");
         allSpace = mySpr.getTextField("allSpace");
         btn_free = mySpr.getButton("btn_free");
         btn_sortLv = mySpr.getButton("btn_sortLv");
         btn_sortRare = mySpr.getButton("btn_sortRare");
         allSpace.text = PlayerVO.cpSpace;
         nowSpace.text = PlayerVO.comElfVec.length;
         allSpace.color = 5715237;
         comList = new List();
         comList.x = 0;
         comList.y = 72;
         comList.width = 500;
         comList.height = 465;
         comList.isSelectable = false;
         comList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         comList.itemRendererProperties.paddingBottom = _loc1_;
         comList.itemRendererProperties.paddingTop = _loc1_;
         mySpr.addChild(comList);
         addChild(mySpr);
         switchBtn();
      }
      
      public function getTick() : Image
      {
         var _loc1_:Image = swf.createImage("img_tick");
         return _loc1_;
      }
      
      public function switchBtn() : void
      {
         btn_sortLv.visible = ComElfMedia.isRareSort;
         btn_sortRare.visible = !ComElfMedia.isRareSort;
      }
   }
}
