#include <cuda_runtime.h>
#include <stdio.h>

__global__ void vectorAdd(const float *A, const float *B, float *C, int numElements) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < numElements) {
        C[i] = A[i] + B[i];
    }
}

extern "C" void launchVectorAdd(const float *A, const float *B, float *C, int numElements) {
    float *d_A = nullptr;
    float *d_B = nullptr;
    float *d_C = nullptr;

    cudaMalloc((void **)&d_A, numElements * sizeof(float));
    cudaMalloc((void **)&d_B, numElements * sizeof(float));
    cudaMalloc((void **)&d_C, numElements * sizeof(float));

    cudaMemcpy(d_A, A, numElements * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, numElements * sizeof(float), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (numElements + threadsPerBlock - 1) / threadsPerBlock;
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, numElements);

    cudaMemcpy(C, d_C, numElements * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
