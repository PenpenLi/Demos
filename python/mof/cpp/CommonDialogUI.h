#ifndef MOF_COMMONDIALOGUI_H
#define MOF_COMMONDIALOGUI_H

class CommonDialogUI{
public:
	void setLabel(std::string,std::string);
	void ~CommonDialogUI();
	void updateContentForSynPvp(float);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void setContentForSynPvp(void);
	void setShowLabelPos(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setShowLabel(std::string);
	void Init(void);
	void setIsOneBtn(void);
	void deleteCommonDialogUI(void);
	void setConfconfirmImageDialog(cocos2d::CCObject *));
	void onEnter(void);
	void create(void);
	void setCancelIamgeDialog(cocos2d::CCObject *));
	void CommonDialogUI(void);
	void setLabel(std::string,	std::string);
	void setTitleLabel(std::string);
	void init(void);
	void onExit(void);
}
#endif