package com.mvc.views.mediator.mainCity.myElf
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.myElf.EvolveMcUI;
   import com.common.events.EventCenter;
   import extend.SoundEvent;
   import com.mvc.models.vos.login.PlayerVO;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   
   public class EvolveMcMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "EvolveMcMediator";
      
      public static var evolvoElfVo:ElfVO;
       
      public var evolveMcUI:EvolveMcUI;
      
      public function EvolveMcMediator(param1:Object = null)
      {
         super("EvolveMcMediator",param1);
         evolveMcUI = param1 as EvolveMcUI;
         EventCenter.addEventListener("elf_evolve_mc_complete",evolve_mc_completeHandler);
      }
      
      private function evolve_mc_completeHandler() : void
      {
         EventCenter.removeEventListener("elf_evolve_mc_complete",evolve_mc_completeHandler);
         sendNotification("switch_win",null);
         SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","mainCity");
         dispose();
         PlayerVO.isAcceptPvp = true;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("send_elf_to_evolveMc" === _loc2_)
         {
            evolveMcUI.createEvolveImg(evolvoElfVo);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["send_elf_to_evolveMc"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         var _loc2_:* = 0;
         var _loc1_:Game = Config.starling.root as Game;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc1_.getChildAt(_loc2_).visible = true;
            _loc2_++;
         }
         UI.removeFromParent(true);
         facade.removeMediator("EvolveMcMediator");
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.elfEvolveMcAssets);
         LoadOtherAssetsManager.getInstance().removeAsset(Config.elfEvolveMusicAssets,true);
         GetElfFactor.gotoEvolve();
      }
   }
}
