function [mean_data,sem]=mean_sem_disp(data)

mean_data=mean(data);
sem=std(data)/sqrt(length(data));

disp(['mean: ' num2str(mean_data)])
disp(['sem: ' num2str(sem)])