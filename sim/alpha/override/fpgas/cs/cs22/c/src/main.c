#include "pass_fail.h"
#include "dma.h"
#include "vmem.h"

VMEM_SECTION unsigned int test_buf[16] = {
    0xf000e000,
    0xf000e001,
    0xf000e002,
};

int main(void)
{
    dma_out_set(VMEM_ROW_ADDRESS(test_buf), 16);
    // for(int i = 0; i < 1024; i++) {
    //     *pass_fail_0 = i;
    // }
}
