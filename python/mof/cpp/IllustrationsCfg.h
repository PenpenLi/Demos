#ifndef MOF_ILLUSTRATIONSCFG_H
#define MOF_ILLUSTRATIONSCFG_H

class IllustrationsCfg{
public:
	void load(std::string);
	void getIllustrationsDefsbyType(IllustrationsType);
	void getIllustrationsDef(int);
}
#endif