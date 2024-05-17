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
  int<lower=0> NTrain;
  int<lower=0> NTest;
  vector[NTrain] log_wage;
  vector[NTrain] schooling; 
  vector[NTrain] experience;
  vector[NTrain] gender;
  vector[NTest] log_wage2;
  vector[NTest] schooling2; 
  vector[NTest] experience2;
  vector[NTest] gender2;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real b0; // constant
  real b1; // schooling
  real b2; // xperience
  real b3; // gender
  real b4; // schooling and gender
  real b5; // experience and gender
  real<lower=0> sigma;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  b0 ~ normal(0, 1);
  b1 ~ normal(0, 1);
  b2 ~ normal(0, 1);
  b3 ~ normal(0, 1);
  b4 ~ normal(0, 1);
  b5 ~ normal(0, 1);
  sigma ~ lognormal(0, 1);
  for (i in 1:NTrain) {
    log_wage[i] ~ normal(b0 + b1 * schooling[i] + b2 * experience[i] + b3 * gender[i] + b4 * 
                    schooling[i] * gender[i] + b5 * experience[i] * gender[i], sigma);
  }
}

generated quantities {
  vector[NTest] logLike;
  for (i in 1:NTest) {
    logLike[i] = normal_lpdf(log_wage2[i] | b0 + b1 * schooling2[i] + b2 * experience2[i] + 
          b3 * gender2[i] + b4 * schooling2[i] * gender2[i] + b5 * experience2[i] * gender2[i], sigma);
  }
}
