#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LENGTH 32

int digits(int n) {
    int i = 1;
    while (n /= 10)
        i++;
    return i;
}

char *titleCount(int i, char print[]) {
    sprintf(print, "-- [%d]", i);
    return print;
}

char *lineCount(int i, char print[]) {
    int spacing = 5 - digits(i);
    sprintf(print, "\t%d%*s", i, spacing, " ");
    return print;
}

void fixLineCount(FILE *in, FILE *out) {
    int i, j = i = 0;
    char read[LENGTH], print[LENGTH];

    while (fgets(read, LENGTH, in)) {
        if (read[0] == '\t')
            fputs(strcat(lineCount(j++, print), read + 6), out);
        else if (read[0] == '-') {
            fputs(strcat(titleCount(i, print), read + 5 + digits(i)), out);
            i++;
        } else
            fputs(read, out);
    }
}

/* This program fixes line numbers for the generated charmap.mif file, after
 * characters are arbitrarily sorted by the user by manipulating the text file
 * directly. */

int main(int argc, char *argv[]) {
    FILE *input, *output;

    // Check if the user provided the correct number of arguments
    if (argc != 3) {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Open the input file for reading
    input = fopen(argv[1], "r");
    if (input == NULL) {
        printf("Error: Unable to open input file '%s' for reading.\n", argv[1]);
        return EXIT_FAILURE;
    }

    // Open the output file for appending
    output = fopen(argv[2], "w");
    if (output == NULL) {
        printf("Error: Unable to open output file '%s' for appending.\n",
               argv[2]);
        fclose(input);
        return EXIT_FAILURE;
    }

    // Fix line counts and write to the output file
    fixLineCount(input, output);

    // Close the input and output files
    fclose(input);
    fclose(output);

    return EXIT_SUCCESS;
}
