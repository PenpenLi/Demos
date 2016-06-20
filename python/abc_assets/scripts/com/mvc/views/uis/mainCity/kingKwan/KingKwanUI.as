package com.mvc.views.uis.mainCity.kingKwan
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.ScrollContainer;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import lzm.starling.swf.display.SwfScale9Image;
   
   public class KingKwanUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_KingBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_reStart:SwfButton;
      
      public var btn_help:SwfButton;
      
      public var btn_exChangeScore:SwfButton;
      
      public var count:TextField;
      
      private var panel:ScrollContainer;
      
      public var kingList:List;
      
      public var spr_king:SwfSprite;
      
      public var btn_kingMopUp:SwfButton;
      
      public function KingKwanUI()
      {
         super();
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("kingKwan");
         spr_KingBg = swf.createSprite("spr_KingBg");
         spr_king = spr_KingBg.getSprite("spr_king");
         btn_close = spr_king.getButton("btn_close");
         btn_reStart = spr_king.getButton("btn_reStart");
         btn_help = spr_king.getButton("btn_help");
         btn_exChangeScore = spr_king.getButton("btn_exChangeScore");
         count = spr_king.getTextField("count");
         btn_kingMopUp = spr_king.getButton("btn_kingMopUp");
         btn_kingMopUp.visible = false;
         addChild(spr_KingBg);
      }
      
      private function addList() : void
      {
         kingList = new List();
         kingList.width = 940;
         kingList.height = 348;
         kingList.x = 40;
         kingList.y = 148;
         kingList.isSelectable = false;
         kingList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_backdrop4").texture,new Rectangle(15,15,15,15));
         kingList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         kingList.itemRendererProperties.paddingTop = 9;
         kingList.itemRendererProperties.paddingBottom = 10;
         spr_king.addChild(kingList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
      
      public function getList(param1:String) : SwfScale9Image
      {
         return swf.createS9Image("s9_backdrop4");
      }
   }
}
