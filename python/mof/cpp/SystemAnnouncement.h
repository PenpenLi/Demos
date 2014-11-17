#ifndef MOF_SYSTEMANNOUNCEMENT_H
#define MOF_SYSTEMANNOUNCEMENT_H

class SystemAnnouncement{
public:
	void ~SystemAnnouncement();
	void refreshLabelsShow(float);
	void init(void);
	void createSystemAnnouncement(std::string);
	void create(void);
}
#endif