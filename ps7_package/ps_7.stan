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
  vector[N] log_rate;
  vector[N] log_size;
  vector[N] instar;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real beta0;
  real beta1;
  real beta2;
  real<lower=0> sigma;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  log_rate ~ normal(beta0 + beta1 * log_size + beta2 * instar, sigma);
  beta0 ~ normal(0, 400);
  beta1 ~ normal(0, 400);
  beta2 ~ normal(0, 400);
  sigma ~ gamma(1, 1);
}

//Part 6
generated quantities {
  vector[N] yPred;
  for (i in 1:N) {
    yPred[i] = beta0 + beta1 * log_size[i] + beta2 * instar[i];
  }
}
