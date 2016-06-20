package com.mvc.views.mediator.mainCity.home
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.home.ComElfUI;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Sprite;
   import com.common.util.DisposeDisplay;
   import feathers.layout.VerticalLayout;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   
   public class ComElfMedia extends Mediator
   {
      
      public static const NAME:String = "ComElfMedia";
      
      public static var seleNum:int;
      
      public static var isRareSort:Boolean;
       
      public var comElf:ComElfUI;
      
      public var comContainVec:Vector.<ElfBgUnitUI>;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var mainIdArr:Array;
      
      private var slidePosition:Number = 0;
      
      public function ComElfMedia(param1:Object = null)
      {
         comContainVec = new Vector.<ElfBgUnitUI>([]);
         displayVec = new Vector.<DisplayObject>([]);
         super("ComElfMedia",param1);
         comElf = param1 as ComElfUI;
         comElf.addEventListener("triggered",clickHandler);
         seleNum = 0;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc11_:* = false;
         var _loc14_:* = false;
         var _loc12_:* = false;
         var _loc2_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc8_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc13_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc15_:* = param1.target;
         if(comElf.putBugBtn !== _loc15_)
         {
            if(comElf.btn_sortLv !== _loc15_)
            {
               if(comElf.btn_sortRare !== _loc15_)
               {
                  if(comElf.btn_free === _loc15_)
                  {
                     LogUtil("seleNum==",seleNum);
                     if(seleNum == 0)
                     {
                        Tips.show("你还未选择精灵");
                        return;
                     }
                     LogUtil("seleNum=" + seleNum);
                     mainIdArr = [];
                     _loc2_ = 0;
                     while(_loc2_ < PlayerVO.comElfVec.length)
                     {
                        if(comContainVec[_loc2_].tick.visible)
                        {
                           if(comContainVec[_loc2_]._elfVO.isLock)
                           {
                              return Tips.show("选中已锁定精灵，放生失败");
                           }
                           if(comContainVec[_loc2_].myElfVO.rareValue >= 4)
                           {
                              _loc11_ = true;
                           }
                           if(comContainVec[_loc2_].myElfVO.rareValue == 5)
                           {
                              _loc14_ = true;
                           }
                           mainIdArr.push(PlayerVO.comElfVec[_loc2_].id);
                        }
                        _loc2_++;
                     }
                     _loc9_ = 0;
                     while(_loc9_ < mainIdArr.length)
                     {
                        if(PlayerVO.miningDefendElfArr.indexOf(mainIdArr[_loc9_]) != -1)
                        {
                           LogUtil("放生的精灵中有挖矿防守中的精灵==",PlayerVO.miningDefendElfArr,mainIdArr[_loc9_]);
                           Tips.show("放生的精灵中有挖矿防守中的精灵");
                           return;
                        }
                        _loc9_++;
                     }
                     _loc7_ = 0;
                     while(_loc7_ < mainIdArr.length)
                     {
                        if(PlayerVO.trainElfArr.indexOf(mainIdArr[_loc7_]) != -1)
                        {
                           LogUtil("放生的精灵中有训练位的精灵==",PlayerVO.trainElfArr,mainIdArr[_loc7_]);
                           Tips.show("放生的精灵中有训练位的精灵");
                           return;
                        }
                        _loc7_++;
                     }
                     _loc5_ = 0;
                     while(_loc5_ < mainIdArr.length)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < PlayerVO.FormationElfVec.length)
                        {
                           if(PlayerVO.FormationElfVec[_loc8_] != null)
                           {
                              if(PlayerVO.FormationElfVec[_loc8_].id == mainIdArr[_loc5_])
                              {
                                 Tips.show("放生的精灵中有竞技场的防守精灵");
                                 return;
                              }
                           }
                           _loc8_++;
                        }
                        _loc5_++;
                     }
                     if(PlayerVO.kingIsOpen)
                     {
                        _loc3_ = 0;
                        while(_loc3_ < mainIdArr.length)
                        {
                           _loc6_ = 0;
                           while(_loc6_ < KingKwanMedia.kingPlayElf.length)
                           {
                              if(KingKwanMedia.kingPlayElf[_loc6_].id == mainIdArr[_loc3_])
                              {
                                 _loc13_ = Alert.show("放生的精灵当中，含有王者之路的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                                 if(_loc14_)
                                 {
                                    _loc13_.addEventListener("close",secondWin);
                                 }
                                 else
                                 {
                                    _loc13_.addEventListener("close",freeElf);
                                 }
                                 return;
                              }
                              _loc6_++;
                           }
                           _loc3_++;
                        }
                     }
                     if(_loc11_)
                     {
                        _loc4_ = Alert.show("放生的精灵当中，含有稀有度为[史诗]或以上的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                        _loc4_.addEventListener("close",freeElf);
                     }
                     else
                     {
                        _loc10_ = Alert.show("确定放生精灵？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                        _loc10_.addEventListener("close",freeElf);
                     }
                  }
               }
               else
               {
                  comElf.btn_sortLv.enabled = false;
                  cleanComTick();
                  isRareSort = true;
                  comElf.switchBtn();
                  GetElfFactor.elfSort(PlayerVO.comElfVec,"rareValue");
                  createComElf();
               }
            }
            else
            {
               comElf.btn_sortRare.enabled = false;
               cleanComTick();
               isRareSort = false;
               comElf.switchBtn();
               GetElfFactor.elfSort(PlayerVO.comElfVec,"lv");
               createComElf();
            }
         }
         else
         {
            sendBag();
         }
      }
      
      private function secondWin(param1:Event, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.label == "确定")
         {
            _loc3_ = Alert.show("放生的精灵当中，含有稀有度为【传说】的精灵，是否确定放生？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc3_.addEventListener("close",freeElf);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = param1.getName();
         if("SHOW_COM_ELF" !== _loc6_)
         {
            if("SEND_COMELF_DATA" !== _loc6_)
            {
               if("CLEAN_COM_TICK" !== _loc6_)
               {
                  if("CLEAN_COM_CLOSE" !== _loc6_)
                  {
                     if("SHOW_COM_SPACE" !== _loc6_)
                     {
                        if("BATCH_FREE_ELF" !== _loc6_)
                        {
                           if("CANCLE_COM_FLATTEN" !== _loc6_)
                           {
                              if("home_update_comelf_lock" === _loc6_)
                              {
                                 _loc5_ = 0;
                                 while(_loc5_ < comContainVec.length)
                                 {
                                    if(comContainVec[_loc5_].tick.visible)
                                    {
                                       comContainVec[_loc5_].tick.visible = false;
                                       PlayerVO.comElfVec[_loc5_].isLock = !PlayerVO.comElfVec[_loc5_].isLock;
                                       comContainVec[_loc5_].switchLock();
                                    }
                                    _loc5_++;
                                 }
                                 ComElfMedia.seleNum = 0;
                              }
                           }
                           else
                           {
                              _loc2_ = (param1.getBody() as int) / 4;
                              LogUtil("取消flatten============",_loc2_);
                              ((comElf.comList.dataProvider.data as Array)[_loc2_].icon as Sprite).unflatten();
                           }
                        }
                        else
                        {
                           deleFreeElf();
                        }
                     }
                     else
                     {
                        comElf.nowSpace.text = PlayerVO.cpSpace;
                     }
                  }
                  else
                  {
                     clearClose();
                  }
               }
               else
               {
                  ElfBgUnitUI.isScrolling = false;
                  comElf.comList.dataViewPort.touchable = true;
                  cleanComTick();
               }
            }
            else
            {
               _loc3_ = param1.getType() as String;
               _loc4_ = param1.getBody() as ElfVO;
               PlayerVO.comElfVec[_loc3_] = null;
               PlayerVO.comElfVec[_loc3_] = _loc4_;
               comContainVec[_loc3_]._elfVO = null;
               comContainVec[_loc3_]._elfVO = _loc4_;
               _loc4_ = null;
            }
         }
         else
         {
            createComElf();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_COM_ELF","SEND_COMELF_DATA","CLEAN_COM_TICK","SHOW_COM_SPACE","CLEAN_COM_CLOSE","BATCH_FREE_ELF","CANCLE_COM_FLATTEN","home_update_comelf_lock"];
      }
      
      public function createComElf() : void
      {
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc5_:* = null;
         var _loc10_:* = 0;
         var _loc3_:* = null;
         if(comElf.comList.dataProvider != null)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            comElf.comList.dataProvider.removeAll();
            comElf.comList.dataProvider = null;
         }
         comElf.allSpace.text = PlayerVO.cpSpace;
         comContainVec = Vector.<ElfBgUnitUI>([]);
         comElf.nowSpace.text = PlayerVO.comElfVec.length;
         var _loc9_:int = PlayerVO.comElfVec.length;
         if(PlayerVO.cpSpace >= 400)
         {
            _loc7_ = PlayerVO.cpSpace;
         }
         else
         {
            _loc7_ = PlayerVO.cpSpace + 1;
         }
         var _loc1_:Array = [];
         var _loc4_:int = Math.floor(_loc7_ / 4);
         var _loc2_:* = 4;
         if(_loc7_ % 4 != 0)
         {
            _loc4_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc5_ = new Sprite();
            if(_loc8_ == _loc4_ - 1 && _loc7_ % 4 != 0)
            {
               _loc2_ = _loc7_ % 4;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc2_)
            {
               _loc3_ = new ElfBgUnitUI();
               _loc3_.x = 119 * _loc10_;
               if(4 * _loc8_ + _loc10_ < _loc9_)
               {
                  _loc3_.identify = "电脑";
                  _loc3_.comIndex = 4 * _loc8_ + _loc10_;
                  _loc3_.myElfVo = PlayerVO.comElfVec[4 * _loc8_ + _loc10_];
                  _loc3_.switchContain(true);
                  comContainVec.push(_loc3_);
               }
               else
               {
                  _loc3_.switchContain(false);
                  if(4 * _loc8_ + _loc10_ == PlayerVO.cpSpace)
                  {
                     _loc3_.addLock();
                  }
               }
               _loc5_.addChild(_loc3_);
               _loc10_++;
            }
            _loc5_.flatten();
            _loc1_.push({
               "icon":_loc5_,
               "label":""
            });
            displayVec.push(_loc5_);
            _loc8_++;
         }
         var _loc6_:ListCollection = new ListCollection(_loc1_);
         comElf.comList.dataProvider = _loc6_;
         comElf.comList.verticalScrollPosition = slidePosition;
         comElf.comList.addEventListener("scrollComplete",scrollComplete);
         comElf.comList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",complete);
         if(!comElf.comList.hasEventListener("creationComplete"))
         {
            comElf.comList.addEventListener("creationComplete",creatComplete);
         }
      }
      
      private function complete(param1:Event) : void
      {
         comElf.btn_sortRare.enabled = true;
         comElf.btn_sortLv.enabled = true;
      }
      
      private function scrollComplete() : void
      {
         slidePosition = comElf.comList.verticalScrollPosition;
      }
      
      private function creatComplete() : void
      {
         (comElf.comList.layout as VerticalLayout).gap = 5;
      }
      
      public function sendBag() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         LogUtil("seleNum=" + seleNum);
         if(seleNum == 0)
         {
            Tips.show("你还未选择精灵");
            return;
         }
         if(seleNum > PlayerVO.pokeSpace - GetElfFactor.bagElfNum())
         {
            Tips.show("背包空位不足");
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.comElfVec.length)
         {
            if(comContainVec[_loc1_].tick.visible)
            {
               _loc2_ = 0;
               while(true)
               {
                  if(_loc2_ < PlayerVO.bagElfVec.length)
                  {
                     if(_loc2_ == PlayerVO.pokeSpace - 1 && PlayerVO.bagElfVec[_loc2_] != null)
                     {
                        break;
                     }
                     if(PlayerVO.bagElfVec[_loc2_] == null)
                     {
                        PlayerVO.bagElfVec[_loc2_] = PlayerVO.comElfVec[_loc1_];
                        PlayerVO.bagElfVec[_loc2_].isCarry = 1;
                        PlayerVO.bagElfVec[_loc2_].position = _loc2_ + 1;
                     }
                     else
                     {
                        _loc2_++;
                        continue;
                     }
                  }
                  PlayerVO.comElfVec.splice(_loc1_,1);
                  comContainVec[_loc1_].dispose();
                  comContainVec.splice(_loc1_,1);
                  _loc1_--;
               }
               Tips.show("空位不足");
               sendNotification("SHOW_BAG_ELF");
               createComElf();
               seleNum = 0;
               return;
            }
            _loc1_++;
         }
         sendNotification("SHOW_BAG_ELF");
         createComElf();
         seleNum = 0;
         (facade.retrieveProxy("HomePro") as HomePro).write2002();
      }
      
      private function freeElf(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("HomePro") as HomePro).write2018(mainIdArr);
         }
      }
      
      public function deleFreeElf() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < KingKwanMedia.kingPlayElf.length)
         {
            if(mainIdArr.indexOf(KingKwanMedia.kingPlayElf[_loc2_].id) != -1)
            {
               KingKwanMedia.kingPlayElf.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.comElfVec.length)
         {
            if(mainIdArr.indexOf(PlayerVO.comElfVec[_loc1_].id) != -1)
            {
               PlayerVO.comElfVec.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
         mainIdArr = [];
         createComElf();
         seleNum = 0;
         sendNotification("CLEAN_ELFINFO_CLOSE");
      }
      
      public function cleanComTick() : void
      {
         var _loc1_:* = 0;
         seleNum = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.comElfVec.length)
         {
            comContainVec[_loc1_].tick.visible = false;
            _loc1_++;
         }
      }
      
      public function clearClose() : void
      {
         while(comContainVec.length > 0)
         {
            comContainVec[0].hideImg();
            comContainVec.splice(0,1);
         }
         comContainVec = null;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         clearClose();
         mainIdArr = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         displayVec = null;
         facade.removeMediator("ComElfMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
