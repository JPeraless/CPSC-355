/*
Author: Jose Perales
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MIN_RAND 0
#define MAX_RAND 9

struct coord {
	int x, y;
};

/*
Creates a random number between the given range, inclusive.
*/
int randumNum(int n, int m) {
	return (rand() % (m - n + 1)) + n;
}

/*
Initializes a 2d integer array
*/
void initialize(int** table, int n) {
	for (int i = 0; i < n; i++) {
		table[i] = (int*)malloc(n * sizeof(int));
		for (int j = 0; j < n; j++)
			table[i][j] = randumNum(MIN_RAND, MAX_RAND);
	}
}

/*
Prints a 2d integer array
*/
void printMat(int** mat, int n) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++)
			printf("%d ", mat[i][j]);
		printf("\n");
	}
}

void displayStats(int digit, struct coord* positions, int count, int n) {
    printf("Digit %d occurs %d times\n", digit, count);
	for (int i = 0; i < count; i++)
		printf("%d. In (%d,%d)\n", i + 1, positions[i].x, positions[i].y);

	int perc = (int)((float)(count / (n * n)) * 100);
	
	printf("The digit %d is %d%% of the matrix\n", digit, perc);
}

int search(int** table, int n, int digit, struct coord* positions) {
    int count = 0;

	for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++){
			if (table[i][j] == digit) {
				positions[count].x = i;
				positions[count].y = j;
				count++;
            }
        }
    }
	return count;
}

void logFile(int** table, int n, int digit, struct coord* positions, int count) {
	FILE* fpointer = fopen("assign1.log", "w");

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++)
			fprintf(fpointer, "%d ", table[i][j]);
		fprintf(fpointer, "\n");
	}

	fprintf(fpointer, "Digit %d occurs %d times\n", digit, count);

	for (int i = 0; i < count; i++)
		fprintf(fpointer, "%d. In (%d,%d)\n", i + 1, positions[i].x, positions[i].y);

	
	fclose(fpointer);
}

int main(int argc, char* argv[]) {
	if (argc != 2) {
		printf("Please provide the table size as the argument\n");
		exit(0);
	}

	unsigned int size = atoi(argv[1]);

    if (size < 0) {
        printf("The size of the table must be positive\n");
        exit(0);
    }

	srand(time(NULL));

	char choice;

	while (choice != 'q' && choice != 'Q') {
		int* table[size];
		
		initialize(table, size);

		printMat(table, size);

		printf("Enter a digit to search for: ");

		int digit;
		scanf("%d", &digit);

		// enough memory for the worst case scenario (all of the digits are the same)
		struct coord positions[size * size];

		int count = search(table, size, digit, positions);

		displayStats(digit, positions, count, size);

		logFile(table, size, digit, positions, count);

		printf("Do you want to [q]uit the program or [c]ontinue?");
		scanf(" %c", &choice);
	}
}
