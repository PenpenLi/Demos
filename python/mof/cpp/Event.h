#ifndef MOF_EVENT_H
#define MOF_EVENT_H

class Event{
public:
	void onComment(std::string const&);
	void onError(void);
}
#endif