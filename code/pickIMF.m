function IMF = pickIMF(peakMatrix,threshold ) 
% **************
% Find an IMF which minimizes the difference of the averaged inst-
% antaneous phases, as well as maximizes the average of instanta-
% neous frequencies between the paired IMFs to be removed. 
%
% Input: 
% peakMatrix: The matrix obtained from PLseries.m.
% threshold: Threshold for the  ratio of the average instantaneous p-
%                 hase.
% Output: 
% IMF: The index of IMF selected to be removed.
%***************

IMF = [];
ph = peakMatrix(2:end - 1,3);
freq = peakMatrix(2:end - 1,1);
    for k = 1:size(ph)
        if ph(k) > threshold 
            IMF = k + 1;
            break
        end
    end
    
    if isempty(IMF)
        fprintf("Warning:No eligible IMF! IMF with the closest phase was selected. \n");
        [~, max_ind] = max(peakMatrix(1:end ,3));
        IMF = max_ind;
    end
    
end