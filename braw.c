#include "braw.h"

braw_t *braw_create(void) {
    braw_t *b = malloc(sizeof(braw_t));
    return b;
}

/* set ``*bp'' to the current terminal state */
int braw_get_terminal_state(braw_t *bp)
{
    if (!bp || tcgetattr(STDIN_FILENO, bp) != BRAW_SUCCESS)
        return BRAW_FAILURE;
    return BRAW_SUCCESS;
}

/* use a modified copy of ``*bp'' to put the terminal in raw mode */
int braw_enable_raw_mode(const braw_t *bp)
{
    if (!bp)
        return BRAW_FAILURE;

    braw_t *raw = malloc(sizeof(braw_t));
    if (!raw)
        return BRAW_FAILURE;

    memcpy(raw, bp, sizeof(braw_t));
    cfmakeraw(raw);

    int r = tcsetattr(STDIN_FILENO, TCSAFLUSH, raw);
    free(raw);
    return r == 0 ? BRAW_SUCCESS : BRAW_FAILURE;
}

/* unmodified ``*bp'' is used to return to cooked mode */
int braw_disable_raw_mode(const braw_t *bp)
{
    if (!bp || tcsetattr(STDIN_FILENO, TCSAFLUSH, bp) != BRAW_SUCCESS)
        return BRAW_FAILURE;
    return BRAW_SUCCESS;
}

/* read single character read from the terminal. blocks indefinitely
 * when timeout is < 0 */
int braw_get_char(unsigned char *c, double timeout)
{
    double seconds;
    double u_seconds = modf(timeout, &seconds);

    struct timeval tv;
    tv.tv_sec = (int)seconds;
    tv.tv_usec = (long int)(u_seconds * 1000000);

    fd_set readfds;
    FD_ZERO(&readfds);
    FD_SET(STDIN_FILENO, &readfds);

    int ready;
    if (timeout < 0)
        ready = select(STDIN_FILENO + 1, &readfds, NULL, NULL, NULL);
    else
        ready = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &tv);

    if (ready == 0)
        return BRAW_TIMEOUT;
    if (ready == -1)
        return BRAW_FAILURE;

    if (read(STDIN_FILENO, c, sizeof(unsigned char)) != 1)
        return BRAW_FAILURE;
    return BRAW_SUCCESS;
}

/* send a single character to the terminal */
int braw_put_char(const unsigned char c)
{
    if (write(STDOUT_FILENO, &c, sizeof(unsigned char)) != 1)
        return BRAW_FAILURE;
    return BRAW_SUCCESS;
}
