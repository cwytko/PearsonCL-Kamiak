// http://www.stat.wmich.edu/s216/book/node122.html

// Precondition: file data will have to be read in
// done timestamp: 4:00 pm 11-22-1016

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
  8. Multiply M and N and take the square root of the product
    a. Call the result P
  9. Divide F by P (F / P)
    a. Call this the result the Pearson Coefficient Oh snap
*/

// Possible # of Intermediate Variables: 16 intermediate variables

/*****************************CL FUNCTION CALLS*******************************/

/* Toes into OpenCL */

/*
  Functions that can used in acquiring the above varaibles
  Variable A: Use the dot product
    The largest vector using the 1.2 standard is the 16 wide vector
    16*5 = 80, however on the data we have that straggling column that
    doesn't have label no matter I'll use the last entry anyway
    split the row into 5 sets of 'dotting' double16 vectors add the 5 sepearate
    scalars together
  Variable B and C: Sum the rows (5 sets of double16 vectors) into scalars
  Variable D: Multiply the 2 scalars
  Variable E: This should be the number 80 (can be hardcoded in our case)
  Variable F: Scalar division D / E
  Variable G: Scalar subtraction A - F
  Variable H and I: square atomically each of the double16

*/
