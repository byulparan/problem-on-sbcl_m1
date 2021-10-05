# SBCL Problem on Apple Silicon M1
  I have some problem on SBCL Apple Silicon M1.  
  https://www.youtube.com/watch?v=m22H8Z8HadI
  
## cocoa
  **THIS IS FIXED**

  1. build foreign-library(make)
	 ```sh
	 > make
	  ```
  2. run lisp
	 ```sh	
	 > sbcl --load cocoa.lisp
     ```

 ~~click the Button, then call (room) lisp function.~~  
 ~~look Control stack usage, every click(call lisp-callback) to increase usage in native SBCL-arm64~~   
 ~~but SBCL-x86_64 is not.~~
	 
## shm-open
 This is not SBCL's bug. It seems CFFI side problem.  
 ~~Can't access shared memory which opened by sbcl(arm64)~~


## glfw-blit-framebuffer
 Error when call gl:blit-framebuffer on sbcl(arm64) but works on ecl(arm64) 
      
