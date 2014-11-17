#ifndef MOF_GUILDSHOPMGR_H
#define MOF_GUILDSHOPMGR_H

class GuildShopMgr{
public:
	void ackGuildShopDataList(int,int,int,std::vector<obj_store_goods_info,std::allocator<obj_store_goods_info>>);
	void reqGuildShopDataList(void);
	void ackUpGuildShopDataList(int, int, int);
	void getDataSize(void);
	void getUpdateNum(void);
	void getGuildShopDataByIndex(int);
	void ~GuildShopMgr();
	void setNextUpdateTime(int);
	void getGuildShopDataIndex(int);
	void deleteItemByIndex(int);
	void ackBuyGuildShopGoods(int,int,int,int);
	void ackUpGuildShopDataList(int,int,int);
	void ackGuildShopDataList(int, int, int, std::vector<obj_store_goods_info, std::allocator<obj_store_goods_info>>);
	void reqUpGuildShopDataList(void);
	void GuildShopMgr(void);
	void getNextUpdateTime(void);
	void reqBuyGuildShopGoods(int);
	void clearData(void);
	void ackBuyGuildShopGoods(int, int, int, int);
}
#endif