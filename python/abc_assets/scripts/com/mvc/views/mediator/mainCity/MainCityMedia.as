package com.mvc.views.mediator.mainCity
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.util.IsAllElfDie;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import org.puremvc.as3.interfaces.INotification;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   
   public class MainCityMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MainCityMedia";
      
      public static var position:Number = 680;
       
      public var mainCity:MainCityUI;
      
      private var isBombWin:Boolean;
      
      private var delay:uint;
      
      public function MainCityMedia(param1:Object = null)
      {
         super("MainCityMedia",param1);
         mainCity = param1 as MainCityUI;
         mainCity.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(mainCity.btn_note !== _loc2_)
         {
            if(mainCity.scene.btn_fourKing !== _loc2_)
            {
               if(mainCity.scene.btn_elfPVP !== _loc2_)
               {
                  if(mainCity.scene.btn_elfSeries !== _loc2_)
                  {
                     if(mainCity.scene.homeBtn !== _loc2_)
                     {
                        if(mainCity.scene.eleCenterBtn !== _loc2_)
                        {
                           if(mainCity.scene.shopBtn !== _loc2_)
                           {
                              if(mainCity.scene.playgroundBtn !== _loc2_)
                              {
                                 if(mainCity.scene.studyBtn !== _loc2_)
                                 {
                                    if(mainCity.scene.btn_union !== _loc2_)
                                    {
                                       if(mainCity.advanceBtn !== _loc2_)
                                       {
                                          if(mainCity.scene.huntingBtn !== _loc2_)
                                          {
                                             if(mainCity.scene.btn_mine !== _loc2_)
                                             {
                                                if(mainCity.scene.btn_huntParty === _loc2_)
                                                {
                                                   return Tips.show("捕虫大会暂未开始");
                                                }
                                             }
                                             else
                                             {
                                                if(PlayerVO.lv < 26)
                                                {
                                                   Tips.show("玩家等级达到26级后开放");
                                                   return;
                                                }
                                                (facade.retrieveProxy("Miningpro") as MiningPro).write3901();
                                             }
                                          }
                                          else
                                          {
                                             if(PlayerVO.lv < 20)
                                             {
                                                Tips.show("玩家等级达到20级后开放");
                                                return;
                                             }
                                             sendNotification("switch_page","load_hunting_page");
                                          }
                                       }
                                       else
                                       {
                                          if(IsAllElfDie.isAllElfDie())
                                          {
                                             return;
                                          }
                                          if(FightingConfig.openCity == -1)
                                          {
                                             (facade.retrieveProxy("MapPro") as MapPro).write1705();
                                          }
                                          else
                                          {
                                             WorldMapMedia.mapVO = GetMapFactor.getMapVoById(FightingConfig.openCity);
                                             Config.cityScene = WorldMapMedia.mapVO.bgImg;
                                             (facade.retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
                                          }
                                       }
                                    }
                                    else
                                    {
                                       if(PlayerVO.lv < 28)
                                       {
                                          Tips.show("玩家等级达到28级后开放");
                                          return;
                                       }
                                       LogUtil("PlayerVO.unionId ======",PlayerVO.unionId,PlayerVO.unionId != -1);
                                       if(PlayerVO.unionId != -1)
                                       {
                                          sendNotification("switch_page","LOAD_UNIONWORLD_PAGE");
                                       }
                                       else
                                       {
                                          sendNotification("switch_page","LOAD_UNIONLIST_PAGE");
                                       }
                                    }
                                 }
                                 else
                                 {
                                    sendNotification("switch_page","LOAD_LABORATORY_PAGE");
                                 }
                              }
                              else
                              {
                                 sendNotification("switch_page","LOAD_AMUSE_PAGE");
                              }
                           }
                           else
                           {
                              sendNotification("switch_page","load_shop_page");
                           }
                        }
                        else
                        {
                           sendNotification("switch_page","LOAD_ELFCENTER_PAGE");
                        }
                     }
                     else
                     {
                        sendNotification("switch_page","LOAD_HOME");
                     }
                  }
                  else
                  {
                     if(PlayerVO.lv < 15)
                     {
                        Tips.show("玩家等级达到15级后开放");
                        return;
                     }
                     sendNotification("switch_page","LOAD_ELFSERIES_PAGE");
                  }
               }
               else
               {
                  if(PlayerVO.lv < 35)
                  {
                     Tips.show("玩家等级达到35级后开放");
                     return;
                  }
                  sendNotification("switch_page","load_pvp_page");
               }
            }
            else
            {
               if(PlayerVO.lv < 22)
               {
                  Tips.show("玩家等级达到22级后开放");
                  return;
               }
               sendNotification("switch_page","LOAD_KING_PAGE");
            }
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("LOOK_LEAVE_WORD" !== _loc3_)
         {
            if("SHOW_SERIES_NEWS" !== _loc3_)
            {
               if("HIDE_SERIES_NEWS" !== _loc3_)
               {
                  if("SHOW_FREE_DRAW" !== _loc3_)
                  {
                     if("HIDE_FREE_DRAW" !== _loc3_)
                     {
                        if("SHOW_HUNTING_DRAW" !== _loc3_)
                        {
                           if("HIDE_HUNTING_DRAW" !== _loc3_)
                           {
                              if("show_mine_draw" !== _loc3_)
                              {
                                 if("hide_mine_draw" === _loc3_)
                                 {
                                    LogUtil("隐藏挖矿提醒");
                                    mainCity.scene.miningNews.visible = false;
                                 }
                              }
                              else
                              {
                                 LogUtil("显示挖矿提醒");
                                 mainCity.scene.miningNews.visible = true;
                              }
                           }
                           else
                           {
                              LogUtil("隐藏狩猎场可用提醒");
                              mainCity.scene.huntingNew.visible = false;
                           }
                        }
                        else
                        {
                           LogUtil("显示狩猎场可用提醒");
                           mainCity.scene.huntingNew.visible = true;
                        }
                     }
                     else
                     {
                        mainCity.scene.freeDraw.visible = false;
                     }
                  }
                  else
                  {
                     mainCity.scene.freeDraw.visible = true;
                  }
               }
               else
               {
                  mainCity.scene.elfSeriesNews.visible = false;
               }
            }
            else
            {
               mainCity.scene.elfSeriesNews.visible = true;
               Tips.show("联盟大赛有人挑战你了");
            }
         }
         else
         {
            _loc2_ = Alert.show("有【" + (param1.getBody() as int) + "】个玩家给你留言，是否查看？","",new ListCollection([{"label":"是"},{"label":"否"}]));
            _loc2_.addEventListener("close",leaveWordHandler);
         }
      }
      
      private function leaveWordHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "是")
         {
            sendNotification("switch_win",null,"LOAD_CHAT");
            sendNotification("SHOW_CHAT_INDEX",1);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["LOOK_LEAVE_WORD","SHOW_SERIES_NEWS","HIDE_SERIES_NEWS","SHOW_FREE_DRAW","HIDE_FREE_DRAW","SHOW_HUNTING_DRAW","HIDE_HUNTING_DRAW","show_mine_draw","hide_mine_draw"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         mainCity.scene.disposeTexture();
         facade.removeMediator("MainCityMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
