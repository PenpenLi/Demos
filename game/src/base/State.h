//
//  State.h
//  game
//
//  Created by Xiaobin Li on 9/19/14.
//
//

#ifndef __game__State__
#define __game__State__

namespace XL {
    
    /*!
     * @interface State 状态接口
     */
    template <typename NodeType>
    class State {
    public:
        /*!
         * @method Enter 变到本状态前执行
         */
        virtual void Enter() = 0;
        
        /*!
         * @method Exit 状态改变后执行
         */
        virtual void Exit() = 0;
        
        /*!
         * @method Execute 本状态行为
         */
        virtual void Execute(NodeType *node) = 0;
    };
    
}

#endif /* defined(__game__State__) */
