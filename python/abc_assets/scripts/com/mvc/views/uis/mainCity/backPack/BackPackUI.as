package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import feathers.controls.TabBar;
   import feathers.controls.List;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class BackPackUI extends Sprite
   {
       
      public var tabs:TabBar;
      
      public var backPackGoodsList:List;
      
      public var closeBtn:Button;
      
      private var swf:Swf;
      
      public var mySpr:SwfSprite;
      
      public var btn_carry:SwfButton;
      
      private var line:SwfImage;
      
      public function BackPackUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         mySpr = swf.createSprite("spr_main");
         closeBtn = mySpr.getButton("btn_close");
         btn_carry = swf.createButton("btn_carry_b");
         line = mySpr.getImage("line");
         line.x = line.x - 10;
         mySpr.x = 1136 - mySpr.width >> 1;
         mySpr.y = 640 - mySpr.height >> 1;
         addChild(mySpr);
         initBackPackGoodsList();
      }
      
      private function initBackPackGoodsList() : void
      {
         tabs = new TabBar();
         tabs.dataProvider = new ListCollection([{"label":"<font size = \'23\'>药品</font>"},{
            "label":"<font size = \'23\'>精灵球</font>",
            "name":"elfBall"
         },{"label":"<font size = \'23\'>学习机</font>"},{"label":"<font size = \'23\'>碎片</font>"},{"label":"<font size = \'23\'>沙袋</font>"},{"label":"<font size = \'23\'>进化石</font>"},{"label":"<font size = \'23\'>玩偶</font>"},{"label":"<font size = \'23\'>其他物品</font>"}]);
         tabs.x = 25;
         tabs.y = 95;
         tabs.direction = "vertical";
         backPackGoodsList = new List();
         backPackGoodsList.width = 860;
         backPackGoodsList.height = 530;
         backPackGoodsList.x = 225;
         backPackGoodsList.y = 85;
         backPackGoodsList.isSelectable = false;
         mySpr.addChild(tabs);
         mySpr.addChild(backPackGoodsList);
         tabs.addEventListener("creationComplete",setTab);
      }
      
      private function setTab(param1:Event) : void
      {
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = new Scale9Textures(swf.createImage("img_up").texture,new Rectangle(20,20,20,20));
         _loc2_.defaultSelectedValue = new Scale9Textures(swf.createImage("img_down").texture,new Rectangle(20,20,20,20));
         tabs.tabProperties.stateToSkinFunction = _loc2_.updateValue;
         tabs.gap = 12;
         tabs.maxHeight = 510;
         tabs.minWidth = 175;
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
