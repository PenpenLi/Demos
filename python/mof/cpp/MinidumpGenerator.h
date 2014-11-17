#ifndef MOF_MINIDUMPGENERATOR_H
#define MOF_MINIDUMPGENERATOR_H

class MinidumpGenerator{
public:
	void CalculateStackSize(unsigned int);
	void Write(char const*);
	void WriteMiscInfoStream(MDRawDirectory *);
	void MinidumpGenerator(unsigned int, unsigned int);
	void SetTaskContext(__darwin_ucontext *);
	void GatherSystemInformation(void);
	void WriteContextARM(uint *,MDLocationDescriptor *);
	void UniqueNameInDirectory(std::string	const&,std::string *);
	void WriteModuleListStream(MDRawDirectory *);
	void MinidumpGenerator(uint,uint);
	void WriteCVRecord(MDRawModule	*,int,char const*,bool);
	void WriteThreadStream(uint,MDRawThread *);
	void UniqueNameInDirectory(std::string	const&,	std::string *);
	void FindExecutableModule(void);
	void WriteMemoryListStream(MDRawDirectory *);
	void GetThreadState(unsigned int, unsigned int	*, unsigned int	*);
	void WriteCVRecord(MDRawModule	*, int,	char const*, bool);
	void WriteStackFromStartAddress(uint,MDMemoryDescriptor *);
	void GetThreadState(uint,uint *,uint *);
	void WriteThreadListStream(MDRawDirectory *);
	void WriteThreadStream(unsigned int, MDRawThread *);
	void WriteBreakpadInfoStream(MDRawDirectory *);
	void ~MinidumpGenerator();
	void WriteExceptionStream(MDRawDirectory *);
	void CalculateStackSize(uint);
	void WriteStackFromStartAddress(unsigned int, MDMemoryDescriptor *);
	void WriteSystemInfoStream(MDRawDirectory *);
	void WriteModuleStream(unsigned int, MDRawModule *);
	void WriteContextARM(unsigned int *, MDLocationDescriptor *);
}
#endif