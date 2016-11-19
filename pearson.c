#define _CRT_SECURE_NO_WARNINGS
#define PROGRAM_FILE "matvec.cl"
#define KERNEL_FUNC "matvec_mult"

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

#ifdef MAC
#include <OpenCL/cl.h>
#else
#include <CL/cl.h>
#endif

int main() {

/*
  This initial amount of code has been derived and modified by the 1st chapter
  code examples from the 'OpenCL in action' technical
*/

  /* Host/device data structures */
  cl_platform_id platform;
  cl_device_id device;
  cl_context context;
  cl_command_queue queue;
  cl_int i, err;

  /* Program/kernel data structures */
  cl_program program;
  FILE *program_handle;
  char *program_buffer, *program_log;
  size_t program_size, log_size;
  cl_kernel kernel;

  // I have 76,451 samples to compare to each other

  /* Data and buffers */
  float mat[16], vec[4], result[4];
  float correct[4] = {0.0f, 0.0f, 0.0f, 0.0f};
  cl_mem mat_buff, vec_buff, res_buff;
  size_t work_units_per_kernel;

}
