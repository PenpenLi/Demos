package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import feathers.controls.ScrollContainer;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.TiledColumnsLayout;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.common.managers.ElfFrontImageManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class ElfBreakUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfBreakUI;
       
      private var swf:Swf;
      
      private var spr_break:SwfSprite;
      
      private var breaktxt:TextField;
      
      private var totalHp:TextField;
      
      private var Attack:TextField;
      
      private var Defense:TextField;
      
      private var super_attack:TextField;
      
      private var spuer_defense:TextField;
      
      private var speed:TextField;
      
      private var rare:TextField;
      
      private var breakBefore:TextField;
      
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
      
      private var openLv:TextField;
      
      private var silver:TextField;
      
      private var btn_elfBreak:SwfButton;
      
      public var _elfVo:ElfVO;
      
      private var propContain:ScrollContainer;
      
      public var brokenColor:Array;
      
      public var brokenStr:Array;
      
      public var isAllMeet:Boolean;
      
      private var propVec:Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>;
      
      private var breakArrInfo:Array;
      
      private var spr_breakInfo:SwfSprite;
      
      private var breakState:TextField;
      
      private var totalHpNum:int;
      
      private var AttackNum:int;
      
      private var DefenseNum:int;
      
      private var super_attackNum:int;
      
      private var super_defenseNum:int;
      
      private var speedNum:int;
      
      private var isEvolve:Boolean;
      
      public var isScrolling:Boolean;
      
      public function ElfBreakUI()
      {
         brokenColor = [5845798,52224,52224,52224,39423,39423,39423,6697983,6697983,6697983,16737792,16737792,16737792,16737792,16737792];
         brokenStr = ["","","+1","+2","","+1","+2","","+1","+2","","+1","+2","+3"," Max"];
         propVec = new Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfBreakUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfBreakUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_break = swf.createSprite("spr_break");
         spr_breakInfo = spr_break.getSprite("spr_breakInfo");
         breakBefore = spr_breakInfo.getTextField("breakBefore");
         breaktxtUp = spr_breakInfo.getTextField("breaktxtUp");
         totalHp = spr_breakInfo.getTextField("totalHp");
         Attack = spr_breakInfo.getTextField("Attack");
         Defense = spr_breakInfo.getTextField("Defense");
         super_attack = spr_breakInfo.getTextField("super_attack");
         spuer_defense = spr_breakInfo.getTextField("spuer_defense");
         speed = spr_breakInfo.getTextField("speed");
         totalHpUp = spr_breakInfo.getTextField("totalHpUp");
         AttackUp = spr_breakInfo.getTextField("AttackUp");
         DefenseUp = spr_breakInfo.getTextField("DefenseUp");
         super_attackUp = spr_breakInfo.getTextField("super_attackUp");
         spuer_defenseUp = spr_breakInfo.getTextField("spuer_defenseUp");
         speedUp = spr_breakInfo.getTextField("speedUp");
         totalHpDec = spr_breakInfo.getTextField("totalHpUpDec");
         AttackDec = spr_breakInfo.getTextField("AttackUpDec");
         DefenseDec = spr_breakInfo.getTextField("DefenseUpDec");
         super_attackDec = spr_breakInfo.getTextField("super_attackUpDec");
         spuer_defenseDec = spr_breakInfo.getTextField("spuer_defenseUpDec");
         speedDec = spr_breakInfo.getTextField("speedUpDec");
         openLv = spr_breakInfo.getTextField("openLv");
         silver = spr_breakInfo.getTextField("silver");
         breakState = spr_breakInfo.getTextField("breakState");
         btn_elfBreak = spr_breakInfo.getButton("btn_elfBreak");
         addChild(spr_break);
         btn_elfBreak.addEventListener("triggered",openChild);
         addontainer();
      }
      
      public function addontainer() : void
      {
         propContain = new ScrollContainer();
         propContain.name = "breakPropContain";
         propContain.x = 18;
         propContain.y = 336;
         propContain.width = 385;
         propContain.height = 145;
         propContain.verticalScrollPolicy = "off";
         var _loc1_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc1_.gap = -17;
         _loc1_.paddingLeft = -8;
         _loc1_.paddingRight = -8;
         propContain.layout = _loc1_;
         spr_break.addChild(propContain);
         propContain.addEventListener("scrollStart",startScroll);
         propContain.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
      }
      
      private function openChild() : void
      {
         if(_elfVo.currentHp <= 0)
         {
            return Tips.show("濒死的精灵无法突破");
         }
         reCheck();
         if(isAllMeet)
         {
            (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2023(_elfVo.id);
         }
         else
         {
            Tips.show("未达到条件");
         }
      }
      
      private function reCheck() : void
      {
         var _loc1_:* = 0;
         isAllMeet = true;
         _loc1_ = 0;
         while(_loc1_ < propVec.length)
         {
            if(!propVec[_loc1_].isMeet)
            {
               isAllMeet = false;
               return;
            }
            _loc1_++;
         }
         if(silver.color != 52224 || openLv.color != 52224 || breakState.color != 52224)
         {
            isAllMeet = false;
         }
      }
      
      public function breakSuccess() : void
      {
         var _loc1_:* = 0;
         ElfFrontImageManager.tempNoRemoveTexture.push(_elfVo.imgName);
         BreakSuccessUI.getInstance().show(_elfVo);
         LogUtil("_elfVo.sss====",_elfVo.brokenLv,_elfVo.elfId);
         _loc1_ = 0;
         while(_loc1_ < propVec.length)
         {
            GetPropFactor.addOrLessProp(propVec[_loc1_]._propVo,false,propVec[_loc1_]._costNum);
            _loc1_++;
         }
         Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver - breakArrInfo[1]);
         myElfVo = _elfVo;
         Facade.getInstance().sendNotification("UPDATA_MYELF");
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         if(FinallyUI.getInstance().parent)
         {
            FinallyUI.getInstance().removeFromParent();
         }
         spr_breakInfo.visible = true;
         isAllMeet = true;
         _elfVo = param1;
         addProp(param1);
         if(!spr_breakInfo.visible)
         {
            Facade.getInstance().sendNotification("UPDATA_BREAK_PROMPT",isAllMeet);
            return;
         }
         addBrokenInfo(param1);
         setElfName(param1);
         brokenValue(param1);
         writeValue(param1);
         writeValueUp(param1);
         writeValueUpDec(param1);
         Facade.getInstance().sendNotification("UPDATA_BREAK_PROMPT",isAllMeet);
      }
      
      public function breakIsAllMeet(param1:ElfVO) : Boolean
      {
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = true;
         if(param1.elfId > 10000 && param1.elfId < 20000)
         {
            _loc6_ = GetElfFactor.getElfVO(param1.elfId - 10000,false);
            _loc6_.brokenLv = param1.brokenLv;
         }
         else
         {
            _loc6_ = param1;
         }
         var _loc8_:Object = calculatePropArr(_loc6_);
         var _loc7_:Array = _loc8_.propIdArr;
         var _loc9_:Boolean = _loc8_.isEvolve;
         if(!_loc7_)
         {
            return false;
         }
         if(_loc9_)
         {
            return false;
         }
         var _loc3_:Array = GetElfQuality.getUpQualityInfo(param1);
         if(PlayerVO.silver < _loc3_[1])
         {
            return false;
         }
         if(param1.lv < _loc3_[0])
         {
            return false;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc7_.length)
         {
            _loc4_ = GetPropFactor.getProp(_loc7_[_loc5_][0]);
            if(!_loc4_)
            {
               _loc2_ = false;
               break;
            }
            if(param1.elfId > 20000)
            {
               if(_loc4_.count <= _loc7_[_loc5_][1])
               {
                  _loc2_ = false;
                  break;
               }
            }
            else if(_loc4_.count <= checkSame(_loc7_,_loc5_))
            {
               _loc2_ = false;
               break;
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function setElfName(param1:ElfVO) : void
      {
         if(spr_breakInfo.visible)
         {
            if(isEvolve)
            {
               breaktxtUp.text = GetElfFactor.getElfVO(param1.evolveId).name + brokenStr[param1.brokenLv + 1];
            }
            else
            {
               breaktxtUp.text = param1.name + brokenStr[param1.brokenLv + 1];
            }
         }
         breakBefore.text = param1.name + brokenStr[param1.brokenLv];
         breakBefore.color = brokenColor[param1.brokenLv];
         breaktxtUp.color = brokenColor[param1.brokenLv + 1];
      }
      
      private function addBrokenInfo(param1:ElfVO) : void
      {
         breakArrInfo = GetElfQuality.getUpQualityInfo(param1);
         openLv.text = breakArrInfo[0];
         silver.text = breakArrInfo[1];
         silver.color = 52224;
         openLv.color = 52224;
         if(isEvolve)
         {
            breakState.text = GetElfFactor.getElfVO(param1.evolveId).name;
            breakState.color = 16711680;
            isAllMeet = false;
         }
         else
         {
            breakState.text = param1.name;
            breakState.color = 52224;
         }
         if(PlayerVO.silver < breakArrInfo[1])
         {
            silver.color = 16711680;
            isAllMeet = false;
         }
         if(param1.lv < breakArrInfo[0])
         {
            openLv.color = 16711680;
            isAllMeet = false;
         }
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
         AttackUp.text = param1.attack + AttackNum;
         DefenseUp.text = param1.defense + DefenseNum;
         super_attackUp.text = param1.super_attack + super_attackNum;
         spuer_defenseUp.text = param1.super_defense + super_defenseNum;
         speedUp.text = param1.speed + speedNum;
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
      
      private function calculatePropArr(param1:ElfVO) : Object
      {
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:Object = {};
         var _loc5_:* = false;
         _loc6_ = GetElfQuality.getUpQualityPropId(param1.elfId,param1.brokenLv + 1);
         LogUtil("propIdArr==---",param1.brokenLv + 1,_loc6_);
         if(!_loc6_)
         {
            LogUtil("没找到这个阶段的道具, 看看这只精灵在那个时期，是完全体， 还是幼生期，还是成长期");
            if(param1.evolveId != "0" && param1.evolveId < 20000)
            {
               if(param1.evoFrom != "0")
               {
                  LogUtil("这个是成长期的精灵=",param1.name);
                  _loc6_ = GetElfQuality.getUpQualityPropId(param1.evoFrom,param1.brokenLv + 1);
                  if(_loc6_)
                  {
                     LogUtil("突破阶段的道具在幼生期");
                  }
                  else
                  {
                     LogUtil("突破阶段的道具在完全体 ……………快去进化吧！！！！！！");
                     _loc6_ = GetElfQuality.getUpQualityPropId(param1.evolveId,param1.brokenLv + 1);
                     _loc5_ = true;
                  }
               }
               else
               {
                  LogUtil("这个是幼生期的精灵=",param1.name," …………找成长期吧, 快去进化吧！！！！！！");
                  _loc6_ = GetElfQuality.getUpQualityPropId(param1.evolveId,param1.brokenLv + 1);
                  if(!_loc6_)
                  {
                     LogUtil("有没有搞错成长期竟然没有突破道具……好吧……只能找完全体期了, 跨度有点大，先计算成长期的精灵，快去进化吧！！！！！！");
                     _loc3_ = GetElfFactor.getElfVO(param1.evolveId,false);
                     _loc6_ = GetElfQuality.getUpQualityPropId(_loc3_.evolveId,param1.brokenLv + 1);
                     _loc3_ = null;
                  }
                  _loc5_ = true;
               }
            }
            else
            {
               LogUtil("这个是完全体的精灵=",param1.name,"…………望上一级找找看",param1.brokenLv);
               if(param1.evoFrom != "0")
               {
                  _loc2_ = GetElfFactor.getElfVO(param1.evoFrom,false);
                  LogUtil("存在成长期的精灵=",_loc2_.name,_loc2_.elfId,"…………望上一级找找看");
                  _loc6_ = GetElfQuality.getUpQualityPropId(param1.evoFrom,param1.brokenLv + 1);
                  LogUtil("propIdArr==",_loc6_);
                  if(!_loc6_ && _loc2_.evoFrom != "0")
                  {
                     LogUtil("存在幼生期的精灵=",_loc2_.evoFrom,"…………望上一级找找看");
                     _loc6_ = GetElfQuality.getUpQualityPropId(_loc2_.evoFrom,param1.brokenLv + 1);
                  }
               }
            }
         }
         _loc4_.propIdArr = _loc6_;
         _loc4_.isEvolve = _loc5_;
         return _loc4_;
      }
      
      private function addProp(param1:ElfVO) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         propContain.removeChildren(0,-1,true);
         if(param1.elfId > 10000 && param1.elfId < 20000)
         {
            _loc5_ = GetElfFactor.getElfVO(param1.elfId - 10000,false);
            _loc5_.brokenLv = param1.brokenLv;
         }
         else
         {
            _loc5_ = param1;
         }
         var _loc6_:Object = calculatePropArr(_loc5_);
         var _loc7_:Array = _loc6_.propIdArr;
         isEvolve = _loc6_.isEvolve;
         LogUtil("propIdArr ===",_loc7_ == null,_loc7_);
         if(!_loc7_)
         {
            LogUtil("噢！！！！！！！！！！！找遍了都没找到,…………这精灵已经走到极境了");
            isAllMeet = false;
            spr_breakInfo.visible = false;
            FinallyUI.getInstance().show(param1,2,this);
            return;
         }
         LogUtil("最终结果============================ ",_loc7_);
         propVec = Vector.<com.mvc.views.uis.mainCity.myElf.SimplePropUI>([]);
         _loc4_ = 0;
         while(_loc4_ < _loc7_.length)
         {
            _loc3_ = GetPropFactor.getProp(_loc7_[_loc4_][0]);
            if(!_loc3_)
            {
               _loc3_ = GetPropFactor.getPropVO(_loc7_[_loc4_][0]);
               LogUtil("没有这个道具-",_loc3_.name);
            }
            if(param1.elfId > 20000)
            {
               LogUtil("测试===========",JSON.stringify(_loc7_));
               _loc2_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.8,_loc7_[_loc4_][1],false,true);
            }
            else if(_loc7_.length > 4)
            {
               _loc2_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.75,1,true,false,checkSame(_loc7_,_loc4_));
            }
            else
            {
               _loc2_ = new com.mvc.views.uis.mainCity.myElf.SimplePropUI(0.8,1,true,false,checkSame(_loc7_,_loc4_));
            }
            _loc2_.identity = "合成1";
            _loc2_.name = "propUnit" + _loc4_;
            _loc2_.myPropVo = _loc3_;
            propContain.addChild(_loc2_);
            propVec.push(_loc2_);
            if(!_loc2_.isMeet)
            {
               isAllMeet = false;
            }
            _loc4_++;
         }
      }
      
      public function updateProp() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         _loc2_ = 0;
         while(_loc2_ < propVec.length)
         {
            _loc1_ = GetPropFactor.getProp(propVec[_loc2_]._propVo.id);
            if(!_loc1_)
            {
               _loc1_ = GetPropFactor.getPropVO(propVec[_loc2_]._propVo.id);
               LogUtil("没有这个道具-",_loc1_.name);
            }
            propVec[_loc2_].myPropVo = _loc1_;
            _loc2_++;
         }
      }
      
      private function checkSame(param1:Array, param2:int) : int
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc5_.push(param1[_loc4_][0]);
            _loc4_++;
         }
         while(_loc5_.length > 0 && _loc5_.indexOf(param1[param2][0]) != -1)
         {
            LogUtil("检测这个道具前面有多少个相同的=============",_loc5_,"——",_loc3_,"——",param1[param2][0],"——",_loc5_.indexOf(param1[param2][0]),"i=",param2);
            _loc3_++;
            _loc5_.splice(_loc5_.indexOf(param1[param2][0]),1);
         }
         return _loc3_;
      }
      
      private function brokenValue(param1:ElfVO) : void
      {
         var _loc2_:ElfVO = GetElfFromSever.copyElf(param1);
         _loc2_.brokenLv = _loc2_.brokenLv + 1;
         CalculatorFactor.calculatorElf(_loc2_);
         totalHpNum = _loc2_.totalHp - param1.totalHp;
         AttackNum = _loc2_.attack - param1.attack;
         DefenseNum = _loc2_.defense - param1.defense;
         super_attackNum = _loc2_.super_attack - param1.super_attack;
         super_defenseNum = _loc2_.super_defense - param1.super_defense;
         speedNum = _loc2_.speed - param1.speed;
      }
      
      public function finalElf(param1:ElfVO) : ElfVO
      {
         var _loc2_:* = null;
         if(param1.evolveId != "0")
         {
            _loc2_ = GetElfFactor.getElfVO(param1.evolveId);
            if(_loc2_.evolveId != "0")
            {
               _loc2_ = GetElfFactor.getElfVO(_loc2_.evolveId);
            }
         }
         else
         {
            _loc2_ = param1;
         }
         return _loc2_;
      }
   }
}
