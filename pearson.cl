// http://www.stat.wmich.edu/s216/book/node122.html

// Precondition: File data will have to be read in
// done timestamp: 4:00 pm 11-22-1016



/********************************DATA PARTITIONING*****************************/
// Initially we'll need dummy data (2 - 80 double entries)
/*****************************END DATA PARTITIONING****************************/



/*****************************PROCESS PARTITIONING*****************************/
// The processing block listed below will be 'placed' in here
// this part bridges with the data partitioning labeled above
/*****************************END PROCESS PARTITIONING*************************/



/*********************************PROCESSING**********************************/

/******************************PSEUDO CODE************************************/

/* Human readable Steps to get the Coefficient */
/*
   1. Multiply the current row to subsequent rows beneath it
    a. Add the the products from multiplying two rows into one sum
       This will be variable A (Sum of multiplying 2 rows)
   2. Sum the the current row and the row beneath the current seperately
    a. This will be variable B (sum of entries in current row) and C (sum of
       entries in lower row)
    b. Multiply B and C to get variable D
    c. Divide D by E (the integral number of entries (this should be the same
       for every row))
    d. Call the result of this F
   3. Subtract: 1. - 2. (or A - F) This gives the covariance of the two
      particular samples. We will call this end result G.
    a. If there is a number there that is not 'too close' to 0, then the two
       genes/transcripts may have some sort of relationship in their respective
       synthesis/construction/expression
   4. Square and add each entry of the respective row and the subsequent row as
      well
    a. Respectively these variables will be called H and I
  5. Sum each row and square the sum of the respective row and the subsequent
     row as well
    a. Respectively these variables will be called J and K
  6. Divide 5. (J and K) by E (the integral number of entries of the specific
     row (this number should be the same for EVERY row))
    a. Call the results of J/E and K/E: L and M respectively
  7. Subtract H by L (H - L) and I by M (I - M)
    a. Call the results N and O respectively
  8. Multiply N and O and take the square root of the product
    a. Call the result P
  9. Divide F by P (F / P)
    a. Call this the result the Pearson Coefficient
    b. OH SNAP! We're done
*/

// Possible # of Intermediate Variables: 16 intermediate variables

/*****************************CL FUNCTION CALLS*******************************/

/* Toes into OpenCL */
/* Precondition: Have two different rows in scope of this kernel */

/*
  Functions that can used in acquiring the above variables
  Variable A: Use the dot product
    The largest vector using the 1.2 standard is the 16 wide vector
    16*5 = 80. Split the row into 5 sets of 'dotting' double16 vectors add the
    5 sepearate scalars together.
  Variable B and C: Sum the rows (5 sets of double16 vectors) into scalars
  Variable D: Scalar multiplication B * C store in D
  Variable E: This should be the number 80 (hardcoded, dirty I know)
  Variable F: Scalar division D / E store in F
  Variable G: Scalar subtraction A - F store in G
  Variable H and I: Square atomically (each of the elements in the vectors) the
    5 double16 vectors add their respective squares together.
  Variable J and K: Square scalars B and C and store in variables (J & K)
  Variable L and M: Scalar Division (L = J / E) and (M = K / E)
  Variable N and O: Scalar subtraction (N = H - L) & (O = I - M)
  Variable P: Scalar multiplication and root (sqrt(N*O))

  Variable FIN: Scalar Division (F / P)

*/

/*******************************END PROCESSING********************************/

/*
  To be used in the construction of variables B & C
*/
void sum_row(__global double16* row0, __global double16* row1,
                      __global double16* row2, __global double16* row3,
                      __global double16* row4, __global double16* sum)
{
  sum = row0 + row1 + row2 + row3 + row4;
}

/*
  To be used in the construction of variables H & I
*/
void sqaure_and_sum_row_elements(__global double16* row0,
                                          __global double16* row1,
                                          __global double16* row2,
                                          __global double16* row3,
                                          __global double16* row4,
                                          __global double16* result)
{
  result = pown(row0, 2) + pown(row1, 2) + pown(row2, 2) + pown(row3, 2) +
           pown(row4, 2);
}

/*
  To be used in the construction of variable A

*/
void dot_row(__global double4* upper_row0, __global double4* lower_row0,
                      __global double4* upper_row1, __global double4* lower_row1,
                      __global double4* upper_row2, __global double4* lower_row2,
                      __global double4* upper_row3, __global double4* lower_row3,
                      __global double4* upper_row4, __global double4* lower_row4,
                      __global double* dot_sum)
{

}

__kernel void spearman(/*kern_arg0*/int size,/*kern_arg1*/ int chunk,
                       /*kern_arg2*/int minSize, /*kern_arg3*/__global int* insts,
                       /*kern_arg4*/__global float* exprs, /*kern_arg4*/__global float* result,
                       /*kern_arg5*/ __global float* alistF, /*kern_arg6*/__global float* blistF,
                      //  __global int* rankF, __global int* iRankF, __global long* summationF,
                       /*kern_arg7*/__global float* aTmpListF, /*kern_arg8*/__global float* bTmpListF,
                       /*kern_arg9*/__global int* aWorkF, /*kern_arg10*/__global int* bWorkF,
                       /*kern_arg11*/__global int* aPointF,
                       /*kern_arg12*/__global int* bPointF)
{
   int i = get_group_id(0)*2;
   int j = get_group_id(0);
   int wsize = get_local_size(0)*2*chunk;
   // '1st' row
   __global float* alist = &alistF[j*wsize];
   // '2nd' row
   __global float* blist = &blistF[j*wsize];
   // not needed
  //  __global int* rank = &rankF[j*wsize];
  //  __global int* iRank = &iRankF[j*wsize];
   __global long* summation = &summationF[j*wsize];
   __global float* aTmpList = &aTmpListF[j*wsize];
   __global float* bTmpList = &bTmpListF[j*wsize];
   // Work group sizes of each row (after dealing with the NANs?)
   // TODO: Verify this
   __global int* aWork = &aWorkF[j*wsize];
   __global int* bWork = &bWorkF[j*wsize];
   // TODO: What are these?
   __global int* aPoint = &aPointF[j*wsize];
   __global int* bPoint = &bPointF[j*wsize];

   fetch_lists(insts[i],insts[i+1],size,chunk,aTmpList,bTmpList,exprs);
   prune_lists(chunk,aTmpList,aWork,aPoint,bTmpList,bWork,bPoint);
   // Not needed
   /*
   double_bitonic_sort_ii(chunk,aWork,aPoint,bWork,bPoint);
   construct_lists(chunk,aTmpList,alist,aPoint,bTmpList,blist,bPoint,rank,iRank);
   bitonic_sort_ff(chunk,alist,blist);
   bitonic_sort_fi(chunk,blist,rank);
   calc_ranks(chunk,summation,rank,iRank);
   accumulate(chunk,summation,iRank);
  */

   if (get_local_id(0)==0)
   {
      size = iRank[0];
      if (size<minSize)
      {
         result[j] = NAN;
      }
      else
      {
         result[j] = 1.0-(6.0*(float)summation[0]/((float)size*(((float)size*(float)size)-1)));
      }
   }
}
