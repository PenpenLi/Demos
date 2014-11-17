#ifndef MOF_SWEEPUI_H
#define MOF_SWEEPUI_H

class SweepUI{
public:
	void onMenuSecondClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setData(int);
	void setRoleData(void);
	void setPorTimeVisible(bool);
	void onMenuSecondClicked(cocos2d::CCObject *);
	void onMenuFirstClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuThirdClicked(cocos2d::CCObject *);
	void create(void);
	void onMenuFirstClicked(cocos2d::CCObject *);
	void ~SweepUI();
	void onExit(void);
	void ackMsg(int,std::vector<obj_copyaward,std::allocator<obj_copyaward>>);
	void setCopyData(int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuThirdClicked(cocos2d::CCObject	*);
	void ackMsg(int, std::vector<obj_copyaward, std::allocator<obj_copyaward>>);
	void init(void);
	void onSweepClicked(cocos2d::CCObject *);
	void onEnter(void);
}
#endif