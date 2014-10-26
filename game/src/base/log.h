#pragma once
#include <iostream>
#include <sstream>
#include <time.h>

/*!
* @macro ENABLE_DEBUG_LOG 用于屏蔽调试日志，通过"#define ENABLE_DEBUG_LOG 0"即可屏蔽Debug
*      及其以下的日志输出
*/
#ifndef ENABLE_DEBUG_LOG
#define ENABLE_DEBUG_LOG 1
#endif

/*!
* @macro LOG_TAG 日志标签，用于日志分类
*/
#ifndef LOG_TAG
#define LOG_TAG "LOG_TAG"
#endif

#ifndef LOG_LEVEL
#   define LOG_LEVEL LOG_LEVEL_ALL
#endif

#ifndef LOG_SEP
#   define LOG_SEP " -- "
#endif

#define ENABLE_CONSOLE 1

// 日志级别
#define LOG_FLAG_FATAL  (1 << 0)  // 0...000001
#define LOG_FLAG_ERROR  (1 << 1)  // 0...000010
#define LOG_FLAG_WARN   (1 << 2)  // 0...000100
#define LOG_FLAG_INFO   (1 << 3)  // 0...001000
#define LOG_FLAG_DEBUG  (1 << 4)  // 0...010000
#define LOG_FLAG_TRACE  (1 << 5)  // 0...100000

#define LOG_LEVEL_OFF   0                                                                                           // 0...000000
#define LOG_LEVEL_FATAL (LOG_FLAG_FATAL)                                                                            // 0...000001
#define LOG_LEVEL_ERROR (LOG_FLAG_FATAL|LOG_FLAG_ERROR)                                                             // 0...000011
#define LOG_LEVEL_WARN  (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN)                                               // 0...000111
#define LOG_LEVEL_INFO  (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO)                                 // 0...001111
#define LOG_LEVEL_DEBUG (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO|LOG_FLAG_DEBUG)                  // 0...011111
#define LOG_LEVEL_TRACE (LOG_FLAG_FATAL|LOG_FLAG_ERROR|LOG_FLAG_WARN|LOG_FLAG_INFO|LOG_FLAG_DEBUG|LOG_FLAG_TRACE)   // 0...111111
#define LOG_LEVEL_ALL   LOG_LEVEL_TRACE

std::string w2c(const std::wstring& ws);
//std::string w2c(const wchar_t* pws);

#if LOG_LEVEL
#   define LogMessage(cw_flag_, cw_msg_) do {  \
		if (cw_flag_ & LOG_LEVEL) { \
			std::stringstream cw_ss_; \
			time_t cw_now_; time(&cw_now_); \
			struct tm *cw_timenow_ = localtime(&cw_now_); \
			char cw_szHeader_[64] = { 0 }; \
			_snprintf(cw_szHeader_, 64, "%02d:%02d:%02d[%u.%u] ", cw_timenow_->tm_hour, cw_timenow_->tm_min, cw_timenow_->tm_sec, GetCurrentProcessId(), GetCurrentThreadId()); \
			cw_ss_ << cw_szHeader_ << cw_msg_; \
			std::cout << cw_ss_.str() << std::endl; \
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

