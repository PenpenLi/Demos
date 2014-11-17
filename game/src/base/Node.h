//
//  Node.h
//  game
//
//  Created by Xiaobin Li on 9/19/14.
//
//

#ifndef __game__Node__
#define __game__Node__

#include <stdint.h>

namespace XL {
    
    /*!
     * @class Node
     */
    class Node {
    public:
        /*!
         * @method SetId
         */
        void SetId(uint64_t val);
        
        /*!
         * @method Id
         */
        uint64_t Id() const;
        
        Node(uint64_t val);
        
        virtual ~Node();
        
        virtual void Update() = 0;
        
    private:
        uint64_t m_id;
        static uint64_t m_nextId;
    };
    
}

#endif /* defined(__game__Node__) */
