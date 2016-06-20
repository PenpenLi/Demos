package com.mvc.views.mediator.mainCity.miracle
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.miracle.MiracleUI;
   import com.mvc.views.uis.mainCity.miracle.MiracleAddElfUnit;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.miracle.MiraclePro;
   import com.common.util.ElfSortHandler;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mainCity.miracle.MiracleMcUI;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.views.uis.mainCity.miracle.MiracleSelectElfUI;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MiracleMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiracleMediator";
       
      public var miracleUI:MiracleUI;
      
      private var miracleAddElfUnitVec:Vector.<MiracleAddElfUnit>;
      
      private var elfRarity:String;
      
      private var miracleElfVec:Vector.<ElfVO>;
      
      private var rarityElfVec:Vector.<ElfVO>;
      
      private var rareElfVec:Vector.<ElfVO>;
      
      private var epicElfVec:Vector.<ElfVO>;
      
      private var legendElfVec:Vector.<ElfVO>;
      
      private var addElfBtnIndex:int;
      
      private var rarityElfVecArr:Array;
      
      private var nowAutoIndex:int;
      
      private var startIndex:int;
      
      private var targetElfImg:Image;
      
      private var targetElfVO:ElfVO;
      
      private var isUpdateRarityElfVecArr:Boolean = true;
      
      private var elfVo:ElfVO;
      
      private var imgName:String;
      
      public function MiracleMediator(param1:Object = null)
      {
         miracleAddElfUnitVec = new Vector.<MiracleAddElfUnit>([]);
         rarityElfVecArr = [];
         super("MiracleMediator",param1);
         miracleUI = param1 as MiracleUI;
         miracleUI.addEventListener("triggered",triggeredHandler);
         createAddELFUnit();
         miracleElfVec = ElfSortHandler.getPlayerELF();
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc6_:* = param1.target;
         if(miracleUI.btn_close !== _loc6_)
         {
            if(miracleUI.btn_miracleBtn !== _loc6_)
            {
               if(miracleUI.btn_autoAddBtn === _loc6_)
               {
                  removeElf();
                  if(isUpdateRarityElfVecArr)
                  {
                     updateRarityElfVecArr();
                  }
                  autoAddElf();
               }
            }
            else
            {
               _loc2_ = [];
               _loc3_ = true;
               _loc6_ = 0;
               var _loc5_:* = miracleAddElfUnitVec;
               for each(var _loc4_ in miracleAddElfUnitVec)
               {
                  if(!_loc4_.elfImage)
                  {
                     _loc3_ = false;
                     break;
                  }
                  _loc2_.push(_loc4_.elfVO.id);
               }
               if(_loc3_)
               {
                  if(PlayerVO.silver < 5000)
                  {
                     Tips.show("亲，金币不足哦。");
                     return;
                  }
                  destoryImg();
                  (facade.retrieveProxy(MiraclePro.NAME) as MiraclePro).write2601(_loc2_);
               }
               else
               {
                  Tips.show("亲，需要的精灵数量不足哦");
               }
            }
         }
         else
         {
            if(targetElfImg)
            {
               targetElfImg.visible = false;
            }
            WinTweens.closeWin(miracleUI.spr_miracle,removeWindow);
         }
      }
      
      private function updateRarityElfVecArr() : void
      {
         rarityElfVecArr = [];
         rarityElfVec = ElfSortHandler.getElfVecByRarity(miracleElfVec,"稀有");
         epicElfVec = ElfSortHandler.getElfVecByRarity(miracleElfVec,"史诗");
         legendElfVec = ElfSortHandler.getElfVecByRarity(miracleElfVec,"传说");
         if(rarityElfVec.length >= 4)
         {
            rarityElfVecArr.push(rarityElfVec);
         }
         if(epicElfVec.length >= 4)
         {
            rarityElfVecArr.push(epicElfVec);
         }
         if(legendElfVec.length >= 4)
         {
            rarityElfVecArr.push(legendElfVec);
         }
         isUpdateRarityElfVecArr = false;
         nowAutoIndex = 0;
         startIndex = 0;
      }
      
      private function autoAddElf() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = true;
         _loc2_ = nowAutoIndex;
         while(_loc2_ < rarityElfVecArr.length)
         {
            if((rarityElfVecArr[_loc2_] as Vector.<ElfVO>).length >= 4 && (rarityElfVecArr[_loc2_] as Vector.<ElfVO>).length - startIndex >= 4)
            {
               nowAutoIndex = _loc2_;
               LogUtil("nowAutoIndex: " + nowAutoIndex);
               addElf();
               startIndex = §§dup().startIndex + 1;
               _loc1_ = false;
               break;
            }
            startIndex = 0;
            _loc2_++;
         }
         if(nowAutoIndex == rarityElfVecArr.length - 1 && (rarityElfVecArr[nowAutoIndex] as Vector.<ElfVO>).length - startIndex < 4)
         {
            nowAutoIndex = 0;
            startIndex = 0;
         }
         if(_loc1_)
         {
            Tips.show("亲，同稀有度的精灵数量不足哦。");
         }
      }
      
      private function addElf() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:int = startIndex;
         _loc4_ = 0;
         while(_loc4_ < miracleAddElfUnitVec.length)
         {
            _loc1_++;
            _loc2_ = (rarityElfVecArr[nowAutoIndex] as Vector.<ElfVO>)[_loc1_];
            miracleAddElfUnitVec[_loc4_].elfVO = _loc2_;
            _loc3_ = miracleElfVec.length - 1;
            while(_loc3_ >= 0)
            {
               if(miracleElfVec[_loc3_].id == _loc2_.id)
               {
                  miracleElfVec.splice(_loc3_,1);
                  break;
               }
               _loc3_--;
            }
            _loc4_++;
         }
      }
      
      private function removeElf(param1:Boolean = true) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = miracleAddElfUnitVec;
         for each(var _loc2_ in miracleAddElfUnitVec)
         {
            if(param1 && _loc2_.elfImage)
            {
               Facade.getInstance().sendNotification("miracle_add_elf_unit_touch_complete",_loc2_.elfVO);
            }
            _loc2_.removeImgAndAddBtn();
         }
      }
      
      private function removeWindow() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc9_:* = false;
         var _loc8_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc11_:* = param1.getName();
         if("miracle_update_add_elf_btn" !== _loc11_)
         {
            if("miracle_add_elf_unit_touch_complete" !== _loc11_)
            {
               if("miracle_update_elfvec" !== _loc11_)
               {
                  if("miracle_exchange_complete" !== _loc11_)
                  {
                     if("miracle_com_list_close_complete" !== _loc11_)
                     {
                        if("miracle_firemc_complete" !== _loc11_)
                        {
                           if("miracle_miraclemc_complete" === _loc11_)
                           {
                              showTargetElf(targetElfVO);
                           }
                        }
                        else
                        {
                           removeElf(false);
                        }
                     }
                     else
                     {
                        miracleUI.addChild(miracleUI.spr_miracle);
                     }
                  }
                  else if(MiracleMcUI.callBack)
                  {
                     MiracleMcUI.getInstances().showMiracleMc(targetElfVO);
                  }
                  else
                  {
                     MiracleMcUI.getInstances(showMiracleMc);
                  }
               }
               else
               {
                  _loc9_ = true;
                  targetElfVO = param1.getBody() as ElfVO;
                  _loc8_ = 0;
                  while(_loc8_ < miracleAddElfUnitVec.length)
                  {
                     _loc6_ = PlayerVO.comElfVec.length - 1;
                     while(_loc6_ >= 0)
                     {
                        if(PlayerVO.comElfVec[_loc6_].id == miracleAddElfUnitVec[_loc8_].elfVO.id)
                        {
                           PlayerVO.comElfVec.splice(_loc6_,1);
                           break;
                        }
                        _loc6_--;
                     }
                     _loc7_ = KingKwanMedia.kingPlayElf.length - 1;
                     while(_loc7_ >= 0)
                     {
                        if(KingKwanMedia.kingPlayElf[_loc7_].id == miracleAddElfUnitVec[_loc8_].elfVO.id)
                        {
                           KingKwanMedia.kingPlayElf.splice(_loc7_,1);
                           break;
                        }
                        _loc7_--;
                     }
                     _loc8_++;
                  }
                  GetElfFactor.bagOrCom(targetElfVO);
                  _loc5_ = 0;
                  while(_loc5_ < PlayerVO.bagElfVec.length)
                  {
                     if(PlayerVO.bagElfVec[_loc5_] != null && PlayerVO.bagElfVec[_loc5_].id == targetElfVO.id)
                     {
                        _loc9_ = false;
                        break;
                     }
                     _loc5_++;
                  }
                  if(_loc9_)
                  {
                     miracleElfVec.push(targetElfVO);
                  }
                  isUpdateRarityElfVecArr = true;
               }
            }
            else
            {
               _loc2_ = param1.getBody() as ElfVO;
               miracleElfVec.push(_loc2_);
            }
         }
         else
         {
            _loc3_ = param1.getBody() as ElfVO;
            _loc11_ = 0;
            var _loc10_:* = miracleElfVec;
            for(var _loc4_ in miracleElfVec)
            {
               if(miracleElfVec[_loc4_].id == _loc3_.id)
               {
                  miracleElfVec.splice(_loc4_,1);
               }
            }
            updateAddElfUnit(_loc3_);
         }
      }
      
      private function showMiracleMc() : void
      {
         MiracleMcUI.getInstances().showMiracleMc(targetElfVO);
      }
      
      private function showTargetElf(param1:ElfVO) : void
      {
         imgName = param1.imgName;
         ElfFrontImageManager.tempNoRemoveTexture = [param1.imgName];
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
      }
      
      private function showElf() : void
      {
         targetElfImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         targetElfImg.addEventListener("touch",targetElfImg_touchHandler);
         miracleUI.addTargetImg(targetElfImg);
      }
      
      private function targetElfImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(targetElfImg);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            ElfDetailInfoMedia.showFreeBtn = false;
            ElfDetailInfoMedia.showSetNameBtn = true;
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
            Facade.getInstance().sendNotification("SEND_ELF_DETAIL",targetElfVO);
         }
      }
      
      private function destoryImg() : void
      {
         if(targetElfImg)
         {
            ElfFrontImageManager.getInstance().disposeImg(targetElfImg);
            targetElfImg.removeEventListener("touch",targetElfImg_touchHandler);
         }
      }
      
      private function updateAddElfUnit(param1:ElfVO) : void
      {
         (miracleAddElfUnitVec[addElfBtnIndex] as MiracleAddElfUnit).elfVO = param1;
      }
      
      private function createAddELFUnit() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:* = null;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc1_ = new MiracleAddElfUnit();
            _loc1_.btn_addElfBtn.name = _loc3_;
            _loc1_.addEventListener("triggered",miracleAddElfUnit_triggeredHandler);
            if(_loc3_ % 2 == 0 && _loc3_ != 0)
            {
               _loc2_++;
            }
            _loc1_.x = 68 + _loc3_ % 2 * 145;
            _loc1_.y = 115 + _loc2_ * 140;
            miracleUI.spr_miracle.addChild(_loc1_);
            miracleAddElfUnitVec.push(_loc1_);
            _loc3_++;
         }
      }
      
      private function miracleAddElfUnit_triggeredHandler(param1:Event) : void
      {
         addElfBtnIndex = (param1.target as SwfButton).name;
         elfRarity = "全稀有度";
         var _loc4_:* = 0;
         var _loc3_:* = miracleAddElfUnitVec;
         for each(var _loc2_ in miracleAddElfUnitVec)
         {
            if(_loc2_.elfImage)
            {
               elfRarity = _loc2_.elfVO.rare;
               break;
            }
         }
         rarityElfVec = null;
         rarityElfVec = ElfSortHandler.getElfVecByRarity(miracleElfVec,elfRarity);
         if(rarityElfVec.length == 0)
         {
            Tips.show("亲，没有可选精灵。");
            return;
         }
         if(!facade.hasMediator("MiracleSelectElfMediator"))
         {
            facade.registerMediator(new MiracleSelectElfMediator(new MiracleSelectElfUI()));
         }
         sendNotification("miracle_update_com_elf_list",rarityElfVec,elfRarity);
         sendNotification("switch_win",miracleUI,"load_miracle_select_com_elf");
         miracleUI.spr_miracle.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["miracle_update_add_elf_btn","miracle_add_elf_unit_touch_complete","miracle_exchange_complete","miracle_update_elfvec","miracle_firemc_complete","miracle_miraclemc_complete","miracle_com_list_close_complete"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            miracleUI.spr_miracle.removeFromParent(true);
         }
         if(MiracleMcUI.callBack)
         {
            MiracleMcUI.getInstances().disposeMiracleMc();
         }
         WinTweens.showCity();
         if(Facade.getInstance().hasMediator("MiracleSelectElfMediator"))
         {
            (Facade.getInstance().retrieveMediator("MiracleSelectElfMediator") as MiracleSelectElfMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("ElfDetailInfoMedia"))
         {
            (Facade.getInstance().retrieveMediator("ElfDetailInfoMedia") as ElfDetailInfoMedia).dispose();
         }
         destoryImg();
         ElfFrontImageManager.getInstance().dispose();
         removeElf(false);
         miracleElfVec = Vector.<ElfVO>([]);
         miracleElfVec = null;
         facade.removeMediator("MiracleMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.miracleAssets);
      }
   }
}
