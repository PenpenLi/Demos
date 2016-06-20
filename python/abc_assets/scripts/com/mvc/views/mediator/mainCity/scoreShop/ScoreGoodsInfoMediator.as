package com.mvc.views.mediator.mainCity.scoreShop
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.scoreShop.ScoreGoodInfoUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class ScoreGoodsInfoMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ScoreGoodsInfoMediator";
       
      public var pvpGoodInfoUI:ScoreGoodInfoUI;
      
      private var selectGoodsId:int;
      
      private var nowType:String;
      
      public function ScoreGoodsInfoMediator(param1:Object = null)
      {
         super("ScoreGoodsInfoMediator",param1);
         pvpGoodInfoUI = param1 as ScoreGoodInfoUI;
         pvpGoodInfoUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpGoodInfoUI.btn_close !== _loc2_)
         {
            if(pvpGoodInfoUI.btn_exChangeBtn === _loc2_)
            {
               clickExChangeBtn();
            }
         }
         else
         {
            WinTweens.closeWin(pvpGoodInfoUI.spr_goodsInfo,removeWindow);
         }
      }
      
      private function clickExChangeBtn() : void
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
                        if(pvpGoodInfoUI.tf_needFightDot.text > PlayerVO.diamond)
                        {
                           Tips.show("钻石不足哦。");
                           return;
                        }
                        (facade.retrieveProxy("ShopPro") as ShopPro).write3602(selectGoodsId);
                     }
                  }
                  else
                  {
                     if(pvpGoodInfoUI.tf_needFightDot.text > PlayerVO.fsDot)
                     {
                        Tips.show("神秘商店积分不足哦。");
                        return;
                     }
                     (facade.retrieveProxy("HomePro") as HomePro).write2802(selectGoodsId);
                  }
               }
               else
               {
                  if(pvpGoodInfoUI.tf_needFightDot.text > PlayerVO.rkDot)
                  {
                     Tips.show("联盟大赛对战点不足哦。");
                     return;
                  }
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5021(selectGoodsId);
               }
            }
            else
            {
               if(pvpGoodInfoUI.tf_needFightDot.text > PlayerVO.kwDot)
               {
                  Tips.show("王者之路对战点不足哦。");
                  return;
               }
               (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2311(selectGoodsId);
            }
         }
         else
         {
            if(pvpGoodInfoUI.tf_needFightDot.text > PlayerVO.pvDot)
            {
               Tips.show("pvp对战点不足哦。");
               return;
            }
            (facade.retrieveProxy("PVPPro") as PVPPro).write6251(selectGoodsId);
         }
      }
      
      private function removeWindow() : void
      {
         pvpGoodInfoUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("send_score_goods_info" !== _loc3_)
         {
            if("remove_score_goods" === _loc3_)
            {
               pvpGoodInfoUI.removeFromParent();
            }
         }
         else
         {
            _loc2_ = param1.getBody();
            pvpGoodInfoUI.propVO = _loc2_.goodsVO;
            if(ScoreShopMediator.disCountActTime > 0)
            {
               pvpGoodInfoUI.setNumAndDot(_loc2_.num,_loc2_.discount);
            }
            else
            {
               pvpGoodInfoUI.setNumAndDot(_loc2_.num,_loc2_.price);
            }
            pvpGoodInfoUI.showScoreImg(_loc2_.shopType);
            selectGoodsId = _loc2_.goodsId;
            nowType = _loc2_.shopType;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["send_score_goods_info","remove_score_goods"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("ScoreGoodsInfoMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
