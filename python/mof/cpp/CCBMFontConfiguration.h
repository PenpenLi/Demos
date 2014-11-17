#ifndef MOF_CCBMFONTCONFIGURATION_H
#define MOF_CCBMFONTCONFIGURATION_H

class CCBMFontConfiguration{
public:
	void purgeFontDefDictionary(void);
	void parseImageFileName(std::string, char const*);
	void parseKerningEntry(std::string);
	void parseCommonArguments(std::string);
	void ~CCBMFontConfiguration();
	void parseConfigFile(char const*);
	void parseCharacterDefinition(std::string,	cocos2d::_BMFontDef *);
	void parseImageFileName(std::string,char const*);
	void create(char const*);
	void parseInfoArguments(std::string);
	void parseCharacterDefinition(std::string,cocos2d::_BMFontDef *);
	void purgeKerningDictionary(void);
}
#endif