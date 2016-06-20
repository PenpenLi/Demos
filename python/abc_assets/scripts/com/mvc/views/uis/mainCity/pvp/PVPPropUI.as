package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import feathers.controls.TabBar;
   import feathers.controls.List;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.data.ListCollection;
   
   public class PVPPropUI extends Sprite
   {
       
      public var tabs:TabBar;
      
      public var pvpPropList:List;
      
      public var closeBtn:Button;
      
      private var swf:Swf;
      
      public var mySpr:SwfSprite;
      
      public var btn_carry:SwfButton;
      
      private var line:SwfImage;
      
      public function PVPPropUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         mySpr = swf.createSprite("spr_main");
         closeBtn = mySpr.getButton("btn_close");
         btn_carry = swf.createButton("btn_carry_b");
         line = mySpr.getImage("line");
         line.visible = false;
         mySpr.x = 1136 - mySpr.width >> 1;
         mySpr.y = 640 - mySpr.height >> 1;
         addChild(mySpr);
         initBackPackGoodsList();
      }
      
      private function initBackPackGoodsList() : void
      {
         tabs = new TabBar();
         tabs.dataProvider = new ListCollection([{"label":"携带物"},{"label":"树果"}]);
         tabs.x = 22;
         tabs.y = 90;
         pvpPropList = new List();
         pvpPropList.width = 1060;
         pvpPropList.height = 430;
         pvpPropList.x = 22;
         pvpPropList.y = 165;
         pvpPropList.isSelectable = false;
         mySpr.addChild(tabs);
         mySpr.addChild(pvpPropList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
