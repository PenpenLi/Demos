package com.mvc.views.mediator.mainCity.home
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.home.BagElfUI;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.display.DisplayObject;
   
   public class BagElfMedia extends Mediator
   {
      
      public static const NAME:String = "BagElfMedia";
      
      public static var seleNum:int;
       
      private var bagElf:BagElfUI;
      
      public function BagElfMedia(param1:Object = null)
      {
         super("BagElfMedia",param1);
         bagElf = param1 as BagElfUI;
         bagElf.addEventListener("triggered",clickHandler);
         createBagElf();
         seleNum = 0;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc8_:* = undefined;
         var _loc7_:* = 0;
         var _loc9_:* = param1.target;
         if(bagElf.putComputerBtn !== _loc9_)
         {
            if(bagElf.lockBtn === _loc9_)
            {
               if(BagElfMedia.seleNum == 0 && ComElfMedia.seleNum == 0)
               {
                  Tips.show("你还未选择精灵");
                  return;
               }
               _loc2_ = [];
               _loc6_ = [];
               if(BagElfMedia.seleNum)
               {
                  _loc5_ = 0;
                  while(_loc5_ < bagElf.bagContainVec.length)
                  {
                     if(bagElf.bagContainVec[_loc5_].tick.visible)
                     {
                        if(bagElf.bagContainVec[_loc5_]._elfVO.isLock)
                        {
                           _loc4_++;
                           _loc2_.push(bagElf.bagContainVec[_loc5_]._elfVO.id);
                        }
                        else
                        {
                           _loc3_++;
                           _loc6_.push(bagElf.bagContainVec[_loc5_]._elfVO.id);
                        }
                     }
                     _loc5_++;
                  }
               }
               if(ComElfMedia.seleNum)
               {
                  _loc8_ = (facade.retrieveMediator("ComElfMedia") as ComElfMedia).comContainVec;
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_.length)
                  {
                     if(_loc8_[_loc7_].tick.visible)
                     {
                        if(_loc8_[_loc7_]._elfVO.isLock)
                        {
                           _loc4_++;
                           _loc2_.push(_loc8_[_loc7_]._elfVO.id);
                        }
                        else
                        {
                           _loc3_++;
                           _loc6_.push(_loc8_[_loc7_]._elfVO.id);
                        }
                     }
                     _loc7_++;
                  }
               }
               if(_loc4_ && _loc3_)
               {
                  return Tips.show("不能同时选择锁定跟非锁定精灵哦");
               }
               if(_loc4_)
               {
                  (facade.retrieveProxy("HomePro") as HomePro).write2030(_loc2_);
               }
               else
               {
                  (facade.retrieveProxy("HomePro") as HomePro).write2029(_loc6_);
               }
            }
         }
         else
         {
            sendCom();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.getName();
         if("SHOW_BAG_ELF" !== _loc3_)
         {
            if("CLEAN_BAG_TICK" !== _loc3_)
            {
               if("home_update_bagelf_lock" === _loc3_)
               {
                  _loc2_ = 0;
                  while(_loc2_ < bagElf.bagContainVec.length)
                  {
                     if(bagElf.bagContainVec[_loc2_].tick.visible)
                     {
                        bagElf.bagContainVec[_loc2_].tick.visible = false;
                        PlayerVO.bagElfVec[_loc2_].isLock = !PlayerVO.bagElfVec[_loc2_].isLock;
                        bagElf.bagContainVec[_loc2_].switchLock();
                     }
                     _loc2_++;
                  }
                  BagElfMedia.seleNum = 0;
               }
            }
            else
            {
               cleanBagTick();
            }
         }
         else
         {
            createBagElf();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_BAG_ELF","CLEAN_BAG_TICK","home_update_bagelf_lock"];
      }
      
      public function createBagElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               bagElf.bagContainVec[_loc1_].myElfVo = PlayerVO.bagElfVec[_loc1_];
               bagElf.bagContainVec[_loc1_].switchContain(true);
            }
            else
            {
               bagElf.bagContainVec[_loc1_].hideImg();
               bagElf.bagContainVec[_loc1_].switchContain(false);
            }
            _loc1_++;
         }
         if(PlayerVO.pokeSpace < 6)
         {
            _loc2_ = PlayerVO.pokeSpace;
            while(_loc2_ < 6)
            {
               bagElf.bagContainVec[_loc2_].addLockIcon();
               _loc2_++;
            }
         }
         cleanBagTick();
      }
      
      public function sendCom() : void
      {
         var _loc1_:* = 0;
         if(seleNum == 0)
         {
            Tips.show("你还未选择精灵");
            return;
         }
         if(seleNum > PlayerVO.cpSpace - PlayerVO.comElfVec.length)
         {
            Tips.show("电脑空位不足");
            return;
         }
         if(cross())
         {
            Tips.show("至少留一个");
            return;
         }
         if(seleNum == 0)
         {
            Tips.show("你还未选择精灵");
            return;
         }
         seleNum = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            if(bagElf.bagContainVec[_loc1_].tick.visible)
            {
               PlayerVO.bagElfVec[_loc1_].isCarry = 0;
               PlayerVO.comElfVec.push(PlayerVO.bagElfVec[_loc1_]);
               PlayerVO.bagElfVec[_loc1_] = null;
            }
            _loc1_++;
         }
         seiri();
         sendNotification("SHOW_COM_ELF");
         sendNotification("CLEAN_ELFINFO_CLOSE");
         (facade.retrieveProxy("HomePro") as HomePro).write2002();
      }
      
      public function seiri() : void
      {
         GetElfFactor.seiri();
         createBagElf();
      }
      
      public function cross() : Boolean
      {
         var _loc3_:* = 0;
         var _loc1_:* = false;
         var _loc2_:* = 0;
         LogUtil("seleNum=" + seleNum);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         if(seleNum > _loc3_ - 1)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function cleanBagTick() : void
      {
         var _loc1_:* = 0;
         seleNum = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            bagElf.bagContainVec[_loc1_].tick.visible = false;
            _loc1_++;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function cleanBag() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < bagElf.bagContainVec.length)
         {
            bagElf.bagContainVec[_loc1_].hideImg();
            bagElf.bagContainVec.splice(_loc1_,1);
         }
         bagElf.bagContainVec = null;
      }
      
      public function dispose() : void
      {
         LogUtil("清除背包精灵");
         cleanBag();
         facade.removeMediator("BagElfMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
