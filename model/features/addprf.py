import os
import shutil

prjFiles = []
for root, dirs, files in os.walk("/home/coreywhite/Documents/QL2_DEMS/10m/FranklinCoNC", topdown=False):
    for name in files:
        if name.endswith(".prj"):
            prjFiles.append(name.split('.')[0])
            print(name)
    for name in files:
        baseName = name.split('.')[0]
        
        
        if baseName not in prjFiles:
            newFileName = "{}.prj".format(baseName)
            newFilePath = os.path.join("/home/coreywhite/Documents/GitHub/FallsJordan/nutrient-loading-model/model/features/", "test", newFileName)
            print(newFilePath)
            cwd = os.getcwd()  
           
            shutil.copyfile(os.path.join(root, 'D10_37_20187103_20160228.prj'), newFilePath)

print(prjFiles)