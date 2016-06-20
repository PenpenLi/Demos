package com.mvc.views.uis.mainCity.mining
{
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.mining.MiningVO;
   import starling.display.Sprite;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.views.mediator.mainCity.mining.MiningFrameMediator;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.starling.swf.display.SwfImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   import lzm.util.TimeUtil;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.DisplayObjectContainer;
   
   public class MiningInfoPage extends SwitchPage
   {
       
      private var swf:Swf;
      
      private var spr_miningInfoPage_s:SwfSprite;
      
      private var spr_collectInfo:SwfSprite;
      
      private var spr_lootInfo:SwfSprite;
      
      private var spr_defend:SwfSprite;
      
      private var spr_attack:SwfSprite;
      
      private var btn_explore:SwfButton;
      
      private var btn_attack1:SwfButton;
      
      private var btn_attack2:SwfButton;
      
      private var btn_attack3:SwfButton;
      
      private var btn_defend1:SwfButton;
      
      private var btn_defend2:SwfButton;
      
      private var btn_defend3:SwfButton;
      
      private var btn_invite1:SwfButton;
      
      private var btn_invite2:SwfButton;
      
      private var btn_occupy1:SwfButton;
      
      private var btn_occupy2:SwfButton;
      
      private var tf_tortalGet:TextField;
      
      private var tf_speed:TextField;
      
      private var tf_defendCompleteTime:TextField;
      
      private var tf_attackCompleteTime:TextField;
      
      private var tf_lootNum:TextField;
      
      private var tf_explorePay:TextField;
      
      public var littleIconType:int;
      
      private var isDefend:Boolean;
      
      public var miningObj:MiningVO;
      
      private var rewardContainer:Sprite;
      
      public var isComplete:Boolean;
      
      public function MiningInfoPage(param1:MiningVO)
      {
         super();
         this.miningObj = param1;
         isComplete = param1.isComplete;
         if(param1.lootNum <= 0)
         {
            isDefend = true;
         }
         if(isDefend)
         {
            littleIconType = param1.type;
         }
         else
         {
            littleIconType = 4;
         }
         addBg("miningBg" + param1.type);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("mining");
         spr_miningInfoPage_s = swf.createSprite("spr_miningInfoPage_s");
         addChild(spr_miningInfoPage_s);
         spr_collectInfo = spr_miningInfoPage_s.getSprite("spr_collectInfo");
         spr_lootInfo = spr_miningInfoPage_s.getSprite("spr_lootInfo");
         spr_defend = spr_miningInfoPage_s.getSprite("spr_defend");
         spr_attack = spr_miningInfoPage_s.getSprite("spr_attack");
         btn_explore = spr_miningInfoPage_s.getButton("btn_explore");
         btn_attack1 = spr_attack.getButton("btn_attack1");
         btn_attack2 = spr_attack.getButton("btn_attack2");
         btn_attack3 = spr_attack.getButton("btn_attack3");
         btn_defend1 = spr_defend.getButton("btn_defend1");
         btn_defend2 = spr_defend.getButton("btn_defend2");
         btn_defend3 = spr_defend.getButton("btn_defend3");
         btn_invite1 = spr_defend.getButton("btn_invite1");
         btn_invite2 = spr_defend.getButton("btn_invite2");
         btn_occupy1 = spr_defend.getButton("btn_occupy1");
         btn_occupy2 = spr_defend.getButton("btn_occupy2");
         tf_tortalGet = spr_collectInfo.getTextField("tf_tortalGet");
         tf_speed = spr_collectInfo.getTextField("tf_speed");
         tf_defendCompleteTime = spr_collectInfo.getTextField("tf_completeTime");
         tf_lootNum = spr_lootInfo.getTextField("tf_lootNum");
         tf_attackCompleteTime = spr_lootInfo.getTextField("tf_completeTime");
         tf_explorePay = (btn_explore.skin as Sprite).getChildByName("tf_explorePay") as TextField;
         showDefendOrAttack();
         addEventListener("triggered",triggeredHandler);
      }
      
      public function showDefendOrAttack() : void
      {
         if(isDefend)
         {
            if(miningObj.endTime - WorldTime.getInstance().serverTime <= 0)
            {
               showMiningReward();
               return;
            }
            spr_lootInfo.removeFromParent(true);
            spr_attack.removeFromParent(true);
            btn_explore.removeFromParent(true);
            showDefend();
            updateIcon(spr_collectInfo);
            tf_tortalGet.text = miningObj.totalNum;
            tf_speed.text = miningObj.speed;
         }
         else
         {
            if(miningObj.endTime - WorldTime.getInstance().serverTime <= 0)
            {
               showLootOver();
               return;
            }
            spr_collectInfo.removeFromParent(true);
            spr_defend.removeFromParent(true);
            showAttack();
            updateIcon(spr_lootInfo);
            tf_lootNum.text = miningObj.lootNum;
            tf_explorePay.text = MiningFrameMediator.exportPay;
         }
      }
      
      private function showAttack() : void
      {
         if(miningObj.defenderArr.length == 1)
         {
            btn_attack2.visible = false;
            btn_attack3.visible = false;
         }
         if(miningObj.defenderArr.length == 2)
         {
            btn_attack3.visible = false;
         }
      }
      
      private function showDefend() : void
      {
         if(miningObj.defenderArr[0] == PlayerVO.userId)
         {
            if(miningObj.defenderArr.length == 1)
            {
               btn_defend2.visible = false;
               btn_defend3.visible = false;
            }
            if(miningObj.defenderArr.length == 2)
            {
               btn_invite1.visible = false;
               btn_defend3.visible = false;
            }
            if(miningObj.defenderArr.length == 3)
            {
               btn_invite1.visible = false;
               btn_invite2.visible = false;
            }
            btn_occupy1.visible = false;
            btn_occupy2.visible = false;
         }
         else
         {
            if(miningObj.defenderArr.length == 1)
            {
               btn_defend2.visible = false;
               btn_defend3.visible = false;
            }
            if(miningObj.defenderArr.length == 2)
            {
               btn_occupy1.visible = false;
               btn_defend3.visible = false;
            }
            if(miningObj.defenderArr.length == 3)
            {
               btn_occupy1.visible = false;
               btn_occupy2.visible = false;
            }
            btn_invite1.visible = false;
            btn_invite2.visible = false;
         }
      }
      
      private function showMiningReward() : void
      {
         var _loc1_:* = null;
         LogUtil("展示守矿的奖励: " + (miningObj.endTime - WorldTime.getInstance().serverTime));
         spr_miningInfoPage_s.removeFromParent(true);
         rewardContainer = new Sprite();
         rewardContainer.addEventListener("touch",rewardContainer_touchHandler);
         addChild(rewardContainer);
         var _loc3_:* = miningObj.type;
         if("1" !== _loc3_)
         {
            if("2" !== _loc3_)
            {
               if("3" === _loc3_)
               {
                  _loc1_ = swf.createImage("img_doll1");
               }
            }
            else
            {
               _loc1_ = swf.createImage("img_sweet1");
            }
         }
         else
         {
            _loc1_ = swf.createImage("img_coin1");
         }
         rewardContainer.addChild(_loc1_);
         var _loc2_:SwfImage = swf.createImage("img_diamond1");
         _loc2_.x = _loc1_.x + _loc1_.width + 50;
         rewardContainer.addChild(_loc2_);
         rewardContainer.x = 1136 - rewardContainer.width >> 1;
         rewardContainer.y = (640 - rewardContainer.height >> 1) + 50;
         createArrowMc(rewardContainer,this);
      }
      
      private function showLootOver() : void
      {
         spr_miningInfoPage_s.removeFromParent(true);
         rewardContainer = new Sprite();
         rewardContainer.x = 480;
         rewardContainer.y = 280;
         rewardContainer.addEventListener("touch",rewardContainer_touchHandler);
         rewardContainer.addChild(swf.createImage("img_lootOver"));
         addChild(rewardContainer);
      }
      
      private function rewardContainer_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(rewardContainer);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(isDefend)
            {
               (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3908(miningObj.id);
            }
            else
            {
               Facade.getInstance().sendNotification("mining_update_pagevec");
            }
         }
      }
      
      private function updateIcon(param1:Sprite) : void
      {
         var _loc2_:* = miningObj.type;
         if("1" !== _loc2_)
         {
            if("2" !== _loc2_)
            {
               if("3" === _loc2_)
               {
                  removeIcon(param1.getChildByName("sweet3Img"));
                  removeIcon(param1.getChildByName("sweet33Img"));
                  removeIcon(param1.getChildByName("coin3Img"));
                  removeIcon(param1.getChildByName("coin33Img"));
               }
            }
            else
            {
               removeIcon(param1.getChildByName("coin3Img"));
               removeIcon(param1.getChildByName("coin33Img"));
               removeIcon(param1.getChildByName("doll3Img"));
               removeIcon(param1.getChildByName("doll33Img"));
            }
         }
         else
         {
            removeIcon(param1.getChildByName("sweet3Img"));
            removeIcon(param1.getChildByName("sweet33Img"));
            removeIcon(param1.getChildByName("doll3Img"));
            removeIcon(param1.getChildByName("doll33Img"));
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_explore !== _loc2_)
         {
            if(btn_attack1 !== _loc2_)
            {
               if(btn_attack2 !== _loc2_)
               {
                  if(btn_attack3 !== _loc2_)
                  {
                     if(btn_defend1 !== _loc2_)
                     {
                        if(btn_defend2 !== _loc2_)
                        {
                           if(btn_defend3 !== _loc2_)
                           {
                              if(btn_invite1 !== _loc2_)
                              {
                                 if(btn_invite2 !== _loc2_)
                                 {
                                    if(btn_occupy1 !== _loc2_)
                                    {
                                       if(btn_occupy2 === _loc2_)
                                       {
                                          if(btn_occupy1.visible)
                                          {
                                             return Tips.show("请先占领上一个");
                                          }
                                          if(btn_defend2.visible && miningObj.defenderArr[1] == PlayerVO.userId)
                                          {
                                             return Tips.show("只能占领一个");
                                          }
                                          loadSelectFormation();
                                       }
                                    }
                                    else
                                    {
                                       loadSelectFormation();
                                    }
                                 }
                                 else
                                 {
                                    Facade.getInstance().sendNotification("switch_win",null,"mining_load_invite_win");
                                 }
                              }
                              else
                              {
                                 Facade.getInstance().sendNotification("switch_win",null,"mining_load_invite_win");
                              }
                           }
                           else
                           {
                              (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[2]);
                           }
                        }
                        else
                        {
                           (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[1]);
                        }
                     }
                     else
                     {
                        (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[0]);
                     }
                  }
                  else
                  {
                     (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[2]);
                  }
               }
               else
               {
                  (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[1]);
               }
            }
            else
            {
               (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3902(miningObj.severId,miningObj.id,miningObj.defenderArr[0]);
            }
         }
         else
         {
            if(MiningFrameMediator.breadNum < 2)
            {
               return Tips.show("能量不足");
            }
            if(PlayerVO.silver < MiningFrameMediator.exportPay)
            {
               return Tips.show("金币不足");
            }
            (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3904();
         }
      }
      
      private function loadSelectFormation() : void
      {
         if(!Facade.getInstance().hasMediator("SelectFormationMedia"))
         {
            Facade.getInstance().registerMediator(new SelectFormationMedia(new SelectFormationUI()));
         }
         Facade.getInstance().sendNotification("selectformation_init_type",initFormationElfVec(),"占矿");
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_SERIES_FORMATION");
      }
      
      private function initFormationElfVec() : Vector.<ElfVO>
      {
         var _loc2_:* = 0;
         var _loc1_:Vector.<ElfVO> = Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc1_.push(null);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function removeIcon(param1:DisplayObject) : void
      {
         if(param1)
         {
            param1.removeFromParent(true);
         }
      }
      
      public function updateLessTimeTf(param1:int) : void
      {
         if(param1 > 0)
         {
            if(isDefend)
            {
               tf_defendCompleteTime.text = "开采完成倒计时：" + TimeUtil.convertStringToDate(param1);
            }
            else
            {
               tf_attackCompleteTime.text = "抢夺结束倒计时：" + TimeUtil.convertStringToDate(param1);
            }
         }
         else
         {
            isComplete = true;
            if(isDefend)
            {
               tf_defendCompleteTime.text = "开采完成";
            }
            else
            {
               tf_attackCompleteTime.text = "抢夺结束";
            }
            if(!rewardContainer && isDefend)
            {
               showMiningReward();
            }
            else if(!rewardContainer && !isDefend)
            {
               showLootOver();
            }
         }
      }
      
      public function updateTfAfterAdjustFormat() : void
      {
         tf_tortalGet.text = miningObj.totalNum;
         tf_speed.text = miningObj.speed;
      }
      
      public function occupyComplete() : void
      {
         if(miningObj.defenderArr.length == 1)
         {
            miningObj.defenderArr.push(PlayerVO.userId);
            btn_occupy1.visible = false;
            btn_defend2.visible = true;
         }
         else if(miningObj.defenderArr.length == 2)
         {
            miningObj.defenderArr.push(PlayerVO.userId);
            btn_occupy2.visible = false;
            btn_defend3.visible = true;
         }
      }
      
      public function createArrowMc(param1:DisplayObject, param2:DisplayObjectContainer) : SwfMovieClip
      {
         var _loc3_:SwfMovieClip = swf.createMovieClip("mc_arrowDown");
         _loc3_.x = (param1.width - 20 >> 1) + param1.x;
         _loc3_.y = param1.y - 90;
         param2.addChild(_loc3_);
         return _loc3_;
      }
   }
}
