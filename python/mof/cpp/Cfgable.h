#ifndef MOF_CFGABLE_H
#define MOF_CFGABLE_H

class Cfgable{
public:
	void loadAll(ThreadDelegateProtocol *, std::string, int, int);
	void loadAll(ThreadDelegateProtocol *,std::string,int,int);
	void getFullFilePath(std::string);
}
#endif