package com.mvc.models.vos.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mapSelect.MapBaseVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.mapSelect.PointVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import lzm.util.LSOManager;
   
   public class FightingConfig
   {
      
      public static var computerElfVO:ElfVO;
      
      public static var selectMap:MapBaseVO;
      
      public static var raidsNum:int;
      
      public static var sceneName:String;
      
      public static var skillAssetsOfDisposeAtOnce:Array = [];
      
      public static var skillAssetsOfUse:Array = [];
      
      public static var skillMusicAssets:Array = [];
      
      public static var elfBackAssets:Array = [];
      
      public static var elfFrontAssets:Array = [];
      
      public static var fightMusicAssets:Array = [];
      
      public static var FSceneAssets:Array = [];
      
      public static var getArr:Array = [];
      
      public static var isWin:Boolean;
      
      public static var isGoOut:Boolean;
      
      public static var moneyFromFighting:String;
      
      public static var getExpFromRaids:int;
      
      public static var getMoneyFromRaids:int;
      
      public static var getPropFromRaids:Vector.<PropVO>;
      
      public static var isLvUp:Boolean;
      
      public static var powerBefore:int;
      
      public static var lvBefore:int;
      
      public static var maxPowerBefore:int;
      
      public static var cannotGoAwayRount:String = "0";
      
      public static var isShareExp:Boolean;
      
      public static var openPoint:Vector.<PointVO> = new Vector.<PointVO>([]);
      
      public static var cityIdArr:Array = [];
      
      public static var openCity:int = -1;
      
      public static var isHasNewPoint:Boolean;
      
      public static var isHasNewCity:Boolean;
      
      public static var attackEffect:int = 0;
      
      public static var isShareScreen:Boolean;
      
      public static var recordSkillIndex:int;
      
      public static var pvpSwitch:int = -1;
      
      public static var otherSelectSkill:int = -1;
      
      public static var otherSelectElf:int = -1;
      
      public static var otherSelectElfAfterDie:int = -1;
      
      public static var selfOrder:Object = {};
      
      public static var otherOrder:Object;
      
      public static var otherOrderNext:Object;
      
      public static var fightingAI:int;
      
      public static var temBagElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var fightToken:String;
      
      public static var isPlayerActAfterChangeElf:Boolean;
      
      public static var selfOrderVec:Vector.<Object> = new Vector.<Object>();
      
      public static var otherOrderVec:Vector.<Object> = new Vector.<Object>();
       
      public function FightingConfig()
      {
         super();
      }
      
      public static function temGetBagElf() : void
      {
         var _loc1_:* = 0;
         temBagElfVec = Vector.<ElfVO>([]);
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            temBagElfVec.push(PlayerVO.bagElfVec[_loc1_]);
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               PlayerVO.bagElfVec[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public static function reGetBagElf() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < temBagElfVec.length)
         {
            PlayerVO.bagElfVec[_loc1_] = temBagElfVec[_loc1_];
            _loc1_++;
         }
         temBagElfVec = Vector.<ElfVO>([]);
      }
      
      public static function updateKingPlayElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         LogUtil("更新王者之路的所有精灵");
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               _loc2_ = 0;
               while(_loc2_ < KingKwanMedia.kingPlayElf.length)
               {
                  if(PlayerVO.bagElfVec[_loc1_].id == KingKwanMedia.kingPlayElf[_loc2_].id)
                  {
                     KingKwanMedia.kingPlayElf[_loc2_] = PlayerVO.bagElfVec[_loc1_];
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      public static function initPvpAllConfig() : void
      {
         selfOrder.isInit = false;
         initOrder(selfOrder);
         otherOrder = null;
         otherOrderNext = null;
         otherSelectSkill = -1;
         otherSelectElf = -1;
         otherSelectElfAfterDie = -1;
         pvpSwitch = -1;
      }
      
      public static function initSelfOrder(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         LogUtil("能初始化吗啊啊啊啊啊");
         if(param2)
         {
            initOrder(selfOrder);
         }
         if(!param1)
         {
            return;
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(selfOrderVec.length > 0)
            {
               LogUtil("初始化前我方战斗信息" + JSON.stringify(selfOrderVec[selfOrderVec.length - 1]));
            }
            if(otherOrderVec.length > 0)
            {
               LogUtil("初始化前敌方战斗信息" + JSON.stringify(otherOrderVec[otherOrderVec.length - 1]));
            }
            _loc3_ = {};
            initOrder(_loc3_);
            selfOrderVec.push(_loc3_);
            _loc4_ = {};
            initOrder(_loc4_);
            otherOrderVec.push(_loc4_);
         }
         else
         {
            if(selfOrderVec.length == 0)
            {
               selfOrderVec = LSOManager.get("selfOrderVec");
            }
            else
            {
               selfOrderVec.splice(0,1);
            }
            if(otherOrderVec.length == 0)
            {
               otherOrderVec = LSOManager.get("otherOrderVec");
            }
            else
            {
               otherOrderVec.splice(0,1);
            }
            selfOrder = null;
            otherOrder = null;
            selfOrder = selfOrderVec[0];
            otherOrder = otherOrderVec[0];
            LogUtil("我方战斗信息" + JSON.stringify(selfOrder));
            LogUtil("敌方战斗信息" + JSON.stringify(otherOrder));
         }
      }
      
      private static function initOrder(param1:Object) : void
      {
         param1.isMull = 0;
         param1.leadSkillId = 0;
         param1.talkSleepUseIndex = -1;
         param1.isStatusHandler = 0;
         param1.attackNum = 0;
         param1.attackRoundNum = 0;
         param1.hitRandomNum = [];
         param1.isHasEffect = 0;
         param1.randomNum = 0;
         param1.isFocusHit = 0;
         param1.randomStatus = 0;
         param1.clearStatus = [];
         param1.isProtectNoDie = 0;
         param1.isFristAttack = 0;
         param1.selectSkill = -1;
         param1.selectElf = -1;
         param1.isGoOut = 0;
         param1.isTimeOut = 0;
         param1.isUseProp = 0;
      }
   }
}
