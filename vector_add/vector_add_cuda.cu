#include <iostream>
#include <chrono>

#define N 1000

__global__ void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
    }
}

int main(){
    auto start = std::chrono::system_clock::now();
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

    // Main function
    vector_add<<<1,1>>>(d_out, d_a, d_b, N);

    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);

    // Cleanup after kernel execution
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double> elapsed_seconds = end-start;
 
    std::cout << "elapsed time: " << elapsed_seconds.count() << "s"
              << std::endl;

    std::cout << "a: ";
    for (int i = 0; i < 10; ++i) std::cout << a[i] << ",";
    std::cout << std::endl;

    std::cout << "b: ";
    for (int i = 0; i < 10; ++i) std::cout << b[i] << ",";
    std::cout << std::endl;
    
    std::cout << "out: ";
    for (int i = 0; i < 10; ++i) std::cout << out[i] << ",";
    std::cout << std::endl;

    free(a);
    free(b);
    free(out);
}
