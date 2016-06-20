package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.themes.Tips;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.ElfFrontImageManager;
   import com.common.util.GetCommon;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class ElfEvolveUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfEvolveUI;
       
      private var swf:Swf;
      
      private var spr_evolve:SwfSprite;
      
      private var breaktxt:TextField;
      
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
      
      private var btn_evolve:SwfButton;
      
      private var _elfVo:ElfVO;
      
      private var image1:Image;
      
      private var image2:Image;
      
      public var evolveVo:ElfVO;
      
      private var spr_evolveInfo:SwfSprite;
      
      private var beforeName:TextField;
      
      private var nowName:TextField;
      
      private var up1:SwfImage;
      
      private var up2:SwfImage;
      
      private var up3:SwfImage;
      
      private var up4:SwfImage;
      
      private var up5:SwfImage;
      
      private var up6:SwfImage;
      
      private var down1:SwfImage;
      
      private var down2:SwfImage;
      
      private var down3:SwfImage;
      
      private var down4:SwfImage;
      
      private var down5:SwfImage;
      
      private var down6:SwfImage;
      
      private var mageContain:Sprite;
      
      private var seleBtn:SwfButton;
      
      public function ElfEvolveUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfEvolveUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfEvolveUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_evolve = swf.createSprite("spr_evolve");
         spr_evolveInfo = spr_evolve.getSprite("spr_evolveInfo");
         beforeName = spr_evolveInfo.getTextField("beforeName");
         nowName = spr_evolveInfo.getTextField("nowName");
         totalHp = spr_evolveInfo.getTextField("totalHp");
         Attack = spr_evolveInfo.getTextField("Attack");
         Defense = spr_evolveInfo.getTextField("Defense");
         super_attack = spr_evolveInfo.getTextField("super_attack");
         spuer_defense = spr_evolveInfo.getTextField("spuer_defense");
         speed = spr_evolveInfo.getTextField("speed");
         rare = spr_evolveInfo.getTextField("rare");
         totalHpUp = spr_evolveInfo.getTextField("totalHpUp");
         AttackUp = spr_evolveInfo.getTextField("AttackUp");
         DefenseUp = spr_evolveInfo.getTextField("DefenseUp");
         super_attackUp = spr_evolveInfo.getTextField("super_attackUp");
         spuer_defenseUp = spr_evolveInfo.getTextField("spuer_defenseUp");
         speedUp = spr_evolveInfo.getTextField("speedUp");
         rareUp = spr_evolveInfo.getTextField("rareUp");
         totalHpDec = spr_evolveInfo.getTextField("totalHpUpDec");
         AttackDec = spr_evolveInfo.getTextField("AttackUpDec");
         DefenseDec = spr_evolveInfo.getTextField("DefenseUpDec");
         super_attackDec = spr_evolveInfo.getTextField("super_attackUpDec");
         spuer_defenseDec = spr_evolveInfo.getTextField("spuer_defenseUpDec");
         speedDec = spr_evolveInfo.getTextField("speedUpDec");
         up1 = spr_evolveInfo.getImage("up1");
         up2 = spr_evolveInfo.getImage("up2");
         up3 = spr_evolveInfo.getImage("up3");
         up4 = spr_evolveInfo.getImage("up4");
         up5 = spr_evolveInfo.getImage("up5");
         up6 = spr_evolveInfo.getImage("up6");
         down1 = spr_evolveInfo.getImage("down1");
         down2 = spr_evolveInfo.getImage("down2");
         down3 = spr_evolveInfo.getImage("down3");
         down4 = spr_evolveInfo.getImage("down4");
         down5 = spr_evolveInfo.getImage("down5");
         down6 = spr_evolveInfo.getImage("down6");
         btn_evolve = spr_evolveInfo.getButton("btn_evolve");
         btn_evolve.name = "btn_evolve1";
         addChild(spr_evolve);
         btn_evolve.addEventListener("triggered",evolve);
         mageContain = new Sprite();
         spr_evolveInfo.addChild(mageContain);
      }
      
      private function evolve() : void
      {
         if(_elfVo.evolveIdArr.length > 0 && _elfVo.evolveId == "0")
         {
            return Tips.show("请选择精灵进化方向");
         }
         if(_elfVo.evolveId != "0")
         {
            this.parent.parent.addChild(EvolveUI.getInstance());
            BeginnerGuide.playBeginnerGuide();
         }
         else
         {
            Tips.show("精灵已是最终形态！无法进化");
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         if(FinallyUI.getInstance().parent)
         {
            FinallyUI.getInstance().removeFromParent();
         }
         _elfVo = param1;
         showUI();
         cleanImg();
         if(_elfVo.evolveId != "0")
         {
            spr_evolveInfo.visible = true;
            LogUtil("进化前====",_elfVo.brokenLv,_elfVo.starts,_elfVo.characterCorrect,_elfVo.lv);
            evolveVo = GetElfFactor.getElfVO(_elfVo.evolveId);
            if(evolveVo.elfId > 20000)
            {
               evolveVo.brokenLv = "0";
               evolveVo.starts = "0";
               evolveVo.characterCorrect = _elfVo.characterCorrect;
               evolveVo.lv = "5";
               evolveVo.individual = [0,0,0,0,0,0];
            }
            else
            {
               evolveVo.brokenLv = _elfVo.brokenLv;
               evolveVo.starts = _elfVo.starts;
               evolveVo.characterCorrect = _elfVo.characterCorrect;
               evolveVo.lv = Math.max(_elfVo.lv,_elfVo.evoLv);
               evolveVo.individual = _elfVo.individual;
            }
            LogUtil("进化后====",evolveVo.brokenLv,evolveVo.starts,evolveVo.characterCorrect,evolveVo.lv);
            CalculatorFactor.calculatorElf(evolveVo);
            ElfFrontImageManager.getInstance().getImg([evolveVo.imgName],showElf);
            EvolveUI.getInstance().myElfVo = param1;
            writeBeforeData(param1);
            evolveData(evolveVo);
            Facade.getInstance().sendNotification("UPDATA_EVOLVE_PROMPT",EvolveUI.getInstance().ifAllPass);
            return;
         }
         if(_elfVo.evolveIdArr.length > 0)
         {
            spr_evolveInfo.visible = true;
            addElfImg();
            addSeleBtn();
            writeBeforeData(_elfVo);
            notKnowEvolve();
            return;
         }
         evolveVo = null;
         spr_evolveInfo.visible = false;
         FinallyUI.getInstance().show(_elfVo,1,this);
         Facade.getInstance().sendNotification("UPDATA_EVOLVE_PROMPT",false);
         Facade.getInstance().sendNotification("UPDATA_EVOLVE_PROMPT",false);
      }
      
      private function showUI() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(_elfVo.evolveId > 20000)
         {
            _loc1_ = 0;
            while(_loc1_ < spr_evolveInfo.numChildren)
            {
               if(!(_loc1_ == 8 || _loc1_ == 9 || _loc1_ == 10))
               {
                  spr_evolveInfo.getChildAt(_loc1_).visible = false;
               }
               _loc1_++;
            }
            addMageUI();
         }
         else
         {
            mageContain.removeChildren(0,-1,true);
            _loc2_ = 0;
            while(_loc2_ < spr_evolveInfo.numChildren)
            {
               spr_evolveInfo.getChildAt(_loc2_).visible = true;
               _loc2_++;
            }
         }
      }
      
      private function addMageUI() : void
      {
         var _loc2_:* = 180;
         var _loc1_:* = 40;
         mageContain.removeChildren(0,-1,true);
         mageContain.visible = true;
         GetCommon.getLabel(mageContain,0,_loc2_,23,"进化首要条件",16190771);
         GetCommon.getLabel(mageContain,0,_loc2_ + _loc1_,20,"突破:",0);
         GetCommon.getLabel(mageContain,57,_loc2_ + _loc1_,20,_elfVo.name + "+3",16740369);
         GetCommon.getLabel(mageContain,180,_loc2_ + _loc1_,20,"个体值:",0);
         GetCommon.getLabel(mageContain,255,_loc2_ + _loc1_,20,"六项全满",0);
         GetCommon.getLabel(mageContain,0,_loc2_ + _loc1_ * 2,20,"特训:",0);
         GetCommon.getImage(58,_loc2_ + _loc1_ * 2 - 8,"img_star",swf,mageContain);
         GetCommon.getS9Image(-30,_loc2_ + _loc1_ * 3 - 5,400,130,"s9_skilldec",swf,mageContain);
         GetCommon.getLabel(mageContain,102,307,20,"Mega进化规则",16740369);
         GetCommon.getLabel(mageContain,-20,338,15,"1、Mega进化之后精灵等级回到5级，技能、携带品不变",0);
         GetCommon.getLabel(mageContain,-20,360,15,"2、Mega进化之后突破、特训、个体值等级清零",0);
         GetCommon.getLabel(mageContain,-20,383,15,"3、Mega进化之后初始形态默认Mega之后的形态，不能\n重置到Mega前形态",0);
      }
      
      private function addSeleBtn() : void
      {
         seleBtn = swf.createButton("btn_bigUnFineImg");
         seleBtn.x = 200;
         spr_evolveInfo.addChild(seleBtn);
         seleBtn.addEventListener("triggered",seleEvoElf);
      }
      
      private function seleEvoElf() : void
      {
         EvolveSeleteUI.getInstance().myElfVO = _elfVo;
      }
      
      private function notKnowEvolve() : void
      {
         var _loc1_:* = 0;
         nowName.text = "?";
         totalHpUp.text = "?";
         AttackUp.text = "?";
         DefenseUp.text = "?";
         super_attackUp.text = "?";
         spuer_defenseUp.text = "?";
         speedUp.text = "?";
         rareUp.text = "?";
         totalHpDec.text = "?";
         AttackDec.text = "?";
         DefenseDec.text = "?";
         super_attackDec.text = "?";
         spuer_defenseDec.text = "?";
         speedDec.text = "?";
         _loc1_ = 1;
         while(_loc1_ < 7)
         {
            upDown(0,_loc1_);
            _loc1_++;
         }
      }
      
      private function writeBeforeData(param1:ElfVO) : void
      {
         beforeName.text = param1.name;
         totalHp.text = param1.totalHp;
         Attack.text = param1.attack;
         Defense.text = param1.defense;
         super_attack.text = param1.super_attack;
         spuer_defense.text = param1.super_defense;
         speed.text = param1.speed;
         rare.text = param1.rare;
      }
      
      private function evolveData(param1:ElfVO) : void
      {
         if(param1 && param1.elfId < 20000)
         {
            nowName.text = param1.name;
            totalHpUp.text = param1.totalHp;
            AttackUp.text = param1.attack;
            DefenseUp.text = param1.defense;
            super_attackUp.text = param1.super_attack;
            spuer_defenseUp.text = param1.super_defense;
            speedUp.text = param1.speed;
            rareUp.text = param1.rare;
            totalHpDec.text = totalHpUp.text - totalHp.text;
            AttackDec.text = AttackUp.text - Attack.text;
            DefenseDec.text = DefenseUp.text - Defense.text;
            super_attackDec.text = super_attackUp.text - super_attack.text;
            spuer_defenseDec.text = spuer_defenseUp.text - spuer_defense.text;
            speedDec.text = speedUp.text - speed.text;
            upDown(totalHpDec.text,1);
            upDown(AttackDec.text,2);
            upDown(DefenseDec.text,3);
            upDown(super_attackDec.text,4);
            upDown(spuer_defenseDec.text,5);
            upDown(speedDec.text,6);
         }
      }
      
      private function upDown(param1:int, param2:int) : void
      {
         if(param1 >= 0)
         {
            (this["up" + param2] as SwfImage).visible = true;
            (this["down" + param2] as SwfImage).visible = false;
         }
         else
         {
            (this["up" + param2] as SwfImage).visible = false;
            (this["down" + param2] as SwfImage).visible = true;
         }
      }
      
      private function addElfImg() : void
      {
         LogUtil("添加精灵进化前的头像");
         image1 = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVo.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image1,160,true);
         image1.x = 60;
         image1.y = 80;
         spr_evolveInfo.addChild(image1);
      }
      
      private function showElf() : void
      {
         addElfImg();
         evolveElfImg(evolveVo);
      }
      
      private function evolveElfImg(param1:ElfVO) : void
      {
         LogUtil("添加精灵进化后的精灵头像");
         image2 = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(param1.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image2,160,true);
         image2.y = 80;
         image2.x = 280;
         spr_evolveInfo.addChild(image2);
         if(_elfVo.evolveIdArr.length > 0 && _elfVo.evolveId != "0")
         {
            ElfFrontImageManager.tempNoRemoveTexture.push(param1.imgName);
            image2.addEventListener("touch",seleElf);
         }
      }
      
      private function seleElf(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image2);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            seleEvoElf();
         }
      }
      
      public function cleanImg() : void
      {
         var _loc1_:* = 0;
         if(image1)
         {
            image1.removeFromParent(true);
            image1 = null;
         }
         if(seleBtn)
         {
            seleBtn.removeFromParent(true);
            seleBtn = null;
         }
         if(image2)
         {
            _loc1_ = 0;
            while(_loc1_ < PlayerVO.bagElfVec.length)
            {
               if(PlayerVO.bagElfVec[_loc1_])
               {
                  if(PlayerVO.bagElfVec[_loc1_].elfId == evolveVo.elfId)
                  {
                     image2.removeFromParent(true);
                     image2 = null;
                     return;
                  }
               }
               _loc1_++;
            }
            LogUtil("======释放进化后的纹理==========");
            ElfFrontImageManager.getInstance().disposeImg(image2);
            image2 = null;
         }
      }
   }
}
