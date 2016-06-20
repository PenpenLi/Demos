package com.mvc.views.uis.mainCity.growthPlan
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import feathers.data.ListCollection;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.DisposeDisplay;
   import starling.text.TextField;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.growthPlan.GrowthPlanPro;
   
   public class GrowthPlanUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var btn_close:SwfButton;
      
      public var btn_buy:SwfButton;
      
      public var img_alearyBuyImg:Image;
      
      public var spr_growthPlan:SwfSprite;
      
      public var planData:ListCollection;
      
      public var planList:List;
      
      private var planArr:Array;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public var getSprVec:Vector.<SwfSprite>;
      
      public function GrowthPlanUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         getSprVec = new Vector.<SwfSprite>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("growthPlan");
         spr_growthPlan = swf.createSprite("spr_growthPlan");
         spr_growthPlan.x = (1136 - spr_growthPlan.width >> 1) + 30;
         spr_growthPlan.y = 640 - spr_growthPlan.height >> 1;
         addChild(spr_growthPlan);
         btn_close = spr_growthPlan.getButton("btn_close");
         btn_buy = spr_growthPlan.getButton("btn_buy");
         img_alearyBuyImg = spr_growthPlan.getImage("alearyBuyImg");
         planArr = [300,350,450,500,550,600,650,700,800,980];
         createPlanList();
      }
      
      private function createPlanList() : void
      {
         planList = new List();
         planList.x = 15;
         planList.y = 243;
         planList.height = 275;
         planList.width = 730;
         planList.isSelectable = false;
         planList.itemRendererProperties.paddingLeft = 0;
         planList.itemRendererProperties.paddingTop = 0;
         planData = new ListCollection();
         planList.dataProvider = planData;
         addListData();
      }
      
      private function addListData() : void
      {
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc1_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc6_:int = planArr.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = swf.createSprite("spr_list_icon");
            _loc4_ = _loc2_.getTextField("tf_fundTittle");
            _loc4_.text = 30 + _loc7_ * 5 + "级成长基金";
            _loc5_ = _loc2_.getTextField("tf_lv");
            _loc5_.text = 30 + _loc7_ * 5 + "级";
            _loc3_ = _loc2_.getTextField("tf_getDiamond");
            _loc3_.text = planArr[_loc7_];
            _loc8_ = swf.createSprite("spr_list_btn");
            _loc1_ = _loc8_.getButton("btn_getBtn");
            _loc1_.name = _loc7_;
            _loc1_.addEventListener("triggered",getBtn_triggeredHandler);
            planData.push({
               "label":"",
               "icon":_loc2_,
               "accessory":_loc8_
            });
            displayVec.push(_loc2_);
            displayVec.push(_loc8_);
            getSprVec.push(_loc8_);
            _loc7_++;
         }
      }
      
      private function getBtn_triggeredHandler(param1:Event) : void
      {
         var _loc2_:int = (param1.target as SwfButton).name;
         (Facade.getInstance().retrieveProxy("GrowthPlanPro") as GrowthPlanPro).write1905(_loc2_);
      }
   }
}
