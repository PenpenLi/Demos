#ifndef MOF_OBJ_MAIL_H
#define MOF_OBJ_MAIL_H

class obj_mail{
public:
	void decode(ByteArray &);
	void operator=(obj_mail const&);
	void obj_mail(void);
	void encode(ByteArray &);
}
#endif