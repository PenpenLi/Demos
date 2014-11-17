#ifndef MOF_WRITINGTIPS_H
#define MOF_WRITINGTIPS_H

class WritingTips{
public:
	void checkShowSucceedTips(float);
	void create(void);
	void showsucceed(std::string,	cocos2d::CCPoint);
	void handleShowSucceedTips(std::string, cocos2d::CCPoint);
	void showWritingTips(std::string, bool, cocos2d::CCPoint, bool);
	void callback(cocos2d::CCNode	*);
	void callbackTips(cocos2d::CCNode *);
	void showWritingTips(std::string,bool,cocos2d::CCPoint,bool);
	void showfail(std::string,cocos2d::CCPoint);
	void ~WritingTips();
	void showsucceed(std::string,cocos2d::CCPoint);
	void showWritingTips(std::vector<std::string,std::allocator<std::string>>,float,cocos2d::CCPoint);
	void handleShowSucceedTips(std::string,cocos2d::CCPoint);
	void showWritingTips(std::vector<std::string,	std::allocator<std::string>>, float, cocos2d::CCPoint);
	void refreshData(float);
	void showfail(std::string, cocos2d::CCPoint);
	void callbackIn(cocos2d::CCNode *);
	void init(void);
	void callback(cocos2d::CCNode *);
}
#endif