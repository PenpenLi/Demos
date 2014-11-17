#ifndef MOF_CCSHADERCACHE_H
#define MOF_CCSHADERCACHE_H

class CCShaderCache{
public:
	void loadDefaultShader(cocos2d::CCGLProgram *, int);
	void loadDefaultShaders(void);
	void loadDefaultShader(cocos2d::CCGLProgram *,int);
	void purgeSharedShaderCache(void);
	void ~CCShaderCache();
	void sharedShaderCache(void);
	void programForKey(char const*);
	void init(void);
}
#endif