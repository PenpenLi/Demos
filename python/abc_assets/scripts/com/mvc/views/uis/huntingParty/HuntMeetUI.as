package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.huntingParty.HuntingPartyMedia;
   import com.common.util.fighting.GotoChallenge;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.display.Quad;
   
   public class HuntMeetUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.huntingParty.HuntMeetUI;
       
      private var swf:Swf;
      
      public var spr_boss:SwfSprite;
      
      public var elfNameTF:TextField;
      
      public var btn_adventure:SwfButton;
      
      public var spr_meetElf:SwfSprite;
      
      public var elfNameTf:TextField;
      
      public var btn_fight:SwfButton;
      
      public var btn_flee:SwfButton;
      
      private var elfImage:Image;
      
      private var _elfVo:ElfVO;
      
      public function HuntMeetUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.huntingParty.HuntMeetUI
      {
         return instance || new com.mvc.views.uis.huntingParty.HuntMeetUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_boss = swf.createSprite("spr_boss");
         elfNameTF = spr_boss.getTextField("elfNameTF");
         btn_adventure = spr_boss.getButton("btn_adventure");
         elfNameTF = spr_boss.getTextField("elfNameTF");
         (spr_boss.getTextField("prompt2") as TextField).text = "1、捕捉的神兽会马上转化\n    为相应的积分！\n2、神兽节点每次活动开启\n    只有一次挑战机会！";
         spr_boss.x = 1136 - spr_boss.width >> 1;
         spr_boss.y = 640 - spr_boss.height >> 1;
         spr_meetElf = swf.createSprite("spr_meetElf");
         elfNameTf = spr_meetElf.getTextField("elfNameTf");
         btn_fight = spr_meetElf.getButton("btn_fight");
         btn_flee = spr_meetElf.getButton("btn_flee");
         spr_meetElf.x = 1136 - spr_meetElf.width >> 1;
         spr_meetElf.y = 640 - spr_meetElf.height >> 1;
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_adventure !== _loc2_)
         {
            if(btn_fight !== _loc2_)
            {
               if(btn_flee === _loc2_)
               {
                  remove();
               }
            }
            else
            {
               remove();
               loadFightUI();
            }
         }
         else
         {
            remove();
            loadFightUI();
         }
      }
      
      private function loadFightUI() : void
      {
         FightingConfig.sceneName = HuntingPartyMedia.nodeVO.scene;
         FightingConfig.fightingAI = 0;
         GotoChallenge.gotoChallenge(null,null,Vector.<ElfVO>([_elfVo]),true,null,null,true);
      }
      
      public function show(param1:ElfVO) : void
      {
         _elfVo = param1;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElfImg);
      }
      
      private function showElfImg() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVo.imgName));
         ElfFrontImageManager.getInstance().autoZoom(elfImage,320,true);
         if(_elfVo.rareValue >= 5)
         {
            elfImage.x = 210;
            elfImage.y = 250;
            elfNameTF.text = _elfVo.name;
            spr_boss.addChild(elfImage);
            addChild(spr_boss);
         }
         else
         {
            elfImage.x = 255;
            elfImage.y = 220;
            elfNameTf.text = "遇见了" + _elfVo.name;
            spr_meetElf.addChild(elfImage);
            addChild(spr_meetElf);
         }
         (Config.starling.root as Game).addChild(this);
      }
      
      public function remove() : void
      {
         removeFromParent(true);
         instance = null;
      }
   }
}
