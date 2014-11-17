#ifndef MOF_CCNODELOADERLIBRARY_H
#define MOF_CCNODELOADERLIBRARY_H

class CCNodeLoaderLibrary{
public:
	void registerCCNodeLoader(char const*,cocos2d::extension::CCNodeLoader *);
	void ~CCNodeLoaderLibrary();
	void registerDefaultCCNodeLoaders(void);
	void registerCCNodeLoader(char const*, cocos2d::extension::CCNodeLoader *);
	void getCCNodeLoader(char	const*);
	void newDefaultCCNodeLoaderLibrary(void);
	void library(void);
	void purge(bool);
}
#endif