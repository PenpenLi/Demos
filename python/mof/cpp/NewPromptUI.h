#ifndef MOF_NEWPROMPTUI_H
#define MOF_NEWPROMPTUI_H

class NewPromptUI{
public:
	void setContent(std::string, int, cocos2d::CCPoint, cocos2d::CCPoint);
	void create(void);
	void ~NewPromptUI();
	void showNewConfirmDialog(std::string, int, cocos2d::CCNode *, cocos2d::CCPoint, cocos2d::CCPoint);
	void setContent(std::string,int,cocos2d::CCPoint,cocos2d::CCPoint);
	void showNewConfirmDialog(std::string,int,cocos2d::CCNode *,cocos2d::CCPoint,cocos2d::CCPoint);
	void init(void);
}
#endif