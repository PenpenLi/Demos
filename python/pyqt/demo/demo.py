#!/usr/bin/env python
# coding: utf-8

import sys
from PyQt4 import QtGui, QtCore
from demo_ui import Ui_MainWindow


class Window(QtGui.QMainWindow, Ui_MainWindow):
    """"""
    def __init__(self):
        """"""
        QtGui.QWidget.__init__(self)
        self.setupUi(self)
        self.pushButtonDemo.clicked.connect(self.demo)

    def demo(self):
        """"""
        yourName, okay = QtGui.QInputDialog.getText(
            self,
            u"你的名字是?",
            u"名字"
        )
        if not okay or yourName == "":
            self.textBrowserOut.append(u"你好, 陌生人!")
        else:
            self.textBrowserOut.append(QtCore.QString.fromUtf8(
                u"你好, <b>%1</b>").arg(yourName))

app = QtGui.QApplication(sys.argv)
window = Window()
window.show()
sys.exit(app.exec_())
