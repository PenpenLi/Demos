package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.controls.List;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class HuntingBagUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_bag:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var bg:SwfScale9Image;
      
      public var bagList:List;
      
      public function HuntingBagUI()
      {
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty1"));
         var _loc2_:* = 1.3;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function addList() : void
      {
         bagList = new List();
         bagList.x = bg.x + 8;
         bagList.y = bg.y + 3;
         bagList.width = bg.width - 16;
         bagList.height = bg.height - 6;
         bagList.isSelectable = false;
         bagList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_listbox").texture,new Rectangle(15,15,15,15));
         bagList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         spr_bag.addChild(bagList);
         bagList.addEventListener("creationComplete",creatComplete);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = 8;
         _loc1_.paddingTop = 8;
         bagList.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_bag = swf.createSprite("spr_bag");
         btn_close = spr_bag.getButton("btn_close");
         bg = spr_bag.getScale9Image("bg");
         spr_bag.x = 1136 - spr_bag.width >> 1;
         spr_bag.y = 640 - spr_bag.height >> 1;
         addChild(spr_bag);
      }
      
      public function setInfo() : void
      {
      }
      
      public function removeHandle() : void
      {
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
