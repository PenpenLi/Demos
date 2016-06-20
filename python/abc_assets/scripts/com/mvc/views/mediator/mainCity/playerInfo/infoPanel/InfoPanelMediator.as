package com.mvc.views.mediator.mainCity.playerInfo.infoPanel
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.InfoPanelUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.ChangeNameUI;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.mvc.views.uis.mainCity.playerInfo.infoPanel.GameSettingUI;
   import starling.core.Starling;
   import com.common.events.EventCenter;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import starling.display.Sprite;
   import com.mvc.views.uis.NoteTestUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetLvExp;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import starling.display.DisplayObject;
   
   public class InfoPanelMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "InfoPanelMediator";
      
      public static var isCancelPokeBtn:Boolean;
       
      private var infoPanelUI:InfoPanelUI;
      
      private var badgeNum:uint;
      
      public function InfoPanelMediator(param1:Object = null)
      {
         super("InfoPanelMediator",param1);
         infoPanelUI = param1 as InfoPanelUI;
         infoPanelUI.addEventListener("triggered",infoPanelUI_triggeredHandler);
         badgeNum = PlayerVO.badgeNum;
      }
      
      private function infoPanelUI_triggeredHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("target: " + param1.target);
         var _loc4_:* = param1.target;
         if(infoPanelUI.personalCloseBtn !== _loc4_)
         {
            if(infoPanelUI.changeNameBtn !== _loc4_)
            {
               if(infoPanelUI.changeTrainerBtn !== _loc4_)
               {
                  if(infoPanelUI.changeHeadPicBtn !== _loc4_)
                  {
                     if(infoPanelUI.cancelHeadBtn !== _loc4_)
                     {
                        if(infoPanelUI.gameSettingBtn !== _loc4_)
                        {
                           if(infoPanelUI.checkBadgeBtn !== _loc4_)
                           {
                              if(infoPanelUI.checkBadgeCloseBtn !== _loc4_)
                              {
                                 if(infoPanelUI.btn_test === _loc4_)
                                 {
                                    infoPanelUI.addChild(NoteTestUI.getIntance());
                                 }
                              }
                              else
                              {
                                 ((infoPanelUI.parent as Game).page as Sprite).unflatten();
                                 infoPanelUI.checkBadgeSpr.removeFromParent();
                                 infoPanelUI.badgeQuad.removeFromParent();
                              }
                           }
                           else
                           {
                              if(PlayerVO.badgeNum == 0)
                              {
                                 Tips.show("亲，暂时还没有获得徽章哦");
                                 return;
                              }
                              if(infoPanelUI.checkBadgeSpr == null)
                              {
                                 infoPanelUI.checkBadge();
                                 infoPanelUI.addChild(infoPanelUI.badgeQuad);
                                 infoPanelUI.addChild(infoPanelUI.checkBadgeSpr);
                                 return;
                              }
                              if(badgeNum != PlayerVO.badgeNum)
                              {
                                 infoPanelUI.checkBadgeSpr.removeChildren(0,-1,true);
                                 infoPanelUI.checkBadge();
                                 badgeNum = PlayerVO.badgeNum;
                              }
                              if(!((infoPanelUI.parent as Game).page is MainCityUI))
                              {
                                 ((infoPanelUI.parent as Game).page as Sprite).flatten();
                              }
                              infoPanelUI.addChild(infoPanelUI.badgeQuad);
                              infoPanelUI.addChild(infoPanelUI.checkBadgeSpr);
                           }
                        }
                        else
                        {
                           if(!facade.hasMediator("GameSettingMediator"))
                           {
                              facade.registerMediator(new GameSettingMediator(new GameSettingUI()));
                           }
                           _loc2_ = (facade.retrieveMediator("GameSettingMediator") as GameSettingMediator).UI as GameSettingUI;
                           (Starling.current.root as Game).addChild(_loc2_);
                           EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadGameSettingSprAfter);
                           WinTweens.openWin(_loc2_.gameSettingSpr);
                        }
                     }
                     else
                     {
                        isCancelPokeBtn = true;
                        if(PlayerVO.headPtId != PlayerVO.trainPtId)
                        {
                           sendNotification("update_headpic",PlayerVO.trainPtId);
                           (facade.retrieveProxy("PlayInfoPro") as PlayInfoPro).write1102(PlayerVO.trainPtId,PlayerVO.nickName,PlayerVO.trainPtId);
                        }
                        else
                        {
                           Tips.show("取消头像成功");
                        }
                     }
                  }
                  else if(PlayerVO.headArr.length)
                  {
                     isCancelPokeBtn = false;
                     sendNotification("switch_win",null,"load_headPic_panel");
                  }
                  else
                  {
                     Tips.show("您当前没有可用的宠物头像");
                  }
               }
               else
               {
                  sendNotification("switch_win",null,"load_trainerPic_panel");
               }
            }
            else
            {
               if(!PlayerVO.isFirstChangeName && PlayerVO.diamond <= 0)
               {
                  Tips.show("亲，钻石不足哦");
                  return;
               }
               if(!facade.hasMediator("ChangeNameMediator"))
               {
                  facade.registerMediator(new ChangeNameMediator(new ChangeNameUI()));
               }
               _loc3_ = (facade.retrieveMediator("ChangeNameMediator") as ChangeNameMediator).UI as ChangeNameUI;
               infoPanelUI.addChild(_loc3_);
            }
         }
         else
         {
            WinTweens.closeWin(infoPanelUI.personalInfoSpr,removeWindow);
         }
      }
      
      private function loadGameSettingSprAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadGameSettingSprAfter);
         sendNotification("update_gamesetting_list");
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         infoPanelUI.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_headpic","update_play_info_panel","update_nickname"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = param1.getName();
         if("update_headpic" !== _loc4_)
         {
            if("update_nickname" !== _loc4_)
            {
               if("update_play_info_panel" === _loc4_)
               {
                  _loc2_ = 0;
                  if(PlayerVO.lv < PlayerVO.playerLvVoVec.length)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < PlayerVO.lv)
                     {
                        _loc2_ = _loc2_ + PlayerVO.playerLvVoVec[_loc3_].exp;
                        _loc3_++;
                     }
                     infoPanelUI.nextEXPTf.text = _loc2_ - PlayerVO.exper;
                  }
                  else
                  {
                     infoPanelUI.nextEXPTf.text = "0";
                  }
                  infoPanelUI.nicknameTf.text = PlayerVO.nickName;
                  infoPanelUI.levelTf.text = PlayerVO.lv;
                  infoPanelUI.vipLvTf.text = PlayerVO.vipRank;
                  infoPanelUI.handbookTf.text = PlayerVO.handbookNum;
                  infoPanelUI.elfLvMaxTf.text = GetLvExp.elfGradepv[PlayerVO.lv - 1];
                  infoPanelUI.adventureTimeTf.text = transDate(PlayerVO.firstLoginDay);
                  infoPanelUI.idContentTf.text = PlayerVO.userId;
                  changeHeadPic(PlayerVO.headPtId);
                  if(PlayerVO.sex)
                  {
                     _loc4_ = true;
                     infoPanelUI.manSign.visible = _loc4_;
                     §§push(_loc4_);
                  }
                  else
                  {
                     _loc4_ = true;
                     infoPanelUI.womanSign.visible = _loc4_;
                     §§push(_loc4_);
                  }
                  §§pop();
               }
            }
            else
            {
               infoPanelUI.nicknameTf.text = PlayerVO.nickName;
               sendNotification("close_nickname_panel");
            }
         }
         else
         {
            changeHeadPic(param1.getBody() as int);
         }
      }
      
      private function transDate(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.fullYear + "年" + (_loc2_.month + 1) + "月" + _loc2_.date + "日";
      }
      
      private function changeHeadPic(param1:int) : void
      {
         var _loc2_:* = null;
         _loc2_ = GetPlayerRelatedPicFactor.getHeadPic(param1);
         infoPanelUI.headPicImg.texture = _loc2_.texture;
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("InfoPanelMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
