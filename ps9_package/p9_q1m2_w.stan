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
  int<lower=0> N;
  vector[N] log_wage;
  vector[N] schooling; 
  vector[N] experience;
  vector[N] gender;
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
// Priors
  b0 ~ normal(0, 1);
  b1 ~ normal(0, 1);
  b2 ~ normal(0, 1);
  b3 ~ normal(0, 1);
  b4 ~ normal(0, 1);
  b5 ~ normal(0, 1);
  sigma ~ lognormal(0, 1);

  // Likelihood
  for (i in 1:N) {
    log_wage[i] ~ normal(b0 + b1 * schooling[i] + b2 * experience[i] + b3 * gender[i] + b4 * 
                    schooling[i] * gender[i] + b5 * experience[i] * gender[i], sigma);
  }
}

generated quantities {
  vector[N] logLike;
  for (i in 1:N) {
    logLike[i] = normal_lpdf(log_wage[i] | b0 + b1 * schooling[i] + b2 * experience[i] + 
          b3 * gender[i] + b4 * schooling[i] * gender[i] + b5 * experience[i] * gender[i], sigma);
  }
}
