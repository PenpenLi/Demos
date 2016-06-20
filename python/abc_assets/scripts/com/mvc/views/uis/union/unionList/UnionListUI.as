package com.mvc.views.uis.union.unionList
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.components.feathers.FeathersCheck;
   import starling.text.TextField;
   import feathers.controls.List;
   import feathers.layout.HorizontalLayout;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionListUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_union:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_createUnion:SwfButton;
      
      public var btn_search:SwfButton;
      
      public var searchInput:FeathersTextInput;
      
      public var check:FeathersCheck;
      
      public var spr_listBg:SwfSprite;
      
      public var applyState:TextField;
      
      public var unionList:List;
      
      public var btn_return:SwfButton;
      
      public function UnionListUI()
      {
         super();
         init();
         addList();
      }
      
      private function addList() : void
      {
         unionList = new List();
         unionList.x = 2;
         unionList.y = 7;
         unionList.width = 906;
         unionList.height = 284;
         unionList.isSelectable = false;
         unionList.horizontalScrollPolicy = "on";
         unionList.verticalScrollPolicy = "off";
         unionList.itemRendererProperties.stateToSkinFunction = null;
         spr_listBg.addChild(unionList);
         unionList.addEventListener("creationComplete",changeHorizontalLayout);
      }
      
      private function changeHorizontalLayout() : void
      {
         unionList.removeEventListener("creationComplete",changeHorizontalLayout);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = "justify";
         unionList.layout = _loc1_;
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("union");
         spr_union = swf.createSprite("spr_union");
         btn_close = spr_union.getButton("btn_close");
         btn_createUnion = spr_union.getButton("btn_createUnion");
         btn_search = spr_union.getButton("btn_search");
         searchInput = spr_union.getChildByName("searchInput") as FeathersTextInput;
         check = spr_union.getChildByName("check") as FeathersCheck;
         spr_listBg = spr_union.getSprite("spr_listBg");
         applyState = spr_union.getTextField("applyState");
         btn_return = spr_union.getButton("btn_return");
         btn_return.visible = false;
         searchInput.width = 361;
         searchInput.height = 45;
         searchInput.paddingLeft = 15;
         searchInput.paddingTop = 7;
         searchInput.prompt = "请输入查找的公会名称";
         addChild(spr_union);
      }
      
      public function addBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
