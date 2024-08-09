#include <iostream>
#include <chrono>

#define N 1000000000

void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
    }
}

int main(){
    auto start = std::chrono::system_clock::now();
    float *a, *b, *out; 

    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f * (i % 10); 
        b[i] = 2.0f * (i % 10);
    }

    // Main function
    vector_add(out, a, b, N);

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
