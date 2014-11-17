#ifndef MOF_CHECKPLAYER_H
#define MOF_CHECKPLAYER_H

class CheckPlayer{
public:
	void showFashionDesc(void);
	void onMenuItemPetAttributeClicked(cocos2d::CCObject *);
	void ~CheckPlayer();
	void onMenuItemEquipClicked(cocos2d::CCObject *);
	void onMenuItemGadCloseClick(cocos2d::CCObject	*);
	void createSkillControlButton(int, cocos2d::CCPoint);
	void setSkillDesc(int, cocos2d::CCPoint);
	void showPersonInfor(void);
	void onSkillTochDownClicked(cocos2d::CCObject	*);
	void initControl(void);
	void createSkillControlButton(int,cocos2d::CCPoint);
	void onMenuItemEquipTipsCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onSkillTouchUpInsideClicked(cocos2d::CCObject *);
	void initGuildGad(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void CheckPlayer(void);
	void initeMultiplEquipmentTip(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void showGuildGadDesc(void);
	void setSkillDesc(int,cocos2d::CCPoint);
	void setRoleNameAndLvl(void);
	void registerWithTouchDispatcher(void);
	void onSkillTochDownClicked(cocos2d::CCObject *);
	void setPersonImageIsEnable(bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onSkillTouchUpOutsideClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onMenuItemFashionDescClicked(cocos2d::CCObject *);
	void setEquipTipsPostion(int,	bool);
	void showRoleModel(void);
	void initequippostion(void);
	void onMenuItemEquipTipsCloseClicked(cocos2d::CCObject	*);
	void onMenuItemFashionCloseClicked(cocos2d::CCObject *);
	void showPetInfor(void);
	void onMenuItemEquipClicked(cocos2d::CCObject	*);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemPersonAttributeClicked(cocos2d::CCObject *);
	void initequipmentTip(void);
	void addEquipmentsMeu(void);
	void onMenuItemGuildGadClick(cocos2d::CCObject	*);
	void setFashionShowImage(EquipInfo);
	void setPlayerAttribute(void);
	void setRoleStarAndGuild(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void setEquipTipsPostion(int,bool);
	void setPetDetailsUI(void);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void setPetSkillIcon(void);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void showLastOnlineTimer(int);
	void setEquipDescTipsHide(void);
	void onMenuItemGadCloseClick(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void onMenuItemGuildGadClick(cocos2d::CCObject *);
}
#endif