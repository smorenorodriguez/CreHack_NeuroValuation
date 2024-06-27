function [data_binned, val_ref_binned,varargout]=do_bin_fixed_val_new(data_to_bin,ref_var,points_ref_var)
% [data_binned, val_ref_binned]=do_bin_fixed_val(data_to_bin,ref_var,points_ref_var)
% function to bin data (data to bin) according to another variable
% (ref_var), that we want to scale on points_ref_var
% This methods create bins of data with different number of observation per
% bin

% Example: 
% You have RT for each trial and you want to bin RT for each Decision Value
% DV associated to each trial. You know that decision value is between 0 and 100.
% [RT_binned, DV_ref_binned]=do_bin_fixed_val(RT_to_bin,DV,[0:10:100]) will
% outpout a vector RT_binned with the mean of all RT for DV between 0 and
% 10, then between 10 and 20, etc. DV_ref_binned is necessarily comprised
% between 0 and 10, 10 and 20 etc but can vary if data are not uniformly
% distributed.
% Then you can simply visualize the results as follow: 
% figure
% scatter(DV_ref_binned, RT_binned)

% Written by A. Lopez-Persem, 06/2020

step = points_ref_var(2)-points_ref_var(1);

data_binned    = NaN(1,length(points_ref_var)-1);
val_ref_binned = NaN(1,length(points_ref_var)-1);

v=0;
for vr_ind=points_ref_var(1:end-1)
    v=v+1;
    data_binned(v)    = nanmean(data_to_bin(ref_var>=vr_ind & ref_var<(vr_ind+step)));
    val_ref_binned(v) = nanmean(ref_var(ref_var>=vr_ind & ref_var<(vr_ind+step)));
    varargout{1}(v)=sum((ref_var>=vr_ind & ref_var<(vr_ind+step)));
end
