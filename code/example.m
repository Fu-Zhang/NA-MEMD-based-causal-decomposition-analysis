ndir = 64;
stp_crit = 'stop';
stp_vec = [0.075 1 0.075];
mode = 'na_fix';
intensity_noise = 0.1;
n_channel_na = 3;

input = randn(2000,2)';

input1 = input(1,:);
input2 = input(2,:);

tmpS = cat(1,input1,input2)';

tmpResult = namemd(tmpS, ndir, stp_crit, stp_vec, mode, intensity_noise, n_channel_na);
imfs1 = tmpResult{1,:};
imfs2 = tmpResult{2,:};
peakMatrix = PLseries(imfs1, imfs2);
IMF = pickIMF(peakMatrix,0.7);
cd = cd_na_memd(IMF, imfs1, imfs2, input1, input2, ndir, stp_crit, stp_vec, mode, intensity_noise, n_channel_na);
