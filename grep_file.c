#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1024

void grep_file(const char *filename, const char *pattern) {
    char command[MAX_LINE];
    FILE *fp;
    char result[MAX_LINE];

    // Construire la commande grep
    snprintf(command, sizeof(command), "/bin/egrep '%s' %s", pattern, filename);

    // Ouvrir un processus en utilisant la commande grep
    fp = popen(command, "r");
    if (fp == NULL) {
        perror("popen");
        exit(EXIT_FAILURE);
    }

    // Lire et afficher chaque ligne de la sortie de grep
    while (fgets(result, sizeof(result), fp) != NULL) {
        printf("%s", result);
    }

    // Fermer le processus
    if (pclose(fp) == -1) {
        perror("pclose");
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <filename> <pattern>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    grep_file(argv[1], argv[2]);

    return 0;
}
