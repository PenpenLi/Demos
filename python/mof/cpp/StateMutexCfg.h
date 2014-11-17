#ifndef MOF_STATEMUTEXCFG_H
#define MOF_STATEMUTEXCFG_H

class StateMutexCfg{
public:
	void load(std::string);
	void stringToObjState(std::string);
	void ~StateMutexCfg();
}
#endif