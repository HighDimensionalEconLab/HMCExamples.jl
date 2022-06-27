% Neoclassical Investment Model with Log Utility

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y c k z c_obs i_obs;
varexo e;

%----------------------------------------------------------------
% 2. Parameters values
%----------------------------------------------------------------

parameters betap delta alpha rho sigma;
alpha   = 0.3;
betap   = 0.2;
delta   = 0.025;
rho     = 0.8;
sigma   = 0.01;

%----------------------------------------------------------------
% 3. Model (Euler Equation, Budget Constraint, Laws of Motion
%----------------------------------------------------------------

model;
  # beta = (1/(betap/100 + 1));
  c^(-1) = beta*c(+1)^(-1)*(alpha*exp(z(+1))*(k^(alpha-1))+1-delta); % Euler
  c+k-(1-delta)*k(-1) = y; % Budget Constraint
  y = exp(z)*(k(-1)^alpha); % Production Function
  z = rho*z(-1)+e; % TFP AR(1)
  c_obs = c - steady_state(c);
  i_obs = k - (1 - delta) * k(-1) - delta * steady_state(k);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

%%Steady State

steady_state_model;
  k = ((betap/100 + delta)/alpha)^(1/(alpha-1));
  c = k^alpha-delta*k;
  y = k^alpha;
  z = 0;
  c_obs = 0;
  i_obs = 0;
end;

shocks;
var e = sigma ^ 2;
var i_obs = 1e-5;
var c_obs = 1e-5;
end;

steady;

stoch_simul(order = 2, nograph);

%----------------------------------------------------------------
% 5. Estimation
%----------------------------------------------------------------

estimated_params;
alpha, 0.4, 0.2, 0.5, normal_pdf, 0.3, 0.025;
betap, 0.4, gamma_pdf, 0.25, 0.1;
rho, 0.8, beta_pdf, 0.5, 0.2;
end;

varobs c_obs i_obs;

options_.cova_compute = 0;
estimation(datafile = 'rbc_2.csv', order = 2, mh_nblocks = 1, mh_replic = 10000, mh_drop = 0.1, mode_compute = 0, mcmc_jumping_covariance = identity_matrix, number_of_particles = 500, mh_jscale = 0.001);

