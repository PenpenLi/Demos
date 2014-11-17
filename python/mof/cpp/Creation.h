#ifndef MOF_CREATION_H
#define MOF_CREATION_H

class Creation{
public:
	void Creation(void);
	void draw(void);
	void ~Creation();
	void create(void);
	void createContent(cocos2d::CCScene *);
	void update(float);
	void init(void);
}
#endif