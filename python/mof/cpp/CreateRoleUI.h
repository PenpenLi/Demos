#ifndef MOF_CREATEROLEUI_H
#define MOF_CREATEROLEUI_H

class CreateRoleUI{
public:
	void playmRoleAnimation(int);
	void showRoleNameHasExits(bool);
	void onMenuItemProfession4Clicked(cocos2d::CCObject *);
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void setControlContent(int)::character;
	void onMenuItemGoBackClicked(cocos2d::CCObject *);
	void onMenuItemProfession3Clicked(cocos2d::CCObject *);
	void onMenuItemProfession6Clicked(cocos2d::CCObject *);
	void ~CreateRoleUI();
	void onMenuItemGotoGameClicked(cocos2d::CCObject *);
	void setControlContent(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void CreateRoleUI(void);
	void detectionInputStr(void);
	void setBtnEnable(bool);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void onMenuItemProfession2Clicked(cocos2d::CCObject *);
	void playLoginAnimations(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void onMenuItemRandNameClicked(cocos2d::CCObject *);
	void onEnter(void);
	void accountInputDetection(void);
	void Init(void);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void onMenuItemProfession1Clicked(cocos2d::CCObject *);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void ProduceRandomName(void);
	void create(void);
	void setPersonDesc(int);
	void onMenuItemProfession5Clicked(cocos2d::CCObject *);
	void getRandomName(std::string);
	void init(void);
	void onExit(void);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string	const&);
}
#endif