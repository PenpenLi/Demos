package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.mining.SwitchPage;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import lzm.starling.swf.display.SwfSprite;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.mvc.views.uis.mainCity.mining.MiningInfoPage;
   import com.mvc.views.uis.mainCity.mining.MiningMainPage;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.mining.MiningRule;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.mining.MiningVO;
   import starling.display.DisplayObject;
   import starling.core.Starling;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiningFrameMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningFrameMediator";
      
      public static var nowPage:SwitchPage;
      
      public static var exportPay:int;
      
      public static var breadNum:int;
      
      public static var miningReward:Object;
       
      public var miningFrameUI:MiningFrameUI;
      
      private var pageVec:Vector.<SwitchPage>;
      
      private var littleIconVec:Vector.<SwfSprite>;
      
      private var nextPage:SwitchPage;
      
      private var nowPageIndex:int;
      
      public function MiningFrameMediator(param1:Object = null)
      {
         pageVec = new Vector.<SwitchPage>([]);
         littleIconVec = new Vector.<SwfSprite>([]);
         super("MiningFrameMediator",param1);
         miningFrameUI = param1 as MiningFrameUI;
         miningFrameUI.addEventListener("triggered",clickHandler);
         EventCenter.addEventListener("mining_finger_left",finger_leftHandler);
         EventCenter.addEventListener("mining_finger_right",finger_rightHandler);
      }
      
      private function initMiningInfoPage() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         if(MiningPro.miningVOVec.length)
         {
            MiningPro.pageEndTime = MiningPro.miningVOVec[0].endTime;
            LogUtil("MiningPro.pageEndTime " + MiningPro.pageEndTime);
            _loc2_ = 0;
            while(_loc2_ < MiningPro.miningVOVec.length)
            {
               _loc1_ = new MiningInfoPage(MiningPro.miningVOVec[_loc2_]);
               pageVec.push(_loc1_);
               littleIconVec.push(miningFrameUI.addLittleIcon(_loc1_.littleIconType,false));
               _loc2_++;
            }
            nowPage = pageVec[0];
            miningFrameUI.pageContainer.addChild(pageVec[0]);
            pageVec.push(miningFrameUI.createMainPage());
            littleIconVec.push(miningFrameUI.addLittleIcon(0,false));
            updateLittleIconState();
            miningFrameUI.tf_pageTittle.text = (nowPage as MiningInfoPage).miningObj.name;
         }
         else
         {
            nowPage = miningFrameUI.createMainPage();
            (nowPage as MiningMainPage).updateInfo();
            pageVec.push(nowPage);
            miningFrameUI.pageContainer.addChild(nowPage);
            littleIconVec.push(miningFrameUI.addLittleIcon(0,false));
            updateLittleIconState();
            miningFrameUI.tf_pageTittle.text = "复刻矿洞大门";
         }
         updateLeftAndRightBtn();
         miningFrameUI.tf_power.text = MiningFrameMediator.breadNum + "/30";
         if(MiningPro.isShowDefendNews)
         {
            miningFrameUI.defendNews.visible = true;
         }
      }
      
      private function finger_rightHandler(param1:Event) : void
      {
         pageMoveRight();
      }
      
      private function pageMoveRight() : void
      {
         if(nowPage.isMoving)
         {
            return;
         }
         LogUtil("向右滑动后@@@" + pageVec);
         if(nowPageIndex != 0)
         {
            nowPage.gestureStatus = "right";
            nowPage.setMoving(true,function():void
            {
               nowPage.removeFromParent();
            });
            nextPage = pageVec[nowPageIndex - 1];
            nextPage.x = -1136;
            nextPage.gestureStatus = "right";
            miningFrameUI.pageContainer.addChild(nextPage);
            nextPage.setMoving(true,function():void
            {
               nowPage = nextPage;
               nowPageIndex = nowPageIndex - 1;
               updateAfterSwitch();
               updateLeftAndRightBtn();
            });
         }
      }
      
      private function finger_leftHandler(param1:Event) : void
      {
         pageMoveLeft();
      }
      
      private function pageMoveLeft() : void
      {
         if(nowPage.isMoving)
         {
            return;
         }
         LogUtil("向左滑动后@@@" + pageVec);
         if(nowPageIndex != pageVec.length - 1)
         {
            nowPage.gestureStatus = "left";
            nowPage.setMoving(true,function():void
            {
               nowPage.removeFromParent();
            });
            nextPage = pageVec[nowPageIndex + 1];
            nextPage.x = 1136;
            nextPage.gestureStatus = "left";
            miningFrameUI.pageContainer.addChild(nextPage);
            nextPage.setMoving(true,function():void
            {
               nowPage = nextPage;
               nowPageIndex = nowPageIndex + 1;
               updateAfterSwitch();
               updateLeftAndRightBtn();
            });
         }
      }
      
      private function updateAfterSwitch() : void
      {
         if(nowPage is MiningInfoPage)
         {
            miningFrameUI.tf_pageTittle.text = (nowPage as MiningInfoPage).miningObj.name;
            MiningPro.pageEndTime = (nowPage as MiningInfoPage).miningObj.endTime;
            LogUtil("切换页面完成后: " + MiningPro.pageEndTime,(nowPage as MiningInfoPage).miningObj.type);
         }
         if(nowPage is MiningMainPage)
         {
            (nowPage as MiningMainPage).updateInfo();
            miningFrameUI.tf_pageTittle.text = "复刻矿洞大门";
         }
         updateLittleIconState();
      }
      
      private function updateLeftAndRightBtn() : void
      {
         if(pageVec.length <= 1)
         {
            miningFrameUI.btn_left.visible = false;
            miningFrameUI.btn_right.visible = false;
            return;
         }
         if(nowPageIndex == 0)
         {
            miningFrameUI.btn_left.visible = false;
            miningFrameUI.btn_right.visible = true;
         }
         else if(nowPageIndex == pageVec.length - 1)
         {
            miningFrameUI.btn_left.visible = true;
            miningFrameUI.btn_right.visible = false;
         }
         else if(nowPageIndex > 0 && nowPageIndex < pageVec.length - 1)
         {
            miningFrameUI.btn_left.visible = true;
            miningFrameUI.btn_right.visible = true;
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(miningFrameUI.btn_close !== _loc2_)
         {
            if(miningFrameUI.btn_defendRecord !== _loc2_)
            {
               if(miningFrameUI.btn_rule !== _loc2_)
               {
                  if(miningFrameUI.btn_left !== _loc2_)
                  {
                     if(miningFrameUI.btn_right === _loc2_)
                     {
                        pageMoveLeft();
                     }
                  }
                  else
                  {
                     pageMoveRight();
                  }
               }
               else
               {
                  MiningRule.getInstance().showRule();
               }
            }
            else
            {
               sendNotification("switch_win",null,"mining_load_fight_record_win");
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         notification = param1;
         var _loc3_:* = notification.getName();
         if("mining_init_page" !== _loc3_)
         {
            if("mining_update_defend_countdown" !== _loc3_)
            {
               if("mining_create_info_page" !== _loc3_)
               {
                  if("mining_adjust_format_complete" !== _loc3_)
                  {
                     if("mining_update_pagevec" !== _loc3_)
                     {
                        if("mining_explort_complete" !== _loc3_)
                        {
                           if("mining_occupy_complete" !== _loc3_)
                           {
                              if("mining_get_power_complete" !== _loc3_)
                              {
                                 if("mining_show_defend_news" !== _loc3_)
                                 {
                                    if("mining_hide_defend_news" === _loc3_)
                                    {
                                       miningFrameUI.defendNews.visible = false;
                                    }
                                 }
                                 else
                                 {
                                    miningFrameUI.defendNews.visible = true;
                                 }
                              }
                              else
                              {
                                 miningFrameUI.tf_power.text = MiningFrameMediator.breadNum + "/30";
                              }
                           }
                           else
                           {
                              (nowPage as MiningInfoPage).occupyComplete();
                           }
                        }
                        else
                        {
                           var i:int = 0;
                           while(i < pageVec.length)
                           {
                              if(pageVec[i] is MiningInfoPage && (pageVec[i] as MiningInfoPage).littleIconType == 4)
                              {
                                 pageVec[i].removeFromParent(true);
                                 pageVec.splice(i,1);
                                 littleIconVec[i].removeFromParent(true);
                                 littleIconVec.splice(i,1);
                                 MiningPro.miningVOVec.splice(i,1);
                                 break;
                              }
                              i = i + 1;
                           }
                           addMiningInfoPage(notification.getBody() as MiningVO);
                           miningFrameUI.tf_power.text = MiningFrameMediator.breadNum + "/30";
                        }
                     }
                     else if(nowPageIndex != pageVec.length - 1)
                     {
                        nowPage.gestureStatus = "left";
                        nowPage.setMoving(true,function():void
                        {
                           nowPage.removeFromParent(true);
                        });
                        var nextPage:SwitchPage = pageVec[nowPageIndex + 1];
                        nextPage.x = 1136;
                        nextPage.gestureStatus = "left";
                        miningFrameUI.pageContainer.addChild(nextPage);
                        nextPage.setMoving(true,function():void
                        {
                           nowPage = nextPage;
                           nowPageIndex = nowPageIndex + 1;
                           updateAfterSwitch();
                           littleIconVec[nowPageIndex - 1].removeFromParent(true);
                           nowPageIndex = nowPageIndex - 1;
                           littleIconVec.splice(nowPageIndex,1);
                           pageVec.splice(nowPageIndex,1);
                           MiningPro.miningVOVec.splice(nowPageIndex,1);
                           updateLeftAndRightBtn();
                        });
                     }
                  }
                  else
                  {
                     var object:Object = notification.getBody();
                     (nowPage as MiningInfoPage).miningObj.totalNum = object.sumRes;
                     (nowPage as MiningInfoPage).miningObj.speed = object.perRes;
                     (nowPage as MiningInfoPage).updateTfAfterAdjustFormat();
                  }
               }
               else
               {
                  addMiningInfoPage(notification.getBody() as MiningVO);
               }
            }
            else if(nowPage is MiningInfoPage)
            {
               (nowPage as MiningInfoPage).updateLessTimeTf(notification.getBody());
            }
         }
         else
         {
            initMiningInfoPage();
         }
      }
      
      private function updateLittleIconState() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < littleIconVec.length)
         {
            if(_loc1_ == nowPageIndex)
            {
               littleIconVec[_loc1_].getChildAt(1).visible = true;
               littleIconVec[_loc1_].getChildAt(0).visible = false;
            }
            else
            {
               littleIconVec[_loc1_].getChildAt(1).visible = false;
               littleIconVec[_loc1_].getChildAt(0).visible = true;
            }
            _loc1_++;
         }
      }
      
      private function addMiningInfoPage(param1:MiningVO) : void
      {
         var _loc2_:MiningInfoPage = new MiningInfoPage(param1);
         if(_loc2_.littleIconType == 4)
         {
            miningFrameUI.createExportMc();
         }
         pageVec.unshift(_loc2_);
         miningFrameUI.pageContainer.addChild(_loc2_);
         nowPage.removeFromParent();
         nowPageIndex = 0;
         nowPage = _loc2_;
         MiningPro.pageEndTime = _loc2_.miningObj.endTime;
         miningFrameUI.tf_pageTittle.text = _loc2_.miningObj.name;
         littleIconVec.unshift(miningFrameUI.addLittleIcon(_loc2_.littleIconType));
         updateLeftAndRightBtn();
      }
      
      private function removePage() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < pageVec.length)
         {
            if(pageVec[_loc2_] is MiningInfoPage && (pageVec[_loc2_] as MiningInfoPage).isComplete)
            {
               _loc1_ = true;
            }
            (pageVec[_loc2_] as SwitchPage).removeFromParent(true);
            _loc2_++;
         }
         if(_loc1_ || MiningPro.isShowDefendNews)
         {
            MiningPro.isShowMineNews = true;
            sendNotification("show_mine_draw");
         }
         else
         {
            MiningPro.isShowMineNews = false;
            sendNotification("hide_mine_draw");
         }
         pageVec = null;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["mining_init_page","mining_update_defend_countdown","mining_create_info_page","mining_adjust_format_complete","mining_update_pagevec","mining_explort_complete","mining_occupy_complete","mining_get_power_complete","mining_show_defend_news","mining_hide_defend_news"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         Starling.current.juggler.removeTweens(nowPage);
         Starling.current.juggler.removeTweens(nextPage);
         if(MiningRule.instance)
         {
            MiningRule.getInstance().removeSelf();
         }
         if(facade.hasMediator("MiningDefendRecordMediator"))
         {
            (facade.retrieveMediator("MiningDefendRecordMediator") as MiningDefendRecordMediator).dispose();
         }
         if(facade.hasMediator("MiningSelectMemberMediator"))
         {
            (facade.retrieveMediator("MiningSelectMemberMediator") as MiningSelectMemberMediator).dispose();
         }
         if(facade.hasMediator("MiningInviteMediator"))
         {
            (facade.retrieveMediator("MiningInviteMediator") as MiningInviteMediator).dispose();
         }
         if(facade.hasMediator("MiningCheckFormatMediator"))
         {
            (facade.retrieveMediator("MiningCheckFormatMediator") as MiningCheckFormatMediator).dispose();
         }
         if(facade.hasMediator("MiningSelectTypeMediator"))
         {
            (facade.retrieveMediator("MiningSelectTypeMediator") as MiningSelectTypeMediator).dispose();
         }
         if(facade.hasMediator("SelePlayElfMedia"))
         {
            (facade.retrieveMediator("SelePlayElfMedia") as SelePlayElfMedia).dispose();
         }
         if(facade.hasMediator("SelectFormationMedia"))
         {
            (facade.retrieveMediator("SelectFormationMedia") as SelectFormationMedia).dispose();
         }
         EventCenter.removeEventListener("mining_finger_left",finger_leftHandler);
         EventCenter.removeEventListener("mining_finger_right",finger_rightHandler);
         removePage();
         facade.removeMediator("MiningFrameMediator");
         UI.dispose();
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.miningAssets);
         MiningPro.removeMiningBgAssets();
      }
   }
}
