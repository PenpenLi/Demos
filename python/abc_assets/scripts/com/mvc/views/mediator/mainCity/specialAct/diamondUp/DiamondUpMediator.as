package com.mvc.views.mediator.mainCity.specialAct.diamondUp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.specialAct.diamondUp.DiamondUpUI;
   import starling.events.Event;
   import com.mvc.models.vos.mainCity.specialAct.DiaMarkUpVO;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.util.TimeUtil;
   import starling.display.DisplayObject;
   import com.common.util.WinTweens;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class DiamondUpMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "DiamondUpMediator";
       
      public var diamondUpUI:DiamondUpUI;
      
      public function DiamondUpMediator(param1:Object = null)
      {
         super("DiamondUpMediator",param1);
         diamondUpUI = param1 as DiamondUpUI;
         diamondUpUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(diamondUpUI.btn_close !== _loc2_)
         {
            if(diamondUpUI.btn_buyDiamond !== _loc2_)
            {
               if(diamondUpUI.btn_recharge === _loc2_)
               {
                  sendNotification("switch_win",null,"load_diamond_panel");
               }
            }
            else
            {
               if(DiaMarkUpVO.lessTime <= 0)
               {
                  return Tips.show("活动已结束。");
               }
               if(DiaMarkUpVO.lessNum <= 0)
               {
                  return Tips.show("活动已完成。");
               }
               if(PlayerVO.diamond < DiaMarkUpVO.nextNeedDia)
               {
                  return Tips.show("钻石不足");
               }
               (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1907();
            }
         }
         else
         {
            dispose();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("UPDATE_DIAMONDUP_INFO" !== _loc2_)
         {
            if("update_diamondup_info_after_buy" !== _loc2_)
            {
               if("update_diamondup_diamond" !== _loc2_)
               {
                  if("update_diamondup_lesstime" === _loc2_)
                  {
                     if(DiaMarkUpVO.lessTime > 0)
                     {
                        diamondUpUI.leftTimeLable.text = "活动倒计时: " + TimeUtil.convertStringToDate3(DiaMarkUpVO.lessTime,"#ffee00");
                     }
                     else
                     {
                        diamondUpUI.leftTimeLable.text = "亲，活动已结束了哦";
                     }
                  }
               }
               else
               {
                  diamondUpUI.tf_ownDiamond.text = PlayerVO.diamond;
               }
            }
            else
            {
               diamondUpUI.showMC();
            }
         }
         else
         {
            diamondUpUI.updateInfo();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["UPDATE_DIAMONDUP_INFO","update_diamondup_info_after_buy","update_diamondup_diamond","update_diamondup_lesstime"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("DiamondUpMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.diamondUpAssets);
      }
   }
}
