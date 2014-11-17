#ifndef MOF_INIFILEEVENT_H
#define MOF_INIFILEEVENT_H

class IniFileEvent{
public:
	void onValue(std::string const&);
	void onKey(std::string const&);
	void onSection(std::string const&);
}
#endif