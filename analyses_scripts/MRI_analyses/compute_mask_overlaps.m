% written by SMR
% last update: 28/05/2024

clear
close all
clc

addpath([pwd '/utils/'])
network_path=[pwd '/data/neural_data/'];
sub_to_include=[1:21 24:40]; % exclusions: 22=claustrophobia -> no MRI 23=MRI technical issue -> no MRI

% initialize
networks_names={'result_Like_RTG_realigned','result_Orig_RTG_realigned','result_Adeq_RTG_realigned','neurosynth_BVS','Yeo_ECN','Yeo_ECNminusBVS','Yeo_DMN','Yeo_DMNminusBVS','Yeo_Visual','Yeo_SomatoMotor','Yeo_DAN','Yeo_SN_VAN','Yeo_limbic'};
number_of_networks=length(networks_names);
all_networks=nan(256,256,256,number_of_networks);

% binarize and store
for i=1:number_of_networks
    current_name=networks_names{i};
    network=niftiread([network_path current_name '.nii']);
    network=single(network);
    % binarize
    for x=1:size(network,1)
        for y=1:size(network,2)
            for z=1:size(network,3)
                if isnan(network(x,y,z))
                    network(x,y,z)=0; % ignore NaNs
                elseif network(x,y,z)>0
                    network(x,y,z)=1; % binarize
                end
                % now "network" should be a 3d binary matrix
            end
        end
    end
    % store
    all_networks(:,:,:,i)=network(:,:,:);
end

%% count voxel overlaps
common_voxels=zeros(number_of_networks,number_of_networks);
j=0;
for i=1:number_of_networks
    for j=1:number_of_networks
        disp(['i=' num2str(i)])
        disp(['j=' num2str(j)])
        disp('_________________________________')
        for x=1:256
            for y=1:256
                for z=1:256
                    if all_networks(x,y,z,i)+all_networks(x,y,z,j)==2
                        common_voxels(i,j)=common_voxels(i,j)+1;
                    end
                end
            end
        end
    end
end

%% display results

disp('Each line & column corresponds to:')
disp(' ')
disp('1  = result Likeability')
disp('2  = result Originality')
disp('3  = result Adequacy')
disp('4  = BVS')
disp('5  = ECN')
disp('6  = ECN minus BVS' )
disp('7  = DMN')
disp('8  = DMN minus BVS')
disp('9  = visual network')
disp('10 = somatomotor network')
disp('11 = dorsal attention')
disp('12 = salience network')
disp('13 = limbic network')
disp(' ')

disp('Number of voxels overlapping:')
disp(' ')
disp(common_voxels)