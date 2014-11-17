#ifndef MOF_MYSTICMERCHANTMGR_H
#define MOF_MYSTICMERCHANTMGR_H

class MySticMerchantMgr{
public:
	void getMySticMerchantDataByIndex(int,int);
	void getMySticMerchantPropsDataIndex(int,int);
	void ackUpMysteriousList(int,int,int);
	void reqBuyMysteriousGoods(int,int,int);
	void comparePropsByLvl(MysteriousInfo, MysteriousInfo);
	void getMySticMerchantDataIndex(int, int);
	void ackBuyMysteriousExchangelist(int, std::vector<obj_mysterious, std::allocator<obj_mysterious>>);
	void ackBuyMysteriousSpeciallist(int, std::vector<obj_mysterious, std::allocator<obj_mysterious>>);
	void ackBuyMysteriousExchangelist(int,std::vector<obj_mysterious,std::allocator<obj_mysterious>>);
	void getMySticMerchantDataByIndex(int, int);
	void reqMysteriousList(int);
	void getDataSize(int);
	void setNextUpdateTime(int);
	void ackBuyMysteriousGoods(int,	int, int);
	void compareProps(MysteriousInfo,MysteriousInfo);
	void comparer(MysteriousInfo,MysteriousInfo);
	void ackUpMysteriousList(int, int, int);
	void getUpdateGoldNum(void);
	void getShopPorpsVec(void);
	void ~MySticMerchantMgr();
	void getNextUpdateTime(void);
	void ackBuyMysteriousGoods(int,int,int);
	void comparer(MysteriousInfo, MysteriousInfo);
	void reqExchangeProps(int,int,int);
	void clearData(int);
	void getUpdateNum(void);
	void deleteItemByIndex(int,int,int);
	void ackMysteriousList(int, int, int, int, int,	int, std::vector<obj_mysteriousInfo, std::allocator<obj_mysteriousInfo>>);
	void compareProps(MysteriousInfo, MysteriousInfo);
	void ackMysteriousList(int,int,int,int,int,int,std::vector<obj_mysteriousInfo,std::allocator<obj_mysteriousInfo>>);
	void ackBuyMysteriousSpeciallist(int,std::vector<obj_mysterious,std::allocator<obj_mysterious>>);
	void ackExchangeProps(int, int,	int);
	void reqBuyMysteriousGoods(int,	int, int);
	void getMysticMerchantPropsDataByIndex(int,int);
	void getMySticMerchantPropsDataIndex(int, int);
	void getShopPropsSize(void);
	void reqUpMysteriousList(int);
	void deleteItemByIndex(int, int, int);
	void getShopPropsByIndex(int);
	void getMysticMerchantPropsDataByIndex(int, int);
	void getMySticMerchantDataIndex(int,int);
	void MySticMerchantMgr(void);
	void ackExchangeProps(int,int,int);
	void comparePropsByLvl(MysteriousInfo,MysteriousInfo);
	void reqExchangeProps(int, int,	int);
}
#endif