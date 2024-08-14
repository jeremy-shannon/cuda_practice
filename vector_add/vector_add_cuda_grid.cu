#include <iostream>
#include <chrono>

#define N 100000000

using namespace std;

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    
    // Handling arbitrary vector size
    if (tid < n){
        out[tid] = a[tid] + b[tid];
    }
}

int main(){
    auto start = chrono::system_clock::now();
    float *a, *b, *out; 
    float *d_a, *d_b, *d_out; 

    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f * (i % 10); 
        b[i] = 2.0f * (i % 10);
    }

    // Allocate device memory
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);

    // Executing kernel 
    int block_size = 16*16 * 8;
    int grid_size = ((N + block_size) / block_size);

    cout << "block size: " << block_size << ", grid size: " << grid_size << endl;
    
    vector_add<<<grid_size,block_size>>>(d_out, d_a, d_b, N);
    
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) { 
        cout << cudaGetErrorString(error) << endl;
    }

    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);

    // Cleanup after kernel execution
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

    auto end = chrono::system_clock::now();

    chrono::duration<double> elapsed_seconds = end-start;
 
    cout << "elapsed time: " << elapsed_seconds.count() << "s"
              << endl;

    cout << "a: ";
    for (int i = 0; i < 10; ++i) cout << a[i] << ",";
    cout << endl;

    cout << "b: ";
    for (int i = 0; i < 10; ++i) cout << b[i] << ",";
    cout << endl;
    
    cout << "out: ";
    for (int i = 0; i < 10; ++i) cout << out[i] << ",";
    cout << endl;

    free(a);
    free(b);
    free(out);
}
