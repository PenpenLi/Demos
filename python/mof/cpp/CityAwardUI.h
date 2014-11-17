#ifndef MOF_CITYAWARDUI_H
#define MOF_CITYAWARDUI_H

class CityAwardUI{
public:
	void runcallBack(void);
	void onMenuItemConfirmClicked(cocos2d::CCObject *);
	void setreward(int, std::vector<ItemGroup, std::allocator<ItemGroup>>, int, int, int,	int, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void refreshData(float);
	void updateFliping(float);
	void ~CityAwardUI();
	void showNum(void);
	void setreward(int,std::vector<ItemGroup,std::allocator<ItemGroup>>,int,int,int,int,int);
	void CityAwardUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onEnter(void);
	void createItemLabel(void);
	void Init(void);
	void showArrow(bool,bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void showArrow(bool, bool);
	void create(void);
	void showGotoCityImage(void);
	void init(void);
	void onExit(void);
}
#endif