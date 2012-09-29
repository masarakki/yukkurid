#include <stdio.h>
#include <AquesTalk2.h>

#define YUKKURI_BUFFSIZE 4096

int main(int argc, char **argv) {
    int size;
    char buffer[YUKKURI_BUFFSIZE];
    unsigned char *wav;

    if (fgets(buffer, YUKKURI_BUFFSIZE-1, stdin) == 0) {
        return 0;
    }

    wav = AquesTalk2_Synthe_Utf8(buffer, 100, &size, NULL);
    if (wav == 0) {
        fprintf(stderr, "ERR:%d\n", size);
        return -1;
    }
    fwrite(wav, 1, size, stdout);
    AquesTalk2_FreeWave(wav);
    return 0;
}
