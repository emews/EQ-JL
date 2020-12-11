# CHANGELOG


For using EQ-JL with your Julia code, you must be sure that you are using a Swift/T version with working Julia 1.5. Following, you can find the instructions to adapt Swift-t for running Julia code.

## Swift-t changelog
- turbine/code/Makefile.in
  - Lines 312-314 deleted
    ```INCLUDES += -I $(USE_JULIA)/src
	  INCLUDES += -I $(USE_JULIA)/usr/include
	  INCLUDES += -I $(USE_JULIA)/src/support```
  - Line 314 added ```INCLUDES += -I $(USE_JULIA)/include/julia```
  - Line 390 ```JULIA_LIB = $(USE_JULIA)/lib``` 
- turbine/code/src/tcl/julia/tcl-julia.c
  - Line 36 change to ``` jl_init();```
  - Line 12 added library ```#include <dlfcn.h>``` in order to do the dynamic link from external source through 
```dlopen("libjulia.so", RTLD_NOW | RTLD_GLOBAL);```
  - Line 38 commented definition ```JL_SET_STACK_BASEM;``` in function ```julia_inizialize(void)```
- turbine/code/configure.ac
  - Line 848 changed ```AC_CHECK_FILE(${USE_JULIA}/include/julia/julia.h, [],```.

## Tested installation of Swift-t with Julia 1.5
1. Create a settings file:
```
./dev/build/init-settings.sh
```

1. Edit the settings file ```dev/build/swift-t-settings.sh```
```
95 # Enable Julia integration
96 ENABLE_JULIA=1
97 JULIA_INSTALL={JULIA-HOME}
```
Remember to change ```{JULIA-HOME}```with your Julia home src.

2. Run the build script ```dev/build/build-swift-t.sh```

See [The Swift/T](http://swift-lang.github.io/swift-t/guide.html) Guide for more informations.

## Experimenting on Amazon AWS EC2 Ubuntu instance

The best way for experimenting with Swift-t EQ-JL is to run on an Amazon EC2 multiple cores machine. 

1. Launch a new EC2 instance using the ```ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026``` AMI (ami-0a91cd140a1fc148a), the latest ubuntu image.
2. ```git clone https://github.com/emews/EQ-JL.git```
3. ```cd EQ-JL && sudo bash support/installEC2.sh```
3. Run [noop](examples/noop) example.

Tested with Swift-t commit [822df8db992e2c301ef68ecfac8b3dfc3cd8663d](https://github.com/swift-lang/swift-t/commit/822df8db992e2c301ef68ecfac8b3dfc3cd8663d).
### Contributors

- Carmine Spagnuolo, PhD
- Giuseppe D'Ambrosio, PhD Student
- Matteo D'Auria, PhD Student
