package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import com.mvc.models.vos.mapSelect.MapVO;
   import com.common.managers.LoadOtherAssetsManager;
   import flash.utils.getTimer;
   import com.mvc.models.vos.mapSelect.ExtenMapVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   
   public class GetMapFactor
   {
      
      public static var mainIdVec:Array;
      
      public static var ExtendVec:Array;
      
      public static var crossPiont:int;
      
      public static var isOrigin:int;
      
      public static var allPropBirthPllace:Object;
      
      public static var allElfBirthPllace:Object;
      
      public static var normalMapVec:Vector.<MainMapVO>;
      
      public static var hardMapVec:Vector.<MainMapVO>;
       
      public function GetMapFactor()
      {
         super();
      }
      
      public static function get() : void
      {
      }
      
      public static function getMapVoById(param1:int) : MapVO
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_bigNode");
         var _loc8_:* = 0;
         var _loc7_:* = _loc2_.sta_bigNode;
         for each(var _loc4_ in _loc2_.sta_bigNode)
         {
            if(_loc4_.@id == param1)
            {
               _loc3_ = new MapVO();
               _loc3_.id = _loc4_.@id;
               _loc3_.name = _loc4_.@name;
               _loc3_.bgImg = _loc4_.@bgImg;
               _loc3_.frameImg = _loc4_.@frameImg;
               _loc3_.firstBox = _loc4_.@firstBox;
               _loc3_.secondBox = _loc4_.@secondBox;
               _loc3_.thirdBox = _loc4_.@thirdBox;
               _loc5_ = _loc4_.@nodeListJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               LogUtil(_loc3_.name + "城市地图节点 = " + _loc5_);
               _loc6_ = JSON.parse(_loc5_).lst;
               isHasExten(_loc6_);
               if(isOrigin != -1)
               {
                  getMainIdVec(_loc6_);
               }
               _loc3_.badgeId = _loc4_.@badgeId;
               break;
            }
         }
         return _loc3_;
      }
      
      public static function getCityNameById(param1:int) : String
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_bigNode");
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_bigNode;
         for each(var _loc3_ in _loc2_.sta_bigNode)
         {
            if(_loc3_.@id == param1)
            {
               return _loc3_.@name;
            }
         }
         return null;
      }
      
      public static function getMainMapNameVoByID(param1:int) : String
      {
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_smallNode");
         var _loc5_:* = 0;
         var _loc4_:* = _loc3_.sta_smallNode;
         for each(var _loc2_ in _loc3_.sta_smallNode)
         {
            if(_loc2_.@id == param1)
            {
               return _loc2_.@name;
            }
         }
         return null;
      }
      
      public static function getNodeIdChilds(param1:int) : int
      {
         var _loc3_:* = 0;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_nodeRcd");
         var _loc6_:* = 0;
         var _loc5_:* = _loc2_.sta_nodeRcd;
         for each(var _loc4_ in _loc2_.sta_nodeRcd)
         {
            if(_loc4_.@nodeId == param1)
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      public static function getMainMapVoByID(param1:int, param2:Boolean = false) : Vector.<MainMapVO>
      {
         var _loc4_:* = null;
         var _loc14_:* = 0;
         var _loc8_:* = 0;
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         var _loc5_:* = null;
         var _loc11_:* = null;
         var _loc12_:* = null;
         LogUtil("通过id获取主线地图相关信息数组==============");
         var _loc10_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_smallNode");
         var _loc16_:* = 0;
         var _loc15_:* = _loc10_.sta_smallNode;
         for each(var _loc9_ in _loc10_.sta_smallNode)
         {
            if(_loc9_.@id == param1)
            {
               if(_loc9_.@openCondJNS != "")
               {
                  _loc4_ = _loc9_.@openCondJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc5_ = JSON.parse(_loc4_);
                  if(_loc5_.eventType == 1)
                  {
                     _loc14_ = _loc5_.skillId;
                  }
                  else if(_loc5_.eventType == 3)
                  {
                     _loc8_ = _loc5_.plyLv;
                  }
                  else
                  {
                     _loc7_ = _loc5_.bageNum;
                  }
               }
               _loc3_ = _loc9_.@endNode;
               break;
            }
         }
         normalMapVec = new Vector.<MainMapVO>([]);
         hardMapVec = new Vector.<MainMapVO>([]);
         var _loc6_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_nodeRcd");
         var _loc18_:* = 0;
         var _loc17_:* = _loc6_.sta_nodeRcd;
         for each(var _loc13_ in _loc6_.sta_nodeRcd)
         {
            if(_loc13_.@nodeId == param1)
            {
               _loc11_ = new MainMapVO();
               _loc11_.id = _loc13_.@id;
               _loc11_.nodeId = _loc13_.@nodeId;
               _loc11_.descs = _loc13_.@descs;
               _loc11_.name = _loc13_.@nodeName;
               _loc11_.picName = _loc13_.@picName;
               _loc11_.npcName = _loc13_.@trainerName;
               if(_loc13_.@pokeList != "")
               {
                  _loc11_.pokeList = _loc13_.@pokeList.split("|");
               }
               if(_loc13_.@dropJNS != "")
               {
                  _loc4_ = _loc13_.@dropJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc11_.propList = JSON.parse(_loc4_).drop;
               }
               _loc11_.sayAfter = _loc13_.@sayAfter;
               _loc11_.sayBefore = _loc13_.@sayBefore;
               _loc11_.needPower = _loc13_.@actForce;
               _loc11_.getExp = _loc13_.@exp;
               _loc11_.rewardMoney = _loc13_.@money;
               _loc11_.type = _loc13_.@type;
               _loc11_.sceneName = _loc13_.@fightBG;
               _loc11_.isClub = _loc13_.@badge;
               _loc11_.needSkillId = _loc14_;
               _loc11_.needOpenLv = _loc8_;
               _loc11_.needBadge = _loc7_;
               _loc11_.isEndPoint = _loc3_;
               normalMapVec.push(_loc11_);
               _loc12_ = new MainMapVO();
               _loc12_.id = _loc13_.@id;
               _loc12_.nodeId = _loc13_.@nodeId;
               _loc12_.descs = _loc13_.@descs;
               _loc12_.name = _loc13_.@nodeName;
               _loc12_.picName = _loc13_.@picName;
               _loc12_.npcName = _loc13_.@trainerName;
               _loc12_.sayAfter = _loc13_.@sayAfter;
               _loc12_.sayBefore = _loc13_.@sayBefore;
               _loc12_.type = _loc13_.@type;
               _loc12_.sceneName = _loc13_.@fightBG;
               _loc12_.isClub = _loc13_.@badge;
               _loc12_.needSkillId = _loc14_;
               _loc12_.needBadge = _loc7_;
               _loc12_.isEndPoint = _loc3_;
               _loc12_.isHard = true;
               if(_loc13_.@hardPokelist != "")
               {
                  _loc12_.pokeList = _loc13_.@hardPokelist.split("|");
               }
               if(_loc13_.@hardDropJNS != "")
               {
                  _loc4_ = _loc13_.@hardDropJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc12_.propList = JSON.parse(_loc4_).drop;
               }
               _loc12_.needPower = _loc13_.@hardActforce;
               _loc12_.getExp = _loc13_.@hardExp;
               _loc12_.rewardMoney = _loc13_.@hardMoney;
               _loc12_.maxTime = 3;
               hardMapVec.push(_loc12_);
            }
         }
         if(param2)
         {
            return hardMapVec;
         }
         return normalMapVec;
      }
      
      public static function getRecIdArr(param1:int) : Vector.<MainMapVO>
      {
         var _loc5_:* = null;
         var _loc3_:Vector.<MainMapVO> = new Vector.<MainMapVO>([]);
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_nodeRcd");
         var _loc7_:* = 0;
         var _loc6_:* = _loc2_.sta_nodeRcd;
         for each(var _loc4_ in _loc2_.sta_nodeRcd)
         {
            if(_loc4_.@nodeId == param1)
            {
               _loc5_ = new MainMapVO();
               _loc5_.descs = _loc4_.@descs;
               _loc5_.name = _loc4_.@nodeName;
               _loc5_.picName = _loc4_.@picName;
               _loc5_.id = _loc4_.@id;
               _loc3_.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      public static function getElfBirthplace() : void
      {
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc9_:* = 0;
         var _loc8_:* = null;
         var _loc10_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         LogUtil("获取所有精灵的分布数据，键值就是精灵的静态id");
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_rawPokeNode");
         allElfBirthPllace = {};
         var _loc11_:Number = getTimer();
         var _loc13_:* = 0;
         var _loc12_:* = _loc1_.sta_rawPokeNode;
         for each(var _loc7_ in _loc1_.sta_rawPokeNode)
         {
            if(_loc7_.@pokeListJNS != "")
            {
               _loc6_ = _loc7_.@pokeListJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               _loc2_ = JSON.parse(_loc6_).metRcd;
               _loc9_ = 0;
               while(_loc9_ < _loc2_.length)
               {
                  _loc8_ = _loc2_[_loc9_].pokes;
                  _loc10_ = 0;
                  while(_loc10_ < _loc8_.length)
                  {
                     if(allElfBirthPllace.propertyIsEnumerable(_loc8_[_loc10_].staId))
                     {
                        allElfBirthPllace[_loc8_[_loc10_].staId].elfBirthNodeIdArr.push(_loc7_.@id);
                        allElfBirthPllace[_loc8_[_loc10_].staId].elfBirthArr.push(_loc7_.@cName);
                     }
                     else
                     {
                        _loc3_ = [];
                        _loc5_ = [];
                        _loc4_ = {};
                        _loc3_.push(_loc7_.@cName);
                        _loc5_.push(_loc7_.@id);
                        _loc4_["elfBirthArr"] = _loc3_;
                        _loc4_["elfBirthNodeIdArr"] = _loc5_;
                        allElfBirthPllace[_loc8_[_loc10_].staId] = _loc4_;
                     }
                     _loc10_++;
                  }
                  _loc9_++;
               }
               continue;
            }
         }
      }
      
      public static function getPropBirthplace() : void
      {
         var _loc5_:* = null;
         var _loc1_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc11_:* = null;
         var _loc9_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc8_:* = 0;
         var _loc15_:* = 0;
         var _loc13_:* = null;
         var _loc14_:* = null;
         var _loc4_:* = null;
         LogUtil("获取所有可掉落的道具分布数据，键值就是道具的静态id");
         var _loc10_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_nodeRcd");
         allPropBirthPllace = {};
         var _loc17_:* = 0;
         var _loc16_:* = _loc10_.sta_nodeRcd;
         for each(var _loc12_ in _loc10_.sta_nodeRcd)
         {
            if(_loc12_.@dropJNS != "")
            {
               _loc5_ = _loc12_.@dropJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               _loc1_ = JSON.parse(_loc5_).drop;
               _loc6_ = 0;
               while(_loc6_ < _loc1_.length)
               {
                  _loc7_ = _loc1_[_loc6_].pId;
                  if(allPropBirthPllace.propertyIsEnumerable(_loc7_))
                  {
                     _loc11_ = {};
                     _loc11_.rcdId = _loc12_.@id;
                     _loc11_.nodeId = _loc12_.@nodeId;
                     _loc11_.isHard = false;
                     allPropBirthPllace[_loc7_].push(_loc11_);
                  }
                  else
                  {
                     _loc9_ = [];
                     _loc3_ = {};
                     _loc3_.rcdId = _loc12_.@id;
                     _loc3_.nodeId = _loc12_.@nodeId;
                     _loc3_.isHard = false;
                     _loc9_.push(_loc3_);
                     allPropBirthPllace[_loc7_] = _loc9_;
                  }
                  _loc6_++;
               }
            }
            if(_loc12_.@hardDropJNS != "")
            {
               _loc5_ = _loc12_.@hardDropJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               _loc2_ = JSON.parse(_loc5_).drop;
               _loc8_ = 0;
               while(_loc8_ < _loc2_.length)
               {
                  _loc15_ = _loc2_[_loc8_].pId;
                  if(allPropBirthPllace.propertyIsEnumerable(_loc15_))
                  {
                     _loc13_ = {};
                     _loc13_.rcdId = _loc12_.@id;
                     _loc13_.nodeId = _loc12_.@nodeId;
                     _loc13_.isHard = true;
                     allPropBirthPllace[_loc15_].push(_loc13_);
                  }
                  else
                  {
                     _loc14_ = [];
                     _loc4_ = {};
                     _loc4_.rcdId = _loc12_.@id;
                     _loc4_.nodeId = _loc12_.@nodeId;
                     _loc4_.isHard = true;
                     _loc14_.push(_loc4_);
                     allPropBirthPllace[_loc15_] = _loc14_;
                  }
                  _loc8_++;
               }
               continue;
            }
         }
      }
      
      public static function getNodeIdByRcdId(param1:int) : int
      {
         var _loc3_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_nodeRcd");
         var _loc6_:* = 0;
         var _loc5_:* = _loc2_.sta_nodeRcd;
         for each(var _loc4_ in _loc2_.sta_nodeRcd)
         {
            if(_loc4_.@id == param1)
            {
               return _loc4_.@nodeId;
            }
         }
         return 0;
      }
      
      public static function getExtenMapVoByID(param1:int) : ExtenMapVO
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_rawPokeNode");
         var _loc8_:* = 0;
         var _loc7_:* = _loc2_.sta_rawPokeNode;
         for each(var _loc4_ in _loc2_.sta_rawPokeNode)
         {
            if(_loc4_.@id == param1)
            {
               _loc3_ = new ExtenMapVO();
               _loc3_.nodeId = _loc4_.@id;
               _loc3_.pointName = _loc4_.@cName;
               _loc3_.needPower = _loc4_.@actionForce;
               _loc5_ = _loc4_.@pokeListJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               _loc3_.elfArr = JSON.parse(_loc5_).metRcd;
               _loc3_.sceneName = _loc4_.@fightBG;
               if(_loc4_.@openCondJNS != "")
               {
                  _loc5_ = _loc4_.@openCondJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc6_ = JSON.parse(_loc5_);
                  if(_loc6_.eventType == 1)
                  {
                     _loc3_.needSkillId = _loc6_.skillId;
                  }
                  else
                  {
                     _loc3_.needBadge = _loc6_.bageNum;
                  }
               }
               break;
            }
         }
         return _loc3_;
      }
      
      public static function getExtenMapNameByID(param1:int) : String
      {
         var _loc3_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_rawPokeNode");
         var _loc6_:* = 0;
         var _loc5_:* = _loc2_.sta_rawPokeNode;
         for each(var _loc4_ in _loc2_.sta_rawPokeNode)
         {
            if(_loc4_.@id == param1)
            {
               return _loc4_.@cName;
            }
         }
         return null;
      }
      
      public static function getExtenMapIcon(param1:int) : String
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_rawPokeNode");
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_rawPokeNode;
         for each(var _loc3_ in _loc2_.sta_rawPokeNode)
         {
            if(_loc3_.@id == param1)
            {
               return _loc3_.@icon;
            }
         }
         return null;
      }
      
      private static function getMainIdVec(param1:Array) : void
      {
         var _loc2_:* = 0;
         mainIdVec = [];
         ExtendVec = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            mainIdVec.push(param1[_loc2_]);
            if(isOrigin == 1)
            {
               ExtendVec.push(param1[_loc2_]);
            }
            if(param1[_loc2_].sNodeId == crossPiont)
            {
               mainIdVec.push(param1[_loc2_ + 1]);
               ExtendVec.push(param1[_loc2_ + 2]);
               supplyIdVec(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private static function supplyIdVec(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(mainIdVec.length > 0)
            {
               if(param1[_loc2_].farNodeId == mainIdVec[mainIdVec.length - 1].sNodeId)
               {
                  mainIdVec.push(param1[_loc2_]);
               }
            }
            if(ExtendVec.length > 0)
            {
               if(param1[_loc2_].farNodeId == ExtendVec[ExtendVec.length - 1].sNodeId)
               {
                  ExtendVec.push(param1[_loc2_]);
               }
            }
            _loc2_++;
         }
      }
      
      private static function isHasExten(param1:Array) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length - 1)
         {
            _loc3_ = _loc2_ + 1;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc2_].farNodeId == param1[_loc3_].farNodeId)
               {
                  crossPiont = param1[_loc2_].farNodeId;
                  if(crossPiont == -1)
                  {
                     isOrigin = -1;
                     mainIdVec = [];
                     ExtendVec = [];
                     mainIdVec.push(param1[_loc3_]);
                     ExtendVec.push(param1[_loc2_]);
                     supplyIdVec(param1);
                  }
                  else
                  {
                     isOrigin = 1;
                  }
                  return true;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         isOrigin = 0;
         return false;
      }
      
      public static function bestNewMapId() : Array
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Array = [];
         var _loc1_:Array = getPointArr();
         _loc2_ = mainIdVec.length - 1;
         while(_loc2_ >= 0)
         {
            if(_loc1_.indexOf(mainIdVec[_loc2_].sNodeId) != -1)
            {
               _loc4_.push(mainIdVec[_loc2_].sNodeId);
               break;
            }
            _loc2_--;
         }
         _loc3_ = ExtendVec.length - 1;
         while(_loc3_ >= 0)
         {
            if(_loc1_.indexOf(ExtendVec[_loc3_].sNodeId) != -1 && mainIdVec.indexOf(ExtendVec[_loc3_]) == -1)
            {
               _loc4_.push(ExtendVec[_loc3_].sNodeId);
               break;
            }
            _loc3_--;
         }
         _loc1_ = [];
         _loc1_ = null;
         return _loc4_;
      }
      
      public static function getPointArr() : Array
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < FightingConfig.openPoint.length)
         {
            _loc1_.push(FightingConfig.openPoint[_loc2_].rcdId);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private static function check(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].sNodeId > 10000)
            {
               LogUtil("小节点 ",_loc2_,param1[_loc2_].sNodeId,getExtenMapNameByID(param1[_loc2_].sNodeId));
            }
            else
            {
               LogUtil("大节点 ",_loc2_,param1[_loc2_].sNodeId,getMainMapNameVoByID(param1[_loc2_].sNodeId));
            }
            _loc2_++;
         }
      }
      
      public static function countCityId(param1:int) : int
      {
         var _loc4_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_bigNode");
         var _loc8_:* = 0;
         var _loc7_:* = _loc2_.sta_bigNode;
         for each(var _loc3_ in _loc2_.sta_bigNode)
         {
            _loc4_ = _loc3_.@nodeListJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
            _loc6_ = JSON.parse(_loc4_).lst;
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(_loc6_[_loc5_].sNodeId == param1)
               {
                  return _loc3_.@id;
               }
               _loc5_++;
            }
            _loc6_ = [];
            _loc6_ = null;
         }
         return null;
      }
      
      public static function isLastPoint(param1:Array, param2:int) : Boolean
      {
         var _loc3_:* = 0;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param2 == param1[_loc3_].sNodeId)
               {
                  if(_loc3_ == param1.length - 1)
                  {
                     LogUtil("最后一个野外节点=",param2);
                     return true;
                  }
               }
               _loc3_++;
            }
         }
         return false;
      }
   }
}
