function [equityLoss equity equityZero paymentVector error] = furfine(interbankLiabilitiesMatrix,externalAssets,externalLiabilities, exogenousRecoveryRate)

% PB for BDF2017
%[1] Furfine, Craig. "The interbank market during a crisis." European Economic Review 46, no. 4 (2002): 809-820.
%interbankLiabilitiesMatrix => L 
%A => A
%externalAssets => Ae
%externalLiabilities => Le
%exogenousRecoveryRate => R

L = interbankLiabilitiesMatrix;
A = L';
R = exogenousRecoveryRate;
Ae = externalAssets;
Le = externalLiabilities;


epsilon = 10^(-5);
max_counts = 10^5;

nbanks = length(L);


l = sum(L,2);

equityZero = Ae - Le + sum(A,2) - l;

equity = equityZero;

error = 1;
counts = 1;

while (error > epsilon)&&(counts < max_counts)
    
    oldEquity = equity;
    recoveryVector = ones([nbanks 1]).*(1 - (1-R)*(equity<0));
    equity = Ae - Le + A*(recoveryVector) - l; 
     
    error = norm(equity - oldEquity)/norm(equity);
    counts = counts +1;
end

recoveryVector = ones([nbanks 1]).*(1 - (1-R)*(equity<0));

equity = Ae - Le + A*(recoveryVector) - l;

paymentVector = max(0,min( Ae - Le + A*recoveryVector, l)); 

equityLoss = equity - equityZero;