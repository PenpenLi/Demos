package com.mvc.models.vos.login
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.mainCity.friend.FriendVO;
   import com.mvc.models.vos.mainCity.playerInfo.DiamondGiftItemVO;
   import com.mvc.models.vos.mainCity.playerInfo.PlayerLvVO;
   import com.mvc.models.vos.mainCity.playerInfo.VIPInfoVO;
   
   public class PlayerVO
   {
      
      public static var enemyElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var bagElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var comElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var feedElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var FormationElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var playElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var medicineVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var elfBallVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var otherPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var propBroken:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var sandBagVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var evolveStoneVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var dollVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var learnMachineVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var trashyPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var huntingPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var bugleChipVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var raidsProp:PropVO;
      
      public static var friendVec:Vector.<FriendVO> = new Vector.<FriendVO>([]);
      
      public static var friendRequestVec:Vector.<FriendVO> = new Vector.<FriendVO>([]);
      
      public static var diamondGiftVec:Vector.<DiamondGiftItemVO>;
      
      public static var maxFriendNum:int;
      
      public static var nickName:String;
      
      public static var isFirstChangeName:Boolean;
      
      public static var userId:String;
      
      public static var sex:int;
      
      public static var headArr:Array = [];
      
      public static var headPtId:int = 1;
      
      public static var trainPtId:int = 10001;
      
      public static var lv:String = "1";
      
      public static var silver:int;
      
      public static var diamond:int;
      
      public static var actionCDTime:int;
      
      public static var actionForce:int;
      
      public static var maxActionForce:int;
      
      public static var handbookNum:int;
      
      public static var badgeNum:int;
      
      public static var pvDot:int;
      
      public static var kwDot:int;
      
      public static var rkDot:int;
      
      public static var fsDot:int;
      
      public static var exper:int;
      
      public static var playerLvVoVec:Vector.<PlayerLvVO>;
      
      public static var vipInfoVO:VIPInfoVO;
      
      public static var vipRank:int;
      
      public static var vipExper:int;
      
      public static var isBuyMonCard:Boolean;
      
      public static var monCardNum:int;
      
      public static var isOpenPokeSpace:Boolean;
      
      public static var pokeSpace:int;
      
      public static var cpSpace:int;
      
      public static var guideProgress:int;
      
      public static var trainSpace:int;
      
      public static var firstLoginDay:int;
      
      public static var isUseProp:Boolean;
      
      public static var usePropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var seriesRank:int;
      
      public static var seriesSilver:int;
      
      public static var seriesDiamon:int;
      
      public static var seriesRkDot:int;
      
      public static var seriesMaxRank:int;
      
      public static var kingIsOpen:Boolean;
      
      public static var firstElfId:int;
      
      public static var trainElfArr:Array = [];
      
      public static var isAcceptPvp:Boolean = true;
      
      public static var unionId:int = -1;
      
      public static var applyCount:int;
      
      public static var isOpenUnion:Boolean = true;
      
      public static var guildApplyGuildId:Array;
      
      public static var payCount:int;
      
      public static var recruitTimes:Array = [];
      
      public static var medalLv:int = 1;
      
      public static var medalExp:int;
      
      public static var isGetMedalReward:Boolean;
      
      public static var miningDefendElfArr:Array = [];
      
      public static var rechargeIdArr:Array;
      
      public static var catchScore:int;
       
      public function PlayerVO()
      {
         super();
      }
      
      public static function getRechargeIdArr(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         rechargeIdArr = [];
         var _loc4_:* = 0;
         var _loc3_:* = param1;
         for(var _loc2_ in param1)
         {
            if(param1[_loc2_] > 0)
            {
               rechargeIdArr.push(_loc2_);
            }
         }
      }
      
      public static function initBagElfVec() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            bagElfVec.push(null);
            _loc1_++;
         }
      }
      
      public static function BagElfSetNull() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < bagElfVec.length)
         {
            bagElfVec[_loc1_] = null;
            _loc1_++;
         }
      }
      
      public static function initFormationElfVec() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            FormationElfVec.push(null);
            _loc1_++;
         }
      }
      
      public static function initPlayElfVec() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            playElfVec.push(null);
            _loc1_++;
         }
      }
      
      public static function initFeedElfVec() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            feedElfVec.push(null);
            _loc1_++;
         }
      }
      
      public static function getAreaCodeByUserId(param1:String) : String
      {
         if(param1 == null)
         {
            return "?";
         }
         var _loc3_:RegExp = new RegExp("s[0-9]+p","i");
         var _loc2_:String = _loc3_.exec(param1)[0];
         _loc2_ = _loc2_.slice(1,_loc2_.length - 1);
         return _loc2_;
      }
   }
}
