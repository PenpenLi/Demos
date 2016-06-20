package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.DisplayObject;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.SomeFontHandler;
   import com.common.util.strHandler.StrHandle;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import starling.display.Quad;
   
   public class CarryThingUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.CarryThingUI;
       
      private var swf:Swf;
      
      private var spr_carry:SwfSprite;
      
      private var btn_close:SwfButton;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var carryList:List;
      
      public function CarryThingUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.CarryThingUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.CarryThingUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_carry = swf.createSprite("spr_carry");
         btn_close = spr_carry.getButton("btn_close");
         spr_carry.x = 1136 - spr_carry.width >> 1;
         spr_carry.y = 20;
         addChild(spr_carry);
         btn_close.addEventListener("triggered",onClose);
      }
      
      private function addList() : void
      {
         carryList = new List();
         carryList.width = 750;
         carryList.height = 485;
         carryList.x = 15;
         carryList.y = 98;
         carryList.isSelectable = false;
         spr_carry.addChild(carryList);
      }
      
      public function show() : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ < GetPropFactor.carryVec.length)
         {
            _loc6_ = swf.createButton("btn_carry");
            _loc6_.name = _loc5_.toString();
            _loc3_ = GetpropImage.getPropSpr(GetPropFactor.carryVec[_loc5_],false);
            _loc2_ = SomeFontHandler.setColoeSize(GetPropFactor.carryVec[_loc5_].name,35,9);
            _loc6_.addEventListener("triggered",carry);
            _loc1_.push({
               "icon":_loc3_,
               "label":_loc2_ + "数量:" + GetPropFactor.carryVec[_loc5_].count + " \n" + StrHandle.lineFeed(GetPropFactor.carryVec[_loc5_].describe,20,"\n",24),
               "accessory":_loc6_
            });
            displayVec.push(_loc3_);
            displayVec.push(_loc6_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         carryList.dataProvider = _loc4_;
      }
      
      private function carry(param1:Event) : void
      {
         var _loc2_:int = (param1.target as SwfButton).name;
         var _loc3_:PropVO = GetPropFactor.carryVec[_loc2_];
         _loc3_.isUsed = false;
         LogUtil("carryVo==" + _loc3_.name);
         Facade.getInstance().sendNotification("SEND_USE_PROP",_loc3_,"直接使用");
      }
      
      public function onClose() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
            Facade.getInstance().sendNotification("SET_CURRENTPROP_NULL");
         }
      }
   }
}
