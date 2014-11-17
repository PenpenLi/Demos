#ifndef MOF_MAILMGR_H
#define MOF_MAILMGR_H

class MailMgr{
public:
	void ackDeleteMail(int,std::string);
	void reqMailDatas(MailType, int, int);
	void ackMailInfo(int, std::string, std::string, std::string);
	void MailMgr(void);
	void getMailDataIndex(std::string);
	void ackGetMailAttach(int, std::string);
	void ackGetMailAttach(int,std::string);
	void reqGetMailAttach(std::string, std::string);
	void getDataSize(void);
	void getMailContentAttach(void);
	void clearMailData(void);
	void IsExistUnReadMail(void);
	void reqMailInfo(std::string);
	void ~MailMgr();
	void ackMailDatas(int,int,int,std::vector<obj_mail,std::allocator<obj_mail>>);
	void ackMailInfo(int,std::string,std::string,std::string);
	void reqDeleteMail(std::string);
	void reqGetMailAttach(std::string,std::string);
	void ackMailDatas(int, int, int, std::vector<obj_mail, std::allocator<obj_mail>>);
	void ackDeleteMail(int, std::string);
	void getMailDataByIndex(int);
	void reqMailDatas(MailType,int,int);
	void notifyNewMail(obj_mail);
}
#endif