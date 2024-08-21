#include "cuda_test.cuh"
#include <iostream>

using namespace std;

__global__ void test_kernel(void) {
}

void wrapper(void)
{
    test_kernel <<<1, 1>>> ();
    cout << "Hello from cuda_test" << endl;
}