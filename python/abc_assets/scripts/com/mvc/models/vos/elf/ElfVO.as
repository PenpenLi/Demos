package com.mvc.models.vos.elf
{
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class ElfVO
   {
       
      public var id:int;
      
      public var elfId:String = "0";
      
      public var name:String;
      
      public var imgName:String;
      
      public var nature:Array;
      
      public var sex:int;
      
      public var sexDistribution:Number;
      
      public var featureVO:com.mvc.models.vos.elf.FeatureVO;
      
      public var feature:String;
      
      public var parentNature:String;
      
      public var characters:int;
      
      public var character:String;
      
      public var nickName:String;
      
      public var color:String;
      
      public var camp:String = "camp_of_player";
      
      public var state:String;
      
      public var tall:Number;
      
      public var heavy:Number;
      
      public var evoLv:int = -1;
      
      public var evoStoneArr:Array;
      
      public var muchEvoStoneArr:Object;
      
      public var evolveId:String = "0";
      
      public var evolveIdArr:Array;
      
      public var descr:String;
      
      public var rare:String;
      
      public var rareValue:int;
      
      public var isDetail:Boolean;
      
      public var elfBallId:int;
      
      public var power:int;
      
      public var master:String;
      
      public var isPromptEvolve:Boolean = true;
      
      public var isAlreadyFree:Boolean;
      
      public var brokenLv:String = "0";
      
      public var freePoints:int;
      
      public var isLock:Boolean;
      
      public var speciesHp:String = "0";
      
      public var speciesAttack:String = "0";
      
      public var speciesDefense:String = "0";
      
      public var speciesSuper_attack:String = "0";
      
      public var speciesSpuer_defense:String = "0";
      
      public var speciesSpeed:String = "0";
      
      public var individual:Array;
      
      public var effAry:Array;
      
      public var characterCorrect:Array;
      
      public var lv:String = "5";
      
      public var ablilityAddLv:Array;
      
      public var starts:String = "1";
      
      public var originStarts:String = "1";
      
      public var maxStar:int;
      
      public var zzTotal:int;
      
      public var evoFrom:String = "0";
      
      public var totalHp:String;
      
      public var currentHp:String = "-1";
      
      public var currentExp:Number;
      
      public var nextLvExp:Number;
      
      public var attack:String;
      
      public var defense:String;
      
      public var super_attack:String;
      
      public var super_defense:String;
      
      public var speed:String;
      
      public var currentSpeed:Number;
      
      public var expCurve:int;
      
      public var captureRate:Number;
      
      public var dropEffort:Array;
      
      public var incubateStep:int;
      
      public var allValue:int;
      
      public var position:int;
      
      public var isCarry:int;
      
      public var isSpecial:Boolean;
      
      public var isGoOut:Boolean;
      
      public var baseExp:int;
      
      public var isHasFiging:Boolean;
      
      public var isShareExp:Boolean;
      
      public var hurtNum:int = 0;
      
      public var sleepCount:String = "0";
      
      public var mullCount:int = 0;
      
      public var boundCount:int = 0;
      
      public var stoneCount:int = 0;
      
      public var fogCount:int = 0;
      
      public var tolerCount:int = 0;
      
      public var lessHurtCount:int = 0;
      
      public var protectCount:int = 0;
      
      public var powerCount:int = 0;
      
      public var inciteCount:int = 0;
      
      public var prayCount:int = 0;
      
      public var yawnCount:int = 0;
      
      public var blightCount:int = 0;
      
      public var blightHurt:int = 0;
      
      public var storeNum:String = "0";
      
      public var hpBeforeAvatars:int = 0;
      
      public var lastHurtOfPhysics:int = 0;
      
      public var isStoreGas:Boolean;
      
      public var isWillDie:Boolean;
      
      public var isCannotActStatus:Boolean;
      
      public var skillBeforeStrone:com.mvc.models.vos.elf.SkillVO;
      
      public var skillFinalUseId:int = 0;
      
      public var currentSkill:com.mvc.models.vos.elf.SkillVO;
      
      public var skillOfLast:com.mvc.models.vos.elf.SkillVO;
      
      public var tolerHurt:int;
      
      public var isReleaseAnger:Boolean;
      
      public var wallArr:Array;
      
      public var relation:int;
      
      public var isPlay:Boolean;
      
      public var isUsedPropOfBandage:Boolean;
      
      public var skillOfFirstSelect:com.mvc.models.vos.elf.SkillVO;
      
      public var status:Array;
      
      public var totalSkillID:Array;
      
      public var totalSkillVec:Vector.<com.mvc.models.vos.elf.SkillVO>;
      
      public var currentSkillVec:Vector.<com.mvc.models.vos.elf.SkillVO>;
      
      public var recordSkillVec:Vector.<com.mvc.models.vos.elf.SkillVO>;
      
      public var recordSkBeforeCopy:com.mvc.models.vos.elf.SkillVO;
      
      public var copykillIndex:int = -1;
      
      public var skillInfo:Array;
      
      public var carryProp:PropVO;
      
      public var hagberryProp:PropVO;
      
      public var hasUseDefense:Boolean;
      
      public var lastHurtOfSpecial:int = 0;
      
      public var eyeCount:int = 0;
      
      public var isEvolve:Boolean;
      
      public var isBreak:Boolean;
      
      public var isStar:Boolean;
      
      public var recruitLimit:int;
      
      public var sound:int;
      
      public var previewLimit:int;
      
      public function ElfVO()
      {
         evoStoneArr = [];
         evolveIdArr = [];
         individual = [0,0,0,0,0,0];
         effAry = [0,0,0,0,0,0];
         characterCorrect = [1,1,1,1,1];
         ablilityAddLv = [0,0,0,0,0,0,0];
         wallArr = [];
         status = [];
         totalSkillID = [];
         totalSkillVec = new Vector.<com.mvc.models.vos.elf.SkillVO>([]);
         currentSkillVec = new Vector.<com.mvc.models.vos.elf.SkillVO>([]);
         recordSkillVec = new Vector.<com.mvc.models.vos.elf.SkillVO>([]);
         super();
      }
   }
}
