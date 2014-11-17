#ifndef MOF_LOGMESSAGE_H
#define MOF_LOGMESSAGE_H

class LogMessage{
public:
	void LogMessage(std::ostream &,char const*);
	void out(void);
	void LogMessage(std::ostream &, char const*);
	void ~LogMessage();
	void flush(void);
}
#endif