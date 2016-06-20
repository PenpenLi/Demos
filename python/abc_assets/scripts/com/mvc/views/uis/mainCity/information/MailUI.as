package com.mvc.views.uis.mainCity.information
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.mainCity.information.MailVO;
   import feathers.controls.ScrollContainer;
   import starling.text.TextField;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import com.common.managers.LoadOtherAssetsManager;
   import flash.geom.Rectangle;
   import com.common.util.GetCommon;
   import com.common.util.RewardHandle;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.display.Image;
   import feathers.layout.TiledColumnsLayout;
   
   public class MailUI extends Sprite
   {
       
      public var buyGoodsList:List;
      
      private var swf:Swf;
      
      public var spr_mail:SwfSprite;
      
      public var getBtn:SwfButton;
      
      public var delectBtn:SwfButton;
      
      public var mailList:List;
      
      private var _mailVo:MailVO;
      
      public var spr_descise:SwfSprite;
      
      public var scrollContainer:ScrollContainer;
      
      public var elfRewardNum:int;
      
      public var mailTitle:TextField;
      
      public var mailStr:TextField;
      
      public var sender:TextField;
      
      public var panel:ScrollContainer;
      
      public function MailUI()
      {
         super();
         init();
         addList();
         addContain();
         addText();
         addRewardContainer();
      }
      
      private function addText() : void
      {
         mailTitle = new TextField(510,25,"","FZCuYuan-M03S",25,5715237);
         mailStr = new TextField(510,100,"","FZCuYuan-M03S",19,5715237);
         mailStr.autoSize = "vertical";
         mailStr.hAlign = "left";
         sender = new TextField(500,50,"","FZCuYuan-M03S",25,5715237);
         sender.hAlign = "right";
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         spr_descise.addChild(panel);
         panel.width = 510;
         panel.height = 355;
         panel.y = 10;
         panel.x = 15;
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 10;
         _loc1_.useVirtualLayout = false;
         panel.scrollBarDisplayMode = "none";
         panel.horizontalScrollPolicy = "none";
         panel.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("information");
         spr_mail = swf.createSprite("spr_mail");
         spr_descise = spr_mail.getSprite("spr_descise");
         getBtn = spr_mail.getButton("getBtn");
         delectBtn = spr_mail.getButton("delectBtn");
         spr_descise.x = spr_descise.x + 10;
         addChild(spr_mail);
         var _loc1_:* = false;
         delectBtn.visible = _loc1_;
         getBtn.visible = _loc1_;
      }
      
      private function addList() : void
      {
         var _loc2_:TextFormat = new TextFormat("FZCuYuan-M03S",20,9713664);
         _loc2_.align = "left";
         mailList = new List();
         mailList.width = 250;
         mailList.height = 460;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(LoadOtherAssetsManager.getInstance().assets.getTexture("tab_btn_up"),new Rectangle(25,25,25,25));
         _loc1_.defaultSelectedValue = new Scale9Textures(LoadOtherAssetsManager.getInstance().assets.getTexture("tab_btn_down"),new Rectangle(25,25,25,25));
         mailList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         mailList.itemRendererProperties.@defaultLabelProperties.textFormat = _loc2_;
         mailList.itemRendererProperties.@defaultLabelProperties.isHTML = true;
         mailList.itemRendererProperties.gap = 4;
         mailList.itemRendererProperties.paddingLeft = 2;
         addChild(mailList);
      }
      
      public function set myMailVo(param1:MailVO) : void
      {
         panel.removeChildren();
         _mailVo = param1;
         LogUtil(param1.desc);
         mailTitle.text = param1.title;
         panel.addChild(mailTitle);
         mailStr.text = param1.desc;
         panel.addChild(mailStr);
         sender.text = param1.sender;
         panel.addChild(sender);
         scrollContainer.removeChildren(0,-1,true);
         if(GetCommon.isNullObject(param1.reward))
         {
            RewardHandle.showReward(param1.reward,scrollContainer);
            panel.addChild(scrollContainer);
         }
         switchBtn(GetCommon.isNullObject(param1.reward));
      }
      
      public function get myMailVo() : MailVO
      {
         return _mailVo;
      }
      
      public function gets9Image(param1:String) : SwfScale9Image
      {
         return swf.createS9Image(param1);
      }
      
      public function getIcon() : Image
      {
         return swf.createImage("img_icon");
      }
      
      private function switchBtn(param1:Boolean) : void
      {
         delectBtn.visible = !param1;
         getBtn.visible = param1;
      }
      
      public function addRewardContainer() : void
      {
         scrollContainer = new ScrollContainer();
         scrollContainer.x = 5;
         scrollContainer.y = 235;
         scrollContainer.width = 520;
         scrollContainer.height = 145;
         scrollContainer.verticalScrollPolicy = "off";
         var _loc1_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc1_.gap = 5;
         scrollContainer.layout = _loc1_;
      }
   }
}
