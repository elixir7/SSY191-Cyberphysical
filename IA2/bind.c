#include <stdio.h>
#include <stdlib.h>

#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

xTaskHandle task_a_Handle;
xTaskHandle task_b_Handle;
xTaskHandle task_c_Handle;

SemaphoreHandle_t resource_a;
SemaphoreHandle_t resource_b;

void the_task(void *pvParameters){
	while (1){
		xSemaphoreTake(resource_a, portMAX_DELAY);
		xSemaphoreTake(resource_b, portMAX_DELAY);
		if (...){
			xSemaphoreGive(resource_a);
			xSemaphoreTake(resource_a, portMAX_DELAY);
		}
		xSemaphoreGive(resource_b);
		xSemaphoreGive(resource_a);
	}
}

int main(int argc, char **argv)
{
    resource_a = xSemaphoreCreateMutex();
    resource_b = xSemaphoreCreateMutex();
    xTaskCreate(the_task, "Task 1", configMINIMAL_STACK_SIZE, NULL, 1, &task_a_Handle);
    xTaskCreate(the_task, "Task 2", configMINIMAL_STACK_SIZE, NULL, 1, &task_b_handle);
    xTaskCreate(the_task, "Task 3", configMINIMAL_STACK_SIZE, NULL, 1, &task_c_handle);

    vTaskStartScheduler();
    for( ;; );
}
