/*
Bharat Kathi
ECE 154A - Fall 2012
Lab 2 - Mystery Caches
Due: 12/3/12, 11:00 pm

Mystery Cache Geometries:
mystery0:
    Cache size: 4194304 bytes
    Cache associativity: 16
    Cache block size: 64 bytes
mystery1:
    Cache size: 4096 bytes
    Cache associativity: 1
    Cache block size: 4 bytes
mystery2:
    Cache size: 4128 bytes
    Cache associativity: 128
    Cache block size: 32 bytes
*/

#include <stdlib.h>
#include <stdio.h>

#include "mystery-cache.h"

/* 
   Returns the size (in B) of the cache
*/
int get_cache_size(int block_size) {
  /* YOUR CODE GOES HERE */
  int i = 0;
  int cache_check = block_size;
  flush_cache();
  access_cache(0);
  while (access_cache(0)) {
    i = block_size;
    while (i <= cache_check) {
      i += block_size;
      access_cache(i);
    }
    cache_check += block_size;
  }
  return i;
}

/*
   Returns the associativity of the cache
*/
int get_cache_assoc(int size) {
  /* YOUR CODE GOES HERE */
  int i = 0;
  int cache_check = 1;
  int assoc = 0;
  flush_cache();
  access_cache(0);
  while (access_cache(0)) {
    i = size;
    assoc = 0;
    while (i <= cache_check) {
      i += size;
      assoc++;
      access_cache(i);
    }
    cache_check += size;
  }
  return assoc;
}

/*
   Returns the size (in B) of each block in the cache.
*/
int get_block_size() {
  /* YOUR CODE GOES HERE */
  int i = 0;
  int block_size = 0;
  access_cache(0);
  while (access_cache(i)) {
    block_size++;
    i++;
  }
  return block_size;
}

int main(void) {
  int size;
  int assoc;
  int block_size;
  
  /* The cache needs to be initialized, but the parameters will be
     ignored by the mystery caches, as they are hard coded.
     You can test your geometry paramter discovery routines by 
     calling cache_init() w/ your own size and block size values. */
  cache_init(0,0);
  
  block_size = get_block_size();
  size = get_cache_size(block_size);
  assoc = get_cache_assoc(size);


  printf("Cache size: %d bytes\n",size);
  printf("Cache associativity: %d\n",assoc);
  printf("Cache block size: %d bytes\n",block_size);
  
  return EXIT_SUCCESS;
}
