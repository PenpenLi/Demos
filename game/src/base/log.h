#ifndef __game__log__
#define __game__log__
#include "Singleton.h"
#include <iostream>
#include <sstream>
#include <time.h>
#include <stdio.h>

namespace XL {
    
    class CLog: public Singleton<CLog> {
    public:
        bool Init(const std::string& logPath);
        void Log(const std::string& message, bool console);
        CLog();
    };
}


/*!
 * @define ENABLE_DEBUG_LOG
 */
#ifndef ENABLE_DEBUG_LOG
#   define ENABLE_DEBUG_LOG 1
#endif

/*!
 * @define LOG_TAG
 * @note We should define our own tag before including logger.h
 */
#ifndef LOG_TAG
#define LOG_TAG "LOG_TAG"
#endif

/*!
 * @define LOG_LEVEL
 */
#ifndef LOG_LEVEL
#   define LOG_LEVEL LOG_LEVEL_ALL
#endif

/*!
 * @define LOG_SEP
 */
#ifndef LOG_SEP
#   define LOG_SEP " -- "
#endif

#ifndef LOG_CONSOLE
#   define LOG_CONSOLE 0
#endif

//
#define LOG_FLAG_FATAL  (1 << 0)  // 0...000001
#define LOG_FLAG_ERROR  (1 << 1)  // 0...000010
#define LOG_FLAG_WARN   (1 << 2)  // 0...000100
#define LOG_FLAG_INFO   (1 << 3)  // 0...001000
#define LOG_FLAG_DEBUG  (1 << 4)  // 0...010000
#define LOG_FLAG_TRACE  (1 << 5)  // 0...100000

/*!
 * LOG_LEVEL TRACE > DEBUG > INFO > WARN > ERROR > FATAL > OFF
 */
#define LOG_LEVEL_OFF   0                                                                                           // 0...000000
#define LOG_LEVEL_FATAL (LOG_FLAG_FATAL)                                                                            // 0...000001
#define LOG_LEVEL_ERROR (LOG_FLAG_FATAL|LOG_FLAG_ERROR)                                                             // 0...000011
#define LOG_LEVEL_WARN  (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN)                                               // 0...000111
#define LOG_LEVEL_INFO  (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO)                                 // 0...001111
#define LOG_LEVEL_DEBUG (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO|LOG_FLAG_DEBUG)                  // 0...011111
#define LOG_LEVEL_TRACE (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO|LOG_FLAG_DEBUG|LOG_FLAG_TRACE)   // 0...111111
#define LOG_LEVEL_ALL   LOG_LEVEL_TRACE

extern std::string w2c(const std::wstring& ws);
//std::string w2c(const wchar_t* pws);

#ifdef WIN32
#   include <windows.h>
#   define GetPid() GetCurrentProcessId()
#   define GetTid() GetCurrentThreadId()
#else
#   include <unistd.h>
#   include <sys/syscall.h>
#   define GetPid() getpid()
#   define GetTid() syscall(SYS_gettid)
#endif

#if LOG_LEVEL
#   define LogMessage(cw_flag_, cw_msg_) do {  \
		if (cw_flag_ & LOG_LEVEL) { \
            std::stringstream cw_ss_; \
            cw_ss_ << cw_msg_; \
            XL::CLog::Instance().Log(cw_ss_.str(), LOG_CONSOLE); \
		}   \
	} while (0)
#else
#   define LogMessage(flag, msg)   ((void)0)
#endif

#define LOGF(msg)   LogMessage(LOG_FLAG_FATAL, "F/" << LOG_TAG << LOG_SEP << msg)

#define LOGE(msg)   LogMessage(LOG_FLAG_ERROR, "E/" << LOG_TAG << LOG_SEP << msg)

#define LOGW(msg)   LogMessage(LOG_FLAG_WARN, "W/" << LOG_TAG << LOG_SEP << msg)

#define LOGI(msg)   LogMessage(LOG_FLAG_INFO, "I/" << LOG_TAG << LOG_SEP << msg)

#if ENABLE_DEBUG_LOG
#   define LOGD(msg)    LogMessage(LOG_FLAG_DEBUG, "D/" << LOG_TAG << LOG_SEP << msg)
#else
#   define LOGD(msg)   ((void)0)
#endif

#if ENABLE_DEBUG_LOG
#   define LOGT(msg)    LogMessage(LOG_FLAG_TRACE, "T/" << LOG_TAG << LOG_SEP << msg)
#else
#   define LOGT(msg)   ((void)0)
#endif
            
#endif