#define _DEFAULT_SOURCE

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <termios.h>
#include <unistd.h>

#define BRAW_SUCCESS 0
#define BRAW_FAILURE -1
#define BRAW_TIMEOUT 1

typedef struct termios braw_t;

braw_t *braw_create(void);
int braw_get_terminal_state(braw_t *bp);
int braw_enable_raw_mode(const braw_t *bp);
int braw_disable_raw_mode(const braw_t *bp);
int braw_get_char(unsigned char *c, double timeout);
int braw_put_char(const unsigned char c);
