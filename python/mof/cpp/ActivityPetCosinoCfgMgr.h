#ifndef MOF_ACTIVITYPETCOSINOCFGMGR_H
#define MOF_ACTIVITYPETCOSINOCFGMGR_H

class ActivityPetCosinoCfgMgr{
public:
	void load(std::string);
	void replacecfg(tagActivityPetCosinoCfg *);
	void readcfg(void);
	void getcfg(void);
}
#endif