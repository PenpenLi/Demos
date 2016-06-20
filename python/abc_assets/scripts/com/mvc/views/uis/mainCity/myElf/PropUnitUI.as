package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.events.EventCenter;
   import com.mvc.views.uis.mainCity.backPack.ComposeUI;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.util.xmlVOHandler.GetpropImage;
   
   public class PropUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var propNum:TextField;
      
      public var ifPass:Boolean;
      
      private var _elfVo:ElfVO;
      
      public var _propVo:PropVO;
      
      private var image:Sprite;
      
      private var propSwf:Swf;
      
      public function PropUnitUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         propNum = new TextField(113,30,"","FZCuYuan-M03S",20,5715237,true);
         propNum.y = 113;
         addChild(propNum);
         addEventListener("touch",touchHandler);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            _loc3_ = GetPropFactor.getBrokenPropByComposeID(_propVo.id);
            if(_loc3_)
            {
               EventCenter.addEventListener("BOKEN_COMPOSE_OVER",update);
               ComposeUI.getInstance().show(_loc3_,"MyElfMedia");
            }
            else if(_propVo)
            {
               FirstRchRewardTips.getInstance().showPropTips(_propVo,this);
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(_propVo)
            {
               FirstRchRewardTips.getInstance().removePropTips();
            }
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVo;
      }
      
      private function update() : void
      {
         EventCenter.removeEventListener("BOKEN_COMPOSE_OVER",update);
         var _loc1_:PropVO = GetPropFactor.getProp(_propVo.id);
         LogUtil("更新道具数量显示===",_loc1_);
         if(_loc1_)
         {
            _propVo.count = _loc1_.count;
            myPropVo = _propVo;
            if(ElfEvolveUI.getInstance().parent)
            {
               ElfEvolveUI.getInstance().myElfVo = _elfVo;
            }
         }
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVo = param1;
         image = GetpropImage.getPropSpr(param1);
         addChild(image);
         propNum.text = param1.name + "\n" + param1.count + "/" + param1.evolveNum;
         propNum.autoSize = "vertical";
         if(param1.count >= param1.evolveNum)
         {
            ifPass = true;
         }
      }
   }
}
