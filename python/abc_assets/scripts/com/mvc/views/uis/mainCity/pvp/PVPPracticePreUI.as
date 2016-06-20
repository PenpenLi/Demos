package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import starling.display.Image;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.utils.AssetManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class PVPPracticePreUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_practicePrepare:SwfSprite;
      
      public var quickStartBtn:SwfButton;
      
      public var createRoomBtn:SwfButton;
      
      public var leftBtn:SwfButton;
      
      public var rightBtn:SwfButton;
      
      public var searchBtn:SwfButton;
      
      public var refreshBtn:SwfButton;
      
      public var lvTf:TextField;
      
      public var nameTf:TextField;
      
      public var pageNumTf:TextField;
      
      public var inputSearch:FeathersTextInput;
      
      private var headImg:Image;
      
      public var roomList:List;
      
      public function PVPPracticePreUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_practicePrepare = swf.createSprite("spr_practicePrepare");
         addChild(spr_practicePrepare);
         quickStartBtn = spr_practicePrepare.getChildByName("quickStartBtn") as SwfButton;
         createRoomBtn = spr_practicePrepare.getChildByName("createRoomBtn") as SwfButton;
         leftBtn = spr_practicePrepare.getChildByName("leftBtn") as SwfButton;
         rightBtn = spr_practicePrepare.getChildByName("rightBtn") as SwfButton;
         searchBtn = spr_practicePrepare.getChildByName("searchBtn") as SwfButton;
         refreshBtn = spr_practicePrepare.getChildByName("refreshBtn") as SwfButton;
         lvTf = spr_practicePrepare.getChildByName("lvTf") as TextField;
         nameTf = spr_practicePrepare.getChildByName("nameTf") as TextField;
         nameTf.fontName = "1";
         pageNumTf = spr_practicePrepare.getChildByName("pageNumTf") as TextField;
         pageNumTf.text = "第1页";
         inputSearch = spr_practicePrepare.getChildByName("inputSearch") as FeathersTextInput;
         inputSearch.prompt = "请输入房号";
         inputSearch.maxChars = 6;
         inputSearch.restrict = "0-9";
         roomList = new List();
         roomList.x = 385;
         roomList.y = 85;
         roomList.width = 660;
         roomList.isSelectable = false;
         roomList.itemRendererProperties.height = 65;
         roomList.addEventListener("creationComplete",roomList_createHandler);
         spr_practicePrepare.addChild(roomList);
         addPlayerInfo();
      }
      
      private function roomList_createHandler(param1:Event) : void
      {
         var _loc2_:AssetManager = LoadOtherAssetsManager.getInstance().assets;
         var _loc3_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc3_.defaultValue = new Scale9Textures(_loc2_.getTexture("alertBg"),new Rectangle(8,8,8,8));
         _loc3_.defaultSelectedValue = new Scale9Textures(_loc2_.getTexture("alertBg"),new Rectangle(8,8,8,8));
         roomList.itemRendererProperties.stateToSkinFunction = _loc3_.updateValue;
      }
      
      private function addPlayerInfo() : void
      {
         headImg = GetPlayerRelatedPicFactor.getHeadPic(PlayerVO.headPtId);
         headImg.x = 175;
         headImg.y = 100;
         spr_practicePrepare.addChild(headImg);
         lvTf.text = "Lv:" + PlayerVO.lv;
         nameTf.text = PlayerVO.nickName;
      }
      
      public function createAddBtn() : SwfButton
      {
         return swf.createButton("btn_addBtn_b") as SwfButton;
      }
      
      public function createClockImg() : Image
      {
         return swf.createImage("img_clock") as Image;
      }
   }
}
