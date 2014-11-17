#ifndef MOF_CLIENTUTILS_H
#define MOF_CLIENTUTILS_H

class ClientUtils{
public:
	void deleteStoragePathFiles(void);
	void verifyConfigFileMd5(std::string);
	void deleteDirectoryFiles(char const*);
	void getDownloadPath(void);
	void cocos2dxCutScreen(cocos2d::CCNode *,std::string);
	void findTreeChildByTag(cocos2d::CCNode *,int);
	void cocos2dxCutScreen(cocos2d::CCNode *, std::string);
	void findTreeChildByTag(cocos2d::CCNode *, int);
}
#endif