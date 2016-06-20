package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadSwfAssetsManager;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.backPack.PlayElfMedia;
   import com.mvc.views.uis.mainCity.backPack.PlayElfUI;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.themes.Tips;
   
   public class CarryPropUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var propBg:SwfImage;
      
      private var rootClass:Game;
      
      private var btn_addFruit:SwfButton;
      
      private var _type:int;
      
      private var image:Sprite;
      
      private var _propVo:PropVO;
      
      private var hagberryIcon:SwfImage;
      
      private var carryIcon:SwfImage;
      
      public function CarryPropUI(param1:int)
      {
         super();
         _type = param1;
         rootClass = Config.starling.root as Game;
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         propBg = swf.createImage("img_propBg");
         var _loc1_:* = 0.8;
         propBg.scaleY = _loc1_;
         propBg.scaleX = _loc1_;
         btn_addFruit = swf.createButton("btn_addFruit_b");
         addChild(propBg);
         if(_type == 0)
         {
            hagberryIcon = swf.createImage("img_HagberryShadow");
            hagberryIcon.x = this.width - hagberryIcon.width >> 1;
            hagberryIcon.y = this.height - hagberryIcon.height >> 1;
            hagberryIcon.alpha = 0.5;
            addChild(hagberryIcon);
         }
         else if(_type == 1)
         {
            carryIcon = swf.createImage("img_carryShadow");
            carryIcon.x = this.width - carryIcon.width >> 1;
            carryIcon.y = this.height - carryIcon.height >> 1;
            carryIcon.alpha = 0.5;
            addChild(carryIcon);
         }
         btn_addFruit.x = this.width - btn_addFruit.width >> 1;
         btn_addFruit.y = this.height - btn_addFruit.height >> 1;
         addChild(btn_addFruit);
         btn_addFruit.addEventListener("triggered",carryProp);
         if(!Facade.getInstance().hasMediator("PlayElfMedia"))
         {
            Facade.getInstance().registerMediator(new PlayElfMedia(new PlayElfUI()));
         }
      }
      
      public function set myProp(param1:PropVO) : void
      {
         _propVo = param1;
         if(param1)
         {
            btn_addFruit.visible = false;
            show(false);
            if(image)
            {
               GetpropImage.clean(image);
            }
            image = GetpropImage.getPropSpr(param1,false,0.8);
            image.x = this.width - image.width >> 1;
            image.y = this.height - image.height >> 1;
            addChild(image);
            addEventListener("touch",ontouch);
         }
         else
         {
            GetpropImage.clean(image);
            image = null;
            show(true);
         }
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            carryProp();
         }
      }
      
      private function carryProp() : void
      {
         if(image)
         {
            if(_propVo.type == 16 || _propVo.type == 17)
            {
               (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3004(PlayerVO.bagElfVec[MyElfMedia.currentElfIndex],_propVo);
               return;
            }
         }
         if(_type == 0)
         {
            if(GetPropFactor.getHagberry())
            {
               Facade.getInstance().sendNotification("SEND_ELFSELECT_ELF",PlayerVO.bagElfVec[MyElfMedia.currentElfIndex]);
               HagberryUI.getInstance().show();
               rootClass.addChild(HagberryUI.getInstance());
            }
            else
            {
               Tips.show("背包里面还没有树果哦");
            }
         }
         if(_type == 1)
         {
            if(GetPropFactor.getCarry())
            {
               Facade.getInstance().sendNotification("SEND_ELFSELECT_ELF",PlayerVO.bagElfVec[MyElfMedia.currentElfIndex]);
               CarryThingUI.getInstance().show();
               rootClass.addChild(CarryThingUI.getInstance());
            }
            else
            {
               Tips.show("背包里面还没有可以携带的物品哦");
            }
         }
      }
      
      public function cleanImg() : void
      {
         if(image)
         {
            GetpropImage.clean(image);
            image = null;
         }
         show(true);
      }
      
      private function show(param1:Boolean) : void
      {
         btn_addFruit.visible = param1;
         if(_type == 0)
         {
            hagberryIcon.visible = param1;
         }
         else
         {
            carryIcon.visible = param1;
         }
      }
   }
}
