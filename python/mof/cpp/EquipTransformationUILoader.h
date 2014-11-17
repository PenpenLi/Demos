#ifndef MOF_EQUIPTRANSFORMATIONUILOADER_H
#define MOF_EQUIPTRANSFORMATIONUILOADER_H

class EquipTransformationUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~EquipTransformationUILoader();
}
#endif