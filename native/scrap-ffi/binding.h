#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef void *RuntimePtr;

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/**
 * Destroy the Tokio Runtime, and return 1 if everything is okay
 */
int32_t destroy_runtime(RuntimePtr runtime);

int32_t error_message_utf8(char *buf, int32_t length);

int32_t last_error_length(void);

int32_t load_page(RuntimePtr runtime, const char *url, int64_t port_id);

/**
 * Setup a new Tokio Runtime and return a pointer to it so it could be used later to run tasks
 */
RuntimePtr setup_runtime(void);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus
