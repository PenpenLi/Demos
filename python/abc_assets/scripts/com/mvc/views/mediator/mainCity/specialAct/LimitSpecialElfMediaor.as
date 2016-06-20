package com.mvc.views.mediator.mainCity.specialAct
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.specialAct.limitSpecialElf.LimitSpecialElfUI;
   import starling.display.DisplayObject;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.util.TimeUtil;
   import com.common.consts.ConfigConst;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import extend.SoundEvent;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.mainCity.specialAct.limitSpecialElf.LimitSpecialElfRewardUnit;
   import starling.text.TextField;
   
   public class LimitSpecialElfMediaor extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "LimitSpecialElfMediaor";
      
      public static var lessTime:int;
       
      public var limitSpecialElfUI:LimitSpecialElfUI;
      
      private var rankListDisplayVec:Vector.<DisplayObject>;
      
      private var rewardListDisplayVec:Vector.<DisplayObject>;
      
      private var isOneDraw:Boolean;
      
      private var elfVO:ElfVO;
      
      private var elfImg:Image;
      
      public function LimitSpecialElfMediaor(param1:Object = null)
      {
         rankListDisplayVec = new Vector.<DisplayObject>([]);
         rewardListDisplayVec = new Vector.<DisplayObject>([]);
         super("LimitSpecialElfMediaor",param1);
         limitSpecialElfUI = param1 as LimitSpecialElfUI;
         limitSpecialElfUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(limitSpecialElfUI.btn_close !== _loc2_)
         {
            if(limitSpecialElfUI.btn_drawOne !== _loc2_)
            {
               if(limitSpecialElfUI.btn_drawTen !== _loc2_)
               {
                  if(limitSpecialElfUI.btn_playTip === _loc2_)
                  {
                     limitSpecialElfUI.addHelp();
                  }
               }
               else
               {
                  if(lessTime <= 0)
                  {
                     Tips.show("亲，活动已结束。");
                     return;
                  }
                  if(PlayerVO.diamond < 3080)
                  {
                     Tips.show("亲，钻石不足哦。");
                     return;
                  }
                  if(AmuseMedia.ten())
                  {
                     isOneDraw = false;
                     if(LoadSwfAssetsManager.getInstance().assets.getSwf("amuse") == null)
                     {
                        LogUtil("限时神兽十连抽加载amuse资源");
                        EventCenter.addEventListener("load_swf_asset_complete",sendMsg);
                        LoadSwfAssetsManager.getInstance().addAssets(Config.amuseAssets);
                     }
                     else
                     {
                        (facade.retrieveProxy("AmusePro") as AmusePro).write2502(6,true);
                     }
                  }
               }
            }
            else
            {
               if(lessTime <= 0)
               {
                  Tips.show("亲，活动已结束。");
                  return;
               }
               if(PlayerVO.diamond < 350)
               {
                  Tips.show("亲，钻石不足哦。");
                  return;
               }
               if(AmuseMedia.once())
               {
                  isOneDraw = true;
                  if(LoadSwfAssetsManager.getInstance().assets.getSwf("amuse") == null)
                  {
                     LogUtil("限时神兽单抽加载amuse资源");
                     EventCenter.addEventListener("load_swf_asset_complete",sendMsg);
                     LoadSwfAssetsManager.getInstance().addAssets(Config.amuseAssets);
                  }
                  else
                  {
                     (facade.retrieveProxy("AmusePro") as AmusePro).write2501(3,true);
                  }
               }
            }
         }
         else
         {
            limitSpecialElfUI.rankList.removeFromParent();
            limitSpecialElfUI.rewardList.removeFromParent();
            WinTweens.closeWin(limitSpecialElfUI.spr_limitSpecialElf,remove);
         }
      }
      
      private function sendMsg() : void
      {
         EventCenter.removeEventListener("load_swf_asset_complete",sendMsg);
         if(isOneDraw)
         {
            (facade.retrieveProxy("AmusePro") as AmusePro).write2501(3,true);
         }
         else
         {
            (facade.retrieveProxy("AmusePro") as AmusePro).write2502(6,true);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         WinTweens.showCity();
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if(ConfigConst.UPDATE_LIMITSPECIALELF_INFO !== _loc3_)
         {
            if("update_limitspecialelf_lesstime" !== _loc3_)
            {
               if(ConfigConst.UPDATE_LIMITSPECIALELF_RANK_LIST !== _loc3_)
               {
                  if(ConfigConst.UPDATE_LIMITSPECIALELF_REWARD_LIST !== _loc3_)
                  {
                     if("load_amuse_mc" === _loc3_)
                     {
                        LogUtil("限时神兽扭蛋开启");
                        limitSpecialElfUI.removeFromParent();
                        AmuseMedia.rewardArr = param1.getBody() as Array;
                        sendNotification("switch_page","load_amuse_mc");
                     }
                  }
                  else
                  {
                     updateRewardList(param1.getBody() as Array);
                  }
               }
               else
               {
                  updateRankList(param1.getBody() as Array);
               }
            }
            else if(lessTime > 0)
            {
               limitSpecialElfUI.tf_countDown.text = TimeUtil.convertStringToDate2(lessTime);
            }
            else
            {
               limitSpecialElfUI.tf_countDown.text = "活动已结束。";
            }
         }
         else
         {
            _loc2_ = param1.getBody();
            updateRankList(_loc2_.rcScoreList);
            updateRewardList(_loc2_.reward);
            setSpecialElfImg(_loc2_.reward);
            limitSpecialElfUI.tf_score.text = _loc2_.rcLtScore;
            limitSpecialElfUI.tf_rank.text = _loc2_.rcRanking <= 0?"暂未上榜":_loc2_.rcRanking;
            limitSpecialElfUI.tf_diamond.text = _loc2_.diamond;
            lessTime = _loc2_.leftTime;
            if(lessTime > 0)
            {
               limitSpecialElfUI.tf_countDown.text = TimeUtil.convertStringToDate2(lessTime);
            }
            else
            {
               limitSpecialElfUI.tf_countDown.text = "活动已结束。";
            }
         }
      }
      
      private function setSpecialElfImg(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.length && param1[0].hasOwnProperty("poke"))
         {
            elfVO = GetElfFactor.getElfVO((param1[0].poke as Array)[0].pokeId,false);
            if(elfImg)
            {
               elfImg.removeFromParent(true);
            }
            ElfFrontImageManager.getInstance().getImg([elfVO.imgName],addElfImg);
         }
      }
      
      private function addElfImg() : void
      {
         elfImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(elfVO.imgName));
         elfImg.alignPivot("center","center");
         elfImg.x = limitSpecialElfUI.spr_elfContainer.width >> 1;
         elfImg.y = 220;
         AniFactor.ifOpen = true;
         AniFactor.elfAni(elfImg);
         limitSpecialElfUI.spr_elfContainer.addChild(elfImg);
         limitSpecialElfUI.tf_elfName.text = elfVO.name;
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfVO.sound);
      }
      
      private function updateRewardList(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(!param1)
         {
            return;
         }
         limitSpecialElfUI.spr_limitSpecialElf.addChild(limitSpecialElfUI.rewardList);
         DisposeDisplay.dispose(rewardListDisplayVec);
         rewardListDisplayVec = Vector.<DisplayObject>([]);
         if(limitSpecialElfUI.rewardList.dataProvider)
         {
            limitSpecialElfUI.rewardList.dataProvider.removeAll();
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = new LimitSpecialElfRewardUnit();
            _loc2_.setRewardUnit(param1[_loc3_]);
            rewardListDisplayVec.push(_loc2_);
            limitSpecialElfUI.rewardList.dataProvider.push({
               "label":"",
               "accessory":_loc2_
            });
            _loc3_++;
         }
      }
      
      private function updateRankList(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(!param1)
         {
            return;
         }
         limitSpecialElfUI.spr_limitSpecialElf.addChild(limitSpecialElfUI.rankList);
         DisposeDisplay.dispose(rankListDisplayVec);
         rankListDisplayVec = Vector.<DisplayObject>([]);
         if(limitSpecialElfUI.rankList.dataProvider)
         {
            limitSpecialElfUI.rankList.dataProvider.removeAll();
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = new TextField(50,20,"","FZCuYuan-M03S",16,11298352);
            _loc5_.hAlign = "left";
            _loc5_.text = "NO." + (_loc4_ + 1);
            _loc3_ = new TextField(50,20,"","FZCuYuan-M03S",16,1023451);
            _loc3_.text = param1[_loc4_].rcLtScore;
            rankListDisplayVec.push(_loc5_,_loc3_);
            _loc2_ = "<font size = \'16\'>" + param1[_loc4_].userName + "</font>";
            limitSpecialElfUI.rankList.dataProvider.push({
               "label":_loc2_,
               "icon":_loc5_,
               "accessory":_loc3_
            });
            _loc4_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.UPDATE_LIMITSPECIALELF_RANK_LIST,ConfigConst.UPDATE_LIMITSPECIALELF_REWARD_LIST,ConfigConst.UPDATE_LIMITSPECIALELF_INFO,"update_limitspecialelf_lesstime","load_amuse_mc"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         ElfFrontImageManager.getInstance().dispose();
         limitSpecialElfUI.clean();
         DisposeDisplay.dispose(rankListDisplayVec);
         DisposeDisplay.dispose(rewardListDisplayVec);
         facade.removeMediator("LimitSpecialElfMediaor");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.limitSpecialElfAssets);
      }
   }
}
