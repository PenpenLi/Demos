#ifndef MOF_MACHOID_H
#define MOF_MACHOID_H

class MachoID{
public:
	void WalkerCB(MacFileUtilities::MachoWalker *,load_command *,long long,bool,void	*);
	void UUIDWalkerCB(MacFileUtilities::MachoWalker *,load_command *,long long,bool,void *);
	void MD5(int, int, unsigned char *);
	void WalkHeader(MacFileUtilities::MachoWalker *,load_command *,long long,bool,void *),void *);
	void UpdateMD5(uchar *,ulong);
	void UUIDCommand(int,int,uchar *);
	void UUIDWalkerCB(MacFileUtilities::MachoWalker	*, load_command	*, long	long, bool, void *);
	void UpdateMD5(unsigned	char *,	unsigned long);
	void WalkerCB(MacFileUtilities::MachoWalker *,load_command *,long long,bool,void *);
	void Update(MacFileUtilities::MachoWalker *, long long,	unsigned long);
	void MachoID(char const*, void *, unsigned long);
	void ~MachoID();
	void WalkHeader(MacFileUtilities::MachoWalker *, load_command *, long long, bool, void *), void *);
	void WalkerCB(MacFileUtilities::MachoWalker *, load_command *, long long, bool,	void *);
	void MachoID(char const*);
	void UUIDCommand(int, int, unsigned char *);
	void MachoID(char const*,void *,ulong);
	void MD5(int,int,uchar *);
	void UUIDWalkerCB(MacFileUtilities::MachoWalker	*,load_command *,long long,bool,void *);
	void Update(MacFileUtilities::MachoWalker *,long long,ulong);
}
#endif