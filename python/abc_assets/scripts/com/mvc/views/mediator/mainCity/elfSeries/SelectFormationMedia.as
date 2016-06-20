package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.display.Image;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.WinTweens;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.mvc.views.mediator.mainCity.mining.MiningSelectTypeMediator;
   import com.mvc.views.mediator.mainCity.mining.MiningFrameMediator;
   import com.mvc.views.uis.mainCity.mining.MiningInfoPage;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.Sprite;
   import flash.geom.Point;
   import starling.animation.Tween;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import extend.SoundEvent;
   import starling.core.Starling;
   import com.common.util.DisposeDisplay;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   
   public class SelectFormationMedia extends Mediator
   {
      
      public static const NAME:String = "SelectFormationMedia";
      
      public static var isPlay:Boolean;
      
      public static var targetFormationElfVec:Vector.<ElfVO>;
       
      private var rootClass:Game;
      
      public var selectFormation:SelectFormationUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var allElfContainVec:Vector.<ElfBgUnitUI>;
      
      private var allElfVec:Vector.<ElfVO>;
      
      private var Addimage:Image;
      
      private var winType:String;
      
      public function SelectFormationMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         allElfContainVec = new Vector.<ElfBgUnitUI>([]);
         allElfVec = new Vector.<ElfVO>([]);
         super("SelectFormationMedia",param1);
         selectFormation = param1 as SelectFormationUI;
         selectFormation.addEventListener("triggered",clickHandler);
         rootClass = Config.starling.root as Game;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = param1.target;
         if(selectFormation.btn_close !== _loc5_)
         {
            if(selectFormation.btn_ok === _loc5_)
            {
               removeClean();
               PlayerVO.isAcceptPvp = true;
               if(GetElfFactor.seriesElfNum(targetFormationElfVec) == 0)
               {
                  Tips.show("你还未选择出战精灵");
                  return;
               }
               if(winType == "联盟")
               {
                  sendNotification("SEND_FORMATION_MAIN");
                  sendNotification("ADD_ELFSERIES_MAIN");
                  (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5008(0);
               }
               else if(winType == "开矿")
               {
                  (facade.retrieveProxy("Miningpro") as MiningPro).write3903(MiningSelectTypeMediator.selectType,MiningSelectTypeMediator.selectTime,getDefendSpiritIdArr());
               }
               else if(winType == "调矿")
               {
                  _loc2_ = (MiningFrameMediator.nowPage as MiningInfoPage).miningObj.id;
                  (facade.retrieveProxy("Miningpro") as MiningPro).write3909(_loc2_,getDefendSpiritIdArr());
               }
               else if(winType == "占矿")
               {
                  _loc3_ = (MiningFrameMediator.nowPage as MiningInfoPage).miningObj.id;
                  _loc4_ = (MiningFrameMediator.nowPage as MiningInfoPage).miningObj.defenderArr;
                  (facade.retrieveProxy("Miningpro") as MiningPro).write3907(_loc3_,_loc4_[0],getDefendSpiritIdArr());
               }
               sendNotification("switch_win",null);
               selectFormation.removeFromParent();
            }
         }
         else
         {
            removeClean();
            PlayerVO.isAcceptPvp = true;
            ElfBgUnitUI.isScrolling = false;
            selectFormation.allElfList.dataViewPort.touchable = true;
            selectFormation.allElfList.removeFromParent();
            WinTweens.closeWin(selectFormation.spr_allelf,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         selectFormation.removeFromParent();
         if(winType == "联盟")
         {
            selectFormation.regetData(selectFormation.temformaElfVec);
            sendNotification("SEND_FORMATION_MAIN");
            sendNotification("ADD_ELFSERIES_MAIN");
         }
         else if(winType == "开矿")
         {
            Facade.getInstance().sendNotification("switch_win",null,"mining_load_select_type_win");
         }
         else if(winType == "调矿")
         {
            Facade.getInstance().sendNotification("switch_win",null,"mining_load_view_camp_win");
         }
         else if(winType == "占矿")
         {
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc3_:* = 0;
         var _loc11_:* = param1.getName();
         if("selectformation_init_type" !== _loc11_)
         {
            if("SEND_FORMATION" !== _loc11_)
            {
               if("SHOW_ALL_ELF" !== _loc11_)
               {
                  if("ADD_FORMATION" !== _loc11_)
                  {
                     if("SUB_FORMATION" !== _loc11_)
                     {
                        if("SEND_SERIESELF_DATA" !== _loc11_)
                        {
                           if("CANCLE_FORMATION_FLATTEN" !== _loc11_)
                           {
                              if("CLEAN_ELFSERIES_FORMATIONELF" === _loc11_)
                              {
                                 cleanList();
                                 showAllElf();
                              }
                           }
                           else
                           {
                              _loc3_ = (param1.getBody() as int) / 6;
                              LogUtil("取消防守阵容flatten=========",_loc3_);
                              ((selectFormation.allElfList.dataProvider.data as Array)[_loc3_].icon as Sprite).unflatten();
                           }
                        }
                        else
                        {
                           _loc7_ = param1.getType() as String;
                           _loc8_ = param1.getBody() as ElfVO;
                           allElfVec[_loc7_] = _loc8_;
                           allElfContainVec[_loc7_]._elfVO = _loc8_;
                        }
                     }
                     else
                     {
                        if(GetElfFactor.seriesElfNum(targetFormationElfVec) <= 1)
                        {
                           Tips.show("至少留一只精灵作为防守");
                           return;
                        }
                        _loc2_ = param1.getBody() as ElfVO;
                        _loc9_ = 0;
                        while(_loc9_ < targetFormationElfVec.length)
                        {
                           if(targetFormationElfVec[_loc9_].id == _loc2_.id)
                           {
                              LogUtil("SUB_FORMATION j ====",_loc9_);
                              targetFormationElfVec[_loc9_] = null;
                              break;
                           }
                           _loc9_++;
                        }
                        if(_loc9_ == 6)
                        {
                           return;
                        }
                        _loc10_ = 0;
                        while(_loc10_ < allElfContainVec.length)
                        {
                           if(allElfContainVec[_loc10_]._elfVO.id == _loc2_.id)
                           {
                              LogUtil("SUB_FORMATION k ====",_loc10_);
                              sendNotification("CANCLE_FORMATION_FLATTEN",_loc10_);
                              allElfContainVec[_loc10_].tick.visible = false;
                              allElfContainVec[_loc10_].removeMask();
                              break;
                           }
                           _loc10_++;
                        }
                        GetElfFactor.otherSeiri(targetFormationElfVec);
                        playCartoon(_loc2_,_loc9_,_loc10_,false);
                        showFormation(targetFormationElfVec);
                     }
                  }
                  else
                  {
                     _loc4_ = param1.getBody() as ElfVO;
                     _loc5_ = 0;
                     while(_loc5_ < targetFormationElfVec.length)
                     {
                        if(targetFormationElfVec[_loc5_] == null)
                        {
                           LogUtil("ADD_FORMATION i ====",_loc5_);
                           targetFormationElfVec[_loc5_] = _loc4_;
                           break;
                        }
                        _loc5_++;
                     }
                     _loc6_ = 0;
                     while(_loc6_ < allElfContainVec.length)
                     {
                        if(allElfContainVec[_loc6_]._elfVO.id == _loc4_.id)
                        {
                           LogUtil("ADD_FORMATION i2 ====",_loc6_);
                           break;
                        }
                        _loc6_++;
                     }
                     if(_loc5_ == 6)
                     {
                        return;
                     }
                     playCartoon(_loc4_,_loc5_,_loc6_,true);
                  }
               }
               else
               {
                  showAllElf();
               }
            }
            else
            {
               showFormation(targetFormationElfVec);
            }
         }
         else
         {
            targetFormationElfVec = param1.getBody() as Vector.<ElfVO>;
            winType = param1.getType();
            if(winType == "联盟")
            {
               selectFormation.updateElf();
               selectFormation.initFormationElfVec(targetFormationElfVec);
            }
         }
      }
      
      private function cleanList() : void
      {
         if(selectFormation.allElfList.dataProvider)
         {
            selectFormation.allElfList.dataProvider.removeAll();
            selectFormation.allElfList.dataProvider = null;
         }
      }
      
      private function playCartoon(param1:ElfVO, param2:int, param3:int, param4:Boolean) : void
      {
         elfVo = param1;
         i = param2;
         k = param3;
         isAdd = param4;
         isPlay = true;
         if(Addimage)
         {
            GetpropImage.clean(Addimage);
         }
         Addimage = ELFMinImageManager.getElfM(elfVo.imgName);
         var point:Point = allElfContainVec[k].getLoadPoint();
         point.x = point.x / Config.scaleX;
         point.y = point.y / Config.scaleY;
         var targetPoint:Point = selectFormation.elfSprite.localToGlobal(new Point(selectFormation.formationContainVec[i].x,selectFormation.formationContainVec[i].y));
         targetPoint.x = targetPoint.x / Config.scaleX;
         targetPoint.y = targetPoint.y / Config.scaleY;
         if(isAdd)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfVo.sound);
            Addimage.x = point.x;
            Addimage.y = point.y;
         }
         else
         {
            Addimage.x = targetPoint.x;
            Addimage.y = targetPoint.y;
         }
         rootClass.addChild(Addimage);
         var t1:Tween = new Tween(Addimage,0.2);
         Starling.juggler.add(t1);
         if(isAdd)
         {
            t1.animate("x",targetPoint.x);
            t1.animate("y",targetPoint.y);
            t1.animate("alpha",0.5);
         }
         else
         {
            t1.animate("x",point.x);
            t1.animate("y",point.y);
            t1.animate("alpha",0);
         }
         t1.onComplete = function():*
         {
            var /*UnknownSlot*/:* = §§dup(function():void
            {
               if(isAdd)
               {
                  showFormation(targetFormationElfVec);
               }
               if(Addimage)
               {
                  GetpropImage.clean(Addimage);
               }
               isPlay = false;
            });
            return function():void
            {
               if(isAdd)
               {
                  showFormation(targetFormationElfVec);
               }
               if(Addimage)
               {
                  GetpropImage.clean(Addimage);
               }
               isPlay = false;
            };
         }();
      }
      
      public function getAllElf(param1:int = 1) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         allElfVec = new Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               if(PlayerVO.bagElfVec[_loc2_].lv >= param1)
               {
                  allElfVec.push(PlayerVO.bagElfVec[_loc2_]);
               }
            }
            _loc2_++;
         }
         _loc4_ = 0;
         while(_loc4_ < PlayerVO.comElfVec.length)
         {
            if(PlayerVO.comElfVec[_loc4_].lv >= param1)
            {
               allElfVec.push(PlayerVO.comElfVec[_loc4_]);
            }
            _loc4_++;
         }
         if(winType == "开矿" || winType == "调矿" || winType == "占矿")
         {
            _loc6_ = 0;
            while(_loc6_ < PlayerVO.miningDefendElfArr.length)
            {
               _loc3_ = 0;
               while(_loc3_ < allElfVec.length)
               {
                  if(PlayerVO.miningDefendElfArr[_loc6_] == allElfVec[_loc3_].id)
                  {
                     allElfVec.splice(_loc3_,1);
                     _loc3_--;
                  }
                  _loc3_++;
               }
               _loc6_++;
            }
            _loc5_ = 0;
            while(_loc5_ < targetFormationElfVec.length)
            {
               if(targetFormationElfVec[_loc5_] != null)
               {
                  allElfVec.unshift(targetFormationElfVec[_loc5_]);
               }
               _loc5_++;
            }
         }
      }
      
      private function showAllElf() : void
      {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         selectFormation.spr_allelf.addChild(selectFormation.allElfList);
         if(selectFormation.allElfList.dataProvider != null && winType == "联盟")
         {
            return;
            §§push(LogUtil("联盟已经不是第一次了"));
         }
         else
         {
            if(winType == "开矿" || winType == "调矿" || winType == "占矿")
            {
               getAllElf(26);
            }
            else
            {
               getAllElf();
            }
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            allElfContainVec = Vector.<ElfBgUnitUI>([]);
            if(allElfVec.length == 0 && (winType == "开矿" || winType == "调矿" || winType == "占矿"))
            {
               Tips.show("精灵等级需26级以上且同时只能防守一个矿");
            }
            var _loc8_:int = allElfVec.length;
            var _loc3_:* = 6;
            var _loc1_:Array = [];
            var _loc5_:int = Math.floor(_loc8_ / _loc3_);
            var _loc2_:* = _loc3_;
            if(_loc8_ % _loc3_ != 0)
            {
               _loc5_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc5_)
            {
               _loc6_ = new Sprite();
               if(_loc9_ == _loc5_ - 1 && _loc8_ % _loc3_ != 0)
               {
                  _loc2_ = _loc8_ % _loc3_;
               }
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  _loc4_ = new ElfBgUnitUI();
                  _loc4_.identify = "防守";
                  _loc4_.x = 140 * _loc10_;
                  _loc4_.comIndex = _loc3_ * _loc9_ + _loc10_;
                  _loc4_.myElfVo = allElfVec[_loc3_ * _loc9_ + _loc10_];
                  _loc4_.switchContain(true);
                  allElfContainVec.push(_loc4_);
                  _loc6_.addChild(_loc4_);
                  _loc10_++;
               }
               _loc6_.flatten();
               _loc1_.push({
                  "icon":_loc6_,
                  "label":""
               });
               displayVec.push(_loc6_);
               _loc9_++;
            }
            var _loc7_:ListCollection = new ListCollection(_loc1_);
            cleanList();
            selectFormation.allElfList.dataProvider = _loc7_;
            if(!selectFormation.allElfList.hasEventListener("creationComplete"))
            {
               selectFormation.allElfList.addEventListener("creationComplete",creatComplete);
            }
            return;
         }
      }
      
      private function creatComplete() : void
      {
         (selectFormation.allElfList.layout as VerticalLayout).gap = 30;
      }
      
      private function showFormation(param1:Vector.<ElfVO>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               selectFormation.formationContainVec[_loc2_].myElfVo = param1[_loc2_];
               selectFormation.formationContainVec[_loc2_].switchContain(true);
               _loc3_ = 0;
               while(_loc3_ < allElfContainVec.length)
               {
                  if(allElfContainVec[_loc3_]._elfVO.id == param1[_loc2_].id)
                  {
                     allElfContainVec[_loc3_].tick.visible = true;
                     allElfContainVec[_loc3_].addMask();
                     break;
                  }
                  _loc3_++;
               }
            }
            else
            {
               selectFormation.formationContainVec[_loc2_].hideImg();
               selectFormation.formationContainVec[_loc2_].switchContain(false);
            }
            _loc2_++;
         }
         selectFormation.power.text = GetElfFactor.powerFormation(param1);
      }
      
      private function getDefendSpiritIdArr() : Array
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < targetFormationElfVec.length)
         {
            if(targetFormationElfVec[_loc2_])
            {
               _loc1_.push(targetFormationElfVec[_loc2_].id);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function removeClean() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < allElfContainVec.length)
         {
            if(allElfContainVec[_loc1_].tick.visible)
            {
               allElfContainVec[_loc1_].tick.visible = false;
               allElfContainVec[_loc1_].removeMask();
            }
            _loc1_++;
         }
      }
      
      public function getFormationPoint(param1:int) : Point
      {
         var _loc2_:Point = new Point(selectFormation.formationContainVec[param1].x,selectFormation.formationContainVec[param1].y);
         return selectFormation.elfSprite.localToGlobal(_loc2_);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_FORMATION","SHOW_ALL_ELF","ADD_FORMATION","SUB_FORMATION","SEND_SERIESELF_DATA","CANCLE_FORMATION_FLATTEN","CLEAN_ELFSERIES_FORMATIONELF","selectformation_init_type"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function clean() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < selectFormation.formationContainVec.length)
         {
            selectFormation.formationContainVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         selectFormation.formationContainVec = Vector.<ElfBgUnitUI>([]);
      }
      
      public function dispose() : void
      {
         targetFormationElfVec = null;
         clean();
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         if(selectFormation.allElfList.dataProvider)
         {
            selectFormation.allElfList.dataProvider.removeAll();
            selectFormation.allElfList.dataProvider = null;
         }
         facade.removeMediator("SelectFormationMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
