package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.SomeFontHandler;
   import com.common.util.strHandler.StrHandle;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Quad;
   
   public class HagberryUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.HagberryUI;
       
      private var swf:Object;
      
      private var spr_hagberry:SwfSprite;
      
      private var btn_close:SwfButton;
      
      private var hagberryList:List;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function HagberryUI()
      {
         displayVec = new Vector.<DisplayObject>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.HagberryUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.HagberryUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_hagberry = swf.createSprite("spr_hagberry");
         btn_close = spr_hagberry.getButton("btn_close");
         spr_hagberry.x = 1136 - spr_hagberry.width >> 1;
         spr_hagberry.y = 20;
         addChild(spr_hagberry);
         btn_close.addEventListener("triggered",onClose);
      }
      
      public function onClose() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
            Facade.getInstance().sendNotification("SET_CURRENTPROP_NULL");
         }
      }
      
      private function addList() : void
      {
         hagberryList = new List();
         hagberryList.width = 750;
         hagberryList.height = 485;
         hagberryList.x = 15;
         hagberryList.y = 98;
         hagberryList.isSelectable = false;
         spr_hagberry.addChild(hagberryList);
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
         while(_loc5_ < GetPropFactor.hagberryVec.length)
         {
            _loc6_ = swf.createButton("btn_carry");
            _loc6_.name = _loc5_.toString();
            _loc3_ = GetpropImage.getPropSpr(GetPropFactor.hagberryVec[_loc5_],false);
            _loc2_ = SomeFontHandler.setColoeSize(GetPropFactor.hagberryVec[_loc5_].name,35,9);
            _loc6_.addEventListener("triggered",carry);
            _loc1_.push({
               "icon":_loc3_,
               "label":_loc2_ + "数量:" + GetPropFactor.hagberryVec[_loc5_].count + " \n" + StrHandle.lineFeed(GetPropFactor.hagberryVec[_loc5_].describe,23,"\n",24),
               "accessory":_loc6_
            });
            displayVec.push(_loc3_);
            displayVec.push(_loc6_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         hagberryList.dataProvider = _loc4_;
      }
      
      private function carry(param1:Event) : void
      {
         var _loc3_:int = (param1.target as SwfButton).name;
         var _loc2_:PropVO = GetPropFactor.hagberryVec[_loc3_];
         _loc2_.isUsed = false;
         LogUtil("carryVo==" + _loc2_.name);
         Facade.getInstance().sendNotification("SEND_USE_PROP",_loc2_,"直接使用");
      }
   }
}
