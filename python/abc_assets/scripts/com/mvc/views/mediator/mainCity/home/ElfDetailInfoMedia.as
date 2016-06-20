package com.mvc.views.mediator.mainCity.home
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.home.ElfDetailInfoUI;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.mainCity.home.HomeUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class ElfDetailInfoMedia extends Mediator
   {
      
      public static const NAME:String = "ElfDetailInfoMedia";
      
      public static var showFreeBtn:Boolean;
      
      public static var showSetNameBtn:Boolean;
       
      public var elfDetailInfo:ElfDetailInfoUI;
      
      public function ElfDetailInfoMedia(param1:Object = null)
      {
         super("ElfDetailInfoMedia",param1);
         elfDetailInfo = param1 as ElfDetailInfoUI;
         elfDetailInfo.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = param1.target;
         if(elfDetailInfo.info_close !== _loc7_)
         {
            if(elfDetailInfo.btn_makeFree !== _loc7_)
            {
               if(elfDetailInfo.btn_setNiceName === _loc7_)
               {
                  sendNotification("switch_win",elfDetailInfo,"LOAD_ELFNAME_WIN");
                  sendNotification("SEND_SETNAME_ELF",elfDetailInfo.myElfVo,"true");
               }
            }
            else
            {
               if(GetElfFactor.bagElfNum() == 1 && elfDetailInfo.myElfVo.isCarry == 1)
               {
                  Tips.show("背包至少留一个精灵");
                  return;
               }
               if(PlayerVO.miningDefendElfArr.indexOf(elfDetailInfo.myElfVo.id) != -1)
               {
                  Tips.show("挖矿防守中的精灵不能放生");
                  return;
               }
               if(PlayerVO.trainElfArr.indexOf(elfDetailInfo.myElfVo.id) != -1)
               {
                  Tips.show("训练位的精灵不能放生");
                  return;
               }
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.FormationElfVec.length)
               {
                  if(PlayerVO.FormationElfVec[_loc2_] != null)
                  {
                     if(PlayerVO.FormationElfVec[_loc2_].id == elfDetailInfo.myElfVo.id)
                     {
                        Tips.show("竞技场的防守精灵不能放生");
                        return;
                     }
                  }
                  _loc2_++;
               }
               if(PlayerVO.kingIsOpen)
               {
                  _loc4_ = 0;
                  while(_loc4_ < KingKwanMedia.kingPlayElf.length)
                  {
                     if(KingKwanMedia.kingPlayElf[_loc4_].id == elfDetailInfo.myElfVo.id)
                     {
                        _loc5_ = Alert.show("放生的精灵当是王者之路的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                        if(elfDetailInfo.myElfVo.rareValue == 5)
                        {
                           _loc5_.addEventListener("close",secondWin);
                        }
                        else
                        {
                           _loc5_.addEventListener("close",makeFreeSureHandler);
                        }
                        return;
                     }
                     _loc4_++;
                  }
               }
               if(elfDetailInfo.myElfVo.rareValue >= 4)
               {
                  _loc3_ = Alert.show("放生的精灵是稀有度为[史诗]或以上的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc3_.addEventListener("close",makeFreeSureHandler);
               }
               else
               {
                  _loc6_ = Alert.show("确定放生精灵？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc6_.addEventListener("close",makeFreeSureHandler);
               }
            }
         }
         else
         {
            remove();
         }
      }
      
      private function secondWin(param1:Event, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.label == "确定")
         {
            _loc3_ = Alert.show("放生的精灵是稀有度为【传说】的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc3_.addEventListener("close",makeFreeSureHandler);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         LogUtil(!((Config.starling.root as Game).page is HomeUI),"===================");
         if(!((Config.starling.root as Game).page is HomeUI))
         {
            LogUtil("不在玩家的家，销毁--");
            elfDetailInfo.cleanImg();
         }
         elfDetailInfo.removeFromParent();
         showFreeBtn = false;
         showSetNameBtn = false;
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function makeFreeSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("HomePro") as HomePro).write2004(elfDetailInfo.myElfVo);
         }
      }
      
      private function freeHandle() : void
      {
         var _loc1_:* = 0;
         sendNotification("switch_win",null);
         elfDetailInfo.cleanImg();
         elfDetailInfo.removeFromParent();
         if(facade.hasMediator("HomeMedia"))
         {
            sendNotification("CLEAN_ELFINFO_CLOSE");
         }
         if(elfDetailInfo.myElfVo.isCarry == 1)
         {
            PlayerVO.bagElfVec[elfDetailInfo.myElfVo.position - 1] = null;
            GetElfFactor.seiri();
            if(facade.hasMediator("HomeMedia"))
            {
               sendNotification("SHOW_BAG_ELF");
            }
         }
         else if(elfDetailInfo.myElfVo.isCarry == 0)
         {
            PlayerVO.comElfVec.splice(GetElfFactor.comIndex(elfDetailInfo.myElfVo),1);
            if(facade.hasMediator("HomeMedia"))
            {
               sendNotification("SHOW_COM_ELF");
            }
         }
         _loc1_ = 0;
         while(_loc1_ < KingKwanMedia.kingPlayElf.length)
         {
            if(KingKwanMedia.kingPlayElf[_loc1_].id == elfDetailInfo.myElfVo.id)
            {
               KingKwanMedia.kingPlayElf.splice(_loc1_,1);
               break;
            }
            _loc1_++;
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_ELF_DETAIL" !== _loc2_)
         {
            if("MAKE_FREE_ELF" === _loc2_)
            {
               freeHandle();
            }
         }
         else
         {
            elfDetailInfo.myElfVo = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_ELF_DETAIL","MAKE_FREE_ELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         elfDetailInfo.cleanImg();
         showFreeBtn = false;
         showSetNameBtn = false;
         facade.removeMediator("ElfDetailInfoMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
