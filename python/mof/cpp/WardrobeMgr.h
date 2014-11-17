#ifndef MOF_WARDROBEMGR_H
#define MOF_WARDROBEMGR_H

class WardrobeMgr{
public:
	void setFashionDataFromSever(std::vector<FashionData,std::allocator<FashionData>>,std::vector<FashionData,std::allocator<FashionData>>&);
	void roleIsclothedWeaponFashion(void);
	void setFashionDataFromSever(std::vector<FashionData,std::allocator<FashionData>>,BodyPart);
	void getWardrobeExp(void)const;
	void ackTakeoffFashion(ack_takeoff_fashion);
	void getWearedFashionID(BodyPart);
	void setFashionDataFromSever(std::vector<FashionData,	std::allocator<FashionData>>, BodyPart);
	void sortFashionData(BodyPart);
	void getCurrentWeaponFashion(void);
	void ~WardrobeMgr();
	void rolechangeCloth(int, BodyPart);
	void setCurrentBodyFashion(int);
	void reqTakeoffFashion(BodyPart);
	void notifyWardrobeLvl(int,int);
	void getIndexByFashion(int,BodyPart);
	void checkFashionRemainderTimer(int);
	void notifyFreshFashion(notify_refresh_fashion);
	void notifyWardrobeLvl(int, int);
	void setCurrentWeaponFashion(int);
	void getFashionDataByIndex(int,BodyPart);
	void notifyExpireFashion(notify_fashion_expire);
	void setFashionListFromServer(std::vector<obj_fashion_info,std::allocator<obj_fashion_info>>);
	void ackPutonFashion(ack_puton_fashion);
	void ackWardrobeInfo(ack_wardrobe_info);
	void getIndexByFashion(int, BodyPart);
	void getWeapModelByMainRole(void);
	void getAlleCollectingFashion(void);
	void getFashionModelCount(BodyPart);
	void checkFashionRemainderTimer(int, std::vector<FashionData,	std::allocator<FashionData>>);
	void rolechangeCloth(int,BodyPart);
	void notifyAddFashion(notify_add_fashion);
	void setWardrobeExp(int);
	void getAllFashionID(void);
	void getFashionByID(int);
	void WardrobeMgr(void);
	void setFashionDataFromSever(std::vector<FashionData,	std::allocator<FashionData>>, std::vector<FashionData, std::allocator<FashionData>>&);
	void setFashionListFromServer(std::vector<obj_fashion_info, std::allocator<obj_fashion_info>>);
	void checkFashionRemainderTimer(int,std::vector<FashionData,std::allocator<FashionData>>);
	void reqPutonFashion(int, BodyPart);
	void getWardrobeExp(void);
	void initFashionList(int,int);
	void reqPutonFashion(int,BodyPart);
	void getCurrentWeaponFashion(void)const;
	void getFashionDataByIndex(int, BodyPart);
	void getCurrentBodyFashion(void)const;
	void getWardrobeLvl(void);
	void initFashionList(int, int);
	void getCurrentBodyFashion(void);
	void setWardrobeLvl(int);
}
#endif