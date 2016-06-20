package com.mvc.views.mediator.mainCity.shop
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.shop.BuySureUI;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class BuySureMedia extends Mediator
   {
      
      public static const NAME:String = "BuySureMedia";
      
      public static var type:int;
       
      public var buySure:BuySureUI;
      
      public function BuySureMedia(param1:Object = null)
      {
         super("BuySureMedia",param1);
         buySure = param1 as BuySureUI;
         buySure.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(buySure.btn_add !== _loc2_)
         {
            if(buySure.btn_max !== _loc2_)
            {
               if(buySure.btn_min !== _loc2_)
               {
                  if(buySure.btn_ok !== _loc2_)
                  {
                     if(buySure.btn_sub !== _loc2_)
                     {
                        if(buySure.btn_sureClose === _loc2_)
                        {
                           WinTweens.closeWin(buySure.spr_sureBg,remove);
                        }
                     }
                     else
                     {
                        if(buySure.sum.text <= 1)
                        {
                           return;
                        }
                        buySure.sum.text = buySure.sum.text - 1;
                     }
                  }
                  else
                  {
                     switch(type - 1)
                     {
                        case 0:
                           (facade.retrieveProxy("ShopPro") as ShopPro).write3306(buySure.myPropVo,buySure.sum.text);
                           break;
                        case 1:
                           (facade.retrieveProxy("ShopPro") as ShopPro).write3312(buySure.myPropVo,buySure.sum.text);
                           break;
                        case 2:
                           (facade.retrieveProxy("ShopPro") as ShopPro).write3304(buySure.myPropVo,buySure.sum.text);
                           break;
                     }
                     WinTweens.closeWin(buySure.spr_sureBg,remove);
                  }
               }
               else if(buySure.sum.text - 10 <= 1)
               {
                  buySure.sum.text = "1";
               }
               else
               {
                  buySure.sum.text = buySure.sum.text - 10;
               }
            }
            else
            {
               if(type == 1)
               {
                  if((PlayerVO.silver - buySure.myPropVo.price * buySure.sum.text) / buySure.myPropVo.price < 10)
                  {
                     Tips.show("金币不足");
                     return;
                  }
               }
               if(type == 2)
               {
                  if((PlayerVO.diamond - buySure.myPropVo.diamond * buySure.sum.text) / buySure.myPropVo.diamond < 10)
                  {
                     Tips.show("钻石不足");
                     return;
                  }
               }
               if(type == 2 && buySure.myPropVo.dayBuyCount > -1 && buySure.sum.text + 10 > buySure.myPropVo.dayBuyCount)
               {
                  Tips.show("超过剩余每日购买次数。");
                  return;
               }
               if(type == 3)
               {
                  if(buySure.myPropVo.count - buySure.sum.text < 10)
                  {
                     Tips.show("数量不足");
                     return;
                  }
               }
               buySure.sum.text = buySure.sum.text + 10;
            }
         }
         else
         {
            if(type == 1 && buySure.moneyPrompt.text.substring(5) + buySure.myPropVo.price > PlayerVO.silver)
            {
               Tips.show("金币不足");
               return;
            }
            if(type == 2 && buySure.moneyPrompt.text.substring(5) + buySure.myPropVo.diamond > PlayerVO.diamond)
            {
               Tips.show("钻石不足");
               return;
            }
            if(type == 2 && buySure.myPropVo.dayBuyCount > -1 && buySure.sum.text + 1 > buySure.myPropVo.dayBuyCount)
            {
               Tips.show("超过剩余每日购买次数。");
               return;
            }
            if(type == 3 && buySure.sum.text + 1 > buySure.myPropVo.count)
            {
               Tips.show("该道具数量已达最大");
               return;
            }
            buySure.sum.text = buySure.sum.text + 1;
         }
         if(type == 1)
         {
            buySure.moneyPrompt.text = "花费金币：" + buySure.myPropVo.price * buySure.sum.text;
         }
         if(type == 2)
         {
            buySure.moneyPrompt.text = "花费钻石：" + buySure.myPropVo.diamond * buySure.sum.text;
         }
         if(type == 3)
         {
            buySure.moneyPrompt.text = "获得金币：" + buySure.myPropVo.price / 2 * buySure.sum.text;
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         buySure.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("BuySureMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
