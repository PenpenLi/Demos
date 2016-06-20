package com.mvc.views.mediator.mainCity.amuse
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.views.uis.mainCity.amuse.AmuseUI;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.amuse.AmusePreviewUI;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class AmuseMedia extends Mediator
   {
      
      public static const NAME:String = "AmuseMedia";
      
      public static var rewardArr:Array;
      
      public static var isFreeDraw:Boolean;
       
      public var amuse:AmuseUI;
      
      private var spriteIdArr:Array;
      
      public function AmuseMedia(param1:Object = null)
      {
         super("AmuseMedia",param1);
         amuse = param1 as AmuseUI;
         amuse.addEventListener("triggered",clickHandler);
      }
      
      public static function once() : Boolean
      {
         if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < 1)
         {
            Tips.show("精灵存放空间不足。");
            return false;
         }
         return true;
      }
      
      public static function ten() : Boolean
      {
         if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < 3)
         {
            Tips.show("精灵存放空间不足。");
            return false;
         }
         return true;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(amuse.btn_mainClose !== _loc2_)
         {
            if(amuse.btn_playTip !== _loc2_)
            {
               if(amuse.btn_scoreRecharge !== _loc2_)
               {
                  if(amuse.btn_preview !== _loc2_)
                  {
                     if(amuse.btn_extractionOne0 !== _loc2_)
                     {
                        if(amuse.btn_extractionOne1 !== _loc2_)
                        {
                           if(amuse.btn_extractionOne2 !== _loc2_)
                           {
                              if(amuse.btn_extractionTen0 !== _loc2_)
                              {
                                 if(amuse.btn_extractionTen1 !== _loc2_)
                                 {
                                    if(amuse.btn_extractionTen2 === _loc2_)
                                    {
                                       if(PlayerVO.vipRank < 11)
                                       {
                                          Tips.show("火力全开需要VIP11及以上才开启哦。");
                                          return;
                                       }
                                       if(ten())
                                       {
                                          (facade.retrieveProxy("AmusePro") as AmusePro).write2502(8);
                                       }
                                    }
                                 }
                                 else if(ten())
                                 {
                                    (facade.retrieveProxy("AmusePro") as AmusePro).write2502(6);
                                 }
                              }
                              else if(ten())
                              {
                                 (facade.retrieveProxy("AmusePro") as AmusePro).write2502(4);
                              }
                           }
                           else
                           {
                              if(PlayerVO.vipRank < 11)
                              {
                                 Tips.show("火力全开需要VIP11及以上才开启哦。");
                                 return;
                              }
                              if(once())
                              {
                                 (facade.retrieveProxy("AmusePro") as AmusePro).write2501(7);
                              }
                           }
                        }
                        else if(once())
                        {
                           (facade.retrieveProxy("AmusePro") as AmusePro).write2501(3);
                        }
                     }
                     else if(once())
                     {
                        (facade.retrieveProxy("AmusePro") as AmusePro).write2501(1);
                     }
                  }
                  else
                  {
                     if(GetElfFactor.amusePreviewElfVoVec.length == 0)
                     {
                        GetElfFactor.getAmusePreviewElfVoVec();
                     }
                     AmusePreviewUI.getInstance().showPreview(GetElfFactor.amusePreviewElfVoVec);
                  }
               }
               else
               {
                  if(AmuseScoreRechargeMediator.itemArr.length == 0)
                  {
                     return Tips.show("暂无可兑换商品。");
                  }
                  sendNotification("switch_win",amuse,"load_amuse_score_win");
               }
            }
            else
            {
               amuse.addHelp();
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
            if(GetElfFactor.bagNewElf)
            {
               GetElfFactor.bagNewElf = false;
               sendNotification("UPDATE_BAG_ELF");
            }
            judgeSureDraw();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("update_count_down" !== _loc3_)
         {
            if("amuse_update_act_lesstime" !== _loc3_)
            {
               if("amuse_update_cost" !== _loc3_)
               {
                  if("load_amuse_mc" !== _loc3_)
                  {
                     if("amuse_send_spriteIdArr" !== _loc3_)
                     {
                        if("amuse_update_ten_tips" !== _loc3_)
                        {
                           if("amuse_open_three" !== _loc3_)
                           {
                              if("amuse_show_tendraw_act_reward" !== _loc3_)
                              {
                                 if("amuse_refresh_preview" === _loc3_)
                                 {
                                    amuse.addPreviewReward();
                                    amuse.showPreContainerTween();
                                 }
                              }
                              else
                              {
                                 _loc2_ = param1.getBody() as Array;
                                 amuse.showTenDrawReward(_loc2_);
                              }
                           }
                           else
                           {
                              if(amuse.spr_2.visible)
                              {
                                 return;
                              }
                              amuse.spr_0.x = amuse.spr_0.x - 200;
                              amuse.spr_1.x = amuse.spr_1.x - 250;
                              amuse.spr_2.visible = true;
                           }
                        }
                        else
                        {
                           amuse.promptTen1.text = "十连抽必出 高级狩猎券";
                        }
                     }
                     else
                     {
                        spriteIdArr = param1.getBody() as Array;
                     }
                  }
                  else
                  {
                     rewardArr = null;
                     rewardArr = param1.getBody() as Array;
                     sendNotification("switch_page","load_amuse_mc");
                  }
               }
               else
               {
                  amuse.updateCost(AmusePro.priceArr);
               }
            }
            else
            {
               amuse.updateDiscountTime();
            }
         }
         else
         {
            amuse.showTime();
         }
      }
      
      private function judgeSureDraw() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < AmusePro.onceTimeVec.length)
         {
            if(_loc1_ == 0)
            {
               if(AmusePro.onceTimeVec[0] <= 0 && AmusePro.recruitFreeTimes > 0)
               {
                  AmuseMedia.isFreeDraw = true;
                  break;
               }
               AmuseMedia.isFreeDraw = false;
            }
            else if(_loc1_ > 0)
            {
               if(AmusePro.onceTimeVec[_loc1_] <= 0)
               {
                  AmuseMedia.isFreeDraw = true;
                  break;
               }
               AmuseMedia.isFreeDraw = false;
            }
            _loc1_++;
         }
         LogUtil("AmuseMedia.isFreeDraw: " + AmuseMedia.isFreeDraw);
         if(isFreeDraw)
         {
            sendNotification("SHOW_FREE_DRAW");
         }
         else
         {
            sendNotification("HIDE_FREE_DRAW");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_Drew_ELF","update_count_down","load_amuse_mc","amuse_send_spriteIdArr","amuse_open_three","amuse_update_ten_tips","amuse_update_cost","amuse_update_act_lesstime","amuse_show_tendraw_act_reward","amuse_refresh_preview"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         amuse.clean();
         if(AmusePreviewUI.instance)
         {
            AmusePreviewUI.getInstance().removeSelf();
         }
         if(PVPPro.isAcceptPvpInvite)
         {
            if(GetElfFactor.bagNewElf)
            {
               GetElfFactor.bagNewElf = false;
               sendNotification("UPDATE_BAG_ELF");
            }
            judgeSureDraw();
         }
         rewardArr = null;
         amuse.stopTimer();
         facade.removeMediator("AmuseMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
