package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.huntingParty.HuntRewardVO;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalLayout;
   import com.common.util.RewardHandle;
   import lzm.starling.display.Button;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class HuntingRewardUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_reward:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var rewardList:List;
      
      private var listBg:SwfScale9Image;
      
      public var btn_help:SwfButton;
      
      public function HuntingRewardUI()
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
         rewardList = new List();
         rewardList.x = listBg.x + 8;
         rewardList.y = listBg.y + 2;
         rewardList.width = listBg.width - 16;
         rewardList.height = listBg.height - 4;
         rewardList.isSelectable = false;
         rewardList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_listbox").texture,new Rectangle(15,15,15,15));
         rewardList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         rewardList.itemRendererProperties.maxHeight = 136;
         spr_reward.addChild(rewardList);
         rewardList.addEventListener("creationComplete",creatComplete);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = 8;
         _loc1_.paddingTop = 8;
         rewardList.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_reward = swf.createSprite("spr_reward");
         btn_close = spr_reward.getButton("btn_close");
         btn_help = spr_reward.getButton("btn_help");
         listBg = spr_reward.getScale9Image("listBg");
         spr_reward.x = 1136 - spr_reward.width >> 1;
         spr_reward.y = 640 - spr_reward.height >> 1;
         addChild(spr_reward);
      }
      
      public function setIcon(param1:HuntRewardVO) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Image = swf.createImage("img_icon_titleBg");
         _loc4_.x = 5;
         _loc4_.y = -5;
         _loc3_.addChild(_loc4_);
         GetCommon.getText(_loc4_.x,_loc4_.y,_loc4_.width - 7,_loc4_.height,"累计\n" + param1.needSorce + "分","FZCuYuan-M03S",20,16777215,_loc3_,false,true,true);
         var _loc5_:ScrollContainer = new ScrollContainer();
         _loc5_.width = 570;
         _loc5_.height = 120;
         _loc5_.x = 150;
         _loc5_.y = 8;
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.verticalAlign = "middle";
         _loc2_.horizontalAlign = "left";
         _loc2_.gap = 20;
         _loc2_.useVirtualLayout = false;
         _loc5_.scrollBarDisplayMode = "none";
         _loc5_.horizontalScrollPolicy = "none";
         _loc5_.layout = _loc2_;
         _loc3_.addChild(_loc5_);
         RewardHandle.showReward(param1.rewardObj,_loc5_,0.8);
         return _loc3_;
      }
      
      public function getBtn(param1:String) : Button
      {
         return swf.createButton(param1);
      }
   }
}
