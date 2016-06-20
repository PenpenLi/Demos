package com.mvc.views.mediator.mainCity.scoreShop
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreShopUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.shop.SaleTrashyProp;
   import com.mvc.views.uis.mainCity.scoreShop.FreeShopGoodsBtn;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreShopGoodsBtnUI;
   import lzm.util.TimeUtil;
   import starling.display.DisplayObject;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreShopNpcTips;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ScoreShopMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ScoreShopMediator";
      
      public static var selectedGoodsIndex:int;
      
      public static var nowType:String;
      
      public static var disCountActTime:int;
       
      public var pvpShopUI:ScoreShopUI;
      
      private var typeArr:Array;
      
      private var typeIndex:int;
      
      private var nextNeedScore:int;
      
      private var nowRefreshTimes:int;
      
      public function ScoreShopMediator(param1:Object = null)
      {
         typeArr = ["PVPBgMediator","KingKwanMedia","ElfSeriesMedia","MainCityMedia","ShopMedia"];
         super("ScoreShopMediator",param1);
         pvpShopUI = param1 as ScoreShopUI;
         pvpShopUI.addEventListener("triggered",triggeredHandler);
         caculateTypeIndex();
      }
      
      private function caculateTypeIndex() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < typeArr.length)
         {
            if(typeArr[_loc1_] == nowType)
            {
               typeIndex = _loc1_;
               break;
            }
            _loc1_++;
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpShopUI.btn_close !== _loc2_)
         {
            if(pvpShopUI.btn_shopRefresh !== _loc2_)
            {
               if(pvpShopUI.btn_shopLeftBtn !== _loc2_)
               {
                  if(pvpShopUI.btn_shopRightBtn !== _loc2_)
                  {
                     if(pvpShopUI.btn_freeBtn === _loc2_)
                     {
                        pvpShopUI.spr_pvpShop.removeFromParent();
                        sendNotification("switch_win",null,"load_freeshop_select_com_elf");
                     }
                  }
                  else
                  {
                     if(typeIndex < typeArr.length - 1)
                     {
                        typeIndex = §§dup(typeIndex + 1);
                        nowType = typeArr[typeIndex + 1];
                     }
                     else if(typeIndex == typeArr.length - 1)
                     {
                        nowType = typeArr[0];
                        typeIndex = 0;
                     }
                     switchShopType();
                  }
               }
               else
               {
                  if(typeIndex > 0)
                  {
                     typeIndex = §§dup(typeIndex - 1);
                     nowType = typeArr[typeIndex - 1];
                  }
                  else if(typeIndex == 0)
                  {
                     nowType = typeArr[typeArr.length - 1];
                     typeIndex = typeArr.length - 1;
                  }
                  switchShopType();
               }
            }
            else
            {
               if(nowRefreshTimes <= 0)
               {
                  Tips.show("亲，您所在的商店刷新次数用完啦。");
                  return;
               }
               showRefreshAlert();
            }
         }
         else
         {
            pvpShopUI.removeGoodsBtn();
            WinTweens.closeWin(pvpShopUI.spr_pvpShop,removeWindow);
         }
      }
      
      private function clickShopReFreshBtn() : void
      {
         var _loc1_:* = nowType;
         if("PVPBgMediator" !== _loc1_)
         {
            if("KingKwanMedia" !== _loc1_)
            {
               if("ElfSeriesMedia" !== _loc1_)
               {
                  if("MainCityMedia" !== _loc1_)
                  {
                     if("ShopMedia" === _loc1_)
                     {
                        if(PlayerVO.diamond < nextNeedScore)
                        {
                           Tips.show("钻石不足哦。");
                           return;
                        }
                        (facade.retrieveProxy("ShopPro") as ShopPro).write3603();
                     }
                  }
                  else
                  {
                     if(PlayerVO.fsDot < nextNeedScore)
                     {
                        Tips.show("神秘商店积分不足哦。");
                        return;
                     }
                     (facade.retrieveProxy("HomePro") as HomePro).write2803();
                  }
               }
               else
               {
                  if(PlayerVO.rkDot < nextNeedScore)
                  {
                     Tips.show("联盟大赛对站点不足哦。");
                     return;
                  }
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5022();
               }
            }
            else
            {
               if(PlayerVO.kwDot < nextNeedScore)
               {
                  Tips.show("王者之路对站点不足哦。");
                  return;
               }
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2312();
            }
         }
         else
         {
            if(PlayerVO.pvDot < nextNeedScore)
            {
               Tips.show("pvp对站点不足哦。");
               return;
            }
            (facade.retrieveProxy("PVPPro") as PVPPro).write6252();
         }
      }
      
      private function showRefreshAlert() : void
      {
         var _loc1_:String = nowType == "ShopMedia"?"钻石":"积分";
         var _loc2_:Alert = Alert.show("亲，是否消耗" + nextNeedScore + _loc1_ + "刷新？您还有" + nowRefreshTimes + "次刷新机会。","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
         _loc2_.addEventListener("close",isRefreshAlert_closeHandler);
      }
      
      private function isRefreshAlert_closeHandler(param1:Event) : void
      {
         if(param1.data.label == "好的")
         {
            clickShopReFreshBtn();
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         if((Starling.current.root as Game).page is MainCityUI)
         {
            WinTweens.showCity();
            dispose();
         }
         pvpShopUI.removeFromParent();
         sendNotification("add_pvp");
         sendNotification("show_king_main");
         sendNotification("show_elfseries_after_shop");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("show_score_shop_goods" !== _loc3_)
         {
            if("update_score_shop" !== _loc3_)
            {
               if("update_score_shop_scoreTf" !== _loc3_)
               {
                  if("freeshop_close_select_elf" !== _loc3_)
                  {
                     if("update_score_less_time" === _loc3_)
                     {
                        if(ScoreShopMediator.disCountActTime > 0)
                        {
                           pvpShopUI.tf_discount.visible = true;
                           pvpShopUI.tf_discount.text = "折扣结束" + TimeUtil.convertStringToDate(ScoreShopMediator.disCountActTime);
                        }
                        else
                        {
                           pvpShopUI.tf_discount.visible = false;
                           switchShopType();
                        }
                     }
                  }
                  else
                  {
                     pvpShopUI.tf_allFightDot.text = PlayerVO.fsDot;
                     pvpShopUI.addChild(pvpShopUI.spr_pvpShop);
                  }
               }
               else
               {
                  updateAllFD(param1.getBody());
               }
            }
            else if(nowType == "MainCityMedia")
            {
               (pvpShopUI.goodsBtnVec[selectedGoodsIndex] as FreeShopGoodsBtn).addMask();
            }
            else
            {
               (pvpShopUI.goodsBtnVec[selectedGoodsIndex] as ScoreShopGoodsBtnUI).addMask();
            }
         }
         else
         {
            _loc2_ = param1.getBody();
            nextNeedScore = _loc2_.nextNeedScore;
            nowRefreshTimes = _loc2_.nowRefreshTimes;
            pvpShopUI.addShopTittle(nowType);
            if(_loc2_.flushTime != null)
            {
               pvpShopUI.spr_countDown.visible = true;
               pvpShopUI.tf_refreshTip.visible = false;
               pvpShopUI.startFreeTimer(_loc2_.flushTime);
            }
            else
            {
               pvpShopUI.tf_refreshTip.visible = true;
               pvpShopUI.spr_countDown.visible = false;
               pvpShopUI.stopFreeTimer();
            }
            if(nowType == "ShopMedia")
            {
               pvpShopUI.tf_refreshTip.text = "每天12，18点刷新";
            }
            else
            {
               pvpShopUI.tf_refreshTip.text = "每天21:00自动刷新";
            }
            if(nowType == "MainCityMedia")
            {
               pvpShopUI.createFreeDescSpr();
               pvpShopUI.showFreeGoods(nowType,_loc2_.goods);
            }
            else
            {
               if(pvpShopUI.spr_freeDesc)
               {
                  pvpShopUI.spr_freeDesc.removeFromParent(true);
                  pvpShopUI.spr_freeDesc = null;
               }
               pvpShopUI.showGoods(nowType,_loc2_.goods);
            }
            if(PlayerVO.trashyPropVec.length != 0)
            {
               SaleTrashyProp.getInstance().showWin();
            }
         }
      }
      
      private function updateAllFD(param1:int) : void
      {
         var _loc2_:* = nowType;
         if("PVPBgMediator" !== _loc2_)
         {
            if("KingKwanMedia" !== _loc2_)
            {
               if("ElfSeriesMedia" !== _loc2_)
               {
                  if("MainCityMedia" !== _loc2_)
                  {
                     if("ShopMedia" === _loc2_)
                     {
                        PlayerVO.diamond = param1;
                        pvpShopUI.tf_allFightDot.text = PlayerVO.diamond;
                        sendNotification("update_play_diamond_info",param1);
                     }
                  }
                  else
                  {
                     PlayerVO.fsDot = param1;
                     pvpShopUI.tf_allFightDot.text = PlayerVO.fsDot;
                  }
               }
               else
               {
                  PlayerVO.rkDot = param1;
                  pvpShopUI.tf_allFightDot.text = PlayerVO.rkDot;
               }
            }
            else
            {
               PlayerVO.kwDot = param1;
               pvpShopUI.tf_allFightDot.text = PlayerVO.kwDot;
            }
         }
         else
         {
            PlayerVO.pvDot = param1;
            pvpShopUI.tf_allFightDot.text = PlayerVO.pvDot;
         }
      }
      
      private function switchShopType() : void
      {
         ScoreShopMediator.disCountActTime = 0;
         pvpShopUI.tf_discount.visible = false;
         var _loc1_:* = nowType;
         if("PVPBgMediator" !== _loc1_)
         {
            if("KingKwanMedia" !== _loc1_)
            {
               if("ElfSeriesMedia" !== _loc1_)
               {
                  if("MainCityMedia" !== _loc1_)
                  {
                     if("ShopMedia" === _loc1_)
                     {
                        (facade.retrieveProxy("ShopPro") as ShopPro).write3601();
                     }
                  }
                  else
                  {
                     (facade.retrieveProxy("HomePro") as HomePro).write2801();
                  }
               }
               else
               {
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5020();
               }
            }
            else
            {
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2310();
            }
         }
         else
         {
            (facade.retrieveProxy("PVPPro") as PVPPro).write6250();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["show_score_shop_goods","update_score_shop","update_score_shop_scoreTf","freeshop_close_select_elf","update_score_less_time"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            pvpShopUI.spr_pvpShop.removeFromParent(true);
         }
         if(Facade.getInstance().hasMediator("FreeSelectElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("FreeSelectElfMediator") as FreeSelectElfMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ScoreGoodsInfoMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreGoodsInfoMediator") as ScoreGoodsInfoMediator).dispose();
         }
         pvpShopUI.stopFreeTimer();
         pvpShopUI.removeGoodsBtn();
         if(ScoreShopNpcTips.instance)
         {
            ScoreShopNpcTips.getInstance().destructSelf();
         }
         facade.removeMediator("ScoreShopMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.scoreShopAssets);
      }
   }
}
