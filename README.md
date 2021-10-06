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

## when call foreign function for over 10 arguments.

```c
#include <stdio.h>
	
void test_fun(int a1, int a2, int a3, int a4, int a5, int a6, int a7, int a8, int a9, int a10, int a11, int a12) {
  printf("input args: %d %d %d %d %d %d %d %d %d %d %d %d\n", a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
  fflush(stdout);
}
```

```cl
(load-shared-object "libffitest.dylib")

(alien-funcall 
  (extern-alien "test_fun" (function void int int int int int int int int int int int int))
 0 1 2 3 4 5 6 7 8 9 10 11)
```

```sh
> sbcl --load ffi-test.lisp
```

## shm-open
 This is not SBCL's bug. It seems CFFI side problem.  
 ~~Can't access shared memory which opened by sbcl(arm64)~~


## glfw-blit-framebuffer
 Error when call gl:blit-framebuffer on sbcl(arm64) but works on ecl(arm64) 
      
