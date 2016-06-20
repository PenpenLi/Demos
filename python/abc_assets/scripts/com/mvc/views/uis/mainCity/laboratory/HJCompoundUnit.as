package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.text.TextField;
   import feathers.controls.Label;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import flash.text.TextFormat;
   import com.mvc.views.mediator.mainCity.laboratory.HJCompoundMediator;
   
   public class HJCompoundUnit extends Sprite
   {
       
      private var _propVO:PropVO;
      
      private var propSpr:Sprite;
      
      private var propName:TextField;
      
      private var label:Label;
      
      public function HJCompoundUnit()
      {
         super();
      }
      
      public function get propVO() : PropVO
      {
         return _propVO;
      }
      
      public function set propVO(param1:PropVO) : void
      {
         if(propSpr)
         {
            propSpr.removeFromParent(true);
         }
         _propVO = GetPropFactor.getProp(param1.id);
         if(!_propVO)
         {
            _propVO = param1;
         }
         propSpr = GetpropImage.getPropSpr(_propVO,true,0.9);
         addChild(propSpr);
         if(propName)
         {
            propName.removeFromParent(true);
         }
         propName = new TextField(120,30,propVO.name.substr(0,7) + "\n" + propVO.name.substr(7),"FZCuYuan-M03S",20,5516307);
         propName.autoScale = true;
         propName.x = propSpr.x - 10;
         propName.y = propSpr.y + propSpr.height;
         addChild(propName);
         setNum(_propVO);
      }
      
      public function setNum(param1:PropVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:TextFormat = new TextFormat("FZCuYuan-M03S",20,5467187);
         if(label)
         {
            label.removeFromParent(true);
         }
         label = new Label();
         label.x = propSpr.x + propSpr.width - 50;
         label.y = propSpr.y + propSpr.height - 30;
         addChild(label);
         label.textRendererProperties.textFormat = _loc3_;
         label.textRendererProperties.isHTML = true;
         if(param1.count < param1.composeNum)
         {
            _loc2_ = "<font color = \'#8d121f\' size = \'20\'>" + param1.count + "</font>" + "/<font color = \'#536c33\' size = \'20\'>" + param1.composeNum + "</font>";
            HJCompoundMediator.isEnough = false;
         }
         else
         {
            _loc2_ = param1.count + "/" + param1.composeNum;
         }
         label.text = _loc2_;
         label.validate();
      }
   }
}
