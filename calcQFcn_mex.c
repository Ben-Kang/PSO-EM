/* 
 * Copyright (c) 2016 Xin (Ben) Kang
 *
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "mex.h"

#define	max(A, B)	((A) > (B) ? (A) : (B))
#define	min(A, B)	((A) < (B) ? (A) : (B))
#define PI 3.14159265358979323846
#define PI2 PI*PI

void calcQFun( double* x, double* y,      /* coordinates/attribute vectors */
								 double* sigma2,          /* variance for Gaussian */
								 double w,                /* amount of outliers */
								 int N, int M, int D,     /* data dimensions */
								 double* E, double* Pmn )	/* Q fn value & Pmn */		
{
	int n, m, d;
	double ksig, diff, dist, outlier_term, sp;
	double *P;
	
	/*-------------------*/
	/*  Calculate p_{mn} */
	/*-------------------*/
	/* outlier_term = \frac{(2\pi\sigma^2)^{D/2} w M} {(1-w)N}
	 * which is the 2nd term of the denominator of p_{mn}
	 *
	 * (*w) - amount of outliers */
	ksig = -2.0*(*sigma2);
	outlier_term = (w*M*pow(-ksig*PI,0.5*D))/((1-w)*N);
	
	P = (double*) calloc(M, sizeof(double));
	for (n=0; n < N; n++) { /* for each x_{n}, a image contour point */
		sp = 0;
		for (m=0; m < M; m++) { /* for each y_{m}, a projected 3D point */
			/* ||x_n - y_m||^2 */
			dist = 0;	/* Euclidean distance */
			for (d=0; d < D; d++) {
				diff = *(x+n+d*N) - *(y+m+d*M);
				diff = diff * diff;
				dist += diff;
			} /* dist = ||x_n - y_m||^2 */
			
			*(P+m) = exp(dist/ksig);	/* numerator of p_{mn} */			
			sp += *(P+m);							/* cumulate the 1st term of 
																 * the denominator of p_{mn} 
																 * for current x_{n} */
		} /* for each y_{m} */
		
		sp += outlier_term;					/* the denominator of p_{mn}, given n */
		for (m=0; m < M; m++) {
			*(Pmn+m+n*M) = *(P+m)/sp;
		}
		
 		*E += -log(sp);							/* cumulating Q function */
	} /* for each x_{n} */

	/* value of the Q function */
	*E += 0.5*D*N*log(*sigma2);
					
	free((void*)P);
}

/* -------------------------------------------------------------------- */
/*                     Matlab interface function                        */ 
/* -------------------------------------------------------------------- */

/* Input arguments */
#define IN_x				prhs[0]	/* coord. of the 2D image contour points */
#define IN_y				prhs[1]	/* coord. of the projected 3D contour points */
#define IN_sigma2		prhs[2]	/* $\sigma^2$ of the Gaussian distribution*/
#define IN_outlier	prhs[3]	/* amount of the outlier */
#define IN_Gx				prhs[4] /* image gradients */
#define IN_Gy				prhs[5] /* projected outer normals*/
#define IN_kappa		prhs[6] /* concentration of the von Mises-Fisher pdf */ 
#define IN_I0k			prhs[7]	/* Bessel fn of order 0 */

/* Output arguments */
#define OUT_E				plhs[0]
#define OUT_Pmn			plhs[1]

/* Gateway routine */
void mexFunction( int nlhs, mxArray *plhs[], 
									int nrhs, const mxArray *prhs[] ) 
{
	double *x, *y, *sigma2, *outlier,	/* basic arguments */
				 *Gx, *Gy, *kappa, *I0k,		/* gradient related */
				 *E, *Pmn;									/* output arguments */
	int N, M, D;	/* dimensions of the points */
	
	/* Get the sizes of each input argument */
	M = mxGetM(IN_y); D = mxGetN(IN_y);
	N = mxGetM(IN_x); D = mxGetN(IN_x);
	
	/* Assign pointers to the input arguments */
	x	= mxGetPr(IN_x);  // Coord. of image contour points
	y = mxGetPr(IN_y);  // Coord. of projected countour generator points
	sigma2  = mxGetPr(IN_sigma2);  // variances of the isotropic Gaussian
	outlier = mxGetPr(IN_outlier); // the amount of the outliers (0-1)

	/* Create new arrays and set the output pointers to them */
	OUT_E   = mxCreateDoubleMatrix(1, 1, mxREAL);
	OUT_Pmn = mxCreateDoubleMatrix(M, N, mxREAL);
	
	/* Assign pointers to the output arguments */
	E   = mxGetPr(OUT_E);
	Pmn = mxGetPr(OUT_Pmn);
		
	if (nrhs == 4) {
	 	calcQFun(x, y, sigma2, *outlier, N, M, D, E, Pmn);
	} else {
		E = NULL;
		Pmn = NULL;
		mexErrMsgTxt("Wrong # of input arguments!");
	}
	
	return;
}

/* EOF */
