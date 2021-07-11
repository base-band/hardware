#pragma once
#include <stdint.h>
#include <unistd.h> //usleep

typedef struct {
    uint32_t ttl;
    uint32_t data;
} raw_ringbus_t;

class EventDsp;

typedef struct {
    size_t peer;
    raw_ringbus_t rb;
    EventDsp* dsp;
} ringbus_later_t;



typedef struct {
    size_t d0;
    size_t d1;
} custom_event_t;

typedef void (*custom_event_callback_t)(custom_event_t*);