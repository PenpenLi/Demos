#!/usr/bin/python
# _*_ coding: utf-8 _*_

import cocos

class HelloWorldLayer(cocos.layer.Layer):
    def __init__(self):
        super(HelloWorldLayer, self).__init__()
        self.lblHello = cocos.text.Label('Hello World!',
                font_name='',
                font_size=32,
                anchor_x='center',
                anchor_y='center')
        self.lblHello.position = 320,240
        self.add(self.lblHello)

if __name__ == '__main__':
    cocos.director.director.init()
    hello_layer = HelloWorldLayer()
    main_scene = cocos.scene.Scene(hello_layer)
    cocos.director.director.run(main_scene)
