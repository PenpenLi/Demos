#ifndef MOF_UTILS_H
#define MOF_UTILS_H

class Utils{
public:
	void makeStr(char const*,...);
	void itoa(int, int,	char *);
	void parseDate(char	const*);
	void JobToString(int);
	void contrastASCII(std::string,std::string);
	void EquipPartToString(int);
	void getPostPram(std::vector<std::string, std::allocator<std::string>> *);
	void isUtf8StringContainEmoji(std::string const&);
	void Utf8ToUtf16(std::string const&);
	void TcpMsgIsLocked(int);
	void safe_atoi(char	const*,int);
	void clearLockTcpMsg(void);
	void contrastASCII(std::string, std::string);
	void getPostPram(std::vector<std::string,std::allocator<std::string>> *);
	void itoa(int,int,char *);
	void lockTcpMsg(int);
	void Utf8StringSize(std::string const&);
	void sameDate(char const*);
	void Utf8SubStr(std::string	const&,	unsigned long, unsigned	long);
	void Utf8SubStr(std::string	const&,ulong,ulong);
	void SwordToString(int);
	void safe_atoi(char	const*,	int);
	void makeStr(char const*, ...);
	void PvpRankToString(int);
	void unLockTcpMsg(int);
}
#endif