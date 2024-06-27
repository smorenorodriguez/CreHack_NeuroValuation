function [FGAT, Ratings]=get_CreHackData(name_participant)

dir_name=[pwd '/data/preproc_data/'];

if exist([dir_name filesep name_participant filesep 'CreHack_' name_participant '.mat'],'file')
    load([dir_name filesep name_participant filesep 'CreHack_' name_participant '.mat'])
else

    % FGAT
    mkdir([dir_name filesep name_participant filesep]);
    [matrix_FGAT,columns] = Data_organizing.Organize_FGAT(name_participant);
    FGAT.cues=matrix_FGAT(:,3);
    FGAT.responses=matrix_FGAT(:,4);
    FGAT.likeability = cell2mat(matrix_FGAT(:,8));
    FGAT.originality = cell2mat(matrix_FGAT(:,9));
    FGAT.adequacy = cell2mat(matrix_FGAT(:,10));
    FGAT.frequencyCreaFlexFirst = cell2mat(matrix_FGAT(:,11));
    FGAT.frequencyCreaFlexDist = cell2mat(matrix_FGAT(:,12));
    FGAT.RT_answer = cell2mat(matrix_FGAT(:,5));
    FGAT.condition = cell2mat(matrix_FGAT(:,2));
    FGAT.unique_creaflexFirst = cell2mat(matrix_FGAT(:,15));
    FGAT.unique_creaflexDist = cell2mat(matrix_FGAT(:,16));
    FGAT.frequency_dictaverf = cell2mat(matrix_FGAT(:,14));


    % Rating
    [matrix_Rating,columns] = Data_organizing.Organize_Rating(name_participant);
    Ratings.cues = matrix_Rating(:,1);
    Ratings.targets = matrix_Rating(:,2);
    Ratings.likeability = cell2mat(matrix_Rating(:,3));
    Ratings.originality = cell2mat(matrix_Rating(:,9));
    Ratings.adequacy = cell2mat(matrix_Rating(:,15));
    Ratings.Likeability_stim_time = cell2mat(matrix_Rating(:,5));
    Ratings.Originality_stim_time = cell2mat(matrix_Rating(:,11));
    Ratings.Adequacy_stim_time = cell2mat(matrix_Rating(:,17));
    Ratings.Likeability_first_move_time = cell2mat(matrix_Rating(:,6));
    Ratings.Originality_first_move_time = cell2mat(matrix_Rating(:,12));
    Ratings.Adequacy_first_move_time = cell2mat(matrix_Rating(:,18));
    Ratings.Likeability_valid_time = cell2mat(matrix_Rating(:,7));
    Ratings.Originality_valid_time = cell2mat(matrix_Rating(:,13));
    Ratings.Adequacy_valid_time = cell2mat(matrix_Rating(:,19));
    Ratings.is_first_resp=cell2mat(matrix_Rating(:,20));
    Ratings.is_subj_resp=cell2mat(matrix_Rating(:,21));
    Ratings.frequencyCreaFlexFirst=cell2mat(matrix_Rating(:,22));
    Ratings.frequencyCreaFlexDist=cell2mat(matrix_Rating(:,23));
    Ratings.frequency_dictaverf = cell2mat(matrix_Rating(:,25));
end
















