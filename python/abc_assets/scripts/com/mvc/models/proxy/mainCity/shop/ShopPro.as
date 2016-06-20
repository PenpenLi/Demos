package com.mvc.models.proxy.mainCity.shop
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.net.Client;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetVIP;
   import com.mvc.views.mediator.mainCity.playerInfo.buyPower.BuyPowerMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.buyMoney.BuyMoneyMediator;
   import com.mvc.views.mediator.mainCity.playerInfo.buyDiamond.BuyDiamondMediator;
   import com.common.util.xmlVOHandler.GetRechargeInfo;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.views.uis.mainCity.shop.SaleTrashyProp;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   
   public class ShopPro extends Proxy
   {
      
      public static const NAME:String = "ShopPro";
      
      public static var medicineVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var elfBallVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var otherPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var diamondPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
       
      private var client:Client;
      
      private var _propVo:PropVO;
      
      private var _count:int;
      
      public function ShopPro(param1:Object = null)
      {
         super("ShopPro",param1);
         client = Client.getInstance();
         client.addCallObj("note3301",this);
         client.addCallObj("note3304",this);
         client.addCallObj("note3306",this);
         client.addCallObj("note3308",this);
         client.addCallObj("note3310",this);
         client.addCallObj("note3311",this);
         client.addCallObj("note3312",this);
         client.addCallObj("note3601",this);
         client.addCallObj("note3602",this);
         client.addCallObj("note3603",this);
      }
      
      public function write3301() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3301;
         client.sendBytes(_loc1_);
      }
      
      public function note3301(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         LogUtil("3301=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.limitArr)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.data.limitArr.length)
               {
                  _loc4_ = 0;
                  while(_loc4_ < diamondPropVec.length)
                  {
                     if(param1.data.limitArr[_loc2_].pId == diamondPropVec[_loc4_].id)
                     {
                        diamondPropVec[_loc4_].dayBuyCount = param1.data.limitArr[_loc2_].times;
                     }
                     _loc4_++;
                  }
                  _loc2_++;
               }
            }
            if(param1.data.notSellPro)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.data.notSellPro.length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < diamondPropVec.length)
                  {
                     if(param1.data.notSellPro[_loc5_] == diamondPropVec[_loc3_].id)
                     {
                        diamondPropVec[_loc3_].isDiamondSale = false;
                     }
                     _loc3_++;
                  }
                  _loc5_++;
               }
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3304(param1:PropVO, param2:int) : void
      {
         _propVo = param1;
         _count = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 3304;
         _loc3_.pId = param1.id;
         _loc3_.num = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3304(param1:Object) : void
      {
         LogUtil("3304=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("出售成功");
            GetPropFactor.addOrLessProp(_propVo,false,_count);
            sendNotification("update_play_money_info",param1.data.silver);
            sendNotification("SHOW_SALE_LIST");
            sendNotification("UPDATA_SELL_LIST");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3306(param1:PropVO, param2:int) : void
      {
         LogUtil("write3306=" + param1.id,param2);
         _propVo = param1;
         _count = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 3306;
         _loc3_.mallId = param1.id;
         _loc3_.num = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3306(param1:Object) : void
      {
         LogUtil("3306==" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("update_play_money_info",param1.data.silver);
            GetPropFactor.addOrLessProp(_propVo,true,_count);
            Tips.show("购买成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3311(param1:int, param2:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3311;
         _loc3_.mallId = param1;
         _loc3_.num = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3311(param1:Object) : void
      {
         LogUtil("3311=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3312(param1:PropVO, param2:int) : void
      {
         _propVo = param1;
         _count = param2;
         LogUtil("_count==" + _count);
         var _loc3_:Object = {};
         _loc3_.msgId = 3312;
         _loc3_.mallId = param1.id;
         _loc3_.num = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3312(param1:Object) : void
      {
         LogUtil("note3312=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("购买成功");
            UmengExtension.getInstance().UMAnalysic("buy|" + _propVo.id + "|" + _count + "|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
            LogUtil("_count==" + _count);
            GetPropFactor.addOrLessProp(_propVo,true,_count,true);
            if(_propVo.dayBuyCount > 0)
            {
               _propVo.dayBuyCount = _propVo.dayBuyCount - _count;
               sendNotification("update_list_after_buy_diamond_goods");
            }
         }
      }
      
      public function write3308() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3308;
         client.sendBytes(_loc1_);
      }
      
      public function note3308(param1:Object) : void
      {
         LogUtil("3308=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("购买钻石成功");
            if(!PlayerVO.vipRank)
            {
               PlayerVO.vipRank = param1.data.vipInfo.vipLv;
               sendNotification("switch_page","SHOW_PLAYERINFO","0");
            }
            PlayerVO.diamond = param1.data.diamond;
            PlayerVO.vipRank = param1.data.vipInfo.vipLv;
            PlayerVO.vipExper = param1.data.vipInfo.vipExp;
            sendNotification("update_play_info_bar");
            sendNotification("update_diamond_recharge");
            PlayerVO.vipInfoVO = GetVIP.getVIP(param1.data.vipInfo.vipLv);
            PlayerVO.vipInfoVO.remainAlliance = param1.data.vipInfo.alliance;
            PlayerVO.vipInfoVO.remainBuyAcFr = param1.data.vipInfo.buyAcFr;
            PlayerVO.vipInfoVO.remainGoldFinger = param1.data.vipInfo.goldFinger;
            PlayerVO.vipInfoVO.remainPmCenter = param1.data.vipInfo.pmCenter;
            PlayerVO.vipInfoVO.remainSweep = param1.data.vipInfo.sweep;
            BuyPowerMediator.useTimes = PlayerVO.vipInfoVO.buyAcFr - PlayerVO.vipInfoVO.remainBuyAcFr;
            LogUtil("充值后兑换体力当前已用次数useTimes: " + BuyPowerMediator.useTimes);
            BuyMoneyMediator.useTimes = PlayerVO.vipInfoVO.goldFinger - PlayerVO.vipInfoVO.remainGoldFinger;
            §§dup(PlayerVO).payCount++;
            if(!BuyDiamondMediator.diamondGiftVec)
            {
               BuyDiamondMediator.diamondGiftVec = GetRechargeInfo.getRechargeInfo();
            }
            if(param1.data.productId == BuyDiamondMediator.diamondGiftVec[0].id)
            {
               if(!PlayerVO.isBuyMonCard)
               {
                  PlayerVO.monCardNum = 30;
               }
               PlayerVO.isBuyMonCard = true;
            }
            if(PlayerVO.rechargeIdArr && PlayerVO.rechargeIdArr.indexOf(param1.data.productId) == -1)
            {
               PlayerVO.rechargeIdArr.push(param1.data.productId);
               sendNotification("update_diamond_recharge_double");
            }
            if(PlayerVO.payCount == 1)
            {
               sendNotification("UPDATE_SELETE_BTN");
            }
            if(facade.hasMediator("DiamondUpMediator"))
            {
               sendNotification("update_diamondup_diamond");
            }
            if(facade.hasMediator("DayRechargeMediator"))
            {
               (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1908();
            }
            if(facade.hasMediator("AmuseMedia") && PlayerVO.vipRank >= 10)
            {
               sendNotification("amuse_open_three");
            }
            if(facade.hasMediator("LotteryMedia"))
            {
               sendNotification("LOAD_LOTTERY_CLICKBTN");
            }
         }
      }
      
      public function write3310(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3310;
         _loc2_.propIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3310(param1:Object) : void
      {
         var _loc2_:* = 0;
         LogUtil("note3310=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("出售商品成功");
            SaleTrashyProp.getInstance().closeWin();
            _loc2_ = PlayerVO.trashyPropVec.length - 1;
            while(_loc2_ >= 0)
            {
               GetPropFactor.addOrLessProp(PlayerVO.trashyPropVec[_loc2_],false,PlayerVO.trashyPropVec[_loc2_].count);
               _loc2_--;
            }
            sendNotification("update_play_money_info",param1.data.silver);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3601() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3601;
         client.sendBytes(_loc1_);
      }
      
      public function note3601(param1:Object) : void
      {
         LogUtil("note3601: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               ScoreShopMediator.disCountActTime = param1.data.time;
               sendNotification("show_score_shop_goods",param1.data);
               sendNotification("update_score_shop_scoreTf",param1.data.diamond);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3602(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3602;
         _loc2_.goodsId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3602(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("note3602=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功。");
            sendNotification("remove_score_goods");
            sendNotification("update_score_shop");
            if(param1.data.goods)
            {
               if(param1.data.goods.spirites)
               {
                  _loc4_ = param1.data.goods.spirites;
                  _loc3_ = GetElfFromSever.getElfInfo(_loc4_);
                  GetElfFactor.bagOrCom(_loc3_);
                  IllustrationsPro.saveElfInfo(_loc3_);
               }
               if(param1.data.goods.props)
               {
                  _loc2_ = GetPropFactor.getPropVO(param1.data.goods.props.pId);
                  _loc2_.rewardCount = param1.data.goods.props.num;
                  GetPropFactor.addOrLessProp(_loc2_,true,_loc2_.rewardCount,true);
                  UmengExtension.getInstance().UMAnalysic("buy|" + _loc2_.id + "|" + _loc2_.rewardCount + "|" + (PlayerVO.diamond - param1.data.diamond));
               }
            }
            sendNotification("update_score_shop_scoreTf",param1.data.diamond);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write3603() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3603;
         client.sendBytes(_loc1_);
      }
      
      public function note3603(param1:Object) : void
      {
         LogUtil("note3603=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
            }
            sendNotification("update_score_shop_scoreTf",param1.data.diamond);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
   }
}
