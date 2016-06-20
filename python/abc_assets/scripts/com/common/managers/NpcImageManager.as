package com.common.managers
{
   import com.common.events.EventCenter;
   
   public class NpcImageManager
   {
      
      private static var instance:com.common.managers.NpcImageManager;
       
      private var NpcImage:Array;
      
      private var mQueue:Array;
      
      public function NpcImageManager()
      {
         NpcImage = [];
         mQueue = [];
         super();
      }
      
      public static function getInstance() : com.common.managers.NpcImageManager
      {
         return instance || new com.common.managers.NpcImageManager();
      }
      
      public function getImg(param1:Array, param2:Function) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = true;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(LoadOtherAssetsManager.getInstance().assets.getTexture(param1[_loc3_]) == null)
            {
               _loc4_ = false;
            }
            else
            {
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         trace(_loc4_ + "NPC纹理" + param1);
         if(_loc4_)
         {
            return;
            §§push(param2());
         }
         else if(mQueue.length > 0)
         {
            mQueue.push([param1,param2]);
            return;
            §§push(LogUtil("NPC有在一直添加吗" + mQueue));
         }
         else
         {
            mQueue.push([param1,param2]);
            loadNpcAssets(param1,param2);
            return;
         }
      }
      
      private function loadNpcAssets(param1:Array, param2:Function) : void
      {
         textureName = param1;
         _callBack = param2;
         var addNpcComplete:Function = function():void
         {
            Config.starling.root.touchable = true;
            EventCenter.removeEventListener("load_other_asset_complete",addNpcComplete);
            _callBack();
            mQueue.shift();
            LogUtil("加载NPC队列长度" + mQueue.length);
            if(mQueue.length > 0)
            {
               loadNpcAssets(mQueue[0][0],mQueue[0][1]);
            }
         };
         Config.starling.root.touchable = false;
         EventCenter.addEventListener("load_other_asset_complete",addNpcComplete);
         var isExist:Boolean = true;
         var i:int = 0;
         while(i < textureName.length)
         {
            if(LoadOtherAssetsManager.getInstance().assets.getTexture(textureName[i]) == null)
            {
               isExist = false;
            }
            if(NpcImage.indexOf(textureName[i]) == -1)
            {
               NpcImage.push(textureName[i]);
            }
            i = i + 1;
         }
         if(isExist)
         {
            return;
            §§push(addNpcComplete());
         }
         else
         {
            LoadOtherAssetsManager.getInstance().addNpcAssets(textureName,true);
            return;
         }
      }
      
      public function dispose() : void
      {
         LogUtil(NpcImage + "释放NPC纹理");
         LoadOtherAssetsManager.getInstance().removeAsset(NpcImage,false);
         NpcImage = [];
         mQueue = [];
      }
   }
}
