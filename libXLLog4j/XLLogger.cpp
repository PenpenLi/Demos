#include "XLLogger.h"
#include <log4cplus/consoleappender.h>
#include <log4cplus/layout.h>

using namespace log4cplus;

XLLogger::XLLogger(): _watchdog(NULL)
{

}

XLLogger::~XLLogger()
{
    if (_watchdog)
    {
        delete _watchdog;
        _watchdog = NULL;
    }
}

void XLLogger::InitLogger(const log4cplus::tstring& cfgFileName, int secRefresh)
{
    Logger::getInstance(LOGGER_NAME).setLogLevel(ALL_LOG_LEVEL);
    if (!_watchdog)
    {
        if (secRefresh > 0) {
            _watchdog = new ConfigureAndWatchThread(cfgFileName, secRefresh*1000);
        }
        else
        {
            PropertyConfigurator::doConfigure(cfgFileName);
        }
    }
}

void XLLogger::InitLogger()
{
    Logger logger = Logger::getInstance(LOGGER_NAME);
    SharedAppenderPtr console(new ConsoleAppender);
    std::auto_ptr<Layout> layout(new PatternLayout("%d[%t] %m%n"));
    console->setLayout(layout);
    logger.addAppender(console);
}

