package com.mvc.views.mediator.union.unionWorld
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionWorld.UnionWorldUI;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.views.uis.union.unionWorld.UnionNoticeUI;
   import com.massage.ane.UmengExtension;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.Sprite;
   import starling.text.TextField;
   import com.common.consts.ConfigConst;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import com.mvc.views.mediator.union.unionHall.UnionHallMedia;
   import com.mvc.views.mediator.union.unionStudy.UnionStudyMedia;
   import com.mvc.views.mediator.union.unionTrain.UnionTrainMedia;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionWorldMedia extends Mediator
   {
      
      public static const NAME:String = "UnionWorldMedia";
       
      public var unoinWorld:UnionWorldUI;
      
      public function UnionWorldMedia(param1:Object = null)
      {
         super("UnionWorldMedia",param1);
         unoinWorld = param1 as UnionWorldUI;
         unoinWorld.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(unoinWorld.btn_close !== _loc2_)
         {
            if(unoinWorld.btn_trainBtn !== _loc2_)
            {
               if(unoinWorld.btn_backPackBtn !== _loc2_)
               {
                  if(unoinWorld.btn_eleBtn !== _loc2_)
                  {
                     if(unoinWorld.btn_taskBtn !== _loc2_)
                     {
                        if(unoinWorld.btn_hall !== _loc2_)
                        {
                           if(unoinWorld.btn_notice !== _loc2_)
                           {
                              if(unoinWorld.btn_shop !== _loc2_)
                              {
                                 if(unoinWorld.btn_study !== _loc2_)
                                 {
                                    if(unoinWorld.btn_train !== _loc2_)
                                    {
                                       if(unoinWorld.btn_Medal === _loc2_)
                                       {
                                          if(PlayerVO.unionId == -1)
                                          {
                                             return Tips.show("亲，你已经不是公会成员，请关闭公会重新加入");
                                          }
                                          sendNotification("switch_win",null,"LOAD_MEDAL_WIN");
                                       }
                                    }
                                    else
                                    {
                                       if(PlayerVO.unionId == -1)
                                       {
                                          return Tips.show("亲，你已经不是公会成员，请关闭公会重新加入");
                                       }
                                       sendNotification("switch_win",null,"LOAD_UNIONTRAIN_WIN");
                                    }
                                 }
                                 else
                                 {
                                    if(PlayerVO.unionId == -1)
                                    {
                                       return Tips.show("亲，你已经不是公会成员，请关闭公会重新加入");
                                    }
                                    sendNotification("switch_win",null,"LOAD_UNIONSTUDY_WIN");
                                 }
                              }
                              else
                              {
                                 Tips.show("敬请期待");
                              }
                           }
                           else
                           {
                              if(PlayerVO.unionId == -1)
                              {
                                 return Tips.show("亲，你已经不是公会成员，请关闭公会重新加入");
                              }
                              if(PlayerVO.userId == UnionPro.myUnionVO.unionRCDId || UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
                              {
                                 UnionNoticeUI.getInstance().show(unoinWorld);
                              }
                              else
                              {
                                 Tips.show("亲，你还没有权限编辑公告牌");
                              }
                              UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|公会公告牌");
                           }
                        }
                        else
                        {
                           if(PlayerVO.unionId == -1)
                           {
                              return Tips.show("亲，你已经不是公会成员，请关闭公会重新加入");
                           }
                           sendNotification("switch_win",null,"LOAD_UNIONHALL_WIN");
                        }
                     }
                     else
                     {
                        sendNotification("switch_win",null,"LOAD_TASK");
                     }
                  }
                  else
                  {
                     sendNotification("switch_win",null,"LOAD_ELF_WIN");
                  }
               }
               else
               {
                  sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
               }
            }
            else
            {
               if(PlayerVO.lv < 8)
               {
                  return Tips.show("玩家等级达到8级开放");
               }
               sendNotification("switch_win",null,"LOAD_TRAINELF");
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_UNION_NOTICE !== _loc2_)
         {
            if("SHOW_TASK_NEWS" !== _loc2_)
            {
               if("HIDE_TASK_NEWS" === _loc2_)
               {
                  unoinWorld.taskNews.visible = false;
               }
            }
            else
            {
               unoinWorld.taskNews.visible = true;
            }
         }
         else
         {
            LogUtil("UnionPro.myUnionVO.notice===",UnionPro.myUnionVO.notice);
            ((unoinWorld.btn_notice.skin as Sprite).getChildByName("noticeTxt") as TextField).text = UnionPro.myUnionVO.notice;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_UNION_NOTICE,"SHOW_TASK_NEWS","HIDE_TASK_NEWS"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(Facade.getInstance().hasMediator("ScoreShopMediator"))
            {
               (Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).dispose();
            }
            if(Facade.getInstance().hasMediator("UnionHallMedia"))
            {
               (Facade.getInstance().retrieveMediator("UnionHallMedia") as UnionHallMedia).dispose();
            }
            if(Facade.getInstance().hasMediator("UnionStudyMedia"))
            {
               (Facade.getInstance().retrieveMediator("UnionStudyMedia") as UnionStudyMedia).dispose();
            }
            if(Facade.getInstance().hasMediator("UnionTrainMedia"))
            {
               (Facade.getInstance().retrieveMediator("UnionTrainMedia") as UnionTrainMedia).dispose();
            }
            if(UnionNoticeUI.instance)
            {
               UnionNoticeUI.getInstance().remove();
            }
         }
         facade.removeMediator("UnionWorldMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.unionWorldAssets);
      }
   }
}
