#ifndef MOF_CREATEROLEUILOADER_H
#define MOF_CREATEROLEUILOADER_H

class CreateRoleUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CreateRoleUILoader();
}
#endif