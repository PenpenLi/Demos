#ifndef MOF_CHOOSECHARACTERUI_H
#define MOF_CHOOSECHARACTERUI_H

class ChooseCharacterUI{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setImgeLabelShowContent(bool);
	void onMenuItemGoBackClicked(cocos2d::CCObject *);
	void create(void);
	void onMenuItemCreateRoleClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void addCharacterData(obj_role);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemStartGameClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setContainerPos(void);
	void playLoginAnimations(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void getCharactersSize(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void showSelectRole(int);
	void onEnter(void);
	void ~ChooseCharacterUI();
	void Init(void);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void onMenuItemDeleteRoleClicked(cocos2d::CCObject *);
	void setStartIamgeState(bool);
	void deleteCharacter(void);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setRolePageData(void);
	void ChooseCharacterUI(void);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif