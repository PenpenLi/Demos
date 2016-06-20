package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.ScrollContainer;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.VerticalLayout;
   import feathers.controls.Button;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class LaboratoryUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_laboratory:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var prompt:TextField;
      
      public var txtArr:Array;
      
      public var panel:ScrollContainer;
      
      public function LaboratoryUI()
      {
         txtArr = ["重置精灵","修改精灵昵称","神兽号角合成","技能回忆","精灵培训室","梦之研究","研究任务"];
         super();
         init();
         addPanel();
         addBtn();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_laboratory = swf.createSprite("spr_laboratoryBg");
         btn_close = spr_laboratory.getButton("btn_close");
         prompt = spr_laboratory.getTextField("prompt");
         addChild(spr_laboratory);
      }
      
      private function addPanel() : void
      {
         panel = new ScrollContainer();
         spr_laboratory.addChild(panel);
         panel.width = 610;
         panel.height = 535;
         panel.y = 100;
         panel.x = 425;
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 10;
         _loc1_.useVirtualLayout = false;
         panel.scrollBarDisplayMode = "none";
         panel.layout = _loc1_;
      }
      
      private function addBtn() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < txtArr.length)
         {
            _loc2_ = new Button();
            _loc2_.width = 550;
            _loc2_.label = txtArr[_loc1_];
            _loc2_.name = _loc1_.toString();
            panel.addChild(_loc2_);
            _loc2_.addEventListener("triggered",onclick);
            _loc1_++;
         }
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = (param1.target as Button).name;
         LogUtil(txtArr[_loc3_]);
         switch(_loc3_)
         {
            case 0:
               if(PlayerVO.lv < 32)
               {
                  Tips.show("玩家等级达到32级后开放");
                  return;
               }
               panel.visible = false;
               Facade.getInstance().sendNotification("switch_win",null,"load_resetelf_win");
               break;
            case 1:
               panel.visible = false;
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_SETNAME");
               break;
            case 2:
               _loc2_ = GetPropFactor.getBugleToCompound();
               if(_loc2_.length <= 0)
               {
                  Tips.show("亲，您还没有获得神兽号角碎片哦。");
                  return;
               }
               panel.visible = false;
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_HJCOMPOUND");
               Facade.getInstance().sendNotification("update_hjcompound_list",_loc2_);
               break;
            case 3:
               panel.visible = false;
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_RECALLSKILL");
               break;
            case 4:
               Tips.show("敬请期待");
               break;
            case 5:
               Tips.show("敬请期待");
            case 6:
               Tips.show("敬请期待");
               break;
            case 7:
               Tips.show("敬请期待");
               break;
         }
      }
   }
}
