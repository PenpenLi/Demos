#ifndef MOF_CCSPRITEBATCHNODE_H
#define MOF_CCSPRITEBATCHNODE_H

class CCSpriteBatchNode{
public:
	void draw(void);
	void insertQuadFromSprite(cocos2d::CCSprite *,uint);
	void create(char const*,uint);
	void addChild(cocos2d::CCNode *,int,int);
	void setBlendFunc(cocos2d::_ccBlendFunc);
	void reorderChild(cocos2d::CCNode *,int);
	void updateAtlasIndex(cocos2d::CCSprite *, int	*);
	void appendChild(cocos2d::CCSprite *);
	void updateAtlasIndex(cocos2d::CCSprite *,int *);
	void create(char const*, unsigned int);
	void addChild(cocos2d::CCNode *,int);
	void addChild(cocos2d::CCNode *);
	void removeSpriteFromAtlas(cocos2d::CCSprite *);
	void removeAllChildrenWithCleanup(bool);
	void reorderChild(cocos2d::CCNode *, int);
	void updateBlendFunc(void);
	void initWithTexture(cocos2d::CCTexture2D *, unsigned int);
	void removeChild(cocos2d::CCNode *,bool);
	void getTexture(void);
	void insertQuadFromSprite(cocos2d::CCSprite *,	unsigned int);
	void removeChild(cocos2d::CCNode *, bool);
	void initWithTexture(cocos2d::CCTexture2D *,uint);
	void visit(void);
	void createWithTexture(cocos2d::CCTexture2D *,uint);
	void getBlendFunc(void);
	void ~CCSpriteBatchNode();
	void setTexture(cocos2d::CCTexture2D *);
	void sortAllChildren(void);
	void addChild(cocos2d::CCNode *, int, int);
	void reorderBatch(bool);
	void addChild(cocos2d::CCNode *, int);
}
#endif