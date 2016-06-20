package com.mvc.models.proxy.mainCity.train
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.train.TrainVO;
   import com.common.net.Client;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetTrainInfo;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.train.TrainMedia;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.GetCommon;
   import com.common.events.EventCenter;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class TrainPro extends Proxy
   {
      
      public static const NAME:String = "TrainPro";
      
      public static var trainVec:Vector.<TrainVO> = new Vector.<TrainVO>([]);
      
      public static var isSeleSkill:Boolean;
      
      public static var trainData:Object = {};
      
      public static var trainOutData:Object = {};
       
      private var client:Client;
      
      private var _traGrdId:int;
      
      private var _elfVo:ElfVO;
      
      public function TrainPro(param1:Object = null)
      {
         super("TrainPro",param1);
         client = Client.getInstance();
         client.addCallObj("note3500",this);
         client.addCallObj("note3501",this);
         client.addCallObj("note3502",this);
         client.addCallObj("note3503",this);
         client.addCallObj("note3504",this);
         client.addCallObj("note3505",this);
         client.addCallObj("note3506",this);
         client.addCallObj("note3507",this);
      }
      
      public function write3500(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3500;
         _loc2_.trainType = param1;
         client.sendBytes(_loc2_);
         if(param1 == 2)
         {
            isSeleSkill = false;
         }
      }
      
      public function note3500(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         trainData = param1;
         LogUtil("3500=" + JSON.stringify(param1));
         var _loc6_:* = param1.status;
         if("success" !== _loc6_)
         {
            if("fail" !== _loc6_)
            {
               if("error" === _loc6_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            _loc5_ = param1.data.trainGrid;
            trainVec = Vector.<TrainVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               _loc2_ = GetTrainInfo.getTrainVo(_loc5_[_loc3_].traGrdId);
               _loc2_.status = _loc5_[_loc3_].status;
               if(_loc5_[_loc3_].spirit)
               {
                  _loc4_ = GetElfFactor.getElfVO(_loc5_[_loc3_].spirit.spStaId);
                  LogUtil("nickName=======",_loc4_.nickName);
                  _loc4_.id = _loc5_[_loc3_].spirit.id;
                  if(_loc5_[_loc3_].spirit.nkName != null)
                  {
                     _loc4_.nickName = _loc5_[_loc3_].spirit.nkName;
                  }
                  _loc4_.lv = _loc5_[_loc3_].spirit.lv2;
                  _loc4_.brokenLv = _loc5_[_loc3_].spirit.bkLv;
                  _loc4_.currentExp = _loc5_[_loc3_].spirit.exp2;
                  _loc4_.currentHp = _loc5_[_loc3_].spirit.curHp;
                  _loc4_.totalHp = _loc5_[_loc3_].spirit.totalHp;
                  _loc4_.isCarry = _loc5_[_loc3_].spirit.isCry;
                  _loc4_.lv = _loc5_[_loc3_].spirit.lv2;
                  _loc2_.isFull = _loc5_[_loc3_].spirit.isLvFull;
                  _loc2_.upExp = _loc5_[_loc3_].spirit.exp2 - _loc5_[_loc3_].spirit.exp1;
                  _loc2_.elfVo = _loc4_;
               }
               trainVec.push(_loc2_);
               _loc3_++;
            }
            rankSort(trainVec);
            sendNotification("SEND_TRAIN");
            GetElfFactor.UpdateIndex = 0;
            GetElfFactor.updateElf(GetElfFactor.UpdateIndex);
         }
      }
      
      public function write3501(param1:int) : void
      {
         _traGrdId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3501;
         _loc2_.traGrdId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3501(param1:Object) : void
      {
         LogUtil("3501=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            trainVec[_traGrdId - 1].status = 1;
            TrainMedia.trainUIVec[_traGrdId - 1].myTrainVO = trainVec[_traGrdId - 1];
            UmengExtension.getInstance().UMAnalysic("buy|019|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
         }
      }
      
      public function write3502(param1:int) : void
      {
         _traGrdId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3502;
         _loc2_.traGrdId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3502(param1:Object) : void
      {
         LogUtil("3502=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            trainVec[_traGrdId - 1].status = param1.data.status;
            TrainMedia.trainUIVec[_traGrdId - 1].myTrainVO = trainVec[_traGrdId - 1];
            UmengExtension.getInstance().UMAnalysic("buy|021|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
         }
      }
      
      public function write3503(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 3503;
         _loc4_.traGrdId = param1;
         _loc4_.pId = param2;
         _loc4_.useTimes = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note3503(param1:Object) : void
      {
         LogUtil("3503=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write3504(param1:int, param2:ElfVO) : void
      {
         _traGrdId = param1;
         _elfVo = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 3504;
         _loc3_.traGrdId = param1;
         _loc3_.spId = param2.id;
         client.sendBytes(_loc3_);
      }
      
      public function note3504(param1:Object) : void
      {
         LogUtil("3504=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            PlayerVO.trainElfArr.push(_elfVo.id);
            LogUtil("训练位的精灵主键id",PlayerVO.trainElfArr);
            sendNotification("CLOSE_SELETRAINELF");
            trainVec[_traGrdId - 1].elfVo = _elfVo;
            trainVec[_traGrdId - 1].isFull = param1.data.isLvFull;
            TrainMedia.trainUIVec[_traGrdId - 1].isCartoon = true;
            TrainMedia.trainUIVec[_traGrdId - 1].myTrainVO = trainVec[_traGrdId - 1];
         }
      }
      
      public function write3505(param1:int) : void
      {
         _traGrdId = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3505;
         _loc2_.traGrdId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3505(param1:Object) : void
      {
         LogUtil("3505=" + JSON.stringify(param1));
         trainOutData = param1;
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            PlayerVO.trainElfArr.splice(PlayerVO.trainElfArr.indexOf(trainVec[_traGrdId - 1].elfVo.id),1);
            LogUtil("训练位的精灵主键id",PlayerVO.trainElfArr);
            if(!GetCommon.isNullObject(param1.data))
            {
               LogUtil("没有任何变化",trainVec[_traGrdId - 1].elfVo.currentExp);
               trainVec[_traGrdId - 1].elfVo = null;
            }
            else if(trainVec[_traGrdId - 1].elfVo.isCarry == 1)
            {
               upDateElf(PlayerVO.bagElfVec,param1.data,_traGrdId);
            }
            else
            {
               upDateElf(PlayerVO.comElfVec,param1.data,_traGrdId);
            }
            trainVec[_traGrdId - 1].upExp = 0;
            TrainMedia.trainUIVec[_traGrdId - 1].myTrainVO = trainVec[_traGrdId - 1];
            EventCenter.dispatchEvent("REPLACE_TRAIN_ELF");
            sendNotification("CLOSE_SELETRAINELF");
         }
      }
      
      public function write3506() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3506;
         client.sendBytes(_loc1_);
      }
      
      public function note3506(param1:Object) : void
      {
         LogUtil("3506=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            PlayerVO.trainElfArr = param1.data.spiritIdArr;
         }
      }
      
      private function upDateElf(param1:Vector.<ElfVO>, param2:Object, param3:int) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_] != null)
            {
               if(trainVec[param3 - 1].elfVo.id == param1[_loc5_].id)
               {
                  _loc4_ = param2.exp;
                  if(param1[_loc5_].currentExp > _loc4_)
                  {
                     LogUtil("elfVec[i].currentExp == ",param1[_loc5_].currentExp,_loc4_);
                     Tips.show("取出后，经验经少了");
                  }
                  param1[_loc5_].currentExp = _loc4_;
                  param1[_loc5_].totalHp = param2.totalHp;
                  param1[_loc5_].currentHp = param2.curHp;
                  LogUtil("取出了谁？",trainVec[param3 - 1].elfVo.nickName);
                  CalculatorFactor.calculatorElfLv(param1[_loc5_]);
                  CalculatorFactor.learnSkillHandler(param1[_loc5_]);
                  CalculatorFactor.calculatorElf(param1[_loc5_]);
                  trainVec[param3 - 1].elfVo = null;
                  break;
               }
            }
            _loc5_++;
         }
      }
      
      public function rankSort(param1:Vector.<TrainVO>) : Vector.<TrainVO>
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].traGrdId > param1[_loc4_ + 1].traGrdId)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
   }
}
