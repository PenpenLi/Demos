package com.mvc.views.mediator.mainCity.kingKwan
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.kingKwan.KingHelpUI;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.mainCity.kingKwan.KingVO;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.text.TextField;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class KingKwanMedia extends Mediator
   {
      
      public static const NAME:String = "KingKwanMedia";
      
      public static var isChallenge:Boolean;
      
      public static var remainCount:int;
      
      public static var mopUpCount:int;
      
      public static var passNum:int;
      
      public static var kingPlayElf:Vector.<ElfVO> = new Vector.<ElfVO>([]);
       
      public var kingKwan:KingKwanUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function KingKwanMedia(param1:Object = null)
      {
         super("KingKwanMedia",param1);
         kingKwan = param1 as KingKwanUI;
         displayVec = new Vector.<DisplayObject>([]);
         kingKwan.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = param1.target;
         if(kingKwan.btn_close !== _loc5_)
         {
            if(kingKwan.btn_help !== _loc5_)
            {
               if(kingKwan.btn_exChangeScore !== _loc5_)
               {
                  if(kingKwan.btn_reStart !== _loc5_)
                  {
                     if(kingKwan.btn_kingMopUp === _loc5_)
                     {
                        _loc3_ = Alert.show("亲爱的玩家，是否使用扫荡功能？目前可以扫荡关数: " + mopUpCount + "关","",new ListCollection([{"label":"扫荡"},{"label":"取消"}]));
                        _loc3_.addEventListener("close",mopUpAlertHander);
                     }
                  }
                  else if(KingKwanMedia.remainCount != 0)
                  {
                     _loc2_ = Alert.show("亲，您确定要重置王者之路么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                     _loc2_.addEventListener("close",reStartAlertHander);
                  }
                  else
                  {
                     Tips.show("重置次数已用完啦，请明天再来挑战哦");
                  }
               }
               else
               {
                  kingKwan.spr_king.removeFromParent();
                  ScoreShopMediator.nowType = "KingKwanMedia";
                  sendNotification("switch_win",null,"load_score_shop");
               }
            }
            else
            {
               if(!facade.hasMediator("KingHelpMedia"))
               {
                  facade.registerMediator(new KingHelpMedia(new KingHelpUI()));
               }
               _loc4_ = (facade.retrieveMediator("KingHelpMedia") as KingHelpMedia).UI as KingHelpUI;
               kingKwan.parent.addChild(_loc4_);
               WinTweens.openWin(_loc4_.spr_helpSpr);
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      private function mopUpAlertHander(param1:Event) : void
      {
         if(param1.data.label == "扫荡")
         {
            (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2313();
         }
      }
      
      private function reStartAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2302();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_KING_LIST" !== _loc3_)
         {
            if("UPDATA_KING_LIST" !== _loc3_)
            {
               if("ADD_KING" !== _loc3_)
               {
                  if("GOTO_GET_REWARD" !== _loc3_)
                  {
                     if("show_king_main" !== _loc3_)
                     {
                        if("SHOW_MOP_UP" !== _loc3_)
                        {
                           if("HIDE_MOP_UP" === _loc3_)
                           {
                              kingKwan.btn_kingMopUp.visible = false;
                           }
                        }
                        else if(PlayerVO.vipRank >= 10 && remainCount == 0)
                        {
                           kingKwan.btn_kingMopUp.visible = true;
                        }
                     }
                     else
                     {
                        kingKwan.spr_KingBg.addChild(kingKwan.spr_king);
                     }
                  }
                  else
                  {
                     _loc2_ = param1.getBody() as int;
                     kingKwan.kingList.scrollToDisplayIndex(_loc2_);
                  }
               }
               else
               {
                  kingKwan.addChild(kingKwan.spr_king);
               }
            }
            else
            {
               _loc2_ = param1.getBody() as int;
               if(kingKwan.kingList.dataProvider)
               {
                  kingKwan.kingList.scrollToDisplayIndex(_loc2_);
               }
            }
         }
         else
         {
            showKing();
         }
      }
      
      public function showKing() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < KingKwanPro.kingVec.length)
         {
            _loc2_ = new Sprite();
            addName(KingKwanPro.kingVec[_loc4_],_loc2_);
            addHead(KingKwanPro.kingVec[_loc4_],_loc2_);
            addElf(KingKwanPro.kingVec[_loc4_].elfVec,_loc2_);
            _loc5_ = addBtn(KingKwanPro.kingVec[_loc4_],_loc5_,_loc4_);
            _loc5_.addEventListener("triggered",btnHandle);
            _loc1_.push({
               "icon":_loc2_,
               "label":"",
               "accessory":_loc5_
            });
            displayVec.push(_loc2_);
            displayVec.push(_loc5_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         kingKwan.kingList.dataProvider = _loc3_;
         kingKwan.count.text = remainCount.toString();
      }
      
      private function showBg() : void
      {
         var _loc1_:SwfScale9Image = kingKwan.getList("s9_backdrop4");
         _loc1_.width = 960;
      }
      
      private function btnHandle(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:String = (param1.target as SwfButton).name.substr(0,2);
         var _loc4_:int = (param1.target as SwfButton).name.substring(2);
         LogUtil(_loc3_,_loc4_);
         var _loc5_:* = _loc3_;
         if("挑战" !== _loc5_)
         {
            if("领取" !== _loc5_)
            {
               if("完成" !== _loc5_)
               {
                  if("没开" === _loc5_)
                  {
                     Tips.show("未解封，你可以选择重置");
                  }
               }
               else
               {
                  Tips.show("别点了，亲");
               }
            }
            else
            {
               (Facade.getInstance().retrieveProxy("KingKwanPro") as KingKwanPro).write2304(KingKwanPro.kingVec[_loc4_].chapter);
            }
         }
         else if(kingKwan.btn_kingMopUp.visible)
         {
            _loc2_ = Alert.show("亲爱的玩家，是否使用扫荡功能？目前可以扫荡关数: " + mopUpCount + "关","",new ListCollection([{"label":"扫荡"},{"label":"继续挑战"}]));
            _loc2_.addEventListener("close",changeAlertHander);
         }
         else
         {
            kingKwan.spr_king.removeFromParent();
            if(!facade.hasMediator("SelePlayElfMedia"))
            {
               facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
            }
            sendNotification("SEND_RIVAL_DATA",KingKwanPro.kingVec[_loc4_],"王者之路");
            sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
         }
      }
      
      private function changeAlertHander(param1:Event) : void
      {
         if(param1.data.label == "扫荡")
         {
            (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2313();
         }
         if(param1.data.label == "继续挑战")
         {
            kingKwan.spr_king.removeFromParent();
            if(!facade.hasMediator("SelePlayElfMedia"))
            {
               facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
            }
            sendNotification("SEND_RIVAL_DATA",KingKwanPro.kingVec[0],"王者之路");
            sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
         }
      }
      
      private function addHead(param1:KingVO, param2:Sprite) : void
      {
         var _loc4_:* = null;
         var _loc3_:Image = GetPlayerRelatedPicFactor.getHeadPic(param1.headId);
         _loc3_.y = 1;
         param2.addChild(_loc3_);
         if(param1.vipRank > 0)
         {
            _loc4_ = GetCommon.getVipIcon(param1.vipRank);
            _loc4_.x = _loc4_.x - 5;
            _loc4_.y = _loc4_.y - 5;
            param2.addChild(_loc4_);
         }
      }
      
      public function addElf(param1:Vector.<ElfVO>, param2:Sprite) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = new ElfBgUnitUI();
            _loc3_.identify = "王者之路";
            _loc3_.touchable = false;
            var _loc5_:* = 0.65;
            _loc3_.scaleY = _loc5_;
            _loc3_.scaleX = _loc5_;
            _loc3_.myElfVo = param1[_loc4_];
            _loc3_.x = 80 * _loc4_ + 120;
            _loc3_.y = 32;
            param2.addChild(_loc3_);
            _loc4_++;
         }
      }
      
      public function addName(param1:KingVO, param2:Sprite) : void
      {
         var _loc3_:TextField = new TextField(200,45,"挑战对象：" + param1.name + " （" + param1.chapter + "/15）","FZCuYuan-M03S",20,10634246);
         _loc3_.autoSize = "horizontal";
         _loc3_.x = 120;
         _loc3_.y = -5;
         param2.addChild(_loc3_);
      }
      
      public function addBtn(param1:KingVO, param2:SwfButton, param3:int) : SwfButton
      {
         if(param1.state == 1 || param1.state == 4)
         {
            var param2:SwfButton = kingKwan.getBtn("btn_challenge_b");
            param2.name = "挑战" + param3;
            return param2;
         }
         if(param1.state == 2)
         {
            param2 = kingKwan.getBtn("btn_getReward_b");
            param2.name = "领取" + param3;
            return param2;
         }
         if(param1.state == 3)
         {
            param2 = kingKwan.getBtn("btn_yetGet_b");
            param2.name = "完成" + param3;
            param2.enabled = false;
            return param2;
         }
         if(param1.state == 0)
         {
            param2 = kingKwan.getBtn("btn_notChallenge");
            param2.name = "没开" + param3;
            param2.enabled = false;
            return param2;
         }
         return null;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_KING_LIST","UPDATA_KING_LIST","ADD_KING","GOTO_GET_REWARD","show_king_main","SHOW_MOP_UP","HIDE_MOP_UP"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            kingKwan.spr_king.removeFromParent(true);
         }
         if(facade.hasMediator("SelePlayElfMedia"))
         {
            sendNotification("REMOVE_SELEPLAYELF_MEDIA");
         }
         if(Facade.getInstance().hasMediator("ScoreShopMediator"))
         {
            (Facade.getInstance().retrieveMediator("ScoreShopMediator") as ScoreShopMediator).dispose();
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("KingKwanMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
