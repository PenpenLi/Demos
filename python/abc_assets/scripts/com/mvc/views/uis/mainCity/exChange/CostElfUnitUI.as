package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.GetCommon;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class CostElfUnitUI extends Sprite
   {
       
      private var image:Image;
      
      private var isHave:Boolean;
      
      private var swf:Swf;
      
      private var btn_add:SwfButton;
      
      public var _elfVo:ElfVO;
      
      public var isPass:Boolean;
      
      public function CostElfUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("exChange");
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
         image = ELFMinImageManager.getElfM(param1.imgName);
         image.alpha = 0.5;
         addChild(image);
         btn_add = swf.createButton("btn_add2");
         btn_add.x = image.width - btn_add.width >> 1;
         btn_add.y = image.height - btn_add.height >> 1;
         addChild(btn_add);
         GetCommon.getText(0,image.height,image.width,30,param1.name,"FZCuYuan-M03S",25,16777215,this,false,true,true);
         btn_add.addEventListener("triggered",onClick);
      }
      
      private function onClick(param1:Event) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:* = 0;
         var _loc8_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         LogUtil("挑选相同静态id的精灵, 电脑");
         _loc3_ = 0;
         while(_loc3_ < PlayerVO.comElfVec.length)
         {
            if(PlayerVO.comElfVec[_loc3_].elfId == _elfVo.elfId)
            {
               _loc8_.push(PlayerVO.comElfVec[_loc3_]);
            }
            _loc3_++;
         }
         if(_loc8_.length == 0)
         {
            return Tips.show("没有可交换的精灵");
         }
         LogUtil("去掉防守阵容的精灵");
         _loc5_ = 0;
         while(_loc5_ < _loc8_.length)
         {
            LogUtil("检查第" + _loc5_ + "精灵");
            _loc2_ = 0;
            while(_loc2_ < PlayerVO.FormationElfVec.length)
            {
               if(PlayerVO.FormationElfVec[_loc2_])
               {
                  if(PlayerVO.FormationElfVec[_loc2_].id == _loc8_[_loc5_].id)
                  {
                     LogUtil("去掉第" + _loc5_ + "精灵",_loc8_[_loc5_].nickName);
                     _loc8_.splice(_loc5_,1);
                     _loc5_--;
                     break;
                  }
               }
               _loc2_++;
            }
            _loc5_++;
         }
         if(_loc8_.length == 0)
         {
            return Tips.show("没有可交换的精灵");
         }
         LogUtil("去掉训练位的精灵");
         _loc4_ = 0;
         while(_loc4_ < _loc8_.length)
         {
            if(PlayerVO.trainElfArr.indexOf(_loc8_[_loc4_].id) != -1)
            {
               LogUtil("去掉训练位的精灵",_loc8_[_loc4_].nickName);
               _loc8_.splice(_loc4_,1);
               _loc4_--;
            }
            _loc4_++;
         }
         if(_loc8_.length == 0)
         {
            return Tips.show("没有可交换的精灵");
         }
         LogUtil("去掉挖矿防守中精灵");
         _loc7_ = 0;
         while(_loc7_ < _loc8_.length)
         {
            if(PlayerVO.miningDefendElfArr.indexOf(_loc8_[_loc7_].id) != -1)
            {
               LogUtil("去掉挖矿防守中精灵",_loc8_[_loc7_].nickName);
               _loc8_.splice(_loc7_,1);
               _loc7_--;
            }
            _loc7_++;
         }
         if(_loc8_.length == 0)
         {
            return Tips.show("没有可交换的精灵");
         }
         _loc6_ = 0;
         while(_loc6_ < _loc8_.length)
         {
            if(GotoExChange.getInstance().seleElfArr.indexOf(_loc8_[_loc6_].id) != -1)
            {
               LogUtil("去掉选中的精灵",_loc8_[_loc6_].nickName);
               _loc8_.splice(_loc6_,1);
               _loc6_--;
            }
            _loc6_++;
         }
         if(_loc8_.length == 0)
         {
            return Tips.show("没有可交换的精灵");
         }
         EventCenter.addEventListener("SELE_EXCHANGE_ELF",seleElfOk);
         ExSeleElfUI.getInstance().show(_loc8_);
         _loc8_ = null;
      }
      
      private function seleElfOk(param1:Event) : void
      {
         EventCenter.removeEventListener("SELE_EXCHANGE_ELF",seleElfOk);
         if(param1.data)
         {
            LogUtil("选择精灵后");
            _elfVo = param1.data as ElfVO;
            isPass = true;
            image.alpha = 1;
            btn_add.removeFromParent();
         }
      }
   }
}
