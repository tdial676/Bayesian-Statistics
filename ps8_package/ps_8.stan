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
  int<lower=0> N; // Number of players
  int<lower=0> atbat[N]; // Number of at bats per player
  int<lower=0> position[N]; // Player position per player
  int<lower=0> hits[N]; // number of hits per player
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector<lower=0>[9] kc; //means kc - 2
  vector<lower=0, upper=1>[9] wc;
  vector<lower=0, upper=1>[N] theta;
  real<lower=0> k; // means k -2
  real<lower=0, upper=1> w;
  
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  //hyperprior
  w ~ beta(1, 1);
  k ~ gamma(0.01, 0.01);
  kc ~ gamma(0.01, 0.01);
  wc ~ beta((w * k) + 1, ((1 - w) * k) + 1);
  
  for (n in 1:N) {
    theta[n] ~ beta((wc[position[n]] * kc[position[n]] + 1), 
                   ((1 - wc[position[n]]) * kc[position[n]] + 1)); //prior
    hits[n] ~ binomial(atbat[n], theta[n]); //likelyhood
  }
}
