package
{
   import starling.core.Starling;
   import starling.display.Stage;
   
   public class Config
   {
      
      public static var isDebug:Boolean;
      
      public static var GAME_FPS:int = 60;
      
      public static const MAIN_CITY_WIDTH:int = 2293;
      
      public static const GAME_WIDTH:int = 1136;
      
      public static const GAME_HEIGHT:int = 640;
      
      public static const WORLD_MAP_WIDTH:int = 1476;
      
      public static const WORLD_MAP_HEIGHT:int = 832;
      
      public static var min_scale:Number = 1;
      
      public static var scaleX:Number = 1;
      
      public static var scaleY:Number = 1;
      
      public static var offset:Number = 1;
      
      public static var device_width:Number;
      
      public static var device_height:Number;
      
      public static var starling:Starling;
      
      public static var stage:Stage;
      
      public static var dialogueDelay:Number = 1.5;
      
      public static const fontName:String = "FZCuYuan-M03S";
      
      public static const bitMAapFontName:String = "img_font";
      
      public static const VIPFontName:String = "img_VIP";
      
      public static const BoldFontName:String = "img_series";
      
      public static var isOpenAni:Boolean = true;
      
      public static var getPowerSwitch:Boolean = true;
      
      public static var privateChaSwitch:Boolean = true;
      
      public static var seriesAttackSwitch:Boolean = true;
      
      public static var isOpenNatice:Boolean;
      
      public static var isOpenBeginner:Boolean;
      
      public static var isCompleteBeginner:Boolean;
      
      public static var isCompleteRestrain:Boolean;
      
      public static var isCompleteCatchElf:Boolean;
      
      public static var isCompleteChange:Boolean;
      
      public static var isAutoFighting:Boolean;
      
      public static var isAutoFightingUseProp:Boolean;
      
      public static var isPvpInviteSure:Boolean = true;
      
      public static var isOpenFightingAni:Boolean = true;
      
      public static const LASTLOGIN:String = "LASTLOGIN";
      
      public static const USERNAME:String = "USERNAME";
      
      public static const USERPSW:String = "USERPSW";
      
      public static const SERVERID:String = "SERVERID";
      
      public static const PORT:String = "PORT";
      
      public static const SERVERNAME:String = "SERVERNAME";
      
      public static const SERVERIP:String = "SERVERIP";
      
      public static const BGMusic:String = "BGMusic";
      
      public static const SEMusic:String = "SEMusic";
      
      public static const isOpenCartoon:String = "isOpenCartoon";
      
      public static const isIgnoreUpdate:String = "isIgnoreUpdate";
      
      public static const isGetPower:String = "isGetPower";
      
      public static const isPrivateChat:String = "isPrivateChat";
      
      public static const isSeriesAttack:String = "isSeriesAttack";
      
      public static const isAutoFightSave:String = "isAutoFightSave";
      
      public static const isAutoFightUsePropSave:String = "isAutoFightUsePropSave";
      
      public static const isPvpInviteSureSave:String = "isPvpInviteSureSave";
      
      public static const isOpenFightingAniSave:String = "isOpenFightingAniSave";
      
      public static var configInfo:Object;
      
      public static const loginAssets:Array = ["loading","login"];
      
      public static const mainCityAssets:Array = ["mainCity"];
      
      public static const worldMapAssets:Array = ["worldMap"];
      
      public static const worldMapTwoAssets:Array = ["worldMapTwo"];
      
      public static const cityMapAssets:Array = ["cityMap"];
      
      public static var cityScene:String;
      
      public static var fightingAssets:Array = ["fighting","elfBallAct"];
      
      public static const homeAssets:Array = ["home"];
      
      public static const feedHouseAssets:Array = ["feedHouse"];
      
      public static const elfSeriesAssets:Array = ["elfSeries"];
      
      public static const kingKwanAssets:Array = ["kingKwan"];
      
      public static const elfCenterAssets:Array = ["elfCenter"];
      
      public static const shopAssets:Array = ["shop"];
      
      public static const amuseAssets:Array = ["amuse"];
      
      public static const amuseMcAssets:Array = ["amuseMc"];
      
      public static const informationAssets:Array = ["information"];
      
      public static const taskAssets:Array = ["task"];
      
      public static const friendAssets:Array = ["friend"];
      
      public static const IllustrationsAssets:Array = ["Illustrations"];
      
      public static const myelfAssets:Array = ["elfPanel"];
      
      public static const elfEvolveMcAssets:Array = ["elfEvolveMc"];
      
      public static const elfEvolveMusicAssets:Array = ["evolveBg","evoSuccess","recoverP","recoverP2"];
      
      public static const eggMcAssets:Array = ["egg_mc"];
      
      public static const startChatAssets:Array = ["startChat"];
      
      public static const fightVSAssets:Array = ["fightVS"];
      
      public static const activityAssets:Array = ["activity"];
      
      public static const badgeMcAssets:Array = ["badgeMc"];
      
      public static const firstRechargeAssets:Array = ["firstRecharge"];
      
      public static const pvpAssets:Array = ["pvp"];
      
      public static const laboratoryAssets:Array = ["laboratory"];
      
      public static const signAssets:Array = ["sign"];
      
      public static const scoreShopAssets:Array = ["scoreShop"];
      
      public static const trainAssets:Array = ["train"];
      
      public static const trialAssets:Array = ["trial"];
      
      public static const miracleAssets:Array = ["miracle"];
      
      public static const miracleMcAssets:Array = ["miracleMc"];
      
      public static const ranklistAssets:Array = ["ranklist"];
      
      public static const growthPlanAssets:Array = ["growthPlan"];
      
      public static const huntingAssets:Array = ["hunting"];
      
      public static const diamondUpAssets:Array = ["diamondUp"];
      
      public static const dayRechargeAssets:Array = ["dayRecharge"];
      
      public static const limitSpecialElfAssets:Array = ["limitSpecialElf"];
      
      public static const auctionAssets:Array = ["auction"];
      
      public static const unionWorldAssets:Array = ["unionWorld","unionMedal"];
      
      public static const unionAssets:Array = ["union"];
      
      public static const unionHallAssets:Array = ["unionHall"];
      
      public static const unionTrainAssets:Array = ["unionTrain"];
      
      public static const unionShopAssets:Array = ["unionShop"];
      
      public static const unionStudyAssets:Array = ["unionStudy"];
      
      public static const exChangeAssets:Array = ["exChange"];
      
      public static const miningAssets:Array = ["mining"];
      
      public static const huntingPartyAssets:Array = ["huntingParty"];
      
      public static const lotteryAssets:Array = ["lottery"];
       
      public function Config()
      {
         super();
      }
   }
}
