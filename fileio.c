#include <stdio.h>
#include <stdlib.h>

/*
 This is a function that gathers the data from this particular file
 and formats it in an intuitive way.

 Once I have it done I'll turn a few the variables into externals so then I can
 include this file in the project.

 This is a naive way (as in I'm NOT using OpenCL to partition file i/o) but
 first I want the algorithm to work
*/
double *score[56393];
size_t size = 80*(sizeof(double));
int i;


char sample_name[80][50];
char gene_transcripts[56393][50];


void read (void)
{
  // The hardcoded # of samples in this particular file (80)
  unsigned int sample_count = 0,
  gene_transcript_count = 0,
  score_sample_count = 0;

  for(i = 0; i < 56393; i++)
    score[i] = (double *) malloc(size);

  FILE *handle = fopen("GEM-log-no.txt", "r");
  // Here I need to seperate on a tab delimiting manner
  if(handle == NULL)
  {
    printf("File could not be opened yo\n");
    return;
  }

  // I have to know how many samples I have so keep a count
  // for now I'll just hard code my number of samples
  while(!feof(handle) && sample_count < 80)
  {
    fscanf(handle,"%s", sample_name[sample_count]);
    //printf("%s\n", sample_name[sample_count]);
    sample_count++;
  }

  // If I scan here right now I get the first gene/transcript
  while(!feof(handle))
  {

    // I want to ignore the last column entries for now
    // it doesn't have a sample associated to it
    // TODO: Find the sample's label

    // Each row consists of 80 columns, the particular score of that gene we
    // are on (the row) associated to the column
    // So after every 80 column reads we are to read in the gene
    if(sample_count % 80 == 0)
    {
      //  printf("\n");
      fscanf(handle, "%s", gene_transcripts[gene_transcript_count]);
      //printf("gene_transcript#%u: %s\n", gene_transcript_count, gene_transcripts[gene_transcript_count]);
      gene_transcript_count++;
      sample_count = 0;
    }

    // The next read from the file will be a double that will be the relationship
    // measure of the particular gene and the sample of that row

    //      56393  80
    //        |    |
    // score[row][col]

    fscanf(handle, "%lf", &score[gene_transcript_count - 1][sample_count]);
    // printf("Row: %u Col: %u  Gene/transcript#%u %s: %.12lf\n", gene_transcript_count, sample_count, gene_transcript_count, gene_transcripts[gene_transcript_count - 1], score[gene_transcript_count - 1][sample_count]);

    score_sample_count++;
    sample_count++;

  }

  printf("out\n");
  getchar();

  fclose(handle);
  return;
}
