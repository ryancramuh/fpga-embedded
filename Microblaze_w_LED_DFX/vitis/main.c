#include "FreeRTOS.h"
#include "task.h"

#include "xil_io.h"
#include "xil_printf.h"
#include "xparameters.h"

#define SSEG_DISP     0x40000000U
#define SSEG_DISP_EN  0x40000004U
#define SSEG_AN       0x40000008U
#define SSEG_AN_EN    0x4000000CU

static TaskHandle_t sseg_blink_task_handle = NULL;
static TaskHandle_t print_task_handle = NULL;

void gpio_init(void)
{
    Xil_Out32(SSEG_DISP_EN, 0x00000000U);
    Xil_Out32(SSEG_AN_EN,   0x00000000U);
}

void sseg_blink_task(void *ptr)
{
    (void)ptr;

    for (;;)
    {
        Xil_Out32(SSEG_DISP, 0xFFFFFFFFU);
        Xil_Out32(SSEG_AN,   0xFFFFFFFFU);

        vTaskDelay(pdMS_TO_TICKS(400));

        Xil_Out32(SSEG_DISP, 0x00000000U);
        Xil_Out32(SSEG_AN,   0x00000000U);

        vTaskDelay(pdMS_TO_TICKS(400));
    }
}

void print_task(void *ptr)
{
    TickType_t tick;

    (void)ptr;

    for (;;)
    {
        tick = xTaskGetTickCount();

        xil_printf("tick = %lu\r\n", (unsigned long)tick);

        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

int main(void)
{
    BaseType_t status;

    gpio_init();

    status = xTaskCreate(
        sseg_blink_task,
        "sseg_blink",
        512,
        NULL,
        2,
        &sseg_blink_task_handle
    );

    if (status != pdPASS)
    {
        xil_printf("Failed to create sseg task\r\n");
        while (1);
    }

    status = xTaskCreate(
        print_task,
        "print",
        512,
        NULL,
        2,
        &print_task_handle
    );

    if (status != pdPASS)
    {
        xil_printf("Failed to create print task\r\n");
        while (1);
    }

    xil_printf("Starting scheduler\r\n");

    vTaskStartScheduler();

    while (1)
    {
        /*
         * Should never get here unless scheduler fails.
         */
    }

    return 0;
}