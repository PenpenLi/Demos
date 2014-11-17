#ifndef MOF_SKILLLEARNINGUILOADER_H
#define MOF_SKILLLEARNINGUILOADER_H

class SkillLearningUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~SkillLearningUILoader();
}
#endif