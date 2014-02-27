#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>
#include <log4cplus/configurator.h>

#ifndef TEXT
#   define TEXT LOG4CPLUS_TEXT
#endif
#define TSTRING log4cplus::tstring

/// 总开关，当某功能相当完善时可以把它的log关掉
#ifndef ENABLE_LOG
#   define ENABLE_LOG 1
#endif //!ENABLE_LOG

/// We should define our own tag before including logger.h
#ifndef LOG_TAG
#   define LOG_TAG LOG4CPLUS_TEXT("YOUR_TAG")
#endif //!LOG_TAG

#ifndef LOG_SEPRATOR
#   define LOG_SEPRATOR TEXT(" -- ")
#endif

#ifndef LOGGER_NAME
#   define LOGGER_NAME LOG4CPLUS_TEXT("XLLogger")
#endif

/// 要关闭LOG_LEVEL_DEBUG及以下的log，在包含logger.h之前"#define ENABLE_DEBUG_LOG 0"
#ifndef ENABLE_DEBUG_LOG
#   define ENABLE_DEBUG_LOG 1
#endif //!ENABLE_DEBUG_LOG

/// 终端、debug window日志开关
#define ENABLE_CONSOLE_LOG 1

#if ENABLE_LOG

#	if ENABLE_DEBUG_LOG
#       define LOGT(msg) LOG4CPLUS_TRACE(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("T/") << LOG_TAG << LOG_SEPRATOR << msg)
#	else
#		define LOGT(msg) ((void)0)
#	endif //ENABLE_DEBUG_LOG

#	if ENABLE_DEBUG_LOG
#		define LOGD(msg) LOG4CPLUS_DEBUG(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("D/") << LOG_TAG << LOG_SEPRATOR << msg)
#	else
#		define LOGD(msg) ((void)0)
#	endif //ENABLE_DEBUG_LOG

#	define LOGI(msg) LOG4CPLUS_INFO(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("I/") << LOG_TAG << LOG_SEPRATOR << msg)

#	define LOGW(msg) LOG4CPLUS_WARN(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("W/") << LOG_TAG << LOG_SEPRATOR << msg)

#	define LOGE(msg) LOG4CPLUS_ERROR(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("E/") << LOG_TAG << LOG_SEPRATOR << msg)

#   define LOGF(msg) LOG4CPLUS_FATAL(log4cplus::Logger::getInstance(LOGGER_NAME), TEXT("F/") << LOG_TAG << LOG_SEPRATOR << msg)

#else

#	define LOGT(msg) ((void)0)
#	define LOGD(msg) ((void)0)
#	define LOGI(msg) ((void)0)
#	define LOGW(msg) ((void)0)
#	define LOGE(msg) ((void)0)
#   define LOGF(msg) ((void)0)

#endif //ENABLE_LOG
//////////////////////////////////////////////////////////////////
/*!
 * @class XLLogger log4j
 */
class XLLogger
{
public:
    static XLLogger *Instance()
    {
        static XLLogger logger;
        return &logger;
    }

    void InitLogger(const TSTRING& cfgFileName, int secRefresh = 0);

    void InitLogger();
protected:
    XLLogger();
    virtual ~XLLogger();
    XLLogger(const XLLogger& logger);
private:
    log4cplus::ConfigureAndWatchThread *_watchdog;
};
