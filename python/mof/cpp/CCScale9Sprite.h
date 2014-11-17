#ifndef MOF_CCSCALE9SPRITE_H
#define MOF_CCSCALE9SPRITE_H

class CCScale9Sprite{
public:
	void getInsetTop(void);
	void CCScale9Sprite(void);
	void initWithFile(cocos2d::CCRect, char const*);
	void visit(void);
	void getPreferredSize(void);
	void getOriginalSize(void)const;
	void getInsetRight(void);
	void initWithFile(char	const*,cocos2d::CCRect);
	void setOpacityModifyRGB(bool);
	void initWithSpriteFrameName(char const*, cocos2d::CCRect);
	void getOriginalSize(void);
	void initWithFile(char	const*,	cocos2d::CCRect, cocos2d::CCRect);
	void initWithBatchNode(cocos2d::CCSpriteBatchNode *,cocos2d::CCRect,bool,cocos2d::CCRect);
	void getInsetBottom(void);
	void setPreferredSize(cocos2d::CCSize);
	void setContentSize(cocos2d::CCSize const&);
	void initWithFile(char	const*,cocos2d::CCRect,cocos2d::CCRect);
	void setInsetBottom(float);
	void updateWithBatchNode(cocos2d::CCSpriteBatchNode *,cocos2d::CCRect,bool,cocos2d::CCRect);
	void initWithSpriteFrame(cocos2d::CCSpriteFrame *,cocos2d::CCRect);
	void updateCapInset(void);
	void getCapInsets(void);
	void setOpacity(unsigned char);
	void initWithSpriteFrameName(char const*,cocos2d::CCRect);
	void setSpriteFrame(cocos2d::CCSpriteFrame *);
	void initWithSpriteFrame(cocos2d::CCSpriteFrame *, cocos2d::CCRect);
	void setColor(cocos2d::_ccColor3B const&);
	void createWithSpriteFrame(cocos2d::CCSpriteFrame *);
	void createWithSpriteFrameName(char const*);
	void initWithFile(char	const*);
	void getColor(void);
	void setOpacity(unsigned	char);
	void setCapInsets(cocos2d::CCRect);
	void initWithFile(char	const*,	cocos2d::CCRect);
	void initWithBatchNode(cocos2d::CCSpriteBatchNode *, cocos2d::CCRect, cocos2d::CCRect);
	void initWithBatchNode(cocos2d::CCSpriteBatchNode *,cocos2d::CCRect,cocos2d::CCRect);
	void ~CCScale9Sprite();
	void getOpacity(void);
	void initWithSpriteFrameName(char const*);
	void updateWithBatchNode(cocos2d::CCSpriteBatchNode *,	cocos2d::CCRect, bool, cocos2d::CCRect);
	void initWithBatchNode(cocos2d::CCSpriteBatchNode *, cocos2d::CCRect, bool, cocos2d::CCRect);
	void updatePositions(void);
	void create(void);
	void setOpacity(uchar);
	void getInsetLeft(void);
	void setInsetTop(float);
	void initWithSpriteFrame(cocos2d::CCSpriteFrame *);
	void setInsetLeft(float);
	void initWithFile(cocos2d::CCRect,char	const*);
	void setInsetRight(float);
	void init(void);
	void isOpacityModifyRGB(void);
}
#endif