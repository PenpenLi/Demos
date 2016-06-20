package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import feathers.controls.TabBar;
   import feathers.controls.List;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mainCity.amuse.AmuseScoreRechargeMediator;
   import starling.events.Event;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   
   public class AmuseScoreRechargeUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var tf_scoreNum:TextField;
      
      public var tf_needDiamondNum:TextField;
      
      public var tf_getScoreNum:TextField;
      
      public var spr_scoreRecharge:SwfSprite;
      
      public var btn_close:SwfButton;
      
      private var scrollContainer:ScrollContainer;
      
      public var tabs:TabBar;
      
      public var propList:List;
      
      public function AmuseScoreRechargeUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuse");
         spr_scoreRecharge = swf.createSprite("spr_scoreRecharge");
         spr_scoreRecharge.x = 1136 - spr_scoreRecharge.width >> 1;
         spr_scoreRecharge.y = 640 - spr_scoreRecharge.height >> 1;
         addChild(spr_scoreRecharge);
         btn_close = spr_scoreRecharge.getButton("btn_close");
         tf_scoreNum = spr_scoreRecharge.getTextField("tf_scoreNum");
         tf_needDiamondNum = spr_scoreRecharge.getTextField("tf_needDiamondNum");
         tf_needDiamondNum.text = "10";
         tf_getScoreNum = spr_scoreRecharge.getTextField("tf_getScoreNum");
         tf_getScoreNum.text = "1";
         initTab();
         initPropList();
      }
      
      private function initPropList() : void
      {
         propList = new List();
         propList.x = 330;
         propList.y = 185;
         propList.width = 645;
         propList.height = 360;
         propList.isSelectable = false;
         propList.dataProvider = new ListCollection();
      }
      
      private function initTab() : void
      {
         var _loc1_:* = 0;
         scrollContainer = new ScrollContainer();
         scrollContainer.x = 40;
         scrollContainer.y = 143;
         scrollContainer.width = 140;
         scrollContainer.height = 360;
         scrollContainer.horizontalScrollPolicy = "off";
         spr_scoreRecharge.addChild(scrollContainer);
         tabs = new TabBar();
         tabs.direction = "vertical";
         tabs.dataProvider = new ListCollection();
         _loc1_ = 0;
         while(_loc1_ < AmuseScoreRechargeMediator.itemArr.length)
         {
            tabs.dataProvider.push({
               "label":"<font size = \'20\'>" + AmuseScoreRechargeMediator.itemArr[_loc1_].content + "</font>",
               "itemId":AmuseScoreRechargeMediator.itemArr[_loc1_].id
            });
            _loc1_++;
         }
         tabs.addEventListener("creationComplete",setTab);
         scrollContainer.addChild(tabs);
      }
      
      private function setTab(param1:Event) : void
      {
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = new Scale9Textures(swf.createImage("img_menuUp").texture,new Rectangle(30,20,30,20));
         _loc2_.defaultSelectedValue = new Scale9Textures(swf.createImage("img_menuDown").texture,new Rectangle(30,20,30,20));
         tabs.tabProperties.stateToSkinFunction = _loc2_.updateValue;
         tabs.gap = 10;
         tabs.tabProperties.width = 140;
         tabs.tabProperties.maxHeight = 50;
      }
      
      public function getRechargeBtn() : SwfButton
      {
         return swf.createButton("btn_rechargeBtn_b");
      }
   }
}
