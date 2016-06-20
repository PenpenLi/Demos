package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.trial.TrialMediator;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class TrialDifficultyBtnUnit extends Sprite
   {
       
      private var swf:Swf;
      
      public var btn_difficulty:SwfButton;
      
      private var tf_difficultyLv:TextField;
      
      private var tf_openLv:TextField;
      
      private var elfImage:Image;
      
      private var imgName:String;
      
      public function TrialDifficultyBtnUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         btn_difficulty = swf.createButton("btn_difficulty");
         addChild(btn_difficulty);
         tf_difficultyLv = (btn_difficulty.skin as Sprite).getChildByName("tf_difficultyLv") as TextField;
         tf_openLv = (btn_difficulty.skin as Sprite).getChildByName("tf_openLv") as TextField;
      }
      
      public function setDifficultyBtn(param1:int, param2:int) : void
      {
         tf_difficultyLv.text = TrialMediator.bossVoVec[param1].difficultyVec[param2].difficultyLv;
         tf_openLv.text = "（" + TrialMediator.bossVoVec[param1].difficultyVec[param2].openLv + "级开放）";
      }
      
      public function setElfImg(param1:String) : void
      {
         imgName = "img_" + param1;
         ElfFrontImageManager.getInstance().getImg(["img_" + param1],showElf);
      }
      
      private function showElf() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         ElfFrontImageManager.getInstance().autoZoom(elfImage,150,true,20);
         elfImage.y = elfImage.y + btn_difficulty.height * 0.25;
         (btn_difficulty.skin as Sprite).addChild(elfImage);
      }
      
      public function destructImg() : void
      {
         if(elfImage)
         {
            elfImage.removeFromParent(true);
            elfImage = null;
         }
      }
   }
}
