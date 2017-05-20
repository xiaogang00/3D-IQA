function [gamparam sigma] = estimateggdparam(vec)
% This the function combined with function feat = brisque_feature(imdist,scalenum)
% the function output the parameters we need to set as global features


gam                              = 0.2:0.001:10;
r_gam                            = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);

sigma_sq                         = mean((vec).^2);
sigma                            = sqrt(sigma_sq);
E                                = mean(abs(vec));
rho                              = sigma_sq/E^2;
[min_difference, array_position] = min(abs(rho - r_gam));
gamparam                         = gam(array_position);  






