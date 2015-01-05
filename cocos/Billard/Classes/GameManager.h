//
//  GameManager.h
//  Billard
//
//  Created by Xiaobin Li on 12/19/14.
//
//

#ifndef __Billard__GameManager__
#define __Billard__GameManager__
#include <memory>

namespace TQ {
    class GameManager;
    
    typedef std::unique_ptr<GameManager *> GameManagerPtr;
    
    class GameManager {
    public:
        GameManagerPtr getInstance();
        void destroyInstance();
        
    protected:
        GameManager();
        ~GameManager();
    };
    
}

#endif /* defined(__Billard__GameManager__) */
