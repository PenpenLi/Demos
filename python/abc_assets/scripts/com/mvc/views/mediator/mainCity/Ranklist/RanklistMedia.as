package com.mvc.views.mediator.mainCity.Ranklist
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.Ranklist.RanklistUI;
   import com.mvc.views.uis.mainCity.Ranklist.MenuButtonUnit;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.rankList.RankListPro;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import starling.display.Quad;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.elfSeries.RivalInfoMedia;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class RanklistMedia extends Mediator
   {
      
      public static const NAME:String = "RanklistMedia";
      
      public static const menuGap:int = 10;
      
      public static var isScrolling:Boolean;
      
      public static var decArr:Array = ["","","\n对战积分","\n收集精灵数量: ","\n遇见精灵数量: ","\n拥有神兽数量: ","\n玩家战斗力: "];
       
      public var ranklist:RanklistUI;
      
      private var btnVec:Vector.<MenuButtonUnit>;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var mainArr:Array;
      
      private var listArr:Array;
      
      private var listAllArr:Array;
      
      private var rankType:int;
      
      private var rankingList:Array;
      
      public function RanklistMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         mainArr = ["等级","竞技场","精灵图鉴","战斗力"];
         listArr = [["玩家等级"],["联盟大赛","pvp在线对战"],["精灵收集","精灵遇见","神兽数量"],["玩家战斗力"]];
         listAllArr = ["玩家等级","联盟大赛","pvp在线对战","精灵收集","精灵遇见","神兽数量","玩家战斗力"];
         super("RanklistMedia",param1);
         ranklist = param1 as RanklistUI;
         ranklist.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(ranklist.btn_close === _loc2_)
         {
            cleanBtn();
            ranklist.cleanImg();
            ranklist.panel.removeChildren(0,-1,true);
            if(ranklist.rankList.dataProvider)
            {
               ranklist.rankList.dataProvider.removeAll();
               ranklist.rankList.dataProvider = null;
            }
            WinTweens.closeWin(ranklist.spr_rank,remove);
         }
      }
      
      private function remove() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = 0;
         var _loc8_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc9_:* = param1.getName();
         if("SHOW_RANK_MENU" !== _loc9_)
         {
            if("CLICK_RANK_MENU" !== _loc9_)
            {
               if("CLICK_RANK_MENU_LIST" !== _loc9_)
               {
                  if("SEND_RANK" !== _loc9_)
                  {
                     if("SHOW_RANKPLAYER_DATA" !== _loc9_)
                     {
                        if("UPDATE_MENU_POSITION" === _loc9_)
                        {
                           upDateMenuPosition(param1.getBody() as int);
                        }
                     }
                     else
                     {
                        _loc6_ = param1.getBody() as RivalVO;
                        sendNotification("switch_win",null,"LOAD_RIVAL_INFO");
                        sendNotification("SEND_RIVAL_INFO",_loc6_);
                     }
                  }
                  else
                  {
                     _loc2_ = param1.getBody().rankObj;
                     rankType = param1.getBody().rankType;
                     rankingList = _loc2_.rankingList;
                     _loc5_ = _loc2_.ownRank;
                     _loc7_ = _loc2_.ownValue;
                     LogUtil("rankType==",rankType,_loc5_);
                     show();
                     ranklist.myRank(_loc5_,rankType,_loc7_);
                  }
               }
               else
               {
                  _loc4_ = param1.getBody().id as uint;
                  _loc8_ = param1.getBody().parentId as uint;
                  _loc3_ = param1.getBody().name as String;
                  clickMenuList(_loc4_,_loc8_);
                  (facade.retrieveProxy("RankListPro") as RankListPro).write2701(listAllArr.indexOf(_loc3_));
               }
            }
            else
            {
               clickMenu(param1.getBody() as int);
            }
         }
         else
         {
            addMenu();
         }
      }
      
      private function menuBtnNum(param1:int) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < listArr.length)
         {
            if(param1 != _loc3_)
            {
               _loc2_ = _loc2_ + listArr[_loc3_].length;
               _loc3_++;
               continue;
            }
            break;
         }
         return _loc2_;
      }
      
      private function clickMenuList(param1:uint, param2:uint) : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < btnVec[param2].btnListVec.length)
         {
            if(btnVec[param2].btnListVec[_loc3_].id != param1)
            {
               btnVec[param2].btnListVec[_loc3_].switchState(true);
            }
            _loc3_++;
         }
      }
      
      private function clickMenu(param1:uint) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < btnVec.length)
         {
            if(btnVec[_loc2_].id != param1)
            {
               btnVec[_loc2_].change();
            }
            _loc2_++;
         }
      }
      
      private function addMenu() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         var _loc3_:* = null;
         ranklist.panel.removeChildren(0,-1,true);
         btnVec = new Vector.<MenuButtonUnit>([]);
         _loc2_ = 0;
         while(_loc2_ < mainArr.length)
         {
            _loc1_ = new MenuButtonUnit(mainArr[_loc2_],ranklist.swf.createImage("img_menuUp").texture,ranklist.swf.createImage("img_menuDown").texture);
            if(_loc2_ > 0)
            {
               _loc1_.y = btnVec[_loc2_ - 1].y + btnVec[_loc2_ - 1].height + 10;
            }
            else
            {
               _loc1_.y = 0;
            }
            _loc1_.id = _loc2_;
            _loc1_.myListBtn = listArr[_loc2_];
            ranklist.panel.addChild(_loc1_);
            btnVec.push(_loc1_);
            _loc2_++;
         }
         if(mainArr.length * (_loc1_.height + 10) + 220 > 500)
         {
            _loc3_ = new Quad(1,1,16777215);
            _loc3_.alpha = 0;
            _loc3_.y = mainArr.length * (_loc1_.height + 10) + 220;
            ranklist.panel.addChild(_loc3_);
         }
      }
      
      public function upDateMenuPosition(param1:uint) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < btnVec.length)
         {
            if(btnVec[_loc2_].id > param1)
            {
               btnVec[_loc2_].y = btnVec[_loc2_ - 1].y + btnVec[_loc2_ - 1].height + 10;
            }
            _loc2_++;
         }
      }
      
      private function show() : void
      {
         var _loc8_:* = 0;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = null;
         if(ranklist.rankList.dataProvider)
         {
            ranklist.rankList.dataProvider.removeAll();
            ranklist.rankList.dataProvider = null;
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc1_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < rankingList.length)
         {
            _loc6_ = new Sprite();
            if(_loc8_ < 3)
            {
               _loc3_ = ranklist.getImage("img_pp" + (_loc8_ + 1));
               var _loc10_:* = 0.8;
               _loc3_.scaleY = _loc10_;
               _loc3_.scaleX = _loc10_;
               _loc3_.x = 10;
               _loc3_.y = 5 + _loc8_ * 10;
               _loc6_.addChild(_loc3_);
            }
            else
            {
               _loc9_ = new TextField(106,69,(_loc8_ + 1).toString(),"img_rank",50,16777215,true);
               _loc9_.y = 18;
               _loc9_.x = -3;
               _loc6_.addChild(_loc9_);
            }
            _loc5_ = GetPlayerRelatedPicFactor.getHeadPic(rankingList[_loc8_].headPtId,0.8);
            _loc5_.x = 110;
            _loc5_.name = _loc8_.toString();
            _loc6_.addChild(_loc5_);
            if(rankingList[_loc8_].vipRank > 0)
            {
               _loc2_ = GetCommon.getVipIcon(rankingList[_loc8_].vipRank);
               _loc2_.x = _loc5_.x - 5;
               _loc2_.y = _loc5_.y - 5;
               _loc6_.addChild(_loc2_);
            }
            _loc4_ = "Lv." + rankingList[_loc8_].lv + "     " + rankingList[_loc8_].userName;
            switch(rankType - 2)
            {
               case 0:
                  _loc4_ = _loc4_ + (decArr[rankType] + rankingList[_loc8_].pvpScore);
                  break;
               case 1:
                  _loc4_ = _loc4_ + (decArr[rankType] + rankingList[_loc8_].catchNum);
                  break;
               case 2:
                  _loc4_ = _loc4_ + (decArr[rankType] + rankingList[_loc8_].metNum);
                  break;
               case 3:
                  _loc4_ = _loc4_ + (decArr[rankType] + rankingList[_loc8_].godPokeNum);
                  break;
               case 4:
                  _loc4_ = _loc4_ + (decArr[rankType] + rankingList[_loc8_].attack);
                  break;
            }
            _loc1_.push({
               "icon":_loc6_,
               "label":_loc4_
            });
            _loc5_.addEventListener("touch",ontouch);
            displayVec.push(_loc6_);
            _loc8_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc1_);
         ranklist.rankList.dataProvider = _loc7_;
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc5_:* = null;
         var _loc2_:Image = param1.target as Image;
         var _loc3_:Touch = param1.getTouch(_loc2_);
         var _loc4_:int = _loc2_.name;
         if(_loc3_ && _loc3_.phase == "began")
         {
            _loc5_ = new RivalVO();
            _loc5_.lv = rankingList[_loc4_].lv;
            _loc5_.headPtId = rankingList[_loc4_].headPtId;
            _loc5_.rank = _loc4_ + 1;
            _loc5_.userName = rankingList[_loc4_].userName;
            _loc5_.userId = rankingList[_loc4_].userId;
            (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5011(_loc5_,true);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_RANK_MENU","CLICK_RANK_MENU","CLICK_RANK_MENU_LIST","SEND_RANK","SHOW_RANKPLAYER_DATA","UPDATE_MENU_POSITION"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function cleanBtn() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < btnVec.length)
         {
            _loc2_ = 0;
            while(_loc2_ < btnVec[_loc1_].btnListVec.length)
            {
               btnVec[_loc1_].btnListVec[_loc2_].removeFromParent(true);
               _loc2_++;
            }
            btnVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         btnVec = Vector.<MenuButtonUnit>([]);
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            cleanBtn();
            ranklist.cleanImg();
            ranklist.panel.removeChildren(0,-1,true);
            if(ranklist.rankList.dataProvider)
            {
               ranklist.rankList.dataProvider.removeAll();
               ranklist.rankList.dataProvider = null;
            }
         }
         if(Facade.getInstance().hasMediator("RivalInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("RivalInfoMedia") as RivalInfoMedia).dispose();
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         isScrolling = false;
         WinTweens.showCity();
         facade.removeMediator("RanklistMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.ranklistAssets);
      }
   }
}
