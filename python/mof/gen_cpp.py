#!/usr/bin/python
# _*_ coding: utf-8 _*_

class CppClass(object):
    """ MOF cpp class convert """
    def __init__(self, name):
        self.name = name
        self.method = set([])
        self.member = []

    def genCppFile(self):
        fileName = "cpp/" + self.name + ".h"
        f = open(fileName, "w")
        macro = "MOF_" + self.name.upper() + "_H"
        f.write("#ifndef " + macro + "\n")
        f.write("#define " + macro + "\n\n")
        f.write("class " + self.name + "{\npublic:\n")
        methodList = [m for m in self.method]
        f.writelines(methodList)
        f.write("}\n")
        f.write("#endif")
        f.close()

    def __str__(self):
        return "Class: name={0}, method count={1}".format(self.name, len(self.method))

def main():
    """ main function """
    classes = {}
    f = open("MOF.asm", "r")
    for line in f.readlines():
        l1 = line.split("(")
        if (len(l1) < 2):
            continue
        l2 = l1[0].split("::")
        if (len(l2) < 2):
            continue
        l3 = l2[-2].split("'")
        l4 = l3[-1].split(" ")
        className = l4[-1]
        if " " in className: continue
        if "," in className: continue
        if "*" in className: continue
        if ">>" in className: continue
        if "std" in className: continue
        print className
        if (classes.has_key(className)):
            c = classes[className]
            c.method.add("\tvoid " + l2[-1] + "(" + l1[-1].strip() + ";\n")
        else:
            c = CppClass(className)
            classes[className] = c
    f.close()

    for c in classes.values():
        print "gen class %s" %(c.name)
        c.genCppFile()

if __name__ == '__main__':
    main()
