package com.mvc.views.mediator.mainCity.playerInfo.buyDiamond
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.mainCity.playerInfo.DiamondGiftItemVO;
   import com.mvc.views.uis.mainCity.playerInfo.buyDiamond.BuyDiamondUI;
   import feathers.controls.ScrollContainer;
   import feathers.controls.Label;
   import flash.geom.Rectangle;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.text.TextFormat;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.mvc.views.uis.mainCity.playerInfo.buyDiamond.DiamondGiftItemUI;
   import lzm.starling.display.Button;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import lzm.util.LSOManager;
   import starling.display.DisplayObject;
   import com.common.util.xmlVOHandler.GetVIPLvInfo;
   import com.common.util.xmlVOHandler.GetRechargeInfo;
   
   public class BuyDiamondMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "BuyDiamondMediator";
      
      public static var privilegeVec:Vector.<String>;
      
      public static var diamondGiftVec:Vector.<DiamondGiftItemVO>;
      
      public static var isUpdateGift:Boolean;
       
      private var buyDiamondUI:BuyDiamondUI;
      
      private var scrollContainer:ScrollContainer;
      
      private var vipNum:int;
      
      private var privilegeScrollText:Label;
      
      private var vipBarWidth:Number;
      
      private var vipBarHeight:Number;
      
      private var rect:Rectangle;
      
      private var tatolDiamon:int;
      
      private var nextVipDiamon:int;
      
      private var index:int;
      
      public function BuyDiamondMediator(param1:Object = null)
      {
         rect = new Rectangle();
         super("BuyDiamondMediator",param1);
         buyDiamondUI = param1 as BuyDiamondUI;
         vipBarWidth = buyDiamondUI.VIPProgressBarSpr.width;
         vipBarHeight = buyDiamondUI.VIPProgressBarSpr.height;
         buyDiamondUI.addEventListener("triggered",buyDiamondUI_triggeredHandler);
         buyDiamondUI.switchMc.addEventListener("triggered",switch_triggeredHandler);
         privilegeVec = GetVIPLvInfo.getVIPLvInfo();
         diamondGiftVec = GetRechargeInfo.getRechargeInfo();
      }
      
      private function switch_triggeredHandler(param1:Event) : void
      {
         if(buyDiamondUI.switchMc.currentFrame == 0)
         {
            switchPrivilegeSpr();
         }
         else
         {
            switchRechargeSpr();
         }
      }
      
      private function switchPrivilegeSpr() : void
      {
         buyDiamondUI.switchMc.gotoAndStop(1);
         scrollContainer.removeFromParent();
         buyDiamondUI.buyDiamondSpr.addChild(buyDiamondUI.VIPPowerSpr);
         buyDiamondUI.privilegeSpr.visible = true;
         buyDiamondUI.rechargeSpr.visible = false;
         if(!privilegeScrollText)
         {
            createPrivilegeList();
         }
         buyDiamondUI.VIPPowerSpr.addChild(privilegeScrollText);
         changeTextAndBtn(PlayerVO.vipRank?PlayerVO.vipRank:1);
      }
      
      private function switchRechargeSpr() : void
      {
         buyDiamondUI.switchMc.gotoAndStop(0);
         buyDiamondUI.buyDiamondSpr.addChild(scrollContainer);
         buyDiamondUI.VIPPowerSpr.removeFromParent();
         buyDiamondUI.privilegeSpr.visible = false;
         buyDiamondUI.rechargeSpr.visible = true;
      }
      
      private function createPrivilegeList() : void
      {
         privilegeScrollText = new Label();
         var _loc1_:TextFormat = new TextFormat("FZCuYuan-M03S",22,4728603);
         _loc1_.align = "justify";
         privilegeScrollText.textRendererProperties.isHTML = true;
         privilegeScrollText.textRendererProperties.textFormat = _loc1_;
         privilegeScrollText.x = 230;
         privilegeScrollText.y = 270;
         privilegeScrollText.width = 530;
         privilegeScrollText.height = 280;
      }
      
      private function buyDiamondUI_triggeredHandler(param1:Event) : void
      {
         var _loc2_:int = buyDiamondUI.selectedVIPTf.text.slice(3);
         var _loc3_:* = param1.target;
         if(buyDiamondUI.buyCloseBtn !== _loc3_)
         {
            if(buyDiamondUI.leftBtn !== _loc3_)
            {
               if(buyDiamondUI.rightBtn === _loc3_)
               {
                  if(_loc2_ < vipNum)
                  {
                     _loc2_++;
                     changeTextAndBtn(_loc2_);
                  }
               }
            }
            else if(_loc2_ >= 2)
            {
               _loc2_--;
               changeTextAndBtn(_loc2_);
            }
         }
         else
         {
            WinTweens.closeWin(buyDiamondUI.buyDiamondSpr,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         buyDiamondUI.removeFromParent();
         scrollContainer.removeEventListener("triggered",scrollContainer_triggeredHandler);
         switchRechargeSpr();
      }
      
      private function changeTextAndBtn(param1:int) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < privilegeVec.length)
         {
            if(param1 - 1 == _loc2_)
            {
               privilegeScrollText.text = privilegeVec[_loc2_];
               buyDiamondUI.leftVIPTf.text = "VIP" + (param1 - 1);
               buyDiamondUI.rightVIPTf.text = "VIP" + (param1 + 1);
            }
            _loc2_++;
         }
         if(param1 == vipNum)
         {
            buyDiamondUI.selectedVIPTf.text = "VIP" + param1;
            buyDiamondUI.leftVIPTf.text = "VIP" + (param1 - 1);
            buyDiamondUI.rightVIPTf.text = "";
            buyDiamondUI.rightBtn.visible = false;
            buyDiamondUI.rightImg.visible = false;
         }
         else if(param1 > 1 && param1 < vipNum)
         {
            buyDiamondUI.selectedVIPTf.text = "VIP" + param1;
            buyDiamondUI.leftVIPTf.text = "VIP" + (param1 - 1);
            buyDiamondUI.rightVIPTf.text = "VIP" + (param1 + 1);
            buyDiamondUI.leftBtn.visible = true;
            buyDiamondUI.rightBtn.visible = true;
            buyDiamondUI.leftImg.visible = true;
            buyDiamondUI.rightImg.visible = true;
         }
         else
         {
            buyDiamondUI.selectedVIPTf.text = "VIP1";
            buyDiamondUI.rightVIPTf.text = "VIP" + (param1 + 1);
            buyDiamondUI.leftVIPTf.text = "";
            buyDiamondUI.leftBtn.visible = false;
            buyDiamondUI.leftImg.visible = false;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_diamond_recharge","update_diamond_recharge_double"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_diamond_recharge" !== _loc2_)
         {
            if("update_diamond_recharge_double" === _loc2_)
            {
               if(GetCommon.isIOSDied())
               {
                  isUpdateGift = true;
                  return;
               }
               createGift();
            }
         }
         else
         {
            buyDiamondUI.nowVIPLvTf.text = "VIP" + PlayerVO.vipRank;
            if(PlayerVO.vipRank < PlayerVO.vipInfoVO.diamondVec.length - 1)
            {
               buyDiamondUI.nextVIPLvTf.text = "VIP" + (PlayerVO.vipRank + 1);
               tatolDiamon = PlayerVO.vipExper - PlayerVO.vipInfoVO.diamondVec[PlayerVO.vipRank];
               nextVipDiamon = PlayerVO.vipInfoVO.diamondVec[PlayerVO.vipRank + 1] - PlayerVO.vipInfoVO.diamondVec[PlayerVO.vipRank];
               buyDiamondUI.cumulativeDiamondTf.text = tatolDiamon;
               buyDiamondUI.nextLvDiamondTf.text = "/" + nextVipDiamon;
               buyDiamondUI.upgradeDiamondTf.text = nextVipDiamon - tatolDiamon;
            }
            else
            {
               buyDiamondUI.nextVIPLvTf.text = "";
               buyDiamondUI.upgradeDiamondTf.text = "";
               nextVipDiamon = PlayerVO.vipInfoVO.diamondVec[PlayerVO.vipRank] - PlayerVO.vipInfoVO.diamondVec[PlayerVO.vipRank - 1];
               tatolDiamon = nextVipDiamon;
               buyDiamondUI.cumulativeDiamondTf.text = tatolDiamon;
               buyDiamondUI.nextLvDiamondTf.text = "/" + nextVipDiamon;
               buyDiamondUI.tfImg.visible = false;
            }
            updateVIPProgressBar();
            createGift();
         }
      }
      
      private function updateVIPProgressBar() : void
      {
         LogUtil(vipBarHeight + " diamond " + vipBarWidth);
         buyDiamondUI.VIPProgressBarSpr.visible = true;
         var _loc1_:Number = tatolDiamon / nextVipDiamon;
         if(_loc1_ == 0)
         {
            buyDiamondUI.VIPProgressBarSpr.visible = false;
         }
         else
         {
            rect.width = vipBarWidth * _loc1_;
            rect.height = vipBarHeight;
            buyDiamondUI.VIPProgressBarSpr.clipRect = rect;
         }
      }
      
      private function createGift() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         if(scrollContainer)
         {
            scrollContainer.removeChildren(0,-1,true);
            scrollContainer = null;
         }
         if(!scrollContainer)
         {
            scrollContainer = new ScrollContainer();
            scrollContainer.x = 25;
            scrollContainer.y = 178;
            scrollContainer.width = 800;
            scrollContainer.height = 360;
            vipNum = privilegeVec.length;
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < diamondGiftVec.length)
            {
               _loc3_ = new DiamondGiftItemUI();
               if(!PlayerVO.rechargeIdArr || PlayerVO.rechargeIdArr.indexOf(diamondGiftVec[_loc2_].id) != -1)
               {
                  _loc3_.doubleIcon.visible = false;
               }
               if(!PlayerVO.rechargeIdArr || PlayerVO.rechargeIdArr.indexOf(diamondGiftVec[_loc2_].id) != -1)
               {
                  _loc3_.giftBagInfoTf.text = "";
               }
               else if(PlayerVO.rechargeIdArr.indexOf(diamondGiftVec[_loc2_].id) == -1)
               {
                  _loc3_.giftBagInfoTf.text = diamondGiftVec[_loc2_].rechargeExplain;
               }
               if(diamondGiftVec[_loc2_].id == 10)
               {
                  _loc3_.giftBagInfoTf.text = diamondGiftVec[_loc2_].rechargeExplain;
               }
               _loc3_.giftBagNameTf.text = diamondGiftVec[_loc2_].title;
               _loc3_.giftBagPriceTf.text = "￥" + diamondGiftVec[_loc2_].rmb;
               _loc3_.diamondItemBtn.name = _loc2_.toString();
               _loc3_.name = diamondGiftVec[_loc2_].id;
               _loc3_.formSpr.addChild(diamondGiftVec[_loc2_].picture);
               diamondGiftVec[_loc2_].picture.x = _loc3_.formSpr.width - diamondGiftVec[_loc2_].picture.width + 7 >> 1;
               diamondGiftVec[_loc2_].picture.y = _loc3_.formSpr.height - diamondGiftVec[_loc2_].picture.height + 7 >> 1;
               if(_loc2_ % 2 == 0 && _loc2_ != 0)
               {
                  _loc1_ = _loc1_ + 1;
               }
               _loc3_.x = 400 * (_loc2_ % 2);
               _loc3_.y = 118 * _loc1_;
               scrollContainer.addChild(_loc3_);
               _loc2_++;
            }
            buyDiamondUI.buyDiamondSpr.addChild(scrollContainer);
         }
         scrollContainer.scrollToPosition(0,0);
         scrollContainer.addEventListener("triggered",scrollContainer_triggeredHandler);
      }
      
      private function scrollContainer_triggeredHandler(param1:Event) : void
      {
         if(scrollContainer.isScrolling)
         {
            return;
         }
         index = (param1.target as Button).name;
         LogUtil("礼包价格: " + diamondGiftVec[index].rmb,diamondGiftVec[index].getDiamond);
         if(diamondGiftVec[index].isLimit)
         {
            if(diamondGiftVec[index].limit <= 0)
            {
               Tips.show("超过限制购买次数");
               return;
            }
         }
         var _loc2_:Alert = Alert.show("是否购买" + diamondGiftVec[index].title + "?","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
         _loc2_.addEventListener("close",buyDiamondSureHandler);
      }
      
      private function buyDiamondSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            LogUtil("diamondGiftVec[index].id == ",diamondGiftVec[index].id);
            Pocketmon.sdkTool.pay(diamondGiftVec[index].rmb,diamondGiftVec[index].getDiamond,diamondGiftVec[index].id,LSOManager.get("SERVERID"),PlayerVO.userId);
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("BuyDiamondMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
