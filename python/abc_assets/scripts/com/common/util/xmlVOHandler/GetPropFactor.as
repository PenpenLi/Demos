package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.mediator.mainCity.hunting.HuntingMediator;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.models.vos.elf.ElfVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   
   public class GetPropFactor
   {
      
      public static var evoStonePlaceArr:Array = [];
      
      public static var hagberryVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var carryVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var pvpPropVecArr:Array = [];
      
      public static var allPropStaticVec:Object;
      
      private static var _isDiamondBug:Boolean;
       
      public function GetPropFactor()
      {
         super();
      }
      
      public static function getAllPropVO() : void
      {
         var _loc1_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_prop");
         allPropStaticVec = {};
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_prop;
         for each(var _loc3_ in _loc2_.sta_prop)
         {
            _loc1_ = new PropVO();
            staticValue(_loc1_,_loc3_);
            allPropStaticVec[_loc1_.id] = _loc1_;
         }
         LoadOtherAssetsManager.getInstance().removeAsset(["sta_prop"],false,true);
      }
      
      public static function getPropVO(param1:int) : PropVO
      {
         var _loc2_:PropVO = new PropVO();
         _loc2_.id = param1;
         _loc2_.name = allPropStaticVec[param1].name;
         _loc2_.imgName = allPropStaticVec[param1].imgName;
         _loc2_.type = allPropStaticVec[param1].type;
         _loc2_.describe = allPropStaticVec[param1].describe;
         _loc2_.validNature = allPropStaticVec[param1].validNature;
         _loc2_.effectValue = allPropStaticVec[param1].effectValue;
         _loc2_.relieveState = allPropStaticVec[param1].relieveState;
         _loc2_.replyType = allPropStaticVec[param1].replyType;
         _loc2_.skillId = allPropStaticVec[param1].skillId;
         _loc2_.elfNature = allPropStaticVec[param1].elfNature;
         _loc2_.actRole = allPropStaticVec[param1].actRole;
         _loc2_.isCarry = allPropStaticVec[param1].isCarry;
         _loc2_.price = allPropStaticVec[param1].price;
         _loc2_.isSale = allPropStaticVec[param1].isSale;
         _loc2_.diamond = allPropStaticVec[param1].diamond;
         _loc2_.composeMoney = allPropStaticVec[param1].composeMoney;
         _loc2_.composeId = allPropStaticVec[param1].composeId;
         _loc2_.composeNum = allPropStaticVec[param1].composeNum;
         _loc2_.quality = allPropStaticVec[param1].quality;
         _loc2_.compNeedPropId = allPropStaticVec[param1].compNeedPropId;
         _loc2_.validElf = allPropStaticVec[param1].validElf;
         _loc2_.vipLimitBuyInfoArr = allPropStaticVec[param1].vipLimitBuyInfoArr;
         _loc2_.exclusiveElf = allPropStaticVec[param1].exclusiveElf;
         _loc2_.effectForAblility = allPropStaticVec[param1].effectForAblility;
         _loc2_.previewLimit = allPropStaticVec[param1].previewLimit;
         return _loc2_;
      }
      
      public static function initShopList() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = allPropStaticVec;
         for each(var _loc1_ in allPropStaticVec)
         {
            if(_loc1_.isSale == 1 || _loc1_.isSale == 4)
            {
               if(_loc1_.price != 0 && _loc1_.diamond == 0)
               {
                  if(_loc1_.type == 2 || _loc1_.type == 3 || _loc1_.type == 16 || _loc1_.type == 17)
                  {
                     ShopPro.medicineVec.push(getPropVO(_loc1_.id));
                  }
                  else if(_loc1_.type == 5 || _loc1_.type == 20)
                  {
                     ShopPro.elfBallVec.push(getPropVO(_loc1_.id));
                  }
                  else
                  {
                     ShopPro.otherPropVec.push(getPropVO(_loc1_.id));
                  }
               }
            }
            if(_loc1_.diamond != 0)
            {
               if(_loc1_.id == 114000 || _loc1_.id == 115000 || _loc1_.id == 116000 || _loc1_.id == 117000 || _loc1_.id == 866 || _loc1_.id == 867)
               {
                  ShopPro.diamondPropVec.unshift(getPropVO(_loc1_.id));
               }
               else
               {
                  ShopPro.diamondPropVec.push(getPropVO(_loc1_.id));
               }
            }
         }
      }
      
      public static function staticValue(param1:PropVO, param2:XML) : void
      {
         var _loc4_:* = null;
         param1.id = param2.@id;
         param1.name = param2.@chineseName;
         param1.imgName = "img_" + param2.@picId;
         param1.type = param2.@type;
         param1.describe = param2.@descr;
         var _loc3_:String = param2.@pokeIds;
         GetPropFactor.getValidElf(param1,_loc3_);
         param1.validNature = param2.@serial;
         param1.effectValue = param2.@val;
         param1.relieveState = param2.@dealStatus;
         param1.replyType = param2.@recoverType;
         param1.skillId = param2.@skillId;
         param1.elfNature = param2.@upSerial;
         param1.actRole = param2.@actRole;
         param1.isCarry = param2.@isCarry;
         param1.price = param2.@price;
         param1.isSale = param2.@isSale;
         param1.diamond = param2.@diamond;
         param1.composeMoney = param2.@syntheticCost;
         param1.composeId = param2.@syntheticId;
         param1.composeNum = param2.@syntheticNum;
         param1.quality = param2.@quality;
         param1.compNeedPropId = param2.@combineNeed.split("|");
         param1.previewLimit = param2.@previewLimit;
         if(param2.@exclusiveElf != "")
         {
            param1.exclusiveElf = param2.@exclusiveElf.split(",");
         }
         if(param2.@effectForAblility != "")
         {
            param1.effectForAblility = param2.@effectForAblility.split("|");
         }
         if(param2.@vipBuy != "")
         {
            _loc4_ = param2.@vipBuy.split(",");
            param1.vipLimitBuyInfoArr = _loc4_;
         }
      }
      
      public static function getPropId(param1:String) : int
      {
         var _loc4_:* = 0;
         var _loc3_:* = allPropStaticVec;
         for each(var _loc2_ in allPropStaticVec)
         {
            if(_loc2_.validNature == param1 && _loc2_.id >= 10000)
            {
               LogUtil("propVo.id== ",_loc2_.id);
               return _loc2_.id;
            }
         }
         return null;
      }
      
      public static function getPropIndex(param1:PropVO) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:* = 0;
         if(param1.type == 2 || param1.type == 3 || param1.type == 16 || param1.type == 17)
         {
            _loc2_ = PlayerVO.medicineVec;
         }
         else if(param1.type == 5 || param1.type == 20)
         {
            _loc2_ = PlayerVO.elfBallVec;
         }
         else if(param1.type == 10 || param1.type == 11 || param1.type == 12 || param1.type == 13 || param1.type == 22 || param1.type == 26)
         {
            _loc2_ = PlayerVO.propBroken;
         }
         else if(param1.type == 24)
         {
            _loc2_ = PlayerVO.sandBagVec;
         }
         else if(param1.type == 4)
         {
            _loc2_ = PlayerVO.evolveStoneVec;
         }
         else if(param1.type == 18 || param1.type == 19)
         {
            _loc2_ = PlayerVO.dollVec;
         }
         else if(param1.type == 6)
         {
            _loc2_ = PlayerVO.learnMachineVec;
         }
         else
         {
            _loc2_ = PlayerVO.otherPropVec;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].id == param1.id)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function addOrLessProp(param1:PropVO, param2:Boolean = true, param3:int = 1, param4:Boolean = false) : void
      {
         _isDiamondBug = param4;
         if(param1.type == 2 || param1.type == 3 || param1.type == 16 || param1.type == 17)
         {
            propHandle(PlayerVO.medicineVec,param1,param3,param2);
         }
         else if(param1.type == 5 || param1.type == 20 || param1.type == 30)
         {
            propHandle(PlayerVO.elfBallVec,param1,param3,param2);
         }
         else if(param1.type == 10 || param1.type == 11 || param1.type == 12 || param1.type == 13 || param1.type == 22)
         {
            propHandle(PlayerVO.propBroken,param1,param3,param2);
         }
         else if(param1.type == 24)
         {
            propHandle(PlayerVO.sandBagVec,param1,param3,param2);
         }
         else if(param1.type == 4)
         {
            propHandle(PlayerVO.evolveStoneVec,param1,param3,param2);
         }
         else if(param1.type == 18 || param1.type == 19)
         {
            propHandle(PlayerVO.dollVec,param1,param3,param2);
         }
         else if(param1.type == 6)
         {
            propHandle(PlayerVO.learnMachineVec,param1,param3,param2);
         }
         else
         {
            propHandle(PlayerVO.otherPropVec,param1,param3,param2);
         }
      }
      
      private static function propHandle(param1:Vector.<PropVO>, param2:PropVO, param3:int, param4:Boolean) : void
      {
         var _loc5_:* = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].id == param2.id)
            {
               if(param4)
               {
                  if(!_isDiamondBug)
                  {
                     UmengExtension.getInstance().UMAnalysic("bonusProp|" + param2.id + "|" + param3 + "|0|1");
                  }
                  param1[_loc5_].count = param1[_loc5_].count + param3;
                  if(param2.type == 4)
                  {
                     getStoneEvolve();
                  }
                  if(param2.name == "扫荡券")
                  {
                     PlayerVO.raidsProp = param1[_loc5_];
                  }
                  if(param2.type == 25)
                  {
                     HuntingMediator.judgeSureHunting();
                  }
               }
               else
               {
                  UmengExtension.getInstance().UMAnalysic("use|" + param2.id + "|" + param3 + "|0");
                  param1[_loc5_].count = param1[_loc5_].count - param3;
                  if(param2.name == "扫荡券")
                  {
                     PlayerVO.raidsProp = param1[_loc5_];
                  }
                  if(param1[_loc5_].count == 0)
                  {
                     if(param2.type == 25)
                     {
                        PlayerVO.huntingPropVec.splice(PlayerVO.huntingPropVec.indexOf(param1[_loc5_]),1);
                     }
                     if(param2.type == 26)
                     {
                        PlayerVO.bugleChipVec.splice(PlayerVO.bugleChipVec.indexOf(param1[_loc5_]),1);
                     }
                     if(param2.type == 14)
                     {
                        PlayerVO.trashyPropVec.splice(PlayerVO.trashyPropVec.indexOf(param1[_loc5_]),1);
                     }
                     sellPropHandle(param1[_loc5_],false);
                     param1.splice(param1.indexOf(param1[_loc5_]),1);
                     LogUtil("删除道具==============",param2.id,param2.name);
                  }
               }
               return;
            }
            _loc5_++;
         }
         if(!_isDiamondBug)
         {
            UmengExtension.getInstance().UMAnalysic("bonusProp|" + param2.id + "|" + param3 + "|0|1");
         }
         param2.count = param2.count + param3;
         LogUtil("添加新的道具==============",param2.id,param2.name);
         param1.push(param2);
         idSort(param1);
         sellPropHandle(param2,true);
         if(param2.name == "扫荡券")
         {
            PlayerVO.raidsProp = param2;
         }
         if(param2.type == 25)
         {
            PlayerVO.huntingPropVec.push(param2);
            HuntingMediator.judgeSureHunting();
         }
         if(param2.type == 26)
         {
            PlayerVO.bugleChipVec.push(param2);
         }
         if(param2.type == 14)
         {
            PlayerVO.trashyPropVec.push(param2);
         }
      }
      
      private static function sellPropHandle(param1:PropVO, param2:Boolean) : void
      {
         var _loc3_:* = 0;
         if(param1.isSale == 1 || param1.isSale == 2)
         {
            if(param2)
            {
               BackPackPro.salePropVec.push(param1);
               GetPropFactor.idSort(BackPackPro.salePropVec);
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < BackPackPro.salePropVec.length)
               {
                  if(BackPackPro.salePropVec[_loc3_].id == param1.id)
                  {
                     BackPackPro.salePropVec.splice(_loc3_,1);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public static function idSort(param1:Vector.<PropVO>) : Vector.<PropVO>
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].type > param1[_loc4_ + 1].type)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function getStoneEvolve() : void
      {
         var _loc1_:* = 0;
         LogUtil("进入精灵检查");
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               if(PlayerVO.bagElfVec[_loc1_].evoStoneArr.length != 0 && PlayerVO.bagElfVec[_loc1_].lv >= PlayerVO.bagElfVec[_loc1_].evoLv && PlayerVO.bagElfVec[_loc1_].evoLv != -1 && PlayerVO.bagElfVec[_loc1_].currentHp > 0)
               {
                  elfStone(PlayerVO.bagElfVec[_loc1_]);
               }
            }
            _loc1_++;
         }
      }
      
      private static function elfStone(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         LogUtil("进入精灵进需要的进化石检查",param1.name);
         _loc2_ = 0;
         while(_loc2_ < param1.evoStoneArr.length)
         {
            _loc4_ = 0;
            while(_loc4_ < PlayerVO.evolveStoneVec.length)
            {
               if(param1.evoStoneArr[_loc2_][0] == PlayerVO.evolveStoneVec[_loc4_].id)
               {
                  if(PlayerVO.evolveStoneVec[_loc4_].count >= param1.evoStoneArr[_loc2_][1])
                  {
                     _loc3_++;
                  }
               }
               _loc4_++;
            }
            _loc2_++;
         }
         LogUtil("检查完毕----",param1.id,_loc3_,param1.isPromptEvolve);
         if(param1.evoStoneArr.length == _loc3_ && param1.isPromptEvolve)
         {
            param1.isPromptEvolve = false;
            Alert.show("【" + param1.nickName + "】已达到进化条件，可以去进化了","",new ListCollection([{"label":"知道了"}]));
         }
      }
      
      public static function getEvolveStomID() : Array
      {
         return [131,132,133,134,137,138,139,140,141,142,143,144,145,146,147];
      }
      
      public static function updateStonePlaceByRefresh(param1:Array) : void
      {
         var _loc4_:* = false;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = true;
            _loc3_ = 0;
            while(_loc3_ < evoStonePlaceArr.length)
            {
               if(param1[_loc2_].rcdId == evoStonePlaceArr[_loc3_].rcdId)
               {
                  evoStonePlaceArr[_loc3_].times = param1[_loc2_].times;
                  _loc4_ = false;
                  break;
               }
               _loc3_++;
            }
            if(_loc4_)
            {
               evoStonePlaceArr.push({
                  "rcdId":param1[_loc2_].rcdId,
                  "times":param1[_loc2_].times
               });
               LogUtil("新加入的进化石节点记录： " + param1[_loc2_].rcdId);
            }
            _loc2_++;
         }
      }
      
      public static function updateStonePlaceAfterAdventure(param1:int) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < evoStonePlaceArr.length)
         {
            if(param1 == evoStonePlaceArr[_loc2_].rcdId)
            {
               if(evoStonePlaceArr[_loc2_].times == 0)
               {
                  return;
               }
               §§dup(evoStonePlaceArr[_loc2_]).times--;
               break;
            }
            _loc2_++;
         }
      }
      
      public static function getProp(param1:int) : PropVO
      {
         var _loc2_:* = undefined;
         var _loc4_:* = 0;
         var _loc3_:PropVO = getPropVO(param1);
         if(_loc3_.type == 2 || _loc3_.type == 3 || _loc3_.type == 16 || _loc3_.type == 17)
         {
            _loc2_ = PlayerVO.medicineVec;
         }
         else if(_loc3_.type == 5 || _loc3_.type == 20)
         {
            _loc2_ = PlayerVO.elfBallVec;
         }
         else if(_loc3_.type == 10 || _loc3_.type == 11 || _loc3_.type == 12 || _loc3_.type == 13 || _loc3_.type == 22)
         {
            _loc2_ = PlayerVO.propBroken;
         }
         else if(_loc3_.type == 24)
         {
            _loc2_ = PlayerVO.sandBagVec;
         }
         else if(_loc3_.type == 4)
         {
            _loc2_ = PlayerVO.evolveStoneVec;
         }
         else if(_loc3_.type == 18 || _loc3_.type == 19)
         {
            _loc2_ = PlayerVO.dollVec;
         }
         else if(_loc3_.type == 6)
         {
            _loc2_ = PlayerVO.learnMachineVec;
         }
         else
         {
            _loc2_ = PlayerVO.otherPropVec;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].id == _loc3_.id)
            {
               LogUtil("已有道具：" + _loc2_[_loc4_].name + "数量" + _loc2_[_loc4_].count);
               return _loc2_[_loc4_];
            }
            _loc4_++;
         }
         _loc2_ = null;
         return null;
      }
      
      public static function getBrokenPropByComposeID(param1:int) : PropVO
      {
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc4_:* = allPropStaticVec;
         for each(var _loc3_ in allPropStaticVec)
         {
            if(_loc3_.composeId == param1)
            {
               _loc2_ = getPropVO(_loc3_.id);
               break;
            }
         }
         return _loc2_;
      }
      
      public static function getValidElf(param1:Object, param2:String) : void
      {
         if(param2 == "all")
         {
            var _loc5_:* = 0;
            var _loc4_:* = GetElfFactor.allElfStaticObj;
            for each(var _loc3_ in GetElfFactor.allElfStaticObj)
            {
               param1.validElf.push(_loc3_.elfId);
            }
         }
         else
         {
            param1.validElf = param2.split("|");
         }
      }
      
      public static function getHagberry() : Boolean
      {
         var _loc1_:* = false;
         var _loc2_:* = 0;
         hagberryVec = new Vector.<PropVO>([]);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.medicineVec.length)
         {
            if(PlayerVO.medicineVec[_loc2_].type == 16 || PlayerVO.medicineVec[_loc2_].type == 17)
            {
               hagberryVec.push(PlayerVO.medicineVec[_loc2_]);
               _loc1_ = true;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getCarry() : Boolean
      {
         var _loc1_:* = false;
         var _loc2_:* = 0;
         carryVec = new Vector.<PropVO>([]);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.otherPropVec.length)
         {
            if(PlayerVO.otherPropVec[_loc2_].type == 1 || PlayerVO.otherPropVec[_loc2_].type == 23)
            {
               carryVec.push(PlayerVO.otherPropVec[_loc2_]);
               _loc1_ = true;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getPVPPropVecArr() : void
      {
         getHagberry();
         getCarry();
         pvpPropVecArr = [];
         pvpPropVecArr.push(carryVec,hagberryVec);
      }
      
      public static function getBugleToCompound() : Vector.<PropVO>
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc1_:Vector.<PropVO> = new Vector.<PropVO>([]);
         var _loc2_:Array = [];
         var _loc4_:int = PlayerVO.bugleChipVec.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc2_.indexOf(PlayerVO.bugleChipVec[_loc5_].composeId) == -1)
            {
               _loc2_.push(PlayerVO.bugleChipVec[_loc5_].composeId);
               _loc3_ = GetPropFactor.getPropVO(PlayerVO.bugleChipVec[_loc5_].composeId);
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         _loc2_ = null;
         return _loc1_;
      }
      
      public static function getHuntPartProp() : void
      {
         var _loc1_:* = 0;
         HuntPartyVO.bagVec = Vector.<PropVO>([]);
         _loc1_ = 0;
         while(_loc1_ < BackPackMedia.huntPropArr.length)
         {
            if(GetPropFactor.getProp(BackPackMedia.huntPropArr[_loc1_]))
            {
               HuntPartyVO.bagVec.push(GetPropFactor.getProp(BackPackMedia.huntPropArr[_loc1_]));
            }
            _loc1_++;
         }
      }
   }
}
