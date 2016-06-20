package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.controls.List;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.huntingParty.HuntNodeVO;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class HuntAdventureUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_adventure:SwfSprite;
      
      public var btn_adventure:SwfButton;
      
      public var btn_cancel:SwfButton;
      
      public var prompt:TextField;
      
      public var nodeName:TextField;
      
      public var bg:SwfScale9Image;
      
      public var list:List;
      
      public function HuntAdventureUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function addList() : void
      {
         list = new List();
         list.x = bg.x + 8;
         list.y = bg.y + 3;
         list.width = bg.width - 16;
         list.height = bg.height - 6;
         list.isSelectable = false;
         list.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_listbox").texture,new Rectangle(15,15,15,15));
         list.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         list.itemRendererProperties.maxHeight = 90;
         spr_adventure.addChild(list);
         list.addEventListener("creationComplete",creatComplete);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = 10;
         _loc1_.paddingTop = 8;
         list.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_adventure = swf.createSprite("spr_adventure");
         btn_adventure = spr_adventure.getButton("btn_adventure");
         btn_cancel = spr_adventure.getButton("btn_cancel");
         prompt = spr_adventure.getTextField("prompt");
         nodeName = spr_adventure.getTextField("nodeName");
         bg = spr_adventure.getScale9Image("bg");
         spr_adventure.x = 1136 - spr_adventure.width >> 1;
         spr_adventure.y = 640 - spr_adventure.height >> 1;
         addChild(spr_adventure);
      }
      
      public function setInfo(param1:HuntNodeVO) : void
      {
         nodeName.text = param1.name;
      }
      
      public function seticon(param1:String) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         var _loc4_:int = CalculatorFactor.natureArr.indexOf(param1);
         LogUtil("property==",param1);
         var _loc6_:Image = _loc2_.createImage("img_nature" + _loc4_);
         _loc6_.alignPivot();
         _loc6_.pivotX = _loc6_.width / 2;
         _loc6_.pivotY = _loc6_.height / 2;
         var _loc5_:Image = _loc2_.createImage("img_bg");
         _loc5_.color = CalculatorFactor.natureColor[_loc4_];
         var _loc7_:* = 40;
         _loc6_.x = _loc7_;
         _loc5_.x = _loc7_;
         _loc7_ = 35;
         _loc6_.y = _loc7_;
         _loc5_.y = _loc7_;
         _loc3_.addChild(_loc5_);
         _loc3_.addChild(_loc6_);
         return _loc3_;
      }
      
      public function removeHandle() : void
      {
      }
   }
}
