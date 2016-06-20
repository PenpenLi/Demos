package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.huntingParty.HuntNodeVO;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.uis.huntingParty.HuntMeetUI;
   import lzm.util.TimeUtil;
   import com.common.managers.ElfFrontImageManager;
   import starling.display.DisplayObject;
   
   public class HuntingPartyMedia extends Mediator
   {
      
      public static const NAME:String = "HuntingPartyMedia";
      
      public static var nodeVO:HuntNodeVO;
      
      public static var isHuntParty:Boolean;
       
      public var huntingParty:HuntingPartyUI;
      
      private var meetElf:ElfVO;
      
      public function HuntingPartyMedia(param1:Object = null)
      {
         super("HuntingPartyMedia",param1);
         huntingParty = param1 as HuntingPartyUI;
         huntingParty.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = param1.target;
         if(huntingParty.btn_home !== _loc4_)
         {
            if(huntingParty.btn_bag !== _loc4_)
            {
               if(huntingParty.btn_elf !== _loc4_)
               {
                  if(huntingParty.btn_rank !== _loc4_)
                  {
                     if(huntingParty.btn_reward !== _loc4_)
                     {
                        if(huntingParty.btn_addTime !== _loc4_)
                        {
                           if(huntingParty.btn_myHome !== _loc4_)
                           {
                              if((param1.target as SwfButton).name.indexOf("btn") != -1)
                              {
                                 if(HuntPartyVO.catchCount <= 0)
                                 {
                                    _loc2_ = Alert.show("行动次数不足，是否购买？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                                    _loc2_.addEventListener("close",alertHander);
                                    return;
                                 }
                                 _loc3_ = (param1.target as SwfButton).name.substring(3);
                                 nodeVO = GetHuntingParty.nodeVec[_loc3_ - 1];
                                 if(nodeVO.type == 1)
                                 {
                                    (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4102(nodeVO);
                                 }
                                 else
                                 {
                                    sendNotification("switch_win",null,"LOAD_HUNTADVENTURE_WIN");
                                 }
                              }
                           }
                           else
                           {
                              sendNotification("switch_page","LOAD_HOME");
                           }
                        }
                        else
                        {
                           if(!closePrompt())
                           {
                              return;
                           }
                           sendNotification("switch_win",null,"LOAD_HUNTBUYCOUNT_WIN");
                        }
                     }
                     else
                     {
                        if(!closePrompt())
                        {
                           return;
                        }
                        sendNotification("switch_win",null,"LOAD_HUNTINGREWARD_WIN");
                     }
                  }
                  else
                  {
                     sendNotification("switch_win",null,"LOAD_HUNTINGRANK_WIN");
                  }
               }
               else
               {
                  sendNotification("switch_win",null,"LOAD_ELF_WIN");
               }
            }
            else
            {
               if(!closePrompt())
               {
                  return;
               }
               sendNotification("switch_win",null,"LOAD_HUNTBAG_WIN");
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      public function closePrompt() : Boolean
      {
         if(!HuntPartyVO.isOpen)
         {
            Tips.show("捕虫大会活动已结束");
            return false;
         }
         return true;
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"LOAD_HUNTBUYCOUNT_WIN");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_HUNTINGPARTY","UPDATE_GOALELF_CDTIME","UPDATE_HUNTBUFFTIME","UPDATE_HUNTCOUNT","UPDATE_HUNTBUFF","SHOW_GOALELF_UI","SEND_MEETREULT","UPDATE_HUNTBUYCOUNT_TIME","UPDATE_HUNTSCORE","UPDATE_HUNTNODE","USE_SCOREPROP","UPDATE_HUNTSCORE_TIME"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_HUNTINGPARTY" !== _loc2_)
         {
            if("UPDATE_GOALELF_CDTIME" !== _loc2_)
            {
               if("UPDATE_HUNTBUFFTIME" !== _loc2_)
               {
                  if("UPDATE_HUNTBUFF" !== _loc2_)
                  {
                     if("SHOW_GOALELF_UI" !== _loc2_)
                     {
                        if("SEND_MEETREULT" !== _loc2_)
                        {
                           if("UPDATE_HUNTBUYCOUNT_TIME" !== _loc2_)
                           {
                              if("UPDATE_HUNTCOUNT" !== _loc2_)
                              {
                                 if("UPDATE_HUNTSCORE" !== _loc2_)
                                 {
                                    if("UPDATE_HUNTNODE" !== _loc2_)
                                    {
                                       if("USE_SCOREPROP" !== _loc2_)
                                       {
                                          if("UPDATE_HUNTSCORE_TIME" === _loc2_)
                                          {
                                             if(HuntPartyVO.scoreLessTime <= 0)
                                             {
                                                huntingParty.updateScore();
                                             }
                                             else if(huntingParty.scoreIcon)
                                             {
                                                huntingParty.scoreIcon.updateTime(HuntPartyVO.scoreLessTime);
                                             }
                                          }
                                       }
                                       else
                                       {
                                          huntingParty.updateScore();
                                       }
                                    }
                                    else
                                    {
                                       huntingParty.updateNode();
                                    }
                                 }
                                 else
                                 {
                                    HuntPartyVO.score = param1.getBody() as int;
                                    huntingParty.sorceNum.text = HuntPartyVO.score;
                                 }
                              }
                              else
                              {
                                 HuntPartyVO.catchCount = param1.getBody() as int;
                                 huntingParty.catchCount.text = HuntPartyVO.catchCount + "<font color=\'#ffff00\' sizer=\'18\'>/" + HuntPartyVO.maxCatchCount + "</font>";
                              }
                           }
                           else
                           {
                              huntingParty.countTime.text = "下点恢复: " + TimeUtil.convertStringToDate(HuntPartyVO.lessCountTime);
                           }
                        }
                        else
                        {
                           meetElf = GetElfFromSever.getElfInfo(param1.getBody());
                           HuntMeetUI.getInstance().show(meetElf);
                        }
                     }
                     else
                     {
                        huntingParty.updateElf();
                     }
                  }
                  else
                  {
                     huntingParty.updateBuff();
                  }
               }
               else if(HuntPartyVO.buffObj.time <= 0)
               {
                  HuntPartyVO.buffObj = null;
                  huntingParty.updateBuff();
               }
               else if(huntingParty.buffIcon)
               {
                  huntingParty.buffIcon.updateTime(HuntPartyVO.buffObj.time);
               }
            }
            else if(HuntPartyVO.catchElfObj.lessTime <= 0)
            {
               LogUtil("000000000000000000");
               huntingParty.updateElf();
            }
            else if(huntingParty.targetElf)
            {
               huntingParty.targetElf.updateTime(HuntPartyVO.catchElfObj.lessTime);
            }
         }
         else
         {
            huntingParty.setInfo();
         }
      }
      
      private function removeHandle() : void
      {
         ElfFrontImageManager.tempNoRemoveTexture = [];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         removeHandle();
         facade.removeMediator("HuntingPartyMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
