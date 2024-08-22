#include "cpu_bitmap.h"
#include "julia.cuh"
#include <memory>
 
using namespace std;

struct cuComplex {
    float r;
    float i;
    __device__ cuComplex( float a, float b ) : r(a), i(b) {}
    __device__ float magnitude2( void ) {
        return r * r + i * i;
    }
    __device__ cuComplex operator*(const cuComplex& a) {
        return cuComplex(r*a.r - i*a.i, i*a.r + r*a.i);
    }
    __device__ cuComplex operator+(const cuComplex& a) {
        return cuComplex(r+a.r, i+a.i);
    }
};

__device__ int julia( int x, int y, int w, int h) {
	const float scale = 1.5;
	float jx = scale * (float)(w/2 - x)/(w/2);
	float jy = scale * (float)(h/2 - y)/(h/2);
	
	cuComplex c(-0.8, 0.156);
	cuComplex a(jx, jy);

	int i = 0;
	for(i=0; i<200; i++){
		a = a * a + c;
		if (a.magnitude2() > 1000)
			return 0;
	}

	return 1;
}

__global__ void kernel( unsigned char *ptr, int w, int h ) {
	// map from threadIdx/BlockIdx to pixel position
	int x = blockIdx.x;
	int y = blockIdx.y;
	int offset = x + y * gridDim.x;

	// now calculate the value at that position
	int juliaValue = julia( x, y, w, h);
	ptr[offset*4 + 0] = 255 * juliaValue * 0.8;
	ptr[offset*4 + 1] = 255 * juliaValue * 0.7;
	ptr[offset*4 + 2] = 255 * juliaValue * 0.9;
	ptr[offset*4 + 3] = 255;
}

CPUBitmap* generate_julia(int width, int height ) {
	CPUBitmap* bitmap = new CPUBitmap( width, height );
	unsigned char *dev_bitmap;

	cudaMalloc( (void**)&dev_bitmap, bitmap->image_size() ) ;

	dim3 grid( width, height );
	
	kernel<<<grid,1>>>( dev_bitmap, width, height );

	cudaMemcpy( bitmap->get_ptr(), 
				  dev_bitmap, 
				  bitmap->image_size(), 
				  cudaMemcpyDeviceToHost ) ;

	cudaFree( dev_bitmap ) ;

	return bitmap;
}