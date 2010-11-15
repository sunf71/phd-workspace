function [CRETMP,Ridges,disSmooth]=superPixelRidges(distribution,differentiation,integration,thr)



border_size=3;
sigma_diff=differentiation;%2.5;
sigma_inte=integration;%0.5;
creaseness_threshold=thr;%5;
minum_creaseness_value=0.3;

mida=size(distribution);

  %%%% WINDOWS
[creasened,disSmooth]=crestesLast(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
                          sigma_diff, sigma_inte, creaseness_threshold);                       
                      
  %%%% LINUX
% [creasened,disSmooth]=crestes(padarray(distribution,ones(1,ndims(distribution))*border_size), ...
%                           sigma_diff, sigma_inte, creaseness_threshold);                                             
                      
creasened=-double(creasened);
CRETMP=creasened;

Ridges = CRETMP(border_size+1:mida+border_size,border_size+1:mida+border_size,border_size+1:mida+border_size);
Ridges(Ridges<0.3)=0;


