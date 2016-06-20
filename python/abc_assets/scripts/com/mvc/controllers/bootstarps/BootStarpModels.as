package com.mvc.controllers.bootstarps
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.mvc.models.proxy.mainCity.elfCenter.ElfCenterPro;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import com.mvc.models.proxy.mainCity.friend.FriendPro;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.models.proxy.mainCity.playerInfo.PlayInfoPro;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.mvc.models.proxy.mainCity.active.ActivePro;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import com.mvc.models.proxy.mainCity.miracle.MiraclePro;
   import com.mvc.models.proxy.mainCity.rankList.RankListPro;
   import com.mvc.models.proxy.mainCity.growthPlan.GrowthPlanPro;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   import com.mvc.models.proxy.mainCity.exChange.ExChangePro;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import com.mvc.models.proxy.mainCity.lotteryUi.LotteryPro;
   
   public class BootStarpModels extends SimpleCommand
   {
       
      public function BootStarpModels()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new HomePro());
         facade.registerProxy(new MyElfPro());
         facade.registerProxy(new BackPackPro());
         facade.registerProxy(new IllustrationsPro());
         facade.registerProxy(new ElfCenterPro());
         facade.registerProxy(new InformationPro());
         facade.registerProxy(new FriendPro());
         facade.registerProxy(new ShopPro());
         facade.registerProxy(new TaskPro());
         facade.registerProxy(new ChatPro());
         facade.registerProxy(new PlayInfoPro());
         facade.registerProxy(new AmusePro());
         facade.registerProxy(new KingKwanPro());
         facade.registerProxy(new ElfSeriesPro());
         facade.registerProxy(new MapPro());
         facade.registerProxy(new FightingPro());
         facade.registerProxy(new ActivePro());
         facade.registerProxy(new PVPPro());
         facade.registerProxy(new SignPro());
         facade.registerProxy(new TrainPro());
         facade.registerProxy(new TrialPro());
         facade.registerProxy(new MiraclePro());
         facade.registerProxy(new RankListPro());
         facade.registerProxy(new GrowthPlanPro());
         facade.registerProxy(new HuntingPro());
         facade.registerProxy(new AuctionPro());
         facade.registerProxy(new UnionPro());
         facade.registerProxy(new SpecialActPro());
         facade.registerProxy(new ExChangePro());
         facade.registerProxy(new MiningPro());
         facade.registerProxy(new HuntingPartyPro());
         facade.registerProxy(new LotteryPro());
      }
   }
}
