% Takes output of dynare simulations from sgu.mod and stores a data set
% Note that this is a separate dataset than that used in the julia samplers due to small differences in the timing convention.

% Utility to save a mode file
parameter_names = [{'alpha'};{'gamma'};{'psi'};{'beta_draw'};{'rho'};{'rho_u'};{'rho_v'}];
xparam1 = [0.328877958223689;2.3399861113683453;0.0005602652317476214;4.094970724844387;0.3877637128809934;0.2240415428766295;0.5348464581738216];

save('sgu_init_params.mat','parameter_names','xparam1')

rng(54321); %Set seed
dynare sgu_1.mod
data1 = table(y_obs,ca_obs,r_obs);

writetable(data1,'../../data/dynare_sgu_1_200.csv')

rng(54321); %Set seed
dynare sgu_2.mod order=2

data2 = table(y_obs,ca_obs,r_obs); 

writetable(data2,'../../data/dynare_sgu_2_200.csv')

