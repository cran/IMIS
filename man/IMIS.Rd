\name{IMIS}
\alias{IMIS}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Incremental Mixture Importance Sampling}
\description{IMIS algorithm draws samples from the posterior distribution of multivariate variable. The user has to define the following R functions in advance: prior(x) calculates prior density of x, likelihood(x) calculates the likelihood of x, and sample.prior(n) draws n samples from the prior distribution. For multivariate x, the prior or the likelihood of a vector should be a scalar, and the prior or the likelihood of a matrix should be a vector.}

\usage{
IMIS(B, B.re, number_k, D)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{B}{ The incremental sample size at each iteration of IMIS. }
  \item{B.re}{ The desired posterior sample size at the resample stage. }
  \item{number_k}{ The maximum number of iterations in IMIS. }
  \item{D}{ The number of optimizers which could be 0. }
}

\value{
  \item{resample}{The posterior resamples}
  \item{stat}{ Diagnostic statistics at each IMIS iteration: Marginal likelihood (1st col), Expected number of unique points among the posterior resamples (2nd col), Maximum importance weight (3rd col), Effective sample size (4th col), Entropy of importance weights relative to the uniform distribution (5th col), Rescaled variance of importance weights (6th col).}
  \item{center}{The centers of Gaussian components}
}
\author{ Adrian Raftery and Le Bao <lebao@uw.edu>}
\references{Raftery A.E. and Bao L. (2010) "Estimating and projecting trends in HIV/AIDS generalized epidemics using incremental mixture importance sampling." Biometrics.}

\keyword{}

\examples{
## Example for multivariate case
likelihood <- function(theta)	dmvnorm(theta, c(1,1), matrix(c(1,0.6,0.6,1),2,2))
prior <- function(theta)	dmvnorm(theta, c(0,0), diag(3,2))
sample.prior <- function(n)	rmvnorm(n, c(0,0), diag(3,2))
result = IMIS(500, 3000, 100, 10)
x1 = x2 = seq(-2, 4, by=0.1)
z = matrix(NA,length(x1),length(x2))
for (i in 1:length(x1))
	for (j in 1:length(x2))
		z[i,j] = likelihood(c(x1[i],x2[j])) * prior(c(x1[i],x2[j]))
contour(x1, x2, z, drawlabels=FALSE, pty="s")
points(result$resample[,1], result$resample[,2], cex=0.1)

## Example for univariate case
likelihood <- function(theta)	exp(-1*sin(3*theta)*sin(theta^2) - 0.1*theta^2)
prior <- function(theta)	dnorm(theta, 0, 5)
sample.prior <- function(n)	rnorm(n, 0, 5)
result = IMIS(500, 3000, 100, 10)
plot(density(result$resample, adjust=0.3), xlim=c(-5,5), main = "wild function")
x = seq(-5, 5, 0.001)
lines(prior(x)*likelihood(x)~x, xlim=c(-5,5), col="red")
}
