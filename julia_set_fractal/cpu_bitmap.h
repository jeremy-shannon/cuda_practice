
#ifndef __CPU_BITMAP_H__
#define __CPU_BITMAP_H__

// #include "gl_helper.h"

struct CPUBitmap {
    unsigned char    *pixels;
    int     x, y;

    CPUBitmap( int width, int height) {
        pixels = new unsigned char[width * height * 4];
        x = width;
        y = height;
    }

    ~CPUBitmap() {
        delete [] pixels;
    }

    unsigned char* get_ptr( void ) const   { return pixels; }
    long image_size( void ) const { return x * y * 4; }
};

#endif  // __CPU_BITMAP_H__