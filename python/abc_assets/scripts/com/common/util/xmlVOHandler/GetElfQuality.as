package com.common.util.xmlVOHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class GetElfQuality
   {
       
      public function GetElfQuality()
      {
         super();
      }
      
      public static function getUpQualityPropId(param1:String, param2:int) : Array
      {
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc6_:* = 0;
         LogUtil("计算突破该阶段需要的道具==",param1);
         if(param1 > 20000)
         {
            if(param2 > 13)
            {
               return null;
            }
            _loc7_ = LoadOtherAssetsManager.getInstance().assets.getXml("sta_mega");
            var _loc11_:* = 0;
            var _loc10_:* = _loc7_.sta_mega;
            for each(var _loc5_ in _loc7_.sta_mega)
            {
               if(_loc5_.@id == param1)
               {
                  _loc8_ = [];
                  _loc9_ = _loc5_["order" + param2].split("|");
                  _loc6_ = 0;
                  while(_loc6_ < _loc9_.length)
                  {
                     _loc8_.push(_loc9_[_loc6_].split(","));
                     _loc6_++;
                  }
                  return _loc8_;
               }
            }
            return null;
         }
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_pokeQuality");
         var _loc13_:* = 0;
         var _loc12_:* = _loc3_.sta_pokeQuality;
         for each(var _loc4_ in _loc3_.sta_pokeQuality)
         {
            if(_loc4_.@id == param1)
            {
               switch(param2 - 1)
               {
                  case 0:
                     return strToArr(_loc4_.@green);
                  case 1:
                     return strToArr(_loc4_.@green1);
                  case 2:
                     return strToArr(_loc4_.@green2);
                  case 3:
                     return strToArr(_loc4_.@blue);
                  case 4:
                     return strToArr(_loc4_.@blue1);
                  case 5:
                     return strToArr(_loc4_.@blue2);
                  case 6:
                     return strToArr(_loc4_.@purple);
                  case 7:
                     return strToArr(_loc4_.@purple1);
                  case 8:
                     return strToArr(_loc4_.@purple2);
                  case 9:
                     return strToArr(_loc4_.@orange);
                  case 10:
                     return strToArr(_loc4_.@orange1);
                  case 11:
                     return strToArr(_loc4_.@orange2);
                  case 12:
                     return strToArr(_loc4_.@orange3);
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
         return null;
      }
      
      public static function getUpQualityInfo(param1:ElfVO) : Array
      {
         var _loc6_:* = null;
         var _loc2_:Array = [];
         if(param1.elfId > 20000)
         {
            _loc6_ = LoadOtherAssetsManager.getInstance().assets.getXml("sta_megaConsumption");
            var _loc8_:* = 0;
            var _loc7_:* = _loc6_.sta_megaConsumption;
            for each(var _loc5_ in _loc6_.sta_megaConsumption)
            {
               if(_loc5_.@id == param1.brokenLv + 1)
               {
                  _loc2_.push(_loc5_.@pokeLv,_loc5_.@gold);
                  break;
               }
            }
            return _loc2_;
         }
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_qualityInfo");
         var _loc10_:* = 0;
         var _loc9_:* = _loc3_.sta_qualityInfo;
         for each(var _loc4_ in _loc3_.sta_qualityInfo)
         {
            if(_loc4_.@id == param1.brokenLv + 1)
            {
               _loc2_.push(_loc4_.@lv,_loc4_.@cost);
               break;
            }
         }
         return _loc2_;
      }
      
      public static function getElfLv(param1:int) : int
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_qualityInfo");
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_qualityInfo;
         for each(var _loc3_ in _loc2_.sta_qualityInfo)
         {
            if(_loc3_.@id == param1)
            {
               return _loc3_.@lv;
            }
         }
         return null;
      }
      
      public static function getElfBreakLv(param1:int) : int
      {
         var _loc3_:* = 0;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_qualityInfo");
         var _loc6_:* = 0;
         var _loc5_:* = _loc2_.sta_qualityInfo;
         for each(var _loc4_ in _loc2_.sta_qualityInfo)
         {
            if(_loc4_.@id == 0)
            {
               _loc3_ = 10;
            }
            else
            {
               _loc3_ = 5;
            }
            if(_loc4_.@lv <= param1 && param1 < _loc4_.@lv + _loc3_)
            {
               LogUtil(_loc3_,"突破等级为===========",_loc4_.@id);
               return _loc4_.@id;
            }
            if(param1 >= 70)
            {
               return 13;
            }
         }
         return null;
      }
      
      public static function strToArr(param1:String) : Array
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(param1 == "")
         {
            return null;
         }
         _loc4_ = [];
         _loc2_ = param1.split("|");
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_.push([_loc2_[_loc3_],1]);
            _loc3_++;
         }
         _loc2_ = null;
         return _loc4_;
      }
      
      public static function maxBreakLv(param1:String) : int
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         LogUtil("计算该精灵的id====",param1);
         while(_loc2_ == null && _loc3_ < 13)
         {
            _loc3_++;
            _loc2_ = getUpQualityPropId(param1,_loc3_);
         }
         LogUtil("计算该精灵的最大突破阶段=",_loc3_);
         if(_loc2_ == null)
         {
            _loc4_ = GetElfFactor.getElfVO(param1).evoFrom;
            _loc3_ = 1;
            _loc2_ = getUpQualityPropId(_loc4_,_loc3_);
            while(_loc2_ != null)
            {
               _loc3_++;
               _loc2_ = getUpQualityPropId(_loc4_,_loc3_);
            }
         }
         LogUtil("计算该精灵的最大突破阶段=",_loc3_);
         return _loc3_ - 1;
      }
      
      public static function GetelfMaxLv(param1:ElfVO) : int
      {
         var _loc2_:int = GetLvExp.elfGradepv[PlayerVO.lv - 1];
         LogUtil(param1.name,"精灵最大等级=================",_loc2_);
         return _loc2_;
      }
      
      public static function alterElfProperty(param1:ElfVO, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         LogUtil("修改野外精灵技能等级=============",param1.name,Math.round(PlayerVO.lv * 0.25));
         _loc3_ = 0;
         while(_loc3_ < param1.currentSkillVec.length)
         {
            param1.currentSkillVec[_loc3_].lv = Math.round(PlayerVO.lv * 0.25);
            _loc3_++;
         }
         param1.brokenLv = getElfBreakLv(param1.lv);
         if(param2)
         {
            if(param1.lv > 0 && param1.lv <= 30)
            {
               param1.starts = param1.starts + 1 > 5?5:param1.starts + 1;
            }
            else if(param1.lv > 30 && param1.lv <= 60)
            {
               param1.starts = param1.starts + 2 > 5?5:param1.starts + 2;
            }
            else
            {
               param1.starts = param1.starts + 3 > 5?5:param1.starts + 3;
            }
         }
      }
      
      public static function allBreakData(param1:ElfVO) : Array
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc9_:* = null;
         var _loc4_:* = null;
         var _loc7_:Array = [];
         LogUtil("第一步：计算这只精灵的所有形态",param1.name);
         var _loc8_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         if(param1.elfId < 20000)
         {
            if(param1.evolveId != "0" && param1.evolveId < 20000)
            {
               if(param1.evoFrom != "0")
               {
                  LogUtil("这个是成长期的精灵……有3种形态……",param1.name);
                  _loc8_.push(GetElfFactor.getElfVO(param1.evoFrom),param1,GetElfFactor.getElfVO(param1.evolveId));
               }
               else
               {
                  LogUtil("这个是幼生期的精灵=",param1.name);
                  _loc3_ = GetElfFactor.getElfVO(param1.evolveId,false);
                  if(_loc3_.evolveId != "0")
                  {
                     _loc8_.push(param1,_loc3_,GetElfFactor.getElfVO(_loc3_.evolveId));
                     LogUtil("有3种形态……",param1.name,_loc3_.name,_loc8_[2].name);
                  }
                  else
                  {
                     _loc8_.push(param1,_loc3_);
                     LogUtil("有2种形态……",param1.name,_loc3_.name);
                  }
               }
            }
            else
            {
               LogUtil("这个是完全体的精灵=",param1.name,"…………望上一级找找看");
               if(param1.evoFrom != "0")
               {
                  _loc2_ = GetElfFactor.getElfVO(param1.evoFrom,false);
                  if(_loc2_.evoFrom != "0")
                  {
                     _loc8_.push(GetElfFactor.getElfVO(_loc2_.evoFrom),_loc2_,param1);
                     LogUtil("有幼生期的……3种形态……",_loc8_[0].name,_loc2_.name,param1.name);
                  }
                  else
                  {
                     LogUtil("有成长期的……2种形态……",_loc2_.name,param1.name);
                     _loc8_.push(_loc2_,param1);
                  }
               }
               else
               {
                  _loc8_.push(param1);
                  LogUtil("只有完全体的……1种形态……",param1.name);
               }
            }
         }
         else
         {
            LogUtil("mage精灵……1种形态……",param1.name);
            _loc8_.push(param1);
         }
         LogUtil("第二步，计算这些精灵的突破阶段");
         _loc5_ = 0;
         while(_loc5_ < _loc8_.length)
         {
            _loc6_ = 1;
            while(_loc6_ < 14)
            {
               _loc9_ = GetElfQuality.getUpQualityPropId(_loc8_[_loc5_].elfId,_loc6_);
               if(_loc9_)
               {
                  _loc4_ = {};
                  _loc4_.elfName = _loc8_[_loc5_].name;
                  _loc4_.propArr = _loc9_;
                  _loc7_.push(_loc4_);
               }
               _loc6_++;
            }
            _loc5_++;
         }
         _loc8_ = Vector.<ElfVO>([]);
         LogUtil("最后结果出来啦……………………",JSON.stringify(_loc7_));
         return _loc7_;
      }
   }
}
