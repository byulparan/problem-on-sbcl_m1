# SBCL Problem on Apple M1
  I have some problem on SBCL/Apple M1 Silicon

  
## cocoa
  1. build foreign-library(make)
	 ```sh
	 > make
	  ```
  2. run lisp
	 ```sh	
	 > sbcl --load cocoa.lisp
     ```

 click the Button, then call (room) lisp function.  
 look *Control stack usage*, every click to increase usage in M1 native SBCL  
 but SBCL-x86_64 is not.
	 
## shm-open
## glfw-blit-framebuffer

      
