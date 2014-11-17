//
//  Singleton.h
//  game
//
//  Created by Xiaobin Li on 9/20/14.
//
//

#ifndef game_Singleton_h
#define game_Singleton_h

namespace XL{
    
    /*!
     * @class Singleton 单例模板
     * @note 简单的单例模式，非线程安全。
     *  要求程序中所有使用的单例都统一顺序初始化
     */
    template <class T>
    class Singleton {
    public:
        static T& Instance() {
            static T t;
            return t;
        }
    };
}

#endif
