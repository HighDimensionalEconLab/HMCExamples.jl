%=========================================================================%
% Schmitt-Grohe and Uribe (2003, JIE)
% Ambrogio Cesa-Bianchi, July 2012
% with modifications (added equations) by David Childers, June 2022
%=========================================================================%
% If you find any bugs when using this file or want to give me comments 
% and suggestions you can email me at ambrogio.cesabianchi@gmail.com


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var  d, c, h, y, i, k, a, lambda,  tb, ca, riskpremium, r, zeta, mu, y_obs, ca_obs, r_obs;  

varexo e, u, v;  

%----------------------------------------------------------------
% 2. Parameters values
%----------------------------------------------------------------                                  
                                             
parameters  gamma, omega, rho, sigmae, delta, psi, alpha, phi, beta_draw, r_w, d_bar, rho_u, sigmau, rho_v, sigmav;

		alpha  = 0.32;
		rho    = 0.42;
		phi    = 0.028;
		r_w    = 0.04;		
        gamma  = 2;
		omega  = 1.455;
		psi    = 0.000742;
		delta  = 0.1;
		sigmae = 0.0129;
		beta_draw   = 100*r_w;
		h_ss   = ((1-alpha)*(alpha/(r_w+delta))^(alpha/(1-alpha)))^(1/(omega-1)); 
		k_ss   = h_ss/(((r_w+delta)/alpha)^(1/(1-alpha)));
		i_ss   = delta*k_ss;                                                     
		y_ss   = (k_ss^alpha)*(h_ss^(1-alpha));                                   
		d_bar  = 0.7442;
		d_ss   = d_bar;                                                        
		c_ss   = y_ss-i_ss-r_w*d_ss;
		tb_ss  = y_ss-c_ss-i_ss;
        rho_u    = 0.2; 
        sigmau = 0.003; 
        rho_v    = 0.4; 
        sigmav = 0.1; 

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
    # beta = 1/(beta_draw/100 + 1);
    d = (1+exp(r(-1)))*d(-1)- exp(y)+exp(c)+exp(i)+(phi/2)*(exp(k)-exp(k(-1)))^2;
    exp(y) = exp(a)*(exp(k(-1))^alpha)*(exp(h)^(1-alpha));
    exp(k) = exp(i)+(1-delta)*exp(k(-1)); 
    exp(lambda)= beta*(1+exp(r))*exp(mu)*exp(lambda(+1)); 
    (exp(c)-((exp(h)^omega)/omega))^(-gamma)   = exp(lambda);  
    ((exp(c)-((exp(h)^omega)/omega))^(-gamma))*(exp(h)^omega)  = exp(lambda)*(1-alpha)*exp(y); 
    exp(lambda)*(1+phi*(exp(k)-exp(k(-1)))) = beta*exp(mu)*exp(lambda(+1))*(alpha*exp(y(+1))/exp(k)+1-delta+phi*(exp(i(+1))-delta*exp(k))); 
    a = rho*a(-1)+e; 
    tb = 1-((exp(c)+exp(i))/exp(y));
    ca = (1/exp(y))*(d-d(-1));                                   
    riskpremium = psi*(exp(d-d_bar)-1)+zeta;
    exp(r) = r_w+riskpremium;
    zeta = rho_u*zeta(-1)+u;
    mu = rho_v*mu(-1)+v;
    y_obs = y - steady_state(y);
    ca_obs = ca - steady_state(ca);
    r_obs = r - steady_state(r);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------


initval;
    r     = log(r_w);
    d     = d_ss;
    h     = log(h_ss);
    k     = log(k_ss);
    y     = log(y_ss);
    c     = log(c_ss);
    i     = log(i_ss);
    tb    = 1-((exp(c)+exp(i))/exp(y));
    lambda= log((exp(c)-((exp(h)^omega)/omega))^(-gamma));
    zeta  = 0;
    mu    = 0;
    y_obs = 0;
    ca_obs= 0;
    r_obs = 0;
end;


check;
steady; 


shocks;
    var e; stderr sigmae;
    var u; stderr sigmau;
    var v; stderr sigmav;
    var y_obs = 1e-3;
    var ca_obs = 1e-3;
    var r_obs = 1e-3;
end;


%stoch_simul(order=1, pruning, periods=200);


%----------------------------------------------------------------
% 5. Estimation
%----------------------------------------------------------------

estimated_params;
alpha, 0.4, 0.2, 0.5, normal_pdf, 0.3, 0.025;
gamma, 1.5, 0.5, 7, normal_pdf, 2.0, 0.5;
%, 0.5, 10.0;
psi, 0.000742, 0.0003, 0.0015, normal_pdf, 0.0007, 0.0004;  
%, 0.0001, 0.003;
beta_draw, gamma_pdf, 4, 6;
rho, beta_pdf, 0.5, 0.2;
rho_u, beta_pdf, 0.5, 0.2;
rho_v, beta_pdf, 0.5, 0.2;
end;

varobs y_obs ca_obs r_obs;

options_.cova_compute = 0;
estimation(datafile = '../../data/dynare_sgu_1_200.csv', mode_file = 'sgu_init_params.mat', order = 1, mh_nblocks = 1, mh_replic = 2000000, mh_drop = 0.1, mh_jscale = 0.01, mode_compute = 0, mcmc_jumping_covariance = identity_matrix);