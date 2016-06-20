package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   import flash.geom.Rectangle;
   
   public class FinallyUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.FinallyUI;
       
      private var spr_finally:SwfSprite;
      
      private var totalHpFinal:TextField;
      
      private var AttackFinal:TextField;
      
      private var DefenseFinal:TextField;
      
      private var super_attackFinal:TextField;
      
      private var spuer_defenseFinal:TextField;
      
      private var speedFinal:TextField;
      
      private var elfName:TextField;
      
      private var starImg:SwfSprite;
      
      private var swf:Swf;
      
      private var rare:TextField;
      
      private var image:Image;
      
      public function FinallyUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.FinallyUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.FinallyUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_finally = swf.createSprite("spr_finally");
         starImg = spr_finally.getSprite("starImg");
         elfName = spr_finally.getTextField("elfName");
         totalHpFinal = spr_finally.getTextField("totalHp");
         AttackFinal = spr_finally.getTextField("Attack");
         DefenseFinal = spr_finally.getTextField("Defense");
         super_attackFinal = spr_finally.getTextField("super_attack");
         spuer_defenseFinal = spr_finally.getTextField("spuer_defense");
         speedFinal = spr_finally.getTextField("speed");
         rare = spr_finally.getTextField("rare");
         addChild(spr_finally);
      }
      
      public function show(param1:ElfVO, param2:int, param3:Sprite) : void
      {
         LogUtil("添加最终阶段的界面 = ",param1.name,MyElfMedia.pageType,param2,param3);
         if(MyElfMedia.pageType != param2)
         {
            return;
         }
         if(this.parent)
         {
            this.removeFromParent();
         }
         if(image)
         {
            image.removeFromParent(true);
            image = null;
         }
         LogUtil(param1.imgName + "找不到的纹理");
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(param1.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,160,true);
         image.x = 170;
         image.y = 130;
         addChild(image);
         elfName.text = param1.nickName;
         elfName.color = 15565568;
         totalHpFinal.text = param1.totalHp;
         AttackFinal.text = param1.attack;
         DefenseFinal.text = param1.defense;
         super_attackFinal.text = param1.super_attack;
         spuer_defenseFinal.text = param1.super_defense;
         speedFinal.text = param1.speed;
         rare.text = param1.rare;
         starImg.visible = false;
         switch(param2 - 1)
         {
            case 0:
               this.y = 50;
               break;
            case 1:
               this.y = 50;
               elfName.text = param1.nickName + "Max";
               elfName.color = ElfBreakUI.getInstance().brokenColor[param1.brokenLv + 1];
               break;
            case 2:
               starImg.visible = true;
               starImg.clipRect = new Rectangle(0,0,MyElfUI.starWidth * param1.starts,starImg.height);
               this.y = 80;
               break;
         }
         this.x = param3.width - this.width >> 1;
         param3.addChild(this);
         return;
         §§push(LogUtil("最终添加子在这里==========",param3));
      }
      
      public function cleanImg() : void
      {
         if(image)
         {
            image.removeFromParent(true);
            image = null;
         }
      }
   }
}
