package com.mvc.views.uis.mainCity.perfer
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mainCity.specialAct.PreferVO;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PreferList extends Sprite
   {
       
      private var swf:Swf;
      
      private var img_equle:SwfImage;
      
      private var _preferVo:PreferVO;
      
      private var propUnitVec:Vector.<com.mvc.views.uis.mainCity.perfer.PreferPropUnit>;
      
      private var remainTxt:TextField;
      
      private var isPropPass:Boolean = true;
      
      private var isDiaPass:Boolean = true;
      
      public var index:int;
      
      public function PreferList()
      {
         propUnitVec = new Vector.<com.mvc.views.uis.mainCity.perfer.PreferPropUnit>([]);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("preferential");
         img_equle = swf.createImage("img_equle");
         img_equle.x = 220;
         img_equle.y = 35;
         addChild(img_equle);
      }
      
      public function set myPreferVo(param1:PreferVO) : void
      {
         var _loc5_:* = 0;
         var _loc7_:* = null;
         var _loc6_:* = 0;
         var _loc8_:* = null;
         var _loc3_:* = null;
         _preferVo = param1;
         propUnitVec = Vector.<com.mvc.views.uis.mainCity.perfer.PreferPropUnit>([]);
         _loc5_ = 0;
         while(_loc5_ < param1.costArr.length)
         {
            _loc7_ = new com.mvc.views.uis.mainCity.perfer.PreferPropUnit(false,0.85);
            _loc7_.handle(param1.costArr[_loc5_]);
            _loc7_.x = 102 * _loc5_ + 3;
            _loc7_.y = 4;
            addChild(_loc7_);
            propUnitVec.push(_loc7_);
            if(!_loc7_.isPropPass)
            {
               isPropPass = false;
            }
            if(!_loc7_.isDiaPass)
            {
               isDiaPass = false;
            }
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < param1.rewardArr.length)
         {
            _loc8_ = new com.mvc.views.uis.mainCity.perfer.PreferPropUnit(true,0.85);
            _loc8_.handle(param1.rewardArr[_loc6_]);
            _loc8_.x = img_equle.x + img_equle.width + 17 + 102 * _loc6_;
            _loc8_.y = 4;
            addChild(_loc8_);
            _loc6_++;
         }
         var _loc2_:Sprite = new Sprite();
         var _loc4_:String = param1.remainCount;
         remainTxt = new TextField(150,30,"剩余次数:" + _loc4_,"FZCuYuan-M03S",20,9713664);
         remainTxt.autoScale = true;
         if(param1.state == 2)
         {
            _loc3_ = swf.createButton("btn_btnBug");
         }
         else
         {
            _loc3_ = swf.createButton("btn_btnExchange");
         }
         _loc3_.name = _loc5_.toString();
         _loc2_.addChild(_loc3_);
         _loc3_.y = 7;
         remainTxt.y = _loc3_.height + 5;
         _loc2_.addChild(remainTxt);
         _loc3_.addEventListener("triggered",clickEvent);
         _loc2_.x = 735;
         addChild(_loc2_);
      }
      
      private function clickEvent(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!isPropPass)
         {
            return Tips.show("道具不足");
         }
         if(!isDiaPass)
         {
            return Tips.show("钻石不足");
         }
         if(_preferVo.remainCount > 0)
         {
            if(_preferVo.state == 2)
            {
               _loc2_ = "亲，确定要购买么？";
            }
            else
            {
               _loc2_ = "亲，确定要兑换么？";
            }
            _loc3_ = Alert.show(_loc2_,"温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc3_.addEventListener("close",preferAlertHander);
         }
         else if(_preferVo.state == 2)
         {
            Tips.show("购买次数已用完");
         }
         else
         {
            Tips.show("兑换次数已用完");
         }
      }
      
      private function preferAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (Facade.getInstance().retrieveProxy("SpecialActivePro") as SpecialActPro).write1913(_preferVo,index);
         }
      }
   }
}
