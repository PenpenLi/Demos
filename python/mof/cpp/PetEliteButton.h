#ifndef MOF_PETELITEBUTTON_H
#define MOF_PETELITEBUTTON_H

class PetEliteButton{
public:
	void ~PetEliteButton();
	void skillClickCallBack(cocos2d::CCObject *,int);
	void createPetEliteButton(float,char const*,char const*);
	void skillClickCallBack(cocos2d::CCObject *, int);
}
#endif