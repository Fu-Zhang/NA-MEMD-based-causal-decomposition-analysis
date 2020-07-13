function [matrix] = PLseries(imf1, imf2)
% **************
% Cauculate average instantaneous phases and frequencies of IMF 
% pair via Hilbert-Huang transform
%
% Input: imf1,imf2: IMFs decomposed from two signals
% Output: 
% matrix: -IN COLUMNS- Average instantaneous frequency of imf1
%            , average instantaneous frequency of imf2, ratio of the av-
%            erage instantaneous phase between two imfs (always less  
%            than 1)  -INROWS- IMFs
%***************

% The frequency of the original signal, please change it according to
% the signal you use on condition that you need to use the frequency
fs = 2000;

av_fre1 = zeros(size(imf1,1),1);
av_fre2 = zeros(size(imf1,1),1);
ratio = zeros(size(imf1,1),1);

for k=1:size(imf1,1)
    % Hilbert transform to find the instantaneous phase of the k-th IMF
    ang1=angle(hilbert(imf1(k,:)'));
    ang2=angle(hilbert(imf2(k,:)')); 
    
    % Average instantaneous phase
    av_ang1 = mean(ang1);
    av_ang2 = mean(ang2);
    
    % Divide the smaller number by the larger number to keep the ratio less
    % than 1
    if abs(av_ang1) > abs(av_ang2)
        ang_tmp = av_ang1;
        av_ang1 = av_ang2;
        av_ang2 = ang_tmp;
    end
    ratio(k) = abs(av_ang1) / abs(av_ang2);
    
    % Unwrap and calculate instantaneous frequency
    un_ang1 = unwrap(ang1);
    un_ang2 = unwrap(ang2); 
    
    fre1 = abs(diff(un_ang1) / (2*pi)*fs);
    fre2 = abs(diff(un_ang2) / (2*pi)*fs);
    
    % Average instantaneous frequency
    av_fre1(k) = mean(fre1);
    av_fre2(k) = mean(fre2); 
    matrix = [av_fre1,av_fre2,ratio];
end
end