# cloneFileSystemTree
Windows batch file for cloning file system tree
## cloneCompleteFileSystemTree.bat
This windows batch file will clone complete file system tree of your windows. However, it may be very slow. For example, 2 hours.  
You can change variables cloneRootDirectory and cloneRootDirectory2 to decide where to store file system tree.
## clonePartialFileSystemTree.bat
This windows batch file will clone file system tree of your windows, and you can set clone directory depth. It is much faster than cloneCompleteFileSystemTree.bat. For example, 30 minutes,even 3 minutes.  
You can change variables cloneRootDirectory and cloneRootDirectory2 to decide where to store file system tree.  
You can change variable maxDepth to decide clone directory depth, smaller,faster.
## CAUTION
These batch files are UNIX format line endings, that is , LF.  
However, if you want to run it on your windows system, you should convert it to WINDOWS format, that is , CRLF.  
Or for simplicity, create a new file on windows, and copy the content into the file. 
