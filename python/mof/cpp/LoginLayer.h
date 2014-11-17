#ifndef MOF_LOGINLAYER_H
#define MOF_LOGINLAYER_H

class LoginLayer{
public:
	void draw(void);
	void create(void);
	void createContent(cocos2d::CCScene *);
	void update(float);
	void ~LoginLayer();
	void init(void);
}
#endif