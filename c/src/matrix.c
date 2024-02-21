#include <stdlib.h>
#include <stdio.h>

void use_vla_pointer(int i, int j)
{
    printf("VLA pointer syntax\n");
    // we use VLA pointer here to point to heap-allocated array
    double (*mat)[i][j] = malloc(sizeof(double[i][j]));

    for (int a = 0; a < i; a++)
        for (int b = 0; b < j; b++) {
            (*mat)[a][b] = (a + 1) * b;
        }

    for (int a = 0; a < i; a++) {
        for (int b = 0; b < j; b++) {
            printf("%.2lf\t", (*mat)[a][b]);
        }
        putchar('\n');
    }
}

#define MATRIX_IDX(row, col, n_cols) (row * n_cols + col)

void use_traditional_way(int i, int j)
{
    printf("Traditional syntax\n");
    double *mat = malloc(sizeof(double) * i * j);

    for (int a = 0; a < i; a++)
        for (int b = 0; b < j; b++) {
            mat[MATRIX_IDX(a, b, j)] = (a + 1) * b;
        }

    for (int a = 0; a < i; a++) {
        for (int b = 0; b < j; b++) {
            printf("%.2lf\t", mat[MATRIX_IDX(a, b, j)]);
        }
        putchar('\n');
    }
}

int main()
{
    int rows = 5, cols = 8;
    use_vla_pointer(rows, cols);
    use_traditional_way(rows, cols);

    return 0;
}
