#ifndef MOF_PETCOLLECT_H
#define MOF_PETCOLLECT_H

class PetCollect{
public:
	void setSelectPetAwardDesc(int, IllustrationsQuality);
	void setSelectPetCollectAllInfor(int,IllustrationsQuality);
	void onMenuItemPinkQuaClicked(cocos2d::CCObject	*);
	void createControl(void);
	void create(void);
	void onMenuItemBlueQuaClicked(cocos2d::CCObject *);
	void setSelectPetAwardDesc(int,IllustrationsQuality);
	void onMenuItemGetAllAwardClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setSelectEffectByQua(IllustrationsQuality);
	void setSelectPetAwardState(int,IllustrationsQuality);
	void setSelectPetAllAwardState(int);
	void onMenuItemBlueQuaClicked(cocos2d::CCObject	*);
	void ~PetCollect();
	void onMenuItemGetSingAwardClicked(cocos2d::CCObject *);
	void playSelectPetAwardEffect(int);
	void settypeImageNotEnable(IllustrationsType);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemPinkQuaClicked(cocos2d::CCObject *);
	void onMenuItemOrdinaryClicked(cocos2d::CCObject *);
	void setSelectPetCollectAllInfor(int, IllustrationsQuality);
	void changeQuaIconByType(IllustrationsType);
	void setSelectPetAwardState(int, IllustrationsQuality);
	void setSelectPetDetails(int);
	void onEnter(void);
	void PetCollect(void);
	void onMenuItemGreenQuaClicked(cocos2d::CCObject *);
	void initPetListByType(IllustrationsType);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void setSelectPetAllAward(int);
	void onMenuItemEliteClicked(cocos2d::CCObject *);
	void statisticalAllAward(IllustrationsType);
	void isHasAwardByPetCollectID(int);
	void onMenuItemBossClicked(cocos2d::CCObject *);
	void isHasCollectByPetID(int);
	void refreshDataByModelID(int);
	void init(void);
	void onExit(void);
}
#endif