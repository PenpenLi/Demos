package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.common.managers.ElfFrontImageManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.geom.Rectangle;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class ElfStarUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfStarUI;
       
      private var swf:Swf;
      
      private var spr_star:SwfSprite;
      
      private var totalHp:TextField;
      
      private var Attack:TextField;
      
      private var Defense:TextField;
      
      private var super_attack:TextField;
      
      private var spuer_defense:TextField;
      
      private var speed:TextField;
      
      private var rare:TextField;
      
      private var breaktxtUp:TextField;
      
      private var totalHpUp:TextField;
      
      private var AttackUp:TextField;
      
      private var DefenseUp:TextField;
      
      private var super_attackUp:TextField;
      
      private var spuer_defenseUp:TextField;
      
      private var speedUp:TextField;
      
      private var rareUp:TextField;
      
      private var totalHpDec:TextField;
      
      private var AttackDec:TextField;
      
      private var DefenseDec:TextField;
      
      private var super_attackDec:TextField;
      
      private var spuer_defenseDec:TextField;
      
      private var speedDec:TextField;
      
      private var silver:TextField;
      
      private var breakState:TextField;
      
      private var btn_star:SwfButton;
      
      private var propContain:Sprite;
      
      public var isAllMeet:Boolean;
      
      private var _elfVo:ElfVO;
      
      private var costMoneyArr:Array;
      
      private var zzPercent:Array;
      
      private var sandPercent:Array;
      
      private var propVec:Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>;
      
      private var totalHpNum:int;
      
      private var AttackNum:int;
      
      private var DefenseNum:int;
      
      private var super_attackNum:int;
      
      private var super_defenseNum:int;
      
      private var speedNum:int;
      
      private var spr_starInfo:SwfSprite;
      
      private var nowStar:SwfSprite;
      
      private var laterStar:SwfSprite;
      
      public function ElfStarUI()
      {
         costMoneyArr = [35000,120000,400000,800000];
         zzPercent = [0.05,0.09,0.15,0.2];
         sandPercent = [0.7,0.3];
         propVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfStarUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfStarUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_star = swf.createSprite("spr_star");
         spr_starInfo = spr_star.getSprite("spr_starInfo_s");
         nowStar = spr_starInfo.getSprite("nowStar");
         laterStar = spr_starInfo.getSprite("laterStar");
         totalHp = spr_starInfo.getTextField("totalHp");
         Attack = spr_starInfo.getTextField("Attack");
         Defense = spr_starInfo.getTextField("Defense");
         super_attack = spr_starInfo.getTextField("super_attack");
         spuer_defense = spr_starInfo.getTextField("spuer_defense");
         speed = spr_starInfo.getTextField("speed");
         totalHpUp = spr_starInfo.getTextField("totalHpUp");
         AttackUp = spr_starInfo.getTextField("AttackUp");
         DefenseUp = spr_starInfo.getTextField("DefenseUp");
         super_attackUp = spr_starInfo.getTextField("super_attackUp");
         spuer_defenseUp = spr_starInfo.getTextField("spuer_defenseUp");
         speedUp = spr_starInfo.getTextField("speedUp");
         totalHpDec = spr_starInfo.getTextField("totalHpUpDec");
         AttackDec = spr_starInfo.getTextField("AttackUpDec");
         DefenseDec = spr_starInfo.getTextField("DefenseUpDec");
         super_attackDec = spr_starInfo.getTextField("super_attackUpDec");
         spuer_defenseDec = spr_starInfo.getTextField("spuer_defenseUpDec");
         speedDec = spr_starInfo.getTextField("speedUpDec");
         silver = spr_starInfo.getTextField("silver");
         breakState = spr_starInfo.getTextField("breakState");
         btn_star = spr_starInfo.getButton("btn_star");
         addChild(spr_star);
         propContain = new Sprite();
         propContain.x = 100;
         propContain.y = 260;
         spr_starInfo.addChild(propContain);
         btn_star.addEventListener("triggered",openChild);
      }
      
      private function openChild() : void
      {
         if(_elfVo.currentHp <= 0)
         {
            return Tips.show("濒死的精灵无法特训");
         }
         if(!isAllMeet)
         {
            return Tips.show("条件不满足");
         }
         (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2025(_elfVo.id);
      }
      
      public function starSuccess() : void
      {
         var _loc1_:* = 0;
         ElfFrontImageManager.tempNoRemoveTexture.push(_elfVo.imgName);
         _loc1_ = 0;
         while(_loc1_ < propVec.length)
         {
            GetPropFactor.addOrLessProp(propVec[_loc1_]._propVo,false,propVec[_loc1_].count);
            _loc1_++;
         }
         Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - costMoneyArr[_elfVo.starts - 1]);
         StarSuccessUI.getInstance().show(_elfVo);
         myElfVo = _elfVo;
         Facade.getInstance().sendNotification("UPDATA_MYELF");
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         if(param1.elfId > 20000)
         {
            return;
         }
         if(FinallyUI.getInstance().parent)
         {
            FinallyUI.getInstance().removeFromParent();
         }
         isAllMeet = true;
         _elfVo = param1;
         addBrokenInfo(param1);
         if(!spr_starInfo.visible)
         {
            Facade.getInstance().sendNotification("UPDATA_STAR_PROMPT",isAllMeet);
            return;
         }
         addProp(param1);
         starValue(param1);
         writeValue(param1);
         writeValueUp(param1);
         writeValueUpDec(param1);
         nowStar.clipRect = new Rectangle(MyElfUI.starWidth * (5 - param1.starts),0,MyElfUI.starWidth * param1.starts,nowStar.height);
         laterStar.clipRect = new Rectangle(0,0,MyElfUI.starWidth * (param1.starts + 1),laterStar.height);
         Facade.getInstance().sendNotification("UPDATA_STAR_PROMPT",isAllMeet);
      }
      
      public function starIsAllMeet(param1:ElfVO) : Boolean
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         if(param1.elfId > 20000)
         {
            return false;
         }
         var _loc2_:* = true;
         if(PlayerVO.silver < costMoneyArr[param1.starts - 1])
         {
            return false;
         }
         if(param1.starts >= param1.maxStar)
         {
            return false;
         }
         var _loc3_:ElfVO = calculateElfVo(param1);
         var _loc5_:Array = calculateSandIdArr(_loc3_,param1);
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc4_ = GetPropFactor.getProp(_loc5_[_loc6_]);
            if(!_loc4_)
            {
               _loc2_ = false;
               break;
            }
            if(_loc4_.count < Math.round(_loc3_.zzTotal * zzPercent[param1.starts - 1] * sandPercent[_loc6_]))
            {
               _loc2_ = false;
               break;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      private function writeValueUpDec(param1:ElfVO) : void
      {
         totalHpDec.text = totalHpNum >= 0?"( +" + totalHpNum + " )":"( " + totalHpNum + " )";
         AttackDec.text = AttackNum >= 0?"( +" + AttackNum + " )":"( " + AttackNum + " )";
         DefenseDec.text = DefenseNum >= 0?"( +" + DefenseNum + " )":"( " + DefenseNum + " )";
         super_attackDec.text = super_attackNum >= 0?"( +" + super_attackNum + " )":"( " + super_attackNum + " )";
         spuer_defenseDec.text = super_defenseNum >= 0?"( +" + super_defenseNum + " )":"( " + super_defenseNum + " )";
         speedDec.text = speedNum >= 0?"( +" + speedNum + " )":"( " + speedNum + " )";
      }
      
      private function writeValueUp(param1:ElfVO) : void
      {
         totalHpUp.text = Math.round(param1.totalHp + totalHpNum);
         AttackUp.text = Math.round(param1.attack + AttackNum);
         DefenseUp.text = Math.round(param1.defense + DefenseNum);
         super_attackUp.text = Math.round(param1.super_attack + super_attackNum);
         spuer_defenseUp.text = Math.round(param1.super_defense + super_defenseNum);
         speedUp.text = Math.round(param1.speed + speedNum);
      }
      
      private function writeValue(param1:ElfVO) : void
      {
         totalHp.text = Math.round(param1.totalHp);
         Attack.text = param1.attack;
         Defense.text = param1.defense;
         super_attack.text = param1.super_attack;
         spuer_defense.text = param1.super_defense;
         speed.text = param1.speed;
      }
      
      private function addBrokenInfo(param1:ElfVO) : void
      {
         LogUtil("添加升星信息==============",param1.starts,param1.maxStar,param1.evolveId);
         spr_starInfo.visible = true;
         silver.text = costMoneyArr[param1.starts - 1];
         silver.color = 52224;
         if(PlayerVO.silver < costMoneyArr[param1.starts - 1])
         {
            silver.color = 16711680;
            isAllMeet = false;
         }
         if(param1.starts < param1.maxStar)
         {
            breakState.text = param1.name;
            breakState.color = 52224;
         }
         else
         {
            isAllMeet = false;
            if(param1.evolveId != "0" && param1.evolveId < 20000)
            {
               breakState.text = GetElfFactor.getElfVO(param1.evolveId).name;
               breakState.color = 16711680;
            }
            else
            {
               spr_starInfo.visible = false;
               FinallyUI.getInstance().show(param1,3,this);
            }
         }
      }
      
      private function calculateElfVo(param1:ElfVO) : ElfVO
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("首先我们要找出用哪种形态的精灵去 计算沙袋",param1.evolveId);
         if(param1.evolveId != "0" && param1.evolveId < 20000)
         {
            if(param1.evoFrom != "0")
            {
               LogUtil("这个是成长期的精灵==",param1.name,"……下一级的星数是=",param1.starts + 1);
               _loc5_ = GetElfFactor.getElfVO(param1.evoFrom,false);
               if(param1.starts + 1 <= _loc5_.maxStar)
               {
                  LogUtil("叮！！！…………是幼生期的");
                  _loc4_ = _loc5_;
               }
               else if(param1.starts + 1 <= param1.maxStar)
               {
                  LogUtil("叮！！！…………是成长期的，用自己的");
                  _loc4_ = param1;
               }
               else
               {
                  LogUtil("叮！！！…………是完全体的 ……………快去进化吧！！！！！！");
                  _loc4_ = GetElfFactor.getElfVO(param1.evolveId);
               }
               _loc5_ = null;
            }
            else
            {
               LogUtil("这个是幼生期的精灵=",param1.name,"……下一级的星数是=",param1.starts + 1);
               if(param1.starts + 1 <= param1.maxStar)
               {
                  LogUtil("叮！！！…………是幼生期的, 用自己的");
                  _loc4_ = param1;
               }
               else
               {
                  LogUtil("叮！！！…………是成长期的");
                  _loc4_ = GetElfFactor.getElfVO(param1.evolveId);
               }
            }
         }
         else
         {
            LogUtil("这个是完全体的精灵=",param1.name,"……下一级的星数是=",param1.starts + 1);
            if(param1.evoFrom != "0")
            {
               _loc3_ = GetElfFactor.getElfVO(param1.evoFrom,false);
               LogUtil("有成熟期的",_loc3_.name,_loc3_.maxStar);
               if(_loc3_.evoFrom != "0")
               {
                  _loc2_ = GetElfFactor.getElfVO(_loc3_.evoFrom,false);
                  LogUtil("有幼生期的",_loc2_.name,_loc2_.maxStar);
                  if(param1.starts + 1 <= _loc2_.maxStar)
                  {
                     LogUtil("叮！！！…………是幼生期的",_loc2_.name);
                     _loc4_ = _loc2_;
                  }
                  else if(param1.starts + 1 <= _loc3_.maxStar)
                  {
                     LogUtil("叮！！！…………是成熟期的",_loc3_.name);
                     _loc4_ = _loc3_;
                  }
                  else
                  {
                     LogUtil("叮！！！…………是完全体的, 用自己的",param1.name);
                     _loc4_ = param1;
                  }
                  _loc2_ = null;
               }
               else if(param1.starts + 1 <= _loc3_.maxStar)
               {
                  LogUtil("叮！！！…………是成熟期的",_loc3_.name);
                  _loc4_ = _loc3_;
               }
               else
               {
                  LogUtil("叮！！！…………是完全体的, 用自己的",param1.name);
                  _loc4_ = param1;
               }
            }
            else
            {
               LogUtil("叮！！！…………是完全体的, 用自己的",param1.name);
               _loc4_ = param1;
            }
            _loc3_ = null;
         }
         return _loc4_;
      }
      
      private function calculateSandIdArr(param1:ElfVO, param2:ElfVO) : Array
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:Array = [];
         if(param1.nature.length > 1)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.nature.length)
            {
               _loc3_ = GetPropFactor.getPropId(param1.nature[_loc4_]) + param2.starts - 1;
               _loc7_.push(_loc3_);
               _loc4_++;
            }
         }
         else
         {
            _loc6_ = GetPropFactor.getPropId(param1.nature[0]) + param2.starts - 1;
            _loc5_ = GetPropFactor.getPropId("all") + param2.starts - 1;
            _loc7_.push(_loc6_,_loc5_);
         }
         return _loc7_;
      }
      
      private function addProp(param1:ElfVO) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:ElfVO = calculateElfVo(param1);
         var _loc6_:Array = calculateSandIdArr(_loc3_,param1);
         LogUtil("sandIdArr === ",_loc6_);
         if(_loc6_)
         {
            propVec = Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
            propContain.removeChildren(0,-1,true);
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               _loc4_ = GetPropFactor.getProp(_loc6_[_loc5_]);
               if(!_loc4_)
               {
                  LogUtil("没有这个道具");
                  _loc4_ = GetPropFactor.getPropVO(_loc6_[_loc5_]);
               }
               _loc2_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.8,Math.round(_loc3_.zzTotal * zzPercent[param1.starts - 1] * sandPercent[_loc5_]));
               _loc2_.identity = "合成1";
               _loc2_.myPropVo = _loc4_;
               _loc2_.x = 110 * _loc5_;
               propContain.addChild(_loc2_);
               propVec.push(_loc2_);
               if(!_loc2_.isMeet)
               {
                  isAllMeet = false;
               }
               _loc5_++;
            }
         }
      }
      
      private function starValue(param1:ElfVO) : void
      {
         var _loc2_:ElfVO = GetElfFromSever.copyElf(param1);
         _loc2_.starts = _loc2_.starts + 1;
         CalculatorFactor.calculatorElf(_loc2_);
         totalHpNum = _loc2_.totalHp - param1.totalHp;
         AttackNum = _loc2_.attack - param1.attack;
         DefenseNum = _loc2_.defense - param1.defense;
         super_attackNum = _loc2_.super_attack - param1.super_attack;
         super_defenseNum = _loc2_.super_defense - param1.super_defense;
         speedNum = _loc2_.speed - param1.speed;
      }
   }
}
