//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int NTest;
  int NTrain;
  matrix[NTrain,2] XTrain;
  matrix[NTest,2] XTest;
  real YTrain[NTrain];
  real YTest[NTest];
}
parameters {
  real beta0;
  real beta1;
  real beta2;
  real<lower=0> sigma;
}
model {
  for (i in 1:NTrain) {
    YTrain[i] ~ normal(beta0 + beta1 * XTrain[i,1] + beta2 * XTrain[i,2],sigma);
  }
  beta0 ~ normal(0,1);
  beta1 ~ normal(0,1);
  beta2 ~ normal(0,1);
  sigma ~ lognormal(0,1);
}
generated quantities {
  vector[NTest] logLike;
    for (i in 1:NTest) {
      logLike[i] = normal_lpdf(YTest[i] | beta0 + beta1 * XTest[i,1] + beta2 * XTest[i,2],sigma);
    }
}