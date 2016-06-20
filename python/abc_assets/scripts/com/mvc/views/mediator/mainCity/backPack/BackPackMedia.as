package com.mvc.views.mediator.mainCity.backPack
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.backPack.BackPackUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.views.uis.mainCity.backPack.ComposeUI;
   import starling.events.Event;
   import feathers.controls.TabBar;
   import com.common.themes.Tips;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.SomeFontHandler;
   import com.common.util.strHandler.StrHandle;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.mainCity.backPack.CanLearnElf;
   import com.mvc.views.uis.mainCity.backPack.PlayElfUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.dialogue.Dialogue;
   import feathers.controls.Alert;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.WinTweens;
   import com.common.consts.ConfigConst;
   
   public class BackPackMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "BackPackMedia";
      
      public static var isElfSeries:Boolean;
      
      public static var huntPropArr:Array = [868,869,870];
       
      public var backPack:BackPackUI;
      
      public var propVO:PropVO;
      
      public var elfVO:ElfVO;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var currentTab:int = 0;
      
      private var index:int;
      
      private var openBoxCount:int;
      
      private var openGiftCount:int;
      
      private var boxPropVo:PropVO;
      
      private var giftPropVo:PropVO;
      
      private const LISTGAP:int = 13;
      
      private const LISTDECGAP:int = 24;
      
      private var sugerPropVo:PropVO;
      
      private var scorePropVo:PropVO;
      
      public function BackPackMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("BackPackMedia",param1);
         backPack = param1 as BackPackUI;
         backPack.addEventListener("triggered",clickHandler);
         backPack.tabs.addEventListener("change",tabs_changeHandler);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_BACKPACK" !== _loc3_)
         {
            if("SEND_CARRY_PROP" !== _loc3_)
            {
               if("UPDATA_USE_PROP" !== _loc3_)
               {
                  if("SELECT_ELF_OVER" !== _loc3_)
                  {
                     if("next_dialogue" !== _loc3_)
                     {
                        if("JUMP_CITY_SUCCESS" === _loc3_)
                        {
                           if(ComposeUI.getInstance().parent)
                           {
                              ComposeUI.getInstance().showDropList(param1.getBody() as Array);
                           }
                        }
                     }
                     else if(param1.getBody() == "prop_be_used")
                     {
                        if(FightingMedia.isFighting)
                        {
                           close();
                           FightingLogicFactor.computerActHandler();
                        }
                     }
                  }
               }
               else
               {
                  index = param1.getBody() as int;
                  LogUtil("滚到使用的道具的位置=====",index);
                  if(backPack.parent != null)
                  {
                     if(backPack.backPackGoodsList.dataProvider)
                     {
                        backPack.backPackGoodsList.scrollToDisplayIndex(index);
                     }
                  }
               }
            }
            else
            {
               propVO = param1.getBody() as PropVO;
            }
         }
         else
         {
            if(backPack.parent == null)
            {
               return;
            }
            LogUtil("展示背包");
            if(param1.getBody() != null)
            {
               currentTab = param1.getBody() as int;
            }
            if(currentTab == 0)
            {
               _loc2_ = 0;
               while(_loc2_ < BackPackPro.bagPropVecArr.length)
               {
                  if(BackPackPro.bagPropVecArr[_loc2_].length != 0)
                  {
                     currentTab = _loc2_;
                     break;
                  }
                  _loc2_++;
               }
            }
            if(currentTab == 2 && FightingMedia.isFighting)
            {
               currentTab = 0;
            }
            backPack.tabs.selectedIndex = currentTab;
            switchBackPackGoods(currentTab);
            if(backPack.backPackGoodsList.dataProvider)
            {
               backPack.backPackGoodsList.scrollToDisplayIndex(index);
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_BACKPACK","SEND_CARRY_PROP","UPDATA_USE_PROP","SELECT_ELF_OVER","next_dialogue","JUMP_CITY_SUCCESS"];
      }
      
      private function carryPropSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
         }
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         if(BackPackPro.bagPropVecArr.length != 0)
         {
            if(BackPackPro.bagPropVecArr[_loc2_.selectedIndex].length == 0)
            {
               Tips.show("该物品栏下没有道具");
               backPack.tabs.selectedIndex = currentTab;
               return;
            }
         }
         if(FightingMedia.isFighting && backPack.tabs.selectedIndex == 2)
         {
            Tips.show("亲，战斗中不能使用学习机哦");
            backPack.tabs.selectedIndex = currentTab;
            return;
         }
         switchBackPackGoods(_loc2_.selectedIndex);
         currentTab = _loc2_.selectedIndex;
      }
      
      private function switchBackPackGoods(param1:int) : void
      {
         var _loc23_:* = 0;
         var _loc21_:* = null;
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc14_:* = 0;
         var _loc6_:* = null;
         var _loc36_:* = null;
         var _loc25_:* = 0;
         var _loc38_:* = null;
         var _loc31_:* = null;
         var _loc3_:* = null;
         var _loc27_:* = 0;
         var _loc8_:* = null;
         var _loc20_:* = null;
         var _loc37_:* = null;
         var _loc32_:* = null;
         var _loc33_:* = null;
         var _loc24_:* = 0;
         var _loc15_:* = null;
         var _loc35_:* = null;
         var _loc11_:* = null;
         var _loc13_:* = null;
         var _loc26_:* = 0;
         var _loc34_:* = null;
         var _loc18_:* = null;
         var _loc28_:* = 0;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc29_:* = 0;
         var _loc2_:* = null;
         var _loc16_:* = null;
         var _loc30_:* = 0;
         var _loc19_:* = null;
         var _loc12_:* = null;
         var _loc7_:* = null;
         var _loc39_:* = null;
         var _loc40_:* = null;
         var _loc17_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         switch(param1)
         {
            case 0:
               _loc23_ = 0;
               while(_loc23_ < PlayerVO.medicineVec.length)
               {
                  _loc21_ = new Sprite();
                  if(PlayerVO.medicineVec[_loc23_].isCarry == 1 || PlayerVO.medicineVec[_loc23_].isCarry == 3)
                  {
                     _loc9_ = backPack.getBtn("btn_use");
                     _loc9_.name = "use|" + _loc23_.toString();
                     _loc21_.addChild(_loc9_);
                     _loc9_.addEventListener("triggered",medicineHandle);
                  }
                  if((PlayerVO.medicineVec[_loc23_].isCarry == 2 || PlayerVO.medicineVec[_loc23_].isCarry == 3) && !FightingMedia.isFighting)
                  {
                     _loc5_ = backPack.getBtn("btn_carry_b");
                     _loc5_.name = "carry|" + _loc23_.toString();
                     _loc5_.x = 100;
                     _loc21_.addChild(_loc5_);
                     _loc5_.addEventListener("triggered",medicineHandle);
                  }
                  if(PlayerVO.medicineVec[_loc23_].isCarry == 3)
                  {
                     _loc14_ = 13 - 3;
                  }
                  else
                  {
                     _loc14_ = 13;
                  }
                  _loc6_ = GetpropImage.getPropSpr(PlayerVO.medicineVec[_loc23_],false);
                  _loc36_ = SomeFontHandler.setColoeSize(PlayerVO.medicineVec[_loc23_].name,35,_loc14_);
                  _loc17_.push({
                     "icon":_loc6_,
                     "label":_loc36_ + "数量:" + PlayerVO.medicineVec[_loc23_].count + " \n" + StrHandle.lineFeed(PlayerVO.medicineVec[_loc23_].describe,24,"\n",24),
                     "accessory":_loc21_
                  });
                  displayVec.push(_loc6_,_loc21_);
                  _loc23_++;
               }
               break;
            case 1:
               _loc25_ = 0;
               for(; _loc25_ < PlayerVO.elfBallVec.length; _loc25_++)
               {
                  if(LoadPageCmd.lastPage is HuntingPartyUI)
                  {
                     if(PlayerVO.elfBallVec[_loc23_].id == 868)
                     {
                     }
                     continue;
                  }
                  _loc38_ = backPack.getBtn("btn_use");
                  _loc38_.name = _loc25_.toString();
                  _loc31_ = GetpropImage.getPropSpr(PlayerVO.elfBallVec[_loc25_],false);
                  _loc3_ = SomeFontHandler.setColoeSize(PlayerVO.elfBallVec[_loc25_].name,35,13);
                  _loc38_.addEventListener("triggered",elfBallHandle);
                  _loc17_.push({
                     "icon":_loc31_,
                     "label":_loc3_ + "数量:" + PlayerVO.elfBallVec[_loc25_].count + " \n" + PlayerVO.elfBallVec[_loc25_].describe,
                     "accessory":_loc38_
                  });
                  displayVec.push(_loc31_,_loc38_);
               }
               break;
            case 2:
               _loc30_ = 0;
               while(_loc30_ < PlayerVO.learnMachineVec.length)
               {
                  _loc19_ = GetpropImage.getPropSpr(PlayerVO.learnMachineVec[_loc30_],false);
                  _loc12_ = SomeFontHandler.setColoeSize(PlayerVO.learnMachineVec[_loc30_].name,28,13);
                  _loc7_ = new Sprite();
                  _loc39_ = backPack.getBtn("btn_detail");
                  _loc39_.name = _loc30_.toString();
                  _loc39_.addEventListener("triggered",mcDetailHandle);
                  _loc40_ = backPack.getBtn("btn_use");
                  _loc40_.name = _loc30_.toString();
                  _loc40_.addEventListener("triggered",mcHandle);
                  _loc40_.x = 100;
                  _loc7_.addChild(_loc40_);
                  _loc7_.addChild(_loc39_);
                  _loc17_.push({
                     "icon":_loc19_,
                     "label":_loc12_ + "数量:" + PlayerVO.learnMachineVec[_loc30_].count + " \n" + PlayerVO.learnMachineVec[_loc30_].describe,
                     "accessory":_loc7_
                  });
                  displayVec.push(_loc19_,_loc7_);
                  _loc30_++;
               }
               break;
            case 3:
               _loc24_ = 0;
               while(_loc24_ < PlayerVO.propBroken.length)
               {
                  _loc15_ = new Sprite();
                  _loc35_ = GetpropImage.getPropSpr(PlayerVO.propBroken[_loc24_],false);
                  _loc15_.addChild(_loc35_);
                  _loc11_ = SomeFontHandler.setColoeSize(PlayerVO.propBroken[_loc24_].name,35,13);
                  if(!FightingMedia.isFighting)
                  {
                     _loc13_ = backPack.getBtn("btn_Composite_b");
                     _loc13_.name = _loc24_.toString();
                     _loc13_.addEventListener("triggered",bokenHandle);
                     displayVec.push(_loc13_);
                  }
                  if(PlayerVO.propBroken[_loc24_].type == 26)
                  {
                     _loc17_.push({
                        "icon":_loc15_,
                        "label":_loc11_ + "数量:" + PlayerVO.propBroken[_loc24_].count + " \n" + StrHandle.lineFeed(PlayerVO.propBroken[_loc24_].describe,24,"\n",24)
                     });
                  }
                  else
                  {
                     _loc17_.push({
                        "icon":_loc15_,
                        "label":_loc11_ + "数量:" + PlayerVO.propBroken[_loc24_].count + " \n" + StrHandle.lineFeed(PlayerVO.propBroken[_loc24_].describe,24,"\n",24),
                        "accessory":_loc13_
                     });
                  }
                  displayVec.push(_loc15_);
                  _loc24_++;
               }
               break;
            case 4:
               _loc26_ = 0;
               while(_loc26_ < PlayerVO.sandBagVec.length)
               {
                  _loc34_ = GetpropImage.getPropSpr(PlayerVO.sandBagVec[_loc26_],true,0.9);
                  _loc18_ = SomeFontHandler.setColoeSize(PlayerVO.sandBagVec[_loc26_].name,35,13 + 3);
                  _loc17_.push({
                     "icon":_loc34_,
                     "label":_loc18_ + "数量:" + PlayerVO.sandBagVec[_loc26_].count + " \n" + PlayerVO.sandBagVec[_loc26_].describe
                  });
                  displayVec.push(_loc34_);
                  _loc26_++;
               }
               break;
            case 5:
               _loc28_ = 0;
               while(_loc28_ < PlayerVO.evolveStoneVec.length)
               {
                  _loc4_ = GetpropImage.getPropSpr(PlayerVO.evolveStoneVec[_loc28_],false);
                  _loc10_ = SomeFontHandler.setColoeSize(PlayerVO.evolveStoneVec[_loc28_].name,35,13 + 3);
                  _loc17_.push({
                     "icon":_loc4_,
                     "label":_loc10_ + "数量:" + PlayerVO.evolveStoneVec[_loc28_].count + " \n" + PlayerVO.evolveStoneVec[_loc28_].describe
                  });
                  displayVec.push(_loc4_);
                  _loc28_++;
               }
               break;
            case 6:
               _loc29_ = 0;
               while(_loc29_ < PlayerVO.dollVec.length)
               {
                  _loc2_ = GetpropImage.getPropSpr(PlayerVO.dollVec[_loc29_],false);
                  _loc16_ = SomeFontHandler.setColoeSize(PlayerVO.dollVec[_loc29_].name,35,13 + 3);
                  _loc17_.push({
                     "icon":_loc2_,
                     "label":_loc16_ + "数量:" + PlayerVO.dollVec[_loc29_].count + " \n" + StrHandle.lineFeed(PlayerVO.dollVec[_loc29_].describe,24 + 4,"\n",24)
                  });
                  displayVec.push(_loc2_);
                  _loc29_++;
               }
               break;
            case 7:
               LogUtil("PlayerVO.otherPropVec.length==" + PlayerVO.otherPropVec.length);
               _loc27_ = 0;
               while(_loc27_ < PlayerVO.otherPropVec.length)
               {
                  _loc8_ = new Sprite();
                  if(PlayerVO.otherPropVec[_loc27_].isCarry == 1 || PlayerVO.otherPropVec[_loc27_].isCarry == 3 || PlayerVO.otherPropVec[_loc27_].isCarry == 4)
                  {
                     _loc20_ = backPack.getBtn("btn_use");
                     _loc20_.name = "use|" + _loc27_.toString();
                     if(PlayerVO.otherPropVec[_loc27_].id < 245 || PlayerVO.otherPropVec[_loc27_].id > 248)
                     {
                        _loc8_.addChild(_loc20_);
                     }
                     _loc20_.addEventListener("triggered",otherHandle);
                  }
                  if((PlayerVO.otherPropVec[_loc27_].isCarry == 2 || PlayerVO.otherPropVec[_loc27_].isCarry == 3) && !FightingMedia.isFighting)
                  {
                     _loc37_ = backPack.getBtn("btn_carry_b");
                     _loc37_.name = "carry|" + _loc27_.toString();
                     _loc8_.addChild(_loc37_);
                     _loc37_.addEventListener("triggered",otherHandle);
                  }
                  _loc32_ = GetpropImage.getPropSpr(PlayerVO.otherPropVec[_loc27_],false);
                  if(PlayerVO.otherPropVec[_loc27_].type == 25 && PlayerVO.otherPropVec[_loc27_].name.search("狩猎") == -1)
                  {
                     var _loc41_:* = 0.8;
                     _loc32_.scaleY = _loc41_;
                     _loc32_.scaleX = _loc41_;
                  }
                  _loc33_ = SomeFontHandler.setColoeSize(PlayerVO.otherPropVec[_loc27_].name,35,13);
                  _loc17_.push({
                     "icon":_loc32_,
                     "label":_loc33_ + "数量:" + PlayerVO.otherPropVec[_loc27_].count + " \n" + StrHandle.lineFeed(PlayerVO.otherPropVec[_loc27_].describe,24,"\n",24),
                     "accessory":_loc8_
                  });
                  displayVec.push(_loc32_,_loc8_);
                  _loc27_++;
               }
               break;
            default:
               LogUtil("什么鬼类型，没找到");
         }
         var _loc22_:ListCollection = new ListCollection(_loc17_);
         backPack.backPackGoodsList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",add);
         backPack.backPackGoodsList.dataProvider = _loc22_;
         backPack.backPackGoodsList.stopScrolling();
         backPack.tabs.selectedIndex = param1;
         if(backPack.backPackGoodsList.dataProvider)
         {
            backPack.backPackGoodsList.scrollToDisplayIndex(0);
         }
      }
      
      private function mcDetailHandle(param1:Event) : void
      {
         var _loc2_:int = (param1.target as SwfButton).name;
         var _loc3_:PropVO = PlayerVO.learnMachineVec[_loc2_];
         CanLearnElf.getInstance().show(_loc3_);
      }
      
      private function mcHandle(param1:Event) : void
      {
         var _loc2_:int = (param1.target as SwfButton).name;
         var _loc3_:PropVO = PlayerVO.learnMachineVec[_loc2_];
         _loc3_.isUsed = true;
         LogUtil("mcVO==",_loc2_,_loc3_.name);
         if(!facade.hasMediator("PlayElfMedia"))
         {
            facade.registerMediator(new PlayElfMedia(new PlayElfUI()));
         }
         sendNotification("SEND_USE_PROP",_loc3_);
         sendNotification("switch_win",null,"LOAD_PLAYELF_WIN");
      }
      
      private function bokenHandle(param1:Event) : void
      {
         var _loc2_:int = (param1.target as DisplayObject).name;
         ComposeUI.getInstance().show(PlayerVO.propBroken[_loc2_],"BackPackMedia");
      }
      
      private function add() : void
      {
         LogUtil("背包时播放新手引导");
         BeginnerGuide.playBeginnerGuide();
         backPack.backPackGoodsList.dataViewPort.removeEventListener("CREAT_LIST_COMPLETE",add);
      }
      
      private function otherHandle(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc2_:Array = (param1.target as DisplayObject).name.split("|");
         var _loc3_:PropVO = PlayerVO.otherPropVec[_loc2_[1]];
         if(huntPropArr.indexOf(_loc3_.id) != -1)
         {
            if(FightingMedia.isFighting)
            {
               Tips.show("战斗中不能使用积分卡");
            }
            else
            {
               Tips.show("该道具只能在捕虫大会中使用哦");
            }
            return;
         }
         if(_loc2_[0] == "carry")
         {
            _loc3_.isUsed = false;
         }
         else if(_loc2_[0] == "use")
         {
            _loc3_.isUsed = true;
         }
         if(_loc3_.type == 9)
         {
            if(FightingMedia.isFighting && NPCVO.name == null)
            {
               LogUtil("查看喷雾使用情况： " + BackPackPro.littleMistNum,BackPackPro.middleMistNum,BackPackPro.heightMistNum);
               if(_loc3_.id == 149 && BackPackPro.littleMistNum >= 5 || _loc3_.id == 150 && BackPackPro.middleMistNum >= 5 || _loc3_.id == 151 && BackPackPro.heightMistNum >= 5)
               {
                  return Tips.show("亲，该喷雾在一次战斗中不能使用超过5次哦");
               }
               FightingConfig.cannotGoAwayRount = _loc3_.effectValue;
               Dialogue.updateDialogue("你使用了" + _loc3_.name + "\n对手精灵被迷惑",true,"prop_be_used");
               (facade.retrieveProxy("BackPackPro") as BackPackPro).write3002(_loc3_);
            }
            else
            {
               Tips.show("老爸说过,每一样东西都有合适使用的时候");
            }
         }
         else if(_loc3_.type == 27)
         {
            LogUtil("可以使用礼包");
            giftPropVo = _loc3_;
            useGiftFun();
         }
         else if(_loc3_.type == 28)
         {
            sugerPropVo = _loc3_;
            _loc4_ = Alert.show("您确定要使用【" + sugerPropVo.name + "】么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc4_.addEventListener("close",useSugerHander);
         }
         else if(_loc3_.type == 29 || _loc3_.type == 37 || _loc3_.type == 38)
         {
            boxPropVo = _loc3_;
            useBox();
         }
         else
         {
            if(!facade.hasMediator("PlayElfMedia"))
            {
               facade.registerMediator(new PlayElfMedia(new PlayElfUI()));
            }
            sendNotification("SEND_USE_PROP",_loc3_);
            sendNotification("switch_win",null,"LOAD_PLAYELF_WIN");
         }
      }
      
      private function useSugerHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3012(sugerPropVo);
         }
      }
      
      private function useGiftFun() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(giftPropVo.count < 2)
         {
            _loc1_ = Alert.show("您要开启【" + giftPropVo.name + "】么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc1_.addEventListener("close",useGiftHander);
         }
         else
         {
            openGiftCount = giftPropVo.count > 10?10:giftPropVo.count;
            _loc2_ = Alert.show("您有多个【" + giftPropVo.name + "】，要开启多个么？","温馨提示",new ListCollection([{"label":"开1个"},{"label":"开" + openGiftCount + "个"},{"label":"不开了"}]));
            _loc2_.addEventListener("close",useMuchGiftHander);
            _loc2_.buttonGroupProperties.gap = 25;
         }
      }
      
      private function useMuchGiftHander(param1:Event) : void
      {
         if(param1.data.label == "开1个")
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(giftPropVo,0,1);
         }
         else if(param1.data.label == "开" + openGiftCount + "个")
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(giftPropVo,0,openGiftCount);
         }
      }
      
      private function useGiftHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(giftPropVo,0,1);
         }
      }
      
      private function useBox() : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc1_:* = null;
         if(boxPropVo.count == 1)
         {
            if(isHasKey())
            {
               LogUtil("可以开启1个");
               _loc4_ = Alert.show("您确定要开启【" + boxPropVo.name + "】？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc4_.addEventListener("close",useBoxHander);
            }
         }
         else
         {
            openBoxCount = boxPropVo.count > 10?10:boxPropVo.count;
            _loc2_ = GetPropFactor.getProp(boxPropVo.actRole);
            if(_loc2_)
            {
               openBoxCount = Math.min(openBoxCount,_loc2_.count);
               if(openBoxCount == 1)
               {
                  _loc3_ = Alert.show("您确定要开启【" + boxPropVo.name + "】？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc3_.addEventListener("close",useBoxHander);
               }
               else
               {
                  _loc1_ = Alert.show("您有多个【" + boxPropVo.name + "】，是否开启多个？","温馨提示",new ListCollection([{"label":"开1个"},{"label":"开" + openBoxCount + "个"},{"label":"不开了"}]));
                  _loc1_.addEventListener("close",useMuchBoxHander);
                  _loc1_.buttonGroupProperties.gap = 25;
               }
            }
            else
            {
               Tips.show("亲，你还缺少【" + GetPropFactor.getPropVO(boxPropVo.actRole).name + "】");
               return;
            }
         }
      }
      
      private function useBoxHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            if(isHasKey())
            {
               (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(boxPropVo,1,1);
            }
         }
      }
      
      private function useMuchBoxHander(param1:Event) : void
      {
         if(param1.data.label == "开1个")
         {
            if(isHasKey())
            {
               LogUtil("可以开启1个，坐等协议");
               (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(boxPropVo,1,1);
            }
         }
         else if(param1.data.label == "开" + openBoxCount + "个")
         {
            if(isHasKey(openBoxCount))
            {
               LogUtil("可以开启" + openBoxCount + "个，坐等协议");
               (facade.retrieveProxy("BackPackPro") as BackPackPro).write3011(boxPropVo,1,openBoxCount);
            }
         }
      }
      
      private function isHasKey(param1:int = 1) : Boolean
      {
         var _loc2_:PropVO = GetPropFactor.getProp(boxPropVo.actRole);
         if(_loc2_)
         {
            if(_loc2_.count >= param1)
            {
               return true;
            }
            Tips.show("亲，你还缺少" + param1 + "枚" + _loc2_.name);
            return false;
         }
         Tips.show("亲，你还缺少" + param1 + "枚" + GetPropFactor.getPropVO(boxPropVo.actRole).name);
         return false;
      }
      
      private function elfBallHandle(param1:Event) : void
      {
         LogUtil("elfBall= " + PlayerVO.elfBallVec[(param1.target as DisplayObject).name].name);
         if(FightingMedia.isFighting)
         {
            propVO = PlayerVO.elfBallVec[(param1.target as DisplayObject).name];
            if(propVO.id == 868)
            {
               if(!(LoadPageCmd.lastPage is HuntingPartyUI))
               {
                  return Tips.show("该精灵球只能用于捕捉捕虫大会的精灵");
               }
            }
            else if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() <= 0)
            {
               Tips.show("空间不足, 无法捕捉精灵");
               return;
            }
            sendNotification("switch_win",null);
            requestCatch();
            close();
         }
         else
         {
            Tips.show("老爸说过,每一样东西都有合适使用的时候");
         }
      }
      
      private function requestCatch() : void
      {
         var _loc1_:int = GetPropFactor.getPropIndex(propVO);
         GetPropFactor.addOrLessProp(propVO,false);
         if(!GetPropFactor.getPropIndex(propVO))
         {
            _loc1_ = _loc1_ > 0?_loc1_ - 1:0.0;
         }
         sendNotification("UPDATA_USE_PROP",_loc1_);
         Dialogue.updateDialogue(PlayerVO.nickName + "使用了" + propVO.name);
         sendNotification("use_elf_ball",propVO);
      }
      
      private function medicineHandle(param1:Event) : void
      {
         sendNotification("switch_win",null,"LOAD_PLAYELF_WIN");
         LogUtil("我先来的");
         var _loc2_:Array = (param1.target as DisplayObject).name.split("|");
         var _loc3_:PropVO = PlayerVO.medicineVec[_loc2_[1]];
         if(_loc2_[0] == "carry")
         {
            _loc3_.isUsed = false;
         }
         else if(_loc2_[0] == "use")
         {
            _loc3_.isUsed = true;
         }
         LogUtil("medicineVO" + _loc3_.name);
         sendNotification("SEND_USE_PROP",_loc3_);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(backPack.closeBtn === _loc2_)
         {
            close();
         }
      }
      
      public function close() : void
      {
         if(backPack.backPackGoodsList.dataProvider)
         {
            backPack.backPackGoodsList.dataProvider.removeAll();
         }
         WinTweens.closeWin(backPack.mySpr,remove);
      }
      
      public function remove() : void
      {
         sendNotification("switch_win",null);
         backPack.removeFromParent();
         if(isElfSeries)
         {
            isElfSeries = false;
            sendNotification("ADD_SELEPLAYELF");
         }
         sendNotification(ConfigConst.CLOSE_BACKPACK);
         WinTweens.showCity();
         BeginnerGuide.playBeginnerGuide();
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("BackPackMedia");
         UI.removeFromParent();
         viewComponent = null;
      }
   }
}
