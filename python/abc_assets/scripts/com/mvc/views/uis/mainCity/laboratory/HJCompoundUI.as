package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import feathers.controls.List;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.utils.AssetManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.mvc.views.mediator.mainCity.laboratory.HJCompoundMediator;
   
   public class HJCompoundUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var btn_compound:SwfButton;
      
      public var spr_compoundHJ:SwfSprite;
      
      public var tf_pay:TextField;
      
      public var list:List;
      
      private var targetBugleSpr:Sprite;
      
      private var targetBugleName:TextField;
      
      private var propVO:PropVO;
      
      public var bugleChipUnitVec:Vector.<com.mvc.views.uis.mainCity.laboratory.HJCompoundUnit>;
      
      public function HJCompoundUI()
      {
         bugleChipUnitVec = new Vector.<com.mvc.views.uis.mainCity.laboratory.HJCompoundUnit>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_compoundHJ = swf.createSprite("spr_compoundHJ");
         spr_compoundHJ.x = 370;
         spr_compoundHJ.y = 120;
         addChild(spr_compoundHJ);
         btn_compound = spr_compoundHJ.getButton("btn_compound");
         tf_pay = spr_compoundHJ.getTextField("tf_pay");
         tf_pay.text = "合成花费：100";
         createList();
      }
      
      public function createList() : void
      {
         list = new List();
         list.width = 160;
         list.height = 400;
         list.x = 30;
         list.y = 80;
         list.itemRendererProperties.height = 70;
         list.addEventListener("initialize",list_initializeHandler);
         spr_compoundHJ.addChild(list);
      }
      
      private function list_initializeHandler() : void
      {
         list.removeEventListener("initialize",list_initializeHandler);
         var _loc1_:AssetManager = LoadOtherAssetsManager.getInstance().assets;
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = new Scale9Textures(_loc1_.getTexture("alertBg"),new Rectangle(8,8,8,8));
         _loc2_.defaultSelectedValue = new Scale9Textures(_loc1_.getTexture("listBg"),new Rectangle(15,15,15,15));
         list.itemRendererProperties.stateToSkinFunction = _loc2_.updateValue;
      }
      
      public function showCompoundInfo(param1:PropVO) : void
      {
         propVO = GetPropFactor.getProp(param1.id);
         if(!propVO)
         {
            propVO = param1;
         }
         if(targetBugleSpr != null)
         {
            targetBugleSpr.removeEventListener("touch",targetBugleName_touchHandler);
            targetBugleSpr.removeFromParent(true);
         }
         targetBugleSpr = GetpropImage.getPropSpr(propVO);
         targetBugleSpr.x = 360;
         targetBugleSpr.y = 90;
         targetBugleSpr.addEventListener("touch",targetBugleName_touchHandler);
         spr_compoundHJ.addChild(targetBugleSpr);
         if(targetBugleName)
         {
            targetBugleName.removeFromParent(true);
         }
         targetBugleName = new TextField(150,30,propVO.name,"FZCuYuan-M03S",20,5516307);
         targetBugleName.autoScale = true;
         targetBugleName.x = targetBugleSpr.x - 15;
         targetBugleName.y = targetBugleSpr.y + targetBugleSpr.height;
         spr_compoundHJ.addChild(targetBugleName);
         showBugleChip(propVO);
      }
      
      private function targetBugleName_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(targetBugleSpr);
         if(_loc2_ && _loc2_.phase == "began")
         {
            FirstRchRewardTips.getInstance().showPropTips(propVO,targetBugleSpr);
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            FirstRchRewardTips.getInstance().removePropTips();
         }
      }
      
      private function showBugleChip(param1:PropVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         removeBugleChipUnit();
         HJCompoundMediator.isEnough = true;
         _loc3_ = 0;
         while(_loc3_ < param1.compNeedPropId.length)
         {
            _loc2_ = new com.mvc.views.uis.mainCity.laboratory.HJCompoundUnit();
            _loc2_.propVO = GetPropFactor.getPropVO(param1.compNeedPropId[_loc3_]);
            _loc2_.x = 210 + 110 * _loc3_;
            _loc2_.y = 240;
            spr_compoundHJ.addChild(_loc2_);
            bugleChipUnitVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function removeBugleChipUnit() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < bugleChipUnitVec.length)
         {
            if(bugleChipUnitVec[_loc1_])
            {
               bugleChipUnitVec[_loc1_].removeFromParent(true);
            }
            _loc1_++;
         }
         bugleChipUnitVec = new Vector.<com.mvc.views.uis.mainCity.laboratory.HJCompoundUnit>([]);
      }
   }
}
