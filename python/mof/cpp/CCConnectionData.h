#ifndef MOF_CCCONNECTIONDATA_H
#define MOF_CCCONNECTIONDATA_H

class CCConnectionData{
public:
	void addSkeletonXmlData(std::string);
	void getTextureDatas(void)const;
	void decodeArmatures(Xml::TiXmlElement *,float,float);
	void addData(char const*, bool);
	void addSkeletonXmlDataAsyn(std::string,ThreadDelegateProtocol *);
	void removeRoleSkeletonData(int,	std::string);
	void addRoleSkeletonData(int, std::string);
	void decodeArmatures(Xml::TiXmlElement *, float,	float);
	void setIsClearSkeletonImmediately(bool);
	void getArmatureData(char const*);
	void getConnectData(std::string,	int);
	void getFrameNodeList(float);
	void ~CCConnectionData();
	void CCConnectionData(float);
	void decodeAnimations(Xml::TiXmlElement *,float,float);
	void addData(char const*,bool);
	void removeSkeletonXmlData(std::string);
	void getFrameNode(Xml::TiXmlElement *,float,float);
	void getTextureDatas(void);
	void removeRoleSkeletonData(int,std::string);
	void getConnectData(std::string,int);
	void setArmarureDatas(cocos2d::CCDictionary *);
	void getChangeClothTextures(std::string);
	void addSkeletonData(float, float);
	void getTextureData(std::string);
	void getArmarureDatas(void);
	void findArmatureFromAnimation(std::string,std::string,int);
	void getAllConnectionData(void);
	void recieveThreadMessage(ThreadMessage *);
	void addSkeletonData(std::string,bool,float,float,float,float);
	void removeSkeletonData(std::string,int);
	void getRoleSkeletonData(int);
	void getFashionDatasFromOtherSkeletonDic(void);
	void clearSkeletonData(std::string);
	void copyWithZone(cocos2d::CCZone *);
	void CCConnectionData(void);
	void clearUnuseSkeletonData(void);
	void setTextureDatas(cocos2d::CCDictionary *);
	void getFrameNodeList(Xml::TiXmlElement *,char const*,float,float);
	void getAnimationData(char const*);
	void removeAll(bool);
	void decodeAllSkeletonData(Xml::TiXmlDocument *);
	void getAnimationDatas(void)const;
	void getAnimationDatas(void);
	void getFrameNode(Xml::TiXmlElement *, float, float);
	void setFashionDatasFromOtherSkeletonDic(cocos2d::CCDictionary *);
	void findArmatureFromAnimation(std::string, std::string,	int);
	void decodeAnimations(Xml::TiXmlElement *, float, float);
	void setAnimationDatas(cocos2d::CCDictionary *);
	void addRoleSkeletonData(int,std::string);
	void removeSkeletonData(std::string, int);
	void getFashionDatasFromOtherSkeletonDic(void)const;
	void CCConnectionData(float,float,float,float);
	void getArmarureDatas(void)const;
	void decodeTextures(Xml::TiXmlElement *);
	void addSkeletonXmlDataAsyn(std::string,	ThreadDelegateProtocol *);
	void init(void);
}
#endif