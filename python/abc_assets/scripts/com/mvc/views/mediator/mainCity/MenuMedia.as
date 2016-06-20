package com.mvc.views.mediator.mainCity
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.MenuUI;
   import starling.events.Event;
   import starling.display.Sprite;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.display.Image;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import starling.text.TextField;
   import lzm.util.TimeUtil;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.views.mediator.mainCity.information.MailMedia;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import com.mvc.views.mediator.mainCity.friend.FriendMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.ElfSeriesMedia;
   import com.mvc.views.mediator.mainCity.active.ActiveMeida;
   import com.mvc.models.vos.mainCity.sign.SignVO;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.mvc.views.mediator.mainCity.growthPlan.GrowthPlanMediator;
   import com.mvc.views.mediator.mainCity.hunting.HuntingMediator;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import starling.display.DisplayObject;
   
   public class MenuMedia extends Mediator
   {
      
      public static const NAME:String = "MenuMedia";
      
      public static var isOpenDia:Boolean;
      
      public static var isOpenLightElf:Boolean;
      
      public static var isOpenDayHappy:Boolean;
      
      public static var isOpenLottery:Boolean;
      
      public static var isOpenLimitSpecialElf:Boolean;
      
      public static var isOpenPrefer:Boolean;
      
      public static var isRichGift:Boolean;
       
      public var menu:MenuUI;
      
      private var delay:uint;
      
      public function MenuMedia(param1:Object = null)
      {
         super("MenuMedia",param1);
         menu = param1 as MenuUI;
         menu.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(menu.menuHandlerBtn !== _loc3_)
         {
            if(menu.btn_activityMenuBtn !== _loc3_)
            {
               if(menu.btn_moreBtn !== _loc3_)
               {
                  if(menu.btn_eleBtn !== _loc3_)
                  {
                     if(menu.btn_backPackBtn !== _loc3_)
                     {
                        if(menu.btn_taskBtn !== _loc3_)
                        {
                           if(menu.friendBtn !== _loc3_)
                           {
                              if(menu.IllustrationsBtn !== _loc3_)
                              {
                                 if(menu.btn_labaBtn !== _loc3_)
                                 {
                                    if(menu.btn_activityBtn !== _loc3_)
                                    {
                                       if(menu.btn_lotteryBtn !== _loc3_)
                                       {
                                          if(menu.btn_informationBtn !== _loc3_)
                                          {
                                             if(menu.btn_signBtn !== _loc3_)
                                             {
                                                if(menu.btn_miracleBtn !== _loc3_)
                                                {
                                                   if(menu.btn_trialBtn !== _loc3_)
                                                   {
                                                      if(menu.btn_rechargeBtn !== _loc3_)
                                                      {
                                                         if(menu.btn_lightElf !== _loc3_)
                                                         {
                                                            if(menu.btn_dayHappy !== _loc3_)
                                                            {
                                                               if(menu.btn_limitSpecialElfBtn !== _loc3_)
                                                               {
                                                                  if(menu.btn_vipGift !== _loc3_)
                                                                  {
                                                                     if(menu.btn_aution !== _loc3_)
                                                                     {
                                                                        if(menu.btn_firstRechargeBtn !== _loc3_)
                                                                        {
                                                                           if(menu.btn_freeShopBtn !== _loc3_)
                                                                           {
                                                                              if(menu.btn_playerShopBtn !== _loc3_)
                                                                              {
                                                                                 if(menu.btn_growthPlanBtn !== _loc3_)
                                                                                 {
                                                                                    if(menu.btn_rankBtn !== _loc3_)
                                                                                    {
                                                                                       if(menu.btn_trainBtn !== _loc3_)
                                                                                       {
                                                                                          if(menu.btn_diamondUp !== _loc3_)
                                                                                          {
                                                                                             if(menu.btn_preferBtn !== _loc3_)
                                                                                             {
                                                                                                if(menu.btn_richGift !== _loc3_)
                                                                                                {
                                                                                                   if(menu.btn_onlineBtn !== _loc3_)
                                                                                                   {
                                                                                                      if(menu.btn_exChange === _loc3_)
                                                                                                      {
                                                                                                         sendNotification("switch_page","LOAD_EXCHANGE_WIN");
                                                                                                      }
                                                                                                   }
                                                                                                   else
                                                                                                   {
                                                                                                      if(SpecialActPro.onlineCountdown > 0)
                                                                                                      {
                                                                                                         return Tips.show("时间未到哦。");
                                                                                                      }
                                                                                                      if(SpecialActPro.onlinePhases <= 0)
                                                                                                      {
                                                                                                         return Tips.show("每日在线奖励阶段数异常");
                                                                                                      }
                                                                                                      (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write3701(SpecialActPro.onlinePhases);
                                                                                                   }
                                                                                                }
                                                                                                else if((menu.btn_richGift.skin as Sprite).getChildByName("news"))
                                                                                                {
                                                                                                   ((menu.btn_richGift.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                                                                   isRichGift = true;
                                                                                                }
                                                                                             }
                                                                                             else
                                                                                             {
                                                                                                if((menu.btn_preferBtn.skin as Sprite).getChildByName("news"))
                                                                                                {
                                                                                                   ((menu.btn_preferBtn.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                                                                   isOpenPrefer = true;
                                                                                                }
                                                                                                sendNotification("switch_win",null,"LOAD_PREFER_WIN");
                                                                                             }
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                             if((menu.btn_diamondUp.skin as Sprite).getChildByName("news"))
                                                                                             {
                                                                                                ((menu.btn_diamondUp.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                                                                isOpenDia = true;
                                                                                             }
                                                                                             sendNotification("switch_win",null,"load_diamondup");
                                                                                          }
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                          if(PlayerVO.lv < 8)
                                                                                          {
                                                                                             return Tips.show("玩家等级达到8级开放");
                                                                                          }
                                                                                          if(Config.isOpenBeginner)
                                                                                          {
                                                                                             TrainMedia.isNewOpen = true;
                                                                                          }
                                                                                          sendNotification("switch_win",null,"LOAD_TRAINELF");
                                                                                       }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       sendNotification("switch_win",null,"LOAD_RANKLIST_WIN");
                                                                                    }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    sendNotification("switch_win",null,"load_growthplan");
                                                                                 }
                                                                              }
                                                                              else
                                                                              {
                                                                                 ScoreShopMediator.nowType = "ShopMedia";
                                                                                 sendNotification("switch_win",null,"load_score_shop");
                                                                              }
                                                                           }
                                                                           else
                                                                           {
                                                                              ScoreShopMediator.nowType = "MainCityMedia";
                                                                              sendNotification("switch_win",null,"load_score_shop");
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           sendNotification("switch_win",null,"load_firstRecharge");
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        sendNotification("switch_page","LOAD_AUCTION_PAGE");
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     sendNotification("switch_win",null,"LOAD_ACTIVITY");
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  if((menu.btn_limitSpecialElfBtn.skin as Sprite).getChildByName("news"))
                                                                  {
                                                                     ((menu.btn_limitSpecialElfBtn.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                                     isOpenLimitSpecialElf = true;
                                                                  }
                                                                  sendNotification("switch_win",null,"load_limit_specialelf");
                                                               }
                                                            }
                                                            else
                                                            {
                                                               if((menu.btn_dayHappy.skin as Sprite).getChildByName("news"))
                                                               {
                                                                  ((menu.btn_dayHappy.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                                  isOpenDayHappy = true;
                                                               }
                                                               sendNotification("switch_win",null,"load_dayrecharge");
                                                            }
                                                         }
                                                         else
                                                         {
                                                            if((menu.btn_lightElf.skin as Sprite).getChildByName("news"))
                                                            {
                                                               ((menu.btn_lightElf.skin as Sprite).getChildByName("news") as Image).removeFromParent(true);
                                                               isOpenLightElf = true;
                                                            }
                                                            (facade.retrieveProxy("SpecialActivePro") as SpecialActPro).write1910();
                                                         }
                                                      }
                                                      else
                                                      {
                                                         sendNotification("switch_win",null,"load_diamond_panel");
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(PlayerVO.lv < 19)
                                                      {
                                                         Tips.show("玩家等级达到19级后开放");
                                                         return;
                                                      }
                                                      sendNotification("switch_page","load_trial_page");
                                                   }
                                                }
                                                else
                                                {
                                                   if(PlayerVO.lv < 48)
                                                   {
                                                      Tips.show("玩家等级达到48级后开放");
                                                      return;
                                                   }
                                                   sendNotification("switch_win",null,"load_miralce");
                                                }
                                             }
                                             else
                                             {
                                                sendNotification("switch_win",null,"LOAD_SIGN");
                                             }
                                          }
                                          else
                                          {
                                             sendNotification("switch_win",null,"LOAD_INFORMATION");
                                          }
                                       }
                                       else
                                       {
                                          sendNotification("switch_page","LOAD_LOTTERY");
                                       }
                                    }
                                    else
                                    {
                                       sendNotification("switch_win",null,"LOAD_ACTIVITY");
                                    }
                                 }
                                 else if(GetPropFactor.getProp(153) != null)
                                 {
                                    sendNotification("switch_win",null,"LOAD_HORN_INPUT");
                                 }
                                 else
                                 {
                                    if(PlayerVO.diamond < 50)
                                    {
                                       Tips.show("【小喇叭】不足，钻石不足，无法使用世界喇叭！");
                                       return;
                                    }
                                    _loc2_ = Alert.show("【小喇叭】不足，是否消耗50颗钻石使用世界喇叭？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                                    _loc2_.addEventListener("close",bugHorneHandler);
                                 }
                              }
                              else
                              {
                                 sendNotification("switch_win",null,"LOAD_ILLUSTRATION_WIN");
                              }
                           }
                           else
                           {
                              sendNotification("switch_win",null,"LOAD_FRIEND");
                           }
                        }
                        else
                        {
                           sendNotification("switch_win",null,"LOAD_TASK");
                        }
                     }
                     else
                     {
                        sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
                     }
                  }
                  else
                  {
                     if(PlayerVO.bagElfVec[0] == null)
                     {
                        return Tips.show("亲, 游戏正获取精灵数据，先不要着急哦");
                     }
                     sendNotification("switch_win",null,"LOAD_ELF_WIN");
                  }
               }
               else
               {
                  menu.spr_moreBtn.visible = true;
                  if(menu.btn_moreBtn.name == "recover")
                  {
                     menu.recoverMoreMenu();
                     menu.btn_moreBtn.name = "bomb";
                     (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreLeft").visible = false;
                     (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreTop").visible = true;
                  }
                  else
                  {
                     menu.bombMoreMenu();
                     menu.btn_moreBtn.name = "recover";
                     (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreLeft").visible = true;
                     (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreTop").visible = false;
                  }
               }
            }
            else
            {
               menu.spr_activity_menu_column.visible = true;
               if(menu.btn_activityMenuBtn.name == "recover")
               {
                  menu.recoverAni(2);
                  menu.btn_activityMenuBtn.name = "bomb";
                  (menu.btn_activityMenuBtn.skin as Sprite).getChildByName("img_activityLess").visible = false;
                  (menu.btn_activityMenuBtn.skin as Sprite).getChildByName("img_activityAdd").visible = true;
               }
               else
               {
                  menu.bombAni(2);
                  menu.btn_activityMenuBtn.name = "recover";
                  (menu.btn_activityMenuBtn.skin as Sprite).getChildByName("img_activityLess").visible = true;
                  (menu.btn_activityMenuBtn.skin as Sprite).getChildByName("img_activityAdd").visible = false;
               }
            }
         }
         else
         {
            menu.spr_moreBtn.visible = false;
            (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreLeft").visible = false;
            (menu.btn_moreBtn.skin as Sprite).getChildByName("img_moreTop").visible = true;
            if(menu.menuHandlerBtn.name == "recover")
            {
               menu.recoverAni(1);
               menu.menuHandlerBtn.name = "bomb";
            }
            else
            {
               menu.bombAni(1);
               menu.menuHandlerBtn.name = "recover";
            }
         }
      }
      
      private function bugHorneHandler(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            clearTimeout(delay);
            delay = setTimeout(loadHorn,300);
         }
      }
      
      private function loadHorn() : void
      {
         sendNotification("switch_win",null,"LOAD_HORN_INPUT");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_TASK_NEWS" !== _loc2_)
         {
            if("SHOW_FRIEND_NEWS" !== _loc2_)
            {
               if("HIDE_FRIEND_NEWS" !== _loc2_)
               {
                  if("HIDE_TASK_NEWS" !== _loc2_)
                  {
                     if("SHOW_INFOMATION_NEWS" !== _loc2_)
                     {
                        if("HIDE_INFOMATION_NEWS" !== _loc2_)
                        {
                           if("SHOW_ACTIVE_REWARD" !== _loc2_)
                           {
                              if("HIDE_ACTIVE_REWARD" !== _loc2_)
                              {
                                 if("SHOW_GROWTHPLAN" !== _loc2_)
                                 {
                                    if("HIDE_GROWTHPLAN" !== _loc2_)
                                    {
                                       if("SHOW_SIGN_NEWS" !== _loc2_)
                                       {
                                          if("HIDE_SIGN_NEWS" !== _loc2_)
                                          {
                                             if("HIDE_VIPGIFT_NEWS" !== _loc2_)
                                             {
                                                if("SHOW_VIPGIFT_NEWS" !== _loc2_)
                                                {
                                                   if("TIP_GET_MAIL" !== _loc2_)
                                                   {
                                                      if("UPDATE_SELETE_BTN" !== _loc2_)
                                                      {
                                                         if("HIDE_UNION_NEWS" !== _loc2_)
                                                         {
                                                            if("SHOW_UNION_NEWS" !== _loc2_)
                                                            {
                                                               if("update_online_countdown" !== _loc2_)
                                                               {
                                                                  if("show_online_news" !== _loc2_)
                                                                  {
                                                                     if("hide_online_news" === _loc2_)
                                                                     {
                                                                        menu.mc_online.gotoAndStop("close");
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     menu.mc_online.gotoAndPlay(0);
                                                                     ((menu.btn_onlineBtn.skin as Sprite).getChildByName("tf_countdown") as TextField).text = "可领取";
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  ((menu.btn_onlineBtn.skin as Sprite).getChildByName("tf_countdown") as TextField).text = TimeUtil.convertStringToDate(SpecialActPro.onlineCountdown);
                                                               }
                                                            }
                                                            else if(AuctionPro.isOPen)
                                                            {
                                                               if(!menu.mc_ham.isPlay)
                                                               {
                                                                  menu.mc_ham.play();
                                                               }
                                                            }
                                                            else if(menu.mc_ham.isPlay)
                                                            {
                                                               menu.mc_ham.gotoAndStop(0);
                                                            }
                                                         }
                                                         else if(menu.mc_ham.isPlay)
                                                         {
                                                            menu.mc_ham.gotoAndStop(0);
                                                         }
                                                      }
                                                      else
                                                      {
                                                         removeBtn(menu.btn_firstRechargeBtn);
                                                         removeBtn(menu.btn_lotteryBtn);
                                                         removeBtn(menu.btn_lightElf);
                                                         removeBtn(menu.btn_diamondUp);
                                                         removeBtn(menu.btn_dayHappy);
                                                         removeBtn(menu.btn_limitSpecialElfBtn);
                                                         removeBtn(menu.btn_preferBtn);
                                                         removeBtn(menu.btn_richGift);
                                                         removeBtn(menu.btn_onlineBtn);
                                                         if(PlayerVO.payCount == 0)
                                                         {
                                                            addSeleBtn(menu.btn_firstRechargeBtn);
                                                         }
                                                         if(SpecialActPro.isDiaOpen)
                                                         {
                                                            addSeleBtn(menu.btn_diamondUp);
                                                         }
                                                         if(SpecialActPro.isLottery)
                                                         {
                                                            addSeleBtn(menu.btn_lotteryBtn);
                                                         }
                                                         if(SpecialActPro.isLightOpen)
                                                         {
                                                            addSeleBtn(menu.btn_lightElf);
                                                         }
                                                         if(SpecialActPro.isDayHappyOpen)
                                                         {
                                                            addSeleBtn(menu.btn_dayHappy);
                                                         }
                                                         if(SpecialActPro.isLimitSpecialElfOpen)
                                                         {
                                                            addSeleBtn(menu.btn_limitSpecialElfBtn);
                                                         }
                                                         if(SpecialActPro.isPreferOpen)
                                                         {
                                                            addSeleBtn(menu.btn_preferBtn);
                                                         }
                                                         if(SpecialActPro.isRichGift)
                                                         {
                                                            addSeleBtn(menu.btn_richGift);
                                                         }
                                                         if(SpecialActPro.isOnlineOpen)
                                                         {
                                                            addSeleBtn(menu.btn_onlineBtn,"left");
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(InformationPro.isGetMail())
                                                      {
                                                         if(param1.getBody())
                                                         {
                                                            Tips.show("亲，你还有邮件未领取哦");
                                                         }
                                                         sendNotification("SHOW_INFOMATION_NEWS");
                                                      }
                                                      newHandle();
                                                   }
                                                }
                                                else if(!Config.isOpenBeginner && !GetCommon.isIOSDied())
                                                {
                                                   menu.vipGiftNews.visible = true;
                                                }
                                             }
                                             else
                                             {
                                                menu.vipGiftNews.visible = false;
                                             }
                                          }
                                          else
                                          {
                                             menu.signNews.visible = false;
                                          }
                                       }
                                       else if(!Config.isOpenBeginner)
                                       {
                                          menu.signNews.visible = true;
                                       }
                                    }
                                    else
                                    {
                                       menu.growthPlanNews.visible = false;
                                    }
                                 }
                                 else if(!Config.isOpenBeginner)
                                 {
                                    menu.growthPlanNews.visible = true;
                                 }
                              }
                              else
                              {
                                 menu.activityNews.visible = false;
                              }
                           }
                           else if(!Config.isOpenBeginner)
                           {
                              menu.activityNews.visible = true;
                           }
                        }
                        else
                        {
                           menu.infoNews.visible = false;
                        }
                     }
                     else
                     {
                        LogUtil("================显示消息提醒");
                        if(!Config.isOpenBeginner)
                        {
                           menu.infoNews.visible = true;
                        }
                     }
                  }
                  else
                  {
                     menu.taskNews.visible = false;
                  }
               }
               else
               {
                  menu.friendNews.visible = false;
                  menu.moreBtnNews.visible = false;
               }
            }
            else
            {
               if(GetCommon.isIOSDied())
               {
                  return;
               }
               menu.friendNews.visible = true;
               menu.moreBtnNews.visible = true;
            }
         }
         else
         {
            LogUtil("显示任务提醒");
            if(!Config.isOpenBeginner)
            {
               menu.taskNews.visible = true;
            }
         }
      }
      
      private function removeBtn(param1:SwfButton) : void
      {
         if(param1.parent)
         {
            param1.removeFromParent();
         }
      }
      
      private function addSeleBtn(param1:SwfButton, param2:String = "up") : void
      {
         if(param2 == "up")
         {
            param1.x = menu.spr_btn.width + 20;
            param1.y = 65;
            menu.spr_btn.addChild(param1);
         }
         else if(param2 == "left")
         {
            param1.y = menu.leftIntermittentSpr.height > 0?menu.leftIntermittentSpr.height + 30:menu.leftIntermittentSpr.height;
            menu.leftIntermittentSpr.addChild(param1);
         }
      }
      
      public function newHandle() : void
      {
         if(MailMedia.isNew)
         {
            LogUtil("返回主城有新的邮件");
            sendNotification("SHOW_INFOMATION_NEWS");
         }
         if(TaskMedia.isNew)
         {
            LogUtil("返回主城有新的任务");
            sendNotification("SHOW_TASK_NEWS");
         }
         if(FriendMedia.isNew)
         {
            LogUtil("返回主城有好友请求");
            sendNotification("SHOW_FRIEND_NEWS");
         }
         if(ElfSeriesMedia.isNew)
         {
            LogUtil("返回主城有人挑战你");
            ElfSeriesMedia.isNew = false;
            sendNotification("SHOW_SERIES_NEWS");
         }
         if(ActiveMeida.isNew)
         {
            LogUtil("活动有奖励领取提醒");
            sendNotification("SHOW_ACTIVE_REWARD");
         }
         if(!SignVO.isTodaySigned)
         {
            sendNotification("SHOW_SIGN_NEWS");
         }
         if(ActiveMeida.isVIPgiftNew)
         {
            sendNotification("SHOW_VIPGIFT_NEWS");
         }
         if(AmuseMedia.isFreeDraw)
         {
            LogUtil("扭蛋可抽取提醒");
            sendNotification("SHOW_FREE_DRAW");
         }
         if(GrowthPlanMediator.isGet)
         {
            sendNotification("SHOW_GROWTHPLAN");
         }
         if(HuntingMediator.isSureHunting)
         {
            sendNotification("SHOW_HUNTING_DRAW");
         }
         else
         {
            sendNotification("HIDE_HUNTING_DRAW");
         }
         if(SpecialActPro.onlineCountdown <= 0)
         {
            sendNotification("show_online_news");
         }
         else
         {
            sendNotification("hide_online_news");
         }
         if(MiningPro.isShowMineNews)
         {
            sendNotification("show_mine_draw");
         }
         else
         {
            sendNotification("hide_mine_draw");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_TASK_NEWS","SHOW_FRIEND_NEWS","HIDE_FRIEND_NEWS","HIDE_TASK_NEWS","SHOW_ACTIVE_REWARD","HIDE_ACTIVE_REWARD","SHOW_SIGN_NEWS","HIDE_SIGN_NEWS","TIP_GET_MAIL","SHOW_INFOMATION_NEWS","HIDE_INFOMATION_NEWS","SHOW_GROWTHPLAN","HIDE_GROWTHPLAN","UPDATE_SELETE_BTN","HIDE_UNION_NEWS","SHOW_UNION_NEWS","HIDE_VIPGIFT_NEWS","SHOW_VIPGIFT_NEWS","update_online_countdown","show_online_news","hide_online_news"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         menu.disposeBtn();
         facade.removeMediator("MenuMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
