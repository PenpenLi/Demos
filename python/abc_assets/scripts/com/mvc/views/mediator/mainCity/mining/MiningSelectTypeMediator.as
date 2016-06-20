package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.mining.MiningSelectTypeUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class MiningSelectTypeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningSelectTypeMediator";
      
      public static var selectType:int;
      
      public static var selectTime:int;
       
      public var miningSelectTypeUI:MiningSelectTypeUI;
      
      public function MiningSelectTypeMediator(param1:Object = null)
      {
         super("MiningSelectTypeMediator",param1);
         miningSelectTypeUI = param1 as MiningSelectTypeUI;
         miningSelectTypeUI.addEventListener("triggered",clickHandler);
         initFormationElfVec();
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(miningSelectTypeUI.btn_close !== _loc2_)
         {
            if(miningSelectTypeUI.btn_backBtn !== _loc2_)
            {
               if(miningSelectTypeUI.btn_coin !== _loc2_)
               {
                  if(miningSelectTypeUI.btn_sweet !== _loc2_)
                  {
                     if(miningSelectTypeUI.btn_doll !== _loc2_)
                     {
                        if(miningSelectTypeUI.selectTimeSpr.getButton("btn_type1") !== _loc2_)
                        {
                           if(miningSelectTypeUI.selectTimeSpr.getButton("btn_type2") !== _loc2_)
                           {
                              if(miningSelectTypeUI.selectTimeSpr.getButton("btn_type3") === _loc2_)
                              {
                                 selectTime = 12;
                                 loadSelectFormation();
                                 remove();
                              }
                           }
                           else
                           {
                              selectTime = 8;
                              loadSelectFormation();
                              remove();
                           }
                        }
                        else
                        {
                           selectTime = 4;
                           loadSelectFormation();
                           remove();
                        }
                     }
                     else
                     {
                        return Tips.show("敬请期待");
                     }
                  }
                  else
                  {
                     selectType = 2;
                     miningSelectTypeUI.showSelectTimeSpr("sweet");
                  }
               }
               else
               {
                  selectType = 1;
                  miningSelectTypeUI.showSelectTimeSpr("coin");
               }
            }
            else if(miningSelectTypeUI.selectTimeSpr)
            {
               miningSelectTypeUI.spr_selectType.visible = true;
               miningSelectTypeUI.selectTimeSpr.removeFromParent(true);
               miningSelectTypeUI.selectTimeSpr = null;
               miningSelectTypeUI.switchBtn(true);
            }
         }
         else
         {
            WinTweens.closeWin(miningSelectTypeUI.spr_miningSelect,remove);
         }
      }
      
      private function loadSelectFormation() : void
      {
         if(!facade.hasMediator("SelectFormationMedia"))
         {
            facade.registerMediator(new SelectFormationMedia(new SelectFormationUI()));
         }
         sendNotification("selectformation_init_type",initFormationElfVec(),"开矿");
         sendNotification("switch_win",miningSelectTypeUI,"LOAD_SERIES_FORMATION");
      }
      
      private function remove() : void
      {
         if(miningSelectTypeUI.selectTimeSpr)
         {
            miningSelectTypeUI.spr_selectType.visible = true;
            miningSelectTypeUI.selectTimeSpr.removeFromParent(true);
            miningSelectTypeUI.selectTimeSpr = null;
            miningSelectTypeUI.switchBtn(true);
         }
         miningSelectTypeUI.removeFromParent();
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      private function initFormationElfVec() : Vector.<ElfVO>
      {
         var _loc2_:* = 0;
         var _loc1_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc1_.push(null);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("MiningSelectTypeMediator");
         UI.dispose();
         viewComponent = null;
      }
   }
}
