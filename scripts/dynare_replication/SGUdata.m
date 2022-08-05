%SGUdata.m
% Takes output of dynare simulations from SU03ext.mod and stores a data set

% Create mode file

parameter_names = [{'alpha'};{'gamma'};{'psi'};{'beta_draw'};{'rho'};{'rho_u'};{'rho_v'}];
xparam1 = [0.4;1.0;0.000742;4.0;0.4;0.4;0.4];

save('SU03ext_mode.mat','parameter_names','xparam1')

rng(54321); %Set seed
dynare SU03ext.mod


data1 = table(y_obs,ca_obs,r_obs);

writetable(data1,'SGUsimorder1.csv')

rng(54321); %Set seed
dynare SU03ext.mod order=2

data2 = table(y_obs,ca_obs,r_obs); 

writetable(data2,'SGUsimorder2.csv')

