# cpe315-matmul
## Your name(s) here
Logan Cable lcable99 Jack Meyers JackMeiers Elissa Covarrubias elcovarr

### To build:
```shell
make clean; make
```
Note: to run matmul-mul.s replace matmul.s from Makefil with matmul-mul.s
### To run:
```shell
perf stat ./mm > p.out
```
### To test:
```shell
diff p.out outputs/N.out
```
Note that N above is one of:
* 16
* 64
* 256
* 1024

### To modify the size:
1. edit the matmul.h file
2. edit the line with: 
```C
#define MATRIX_SIZE
```
3. Save the file
4. Rebuild
