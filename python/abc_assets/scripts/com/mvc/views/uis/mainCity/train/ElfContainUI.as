package com.mvc.views.uis.mainCity.train
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.train.TrainVO;
   import flash.utils.Timer;
   import flash.geom.Rectangle;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import com.mvc.views.mediator.mainCity.train.SeleTrainElfMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.ELFMinImageManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import extend.SoundEvent;
   import flash.events.TimerEvent;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import starling.display.DisplayObject;
   
   public class ElfContainUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var status:int;
      
      public var elfVo:ElfVO;
      
      private var elfName:TextField;
      
      private var elfLv:TextField;
      
      private var spr_exp:SwfSprite;
      
      private var nowExp:TextField;
      
      private var totalExp:TextField;
      
      private var exp:SwfSprite;
      
      private var btn_unlock:SwfButton;
      
      private var btn_upgrade:SwfButton;
      
      public var btn_addElfBtn:SwfButton;
      
      private var elfImage:Image;
      
      private var spr_propContain:SwfSprite;
      
      private var lock:SwfImage;
      
      private var image:Image;
      
      private var diamond:Image;
      
      private var isNotTrain:Boolean;
      
      private var traGrdId:int;
      
      private var trainingIcon:Image;
      
      private var btn_take:SwfButton;
      
      private var trainName:String;
      
      private var upgradeDiamond:int;
      
      public var isCartoon:Boolean;
      
      private var _trainVo:TrainVO;
      
      private var hourUpExp:int;
      
      private var lightBg:Image;
      
      private var propTimer:Timer;
      
      private var time:int;
      
      private var rect:Rectangle;
      
      private var speed:int = 30;
      
      private var lvDiff:int;
      
      private var isUpgrade:Boolean;
      
      private var expWidth:Number;
      
      private var _propUnitUI:com.mvc.views.uis.mainCity.train.PropUnitUI;
      
      private var propBeforeNum:int;
      
      private var tempLv:int;
      
      private const leftPosition:int = 150;
      
      public function ElfContainUI()
      {
         propTimer = new Timer(10);
         rect = new Rectangle(0,0,0,0);
         super();
         init();
         addTxt();
      }
      
      private function addTxt() : void
      {
         elfName = new TextField(50,30,"","FZCuYuan-M03S",24,9850399,true);
         elfLv = new TextField(50,25,"","FZCuYuan-M03S",24,9850399,true);
         elfName.hAlign = "left";
         elfName.autoSize = "horizontal";
         elfLv.hAlign = "left";
         elfLv.autoSize = "horizontal";
         elfName.x = 150;
         elfName.y = 23;
         elfLv.x = 150;
         elfLv.y = elfName.y + elfName.height;
         addQuickChild(elfName);
         addQuickChild(elfLv);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("train");
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = param1.target;
         if(btn_addElfBtn !== _loc4_)
         {
            if(btn_take !== _loc4_)
            {
               if(btn_unlock !== _loc4_)
               {
                  if(btn_upgrade === _loc4_)
                  {
                     if(PlayerVO.diamond < upgradeDiamond)
                     {
                        Tips.show("您的钻石不足以升级！");
                        return;
                     }
                     _loc3_ = Alert.show("升级" + trainName + "需要花费钻石" + upgradeDiamond + ", 升级后每小时增加" + hourUpExp + "经验, 是否确认升级？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                     _loc3_.addEventListener("close",upgradeSure);
                  }
               }
               else
               {
                  if(PlayerVO.diamond < _trainVo.openCost)
                  {
                     Tips.show("您的钻石不足！");
                     return;
                  }
                  if(PlayerVO.vipRank < _trainVo.vipNeed)
                  {
                     Tips.show("你的vip等级不够！");
                     return;
                  }
                  _loc2_ = Alert.show("开通白色训练位需要花费钻石" + _trainVo.openCost + ", 是否确认开通?","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",unlockSure);
               }
            }
            else
            {
               (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3505(SeleTrainElfMedia.traGrdId);
            }
         }
         else
         {
            SeleTrainElfMedia.traGrdId = traGrdId;
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_SELETRAINELF");
         }
      }
      
      private function upgradeSure(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3502(traGrdId);
         }
      }
      
      private function unlockSure(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3501(traGrdId);
         }
      }
      
      private function seleElf(param1:TouchEvent) : void
      {
         if(SeleTrainElfUI.isScrolling)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            LogUtil("elfVo.isDetail==== ",elfVo.isDetail,JSON.stringify(elfVo));
            EventCenter.addEventListener("TRAINELF_DATA_SUCCESS",handle);
            (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2015(elfVo,"训练",elfVo.position);
         }
      }
      
      private function putElf() : void
      {
         if(TrainMedia.trainUIVec[SeleTrainElfMedia.traGrdId - 1].elfVo)
         {
            EventCenter.addEventListener("REPLACE_TRAIN_ELF",replaceElf);
            (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3505(SeleTrainElfMedia.traGrdId);
         }
         else
         {
            (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3504(SeleTrainElfMedia.traGrdId,elfVo);
         }
      }
      
      private function handle(param1:Event) : void
      {
         LogUtil("请求详细数据后处理=",param1.data);
         EventCenter.removeEventListener("TRAINELF_DATA_SUCCESS",handle);
         elfVo = param1.data as ElfVO;
         LogUtil("elfVo.name==",JSON.stringify(elfVo));
         putElf();
      }
      
      private function replaceElf() : void
      {
         EventCenter.removeEventListener("REPLACE_TRAIN_ELF",replaceElf);
         (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3504(SeleTrainElfMedia.traGrdId,elfVo);
      }
      
      private function takeUp(param1:TouchEvent) : void
      {
         if(TrainUI.isScrolling)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(elfImage);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            SeleTrainElfMedia.traGrdId = traGrdId;
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_SELETRAINELF");
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         isNotTrain = true;
         status = 1;
         elfVo = param1;
         showBg();
         showIcon();
         showBtn();
         if(TrainPro.trainVec[SeleTrainElfMedia.traGrdId - 1].elfVo)
         {
            if(TrainPro.trainVec[SeleTrainElfMedia.traGrdId - 1].elfVo.id == param1.id)
            {
               addTrainIcon();
            }
            else
            {
               this.addEventListener("touch",seleElf);
            }
         }
         else
         {
            this.addEventListener("touch",seleElf);
         }
      }
      
      public function set myTrainVO(param1:TrainVO) : void
      {
         clean();
         _trainVo = param1;
         isNotTrain = false;
         traGrdId = param1.traGrdId;
         status = param1.status;
         hourUpExp = (60 + 0.6 * (PlayerVO.lv - 1)) * (15 + 3 * (status + 1) * status / 2);
         if(param1.elfVo)
         {
            elfVo = param1.elfVo;
         }
         else
         {
            elfVo = null;
         }
         showBg();
         showBtn();
         showIcon();
      }
      
      private function showBg() : void
      {
         switch(status)
         {
            case 0:
            case 1:
               image = swf.createImage("img_white");
               break;
            case 2:
               image = swf.createImage("img_green");
               break;
            case 3:
               image = swf.createImage("img_blue");
               break;
            case 4:
               image = swf.createImage("img_purple");
               break;
            case 5:
               image = swf.createImage("img_orange");
               break;
         }
         if(image)
         {
            addQuickChildAt(image,0);
         }
      }
      
      private function showExp() : void
      {
         var _loc1_:* = 0;
         var _loc4_:* = 0;
         spr_exp = swf.createSprite("spr_expBar_s");
         nowExp = spr_exp.getTextField("nowExp");
         totalExp = spr_exp.getTextField("totalExp");
         exp = spr_exp.getSprite("exp");
         spr_exp.x = 150;
         spr_exp.y = elfLv.y + elfLv.height + 20;
         addQuickChild(spr_exp);
         rect.height = exp.height;
         expWidth = exp.width;
         var _loc3_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv);
         elfVo.nextLvExp = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv + 1);
         totalExp.text = "/" + Math.round(elfVo.nextLvExp - _loc3_);
         var _loc2_:Number = (elfVo.currentExp - _loc3_) / (elfVo.nextLvExp - _loc3_);
         if(isNotTrain)
         {
            _loc1_ = Math.round(elfVo.currentExp - _loc3_);
            nowExp.text = _loc1_;
            rect.width = expWidth * _loc2_;
            exp.clipRect = rect;
         }
         else
         {
            _loc4_ = elfVo.currentExp - _loc3_ - _trainVo.upExp < 0?0:elfVo.currentExp - _loc3_ - _trainVo.upExp;
            nowExp.text = _loc4_;
            if(_trainVo.upExp > 0)
            {
               AniFactor.numTfAni(nowExp,elfVo.currentExp - _loc3_);
               expUpAni(_trainVo.upExp);
               expAni(_loc2_,expWidth * _loc2_,rect.width);
            }
            else
            {
               rect.width = expWidth * _loc2_;
               exp.clipRect = rect;
            }
         }
      }
      
      private function showBtn() : void
      {
         if(status == 0)
         {
            btn_unlock = swf.createButton("btn_unlock_b");
            btn_unlock.x = 150;
            btn_unlock.y = elfLv.y + elfLv.height + 20;
            addQuickChild(btn_unlock);
         }
         else if(!elfVo)
         {
            btn_upgrade = swf.createButton("btn_upgrade_b");
            btn_upgrade.x = 150;
            btn_upgrade.y = elfLv.y + elfLv.height + 20;
            addQuickChild(btn_upgrade);
         }
      }
      
      private function showIcon() : void
      {
         if(elfVo)
         {
            elfImage = ELFMinImageManager.getElfM(elfVo.imgName);
            elfImage.pivotX = elfImage.width / 2;
            elfImage.pivotY = elfImage.height / 2;
            elfImage.x = elfImage.width / 2 + 14;
            elfImage.y = elfImage.height / 2 + 23;
            addQuickChild(elfImage);
            elfName.text = elfVo.nickName;
            showExp();
            if(isNotTrain)
            {
               elfLv.text = "等级: " + elfVo.lv;
            }
            else
            {
               if(isCartoon)
               {
                  isCartoon = false;
                  AniFactor.ScaleMaxAni(elfImage,0.4);
               }
               if(_trainVo.isFull)
               {
                  elfLv.text = "Lv." + elfVo.lv + "  经验已满";
               }
               else
               {
                  elfLv.text = "Lv." + elfVo.lv + "  训练中…";
               }
               elfImage.addEventListener("touch",takeUp);
            }
         }
         else
         {
            spr_propContain = swf.createSprite("spr_propContain_s");
            spr_propContain.x = 15;
            spr_propContain.y = 23;
            addQuickChild(spr_propContain);
            diamond = swf.createImage("img_dimmon");
            var _loc1_:* = 0.5;
            diamond.scaleY = _loc1_;
            diamond.scaleX = _loc1_;
            diamond.x = 205;
            diamond.y = elfLv.y;
            if(status > 0)
            {
               btn_addElfBtn = swf.createButton("btn_addElfBtn_b");
               btn_addElfBtn.name = "addElfBtn_b" + _trainVo.traGrdId;
               LogUtil(btn_addElfBtn.name + "按钮名称");
               btn_addElfBtn.x = (spr_propContain.width - btn_addElfBtn.width) / 2;
               btn_addElfBtn.y = (spr_propContain.height - btn_addElfBtn.height) / 2;
               spr_propContain.addQuickChild(btn_addElfBtn);
               switch(status - 1)
               {
                  case 0:
                     upGrade("白色",_trainVo.green);
                     break;
                  case 1:
                     upGrade("绿色",_trainVo.blue);
                     break;
                  case 2:
                     upGrade("蓝色",_trainVo.purple);
                     break;
                  case 3:
                     upGrade("紫色",_trainVo.orange);
                     break;
                  case 4:
                     trainName = "橙色训练位";
                     elfName.text = trainName;
                     elfLv.text = "";
                     removeNoNull(diamond);
                     removeNoNull(btn_upgrade);
                     break;
               }
            }
            else
            {
               lock = swf.createImage("img_lock");
               lock.x = (spr_propContain.width - lock.width) / 2;
               lock.y = (spr_propContain.height - lock.height) / 2;
               spr_propContain.addQuickChild(lock);
               if(_trainVo.vipNeed != 0)
               {
                  elfName.text = "需要VIP" + _trainVo.vipNeed;
                  elfName.color = 16582659;
               }
               else
               {
                  trainName = "白色训练位";
                  elfName.text = trainName;
                  elfName.color = 9844736;
               }
               elfLv.text = "花费       " + _trainVo.openCost;
               addQuickChild(diamond);
            }
         }
      }
      
      private function upGrade(param1:String, param2:int) : void
      {
         trainName = param1 + "训练位";
         elfName.text = trainName;
         elfName.color = 9844736;
         upgradeDiamond = param2;
         elfLv.text = "花费       " + upgradeDiamond;
         addQuickChild(diamond);
      }
      
      private function addTrainIcon() : void
      {
         trainingIcon = swf.createImage("img_training");
         addQuickChild(trainingIcon);
         btn_take = swf.createButton("btn_takeOut_b");
         var _loc1_:* = 0.8;
         btn_take.scaleY = _loc1_;
         btn_take.scaleX = _loc1_;
         btn_take.x = elfLv.x + elfLv.width + 12;
         btn_take.y = elfLv.y;
         addQuickChild(btn_take);
      }
      
      private function expUpAni(param1:int) : void
      {
         addExp = param1;
         var expText:TextField = new TextField(280,30,"经验 +" + addExp,"FZCuYuan-M03S",30,5803285,true);
         expText.y = 50;
         addQuickChild(expText);
         var t:Tween = new Tween(expText,1.5);
         Starling.juggler.add(t);
         t.animate("y",expText.y - 75,expText.y);
         t.onComplete = function():void
         {
            var t2:Tween = new Tween(expText,0.5);
            Starling.juggler.add(t2);
            t2.animate("y",expText.y - 25,expText.y);
            t2.animate("alpha",0);
            t2.onComplete = function():void
            {
               expText.removeFromParent(true);
               expText = null;
            };
         };
      }
      
      private function expAni(param1:Number, param2:Number, param3:Number) : void
      {
         scale = param1;
         finalWidth = param2;
         beforeWidth = param3;
         Starling.juggler.removeTweens(rect);
         var t:Tween = new Tween(rect,(finalWidth - beforeWidth) * 0.8 / 130);
         Starling.juggler.add(t);
         t.animate("width",finalWidth,beforeWidth);
         t.onUpdate = upAni;
         t.onUpdateArgs = [t,finalWidth,beforeWidth];
         if(isUpgrade && lvDiff > 0)
         {
            lvDiff = lvDiff - 1;
            tempLv = tempLv + 1;
            elfLv.text = "Lv." + tempLv + "  训练中…";
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         }
         t.onComplete = function():void
         {
            if(lvDiff > 0)
            {
               expAni(scale,expWidth,0);
            }
            if(_trainVo.isFull && lvDiff == 0 && !isUpgrade)
            {
               elfLv.text = "Lv." + elfVo.lv + "  经验已满";
               Tips.show("经验已达到玩家现等级的最大值");
            }
            if(lvDiff == 0 && isUpgrade)
            {
               isUpgrade = false;
               expAni(scale,expWidth * scale,0);
            }
         };
      }
      
      private function upAni(param1:Tween, param2:Number, param3:Number) : void
      {
         exp.clipRect = null;
         rect.width = param3 + (param2 - param3) * param1.progress;
         exp.clipRect = rect;
      }
      
      public function addLight(param1:com.mvc.views.uis.mainCity.train.PropUnitUI) : void
      {
         _propUnitUI = param1;
         if(lightBg && lightBg.parent)
         {
            if(!TrainMedia.isUseProp)
            {
               lightBg.removeEventListener("touch",useProp);
               removeNoNull(lightBg);
            }
         }
         else
         {
            lightBg = swf.createImage("img_light");
            lightBg.x = -1;
            if(TrainMedia.isUseProp)
            {
               addQuickChild(lightBg);
               lightBg.addEventListener("touch",useProp);
            }
         }
      }
      
      private function useProp(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(lightBg);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(_trainVo.isFull)
            {
               return Tips.show("经验已达到玩家现在等级的最大值");
            }
            if(elfVo.currentHp <= 0)
            {
               return Tips.show("濒死的精灵不能使用糖果");
            }
            time = 0;
            propBeforeNum = _propUnitUI.propVO.count;
            propTimer.addEventListener("timer",starTime);
            propTimer.start();
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            mouseEnd();
         }
      }
      
      private function mouseEnd() : void
      {
         LogUtil("====鼠标弹起后的操作==");
         if(!propTimer.running)
         {
            return;
         }
         (Facade.getInstance().retrieveProxy("TrainPro") as TrainPro).write3503(traGrdId,_propUnitUI.propVO.id,propBeforeNum - _propUnitUI.propVO.count);
         propTimer.removeEventListener("timer",starTime);
         propTimer.stop();
         return;
         §§push(LogUtil("训练的计时器开启"));
      }
      
      protected function starTime(param1:TimerEvent) : void
      {
         time = time + 1;
         if(time > 10)
         {
            if(time % 100)
            {
               if(speed > 5)
               {
                  speed = §§dup().speed - 5;
               }
            }
            if(time % speed == 0)
            {
               useProp2();
            }
         }
         if(time < 2)
         {
            useProp2();
         }
      }
      
      private function useProp2() : void
      {
         if(_trainVo.isFull)
         {
            return;
         }
         if(_propUnitUI.propVO.count > 0)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","useExpSuger");
            _propUnitUI.propVO.count = _propUnitUI.propVO.count - 1;
            _propUnitUI.count = _propUnitUI.propVO.count;
            usePropAni(_propUnitUI.propVO.effectValue);
            if(_propUnitUI.propVO.count == 0)
            {
               mouseEnd();
            }
         }
         else
         {
            propTimer.removeEventListener("timer",starTime);
            propTimer.stop();
            LogUtil("训练的计时器关闭");
         }
      }
      
      private function usePropAni(param1:int) : void
      {
         expUpAni(param1);
         elfVo.currentExp = elfVo.currentExp + param1;
         var _loc3_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,GetElfQuality.GetelfMaxLv(elfVo) + 1) - 1;
         LogUtil("maxExp ================ ",_loc3_,GetElfQuality.GetelfMaxLv(elfVo));
         if(elfVo.currentExp > _loc3_)
         {
            elfVo.currentExp = _loc3_;
            _trainVo.isFull = true;
         }
         tempLv = elfVo.lv;
         CalculatorFactor.calculatorElfLv(elfVo);
         upDateElf();
         lvDiff = elfVo.lv - tempLv;
         LogUtil(elfVo.lv,"升了多少级===================",lvDiff);
         var _loc4_:Number = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv);
         elfVo.nextLvExp = CalculatorFactor.calculatorLvNeedExp(elfVo,elfVo.lv + 1);
         totalExp.text = "/" + Math.round(elfVo.nextLvExp - _loc4_);
         var _loc2_:Number = (elfVo.currentExp - _loc4_) / (elfVo.nextLvExp - _loc4_);
         if(lvDiff > 0)
         {
            isUpgrade = true;
            expAni(_loc2_,expWidth,rect.width);
         }
         else
         {
            expAni(_loc2_,expWidth * _loc2_,rect.width);
         }
         AniFactor.numTfAni(nowExp,elfVo.currentExp - _loc4_);
      }
      
      private function upDateElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(elfVo.isCarry == 1)
         {
            _loc1_ = 0;
            while(_loc1_ < PlayerVO.bagElfVec.length)
            {
               if(PlayerVO.bagElfVec[_loc1_])
               {
                  if(PlayerVO.bagElfVec[_loc1_].id == elfVo.id)
                  {
                     upDateElf2(PlayerVO.bagElfVec[_loc1_]);
                  }
               }
               _loc1_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < PlayerVO.comElfVec.length)
            {
               if(PlayerVO.comElfVec[_loc2_].id == elfVo.id)
               {
                  upDateElf2(PlayerVO.comElfVec[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      private function upDateElf2(param1:ElfVO) : void
      {
         var _loc2_:int = param1.totalHp;
         param1.currentExp = elfVo.currentExp;
         CalculatorFactor.calculatorElfLv(param1);
         CalculatorFactor.calculatorElf(param1);
         param1.currentHp = param1.currentHp + (param1.totalHp - _loc2_);
         if(param1.currentHp > param1.totalHp)
         {
            LogUtil("当前hp超过了总hp");
            param1.currentHp = param1.totalHp;
         }
         if(CalculatorFactor.learnSkillHandler(param1))
         {
            mouseEnd();
         }
      }
      
      private function removeNoNull(param1:DisplayObject) : void
      {
         if(param1 && param1.parent)
         {
            if(param1 is Image)
            {
               (param1 as Image).texture.dispose();
            }
            if(param1 is TextField)
            {
               (param1 as TextField).text = "";
            }
            param1.removeFromParent(true);
            var param1:DisplayObject = null;
         }
      }
      
      public function clean(param1:Boolean = false) : void
      {
         removeNoNull(nowExp);
         removeNoNull(totalExp);
         removeNoNull(exp);
         removeNoNull(spr_exp);
         removeNoNull(btn_unlock);
         removeNoNull(btn_upgrade);
         removeNoNull(btn_addElfBtn);
         removeNoNull(elfImage);
         removeNoNull(spr_propContain);
         removeNoNull(lock);
         removeNoNull(image);
         removeNoNull(diamond);
         removeNoNull(btn_take);
         removeNoNull(trainingIcon);
         removeNoNull(lightBg);
         if(param1)
         {
            removeNoNull(elfLv);
            removeNoNull(elfName);
         }
      }
   }
}
