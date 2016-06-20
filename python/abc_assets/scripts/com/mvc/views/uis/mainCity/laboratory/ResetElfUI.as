package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ResetElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_putElf:SwfSprite;
      
      public var btn_seleElf:SwfButton;
      
      public var btn_resetBtn:SwfButton;
      
      public var btn_return:SwfButton;
      
      public var spr_resetElf:SwfSprite;
      
      public var _elfVO:ElfVO;
      
      public var selectElfImg:Image;
      
      public var tf_tips:TextField;
      
      public function ResetElfUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_resetElf = swf.createSprite("spr_resetElf");
         spr_resetElf.x = 370;
         spr_resetElf.y = 120;
         addChild(spr_resetElf);
         spr_putElf = spr_resetElf.getSprite("spr_putElf");
         spr_putElf.visible = false;
         btn_seleElf = spr_resetElf.getButton("btn_seleElf");
         btn_resetBtn = spr_resetElf.getButton("btn_resetBtn");
         btn_return = spr_resetElf.getButton("btn_return");
         btn_return.visible = false;
         tf_tips = spr_resetElf.getTextField("tf_tips");
         tf_tips.hAlign = "center";
         tf_tips.autoScale = true;
         tf_tips.text = "重置精灵时返还培养所消耗的部分道具和金币\n重置mega精灵只返还50%资源\n精灵重置后，恢复到获得时的形态\n背包、训练中、防守、采矿中精灵不能重置。";
      }
      
      public function showElfImg(param1:ElfVO) : void
      {
         spr_putElf.visible = true;
         btn_seleElf.visible = false;
         _elfVO = param1;
         AniFactor.ifOpen = true;
         if(selectElfImg)
         {
            ElfFrontImageManager.getInstance().disposeImg(selectElfImg);
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
      }
      
      private function showElf() : void
      {
         selectElfImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(selectElfImg,190,true,20);
         selectElfImg.addEventListener("touch",selectElfImg_touchHandler);
         spr_putElf.addChild(selectElfImg);
         AniFactor.elfAni(selectElfImg);
      }
      
      private function selectElfImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(selectElfImg);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            Facade.getInstance().sendNotification("switch_win",this,"load_resetelf_select_com_elf");
            selectElfImg.removeEventListener("touch",selectElfImg_touchHandler);
         }
      }
      
      public function removeElfAndSwitchBtn() : void
      {
         ElfFrontImageManager.getInstance().disposeImg(selectElfImg);
         spr_putElf.visible = false;
         btn_seleElf.visible = true;
         _elfVO = null;
      }
   }
}
