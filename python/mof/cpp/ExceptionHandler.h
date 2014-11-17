#ifndef MOF_EXCEPTIONHANDLER_H
#define MOF_EXCEPTIONHANDLER_H

class ExceptionHandler{
public:
	void WaitForMessage(void	*);
	void SuspendThreads(void);
	void UninstallHandler(bool);
	void WriteMinidumpWithException(int,int,int,__darwin_ucontext *,uint,bool,bool);
	void ResumeThreads(void);
	void WriteMinidumpWithException(int, int, int, __darwin_ucontext *, unsigned int, bool,	bool);
	void Teardown(void);
	void UpdateNextID(void);
	void InstallHandler(void);
	void Setup(bool);
	void WaitForMessage(void *);
	void SignalHandler(int,	__siginfo *, void *);
	void ExceptionHandler(char	const*,char const*,void	*,bool),void *,bool,char const*);
	void ~ExceptionHandler();
	void ExceptionHandler(char const*, char const*, void *, bool), void *, bool, char const*);
	void SignalHandler(int,__siginfo	*,void *);
	void SignalHandler(int,__siginfo *,void	*);
}
#endif