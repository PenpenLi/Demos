#ifndef MOF_MACHOWALKER_H
#define MOF_MACHOWALKER_H

class MachoWalker{
public:
	void CurrentHeader(mach_header_64 *,long long *);
	void WalkHeaderCore(long long, unsigned int, bool);
	void WalkHeader64AtOffset(long long);
	void ~MachoWalker();
	void MachoWalker(MacFileUtilities::MachoWalker*, load_command *, long long,	bool, void *), void *);
	void ReadBytes(void	*,ulong,long long);
	void WalkHeaderAtOffset(long long);
	void MachoWalker(MacFileUtilities::MachoWalker*,load_command *,long long,bool,void *),void *);
	void WalkHeaderCore(long long,uint,bool);
	void CurrentHeader(mach_header_64 *, long long *);
	void FindHeader(int,int,long long &);
	void ReadBytes(void	*, unsigned long, long long);
	void WalkHeader(int, int);
	void WalkHeader(int,int);
	void FindHeader(int, int, long long	&);
}
#endif