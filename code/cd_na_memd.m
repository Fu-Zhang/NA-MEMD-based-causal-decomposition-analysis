function [causal_matrix] = cd_na_memd(IMF, imfs1, imfs2, s1, s2, ndir, stp_crit, stp_vec, mode, intensity_noise, n_channel_na)
% imfs1 eeg
% imfs2 emg

% IMF: the chosen IMF index

imfsize=size(imfs1,1);

% initiate phase vectors
p12=zeros(imfsize,1);
p21=zeros(imfsize,1);

% calculate phase coherence between paired IMFs
[ps,pd]=phasefcimf(imfs1,imfs2);

% calculate variance of IMFs
v1=nvar(imfs1)';
v2=nvar(imfs2)';

% remove an IMF and do the redecomposition by NA-MEMD method
s1r=s1-imfs1(IMF,:);
s2r=s2-imfs2(IMF,:);

imfsr = namemd(cat(1,s1,s2r)', ndir, stp_crit, stp_vec, mode, intensity_noise, n_channel_na);
imfsr11 = imfsr{1,:};
imfsr12 = imfsr{2,:};

imfsr = namemd(cat(1,s1r,s2)', ndir, stp_crit, stp_vec, mode, intensity_noise, n_channel_na);
imfsr21 = imfsr{1,:};
imfsr22 = imfsr{2,:};

% recalculate phase coherence between paired IMFs
ps12=phasefcimf(imfsr11,imfsr12);
ps21=phasefcimf(imfsr21,imfsr22);

% calculate absolute causal strength using variance-weighted Euclidian distance
% between the phase coherence of the original IMFs and redecomposed IMFs
p12=sqrt(sum(v1.*v2.*(ps12-ps).^2)/sum(v1.*v2));
p21=sqrt(sum(v1.*v2.*(ps21-ps).^2)/sum(v1.*v2));

% calculate relative causal strengths from absolute causal strengths (p12 and p21)
% the output is 4 by 1 matrix
% the first column indicates relative causal strength from time series 1 to 2
% the second column indicates relative causal strength from time series 2 to 1
% the third column indicates absolute causal strength from time series 1 to 2
% the fourth column indicates absolute causal strength from time series 2 to 1

if p12<0.05 & p21<0.05
    alpha=1;
else
    alpha=0;
end

causal_matrix = [(alpha+p12)/(2*alpha+p12+p21) (alpha+p21)/(2*alpha+p12+p21) p12 p21];


end
