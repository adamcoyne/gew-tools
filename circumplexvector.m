close all
clear

% To run this, you'll need anglediff.m

%%%% CSV FILE FORMAT GUIDE %%%%

% The file is set to read CSV files for each individual test scenario you have.
% For our experiment, we went through 9 different emotions as portrayed by a robot, so we have 9 files, one for each test condition.
% They're named "emotion_01.csv" through "emotion_09.csv".
% See below for using different filenames, or a different amount of test conditions.

% Required headers:
% - emotion (index of emotion sector the datapoint is on, from 0->20 for regular GEW where 0 is "None")
% - intensity (intensity of the emotion datapoint on the GEW, from 1->4 on v1, 1->6 on v3 etc)

% Your data will probably have more, but these are the only required ones for this script.

% Example:

% id,date,time,emotion,intensity;
% 001,"01/01/2021","12:00",7,5;
% 002,"01/01/2021","12:30",8,1;
% 003,"01/01/2021","11:00",0,0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Aside from that, you'll need to edit parts of this file to match your data. See comments marked "EDIT HERE".

%% EDIT HERE %%
% Set the following variable based on what GEW you're using.
% Version 1.0 only has 16 emotions, but subsequent ones have 20.
total_emotions = 20;

% Set the following variable based on how many different conditions you're comparing.
test_conditions = 9;

n = total_emotions;
tc = test_conditions
spopt = {[0.1 0.05], [0.1 0.05], [0.1 0.05]};
subplot = @(m,n,p) subtightplot(m,n,p,spopt{:});

emotion_names = [""];

%% EDIT HERE %%
% The following block is for writing out data at the end.
% If you want to do so, make sure each test condition is properly named in f_emotion_name.
% Also make sure f_closest_matching_emotion is of the same length.
% If you just want to generate some graphs, these don't matter.

% header = {'emotion_number', 'emotion_name', 'th_e', 'closest_matching_emotion', 'i_e', 'v_e_ep', 'v_e_e'};

% f_emotion_number = 1:tc;
% f_n = ones(1,tc) .* -1.0;
% f_emotion_name = ["Neutral","Sadness","Fear","Disgust","Anger","Joy","Happiness","Awe","Surprise"];
% f_th_e = ones(1,tc) .* -1.0;
% f_closest_matching_emotion = ["","","","","","","","",""];
% f_i_e = ones(1,tc) .* -1.0;
% f_v_e_e = ones(1,tc) .* -1.0;
% f_v_e_ep = ones(1,tc) .* -1.0;


for p = 1:tc

figure

% If you have different filenames you can change how they work in the following bit.
% Right now, this will read "emotion_01.csv", then "emotion_02.csv" on and on until the number reaches the amount of test conditions.
% If you have more than 99 test conditions you'll have to edit how this works.

filename = strcat('emotion_', num2str(p,'%02.f'), '.csv');

opts = detectImportOptions(filename);
data = readtable(filename,opts);

emotion_data = data.emotion;
th_i = emotion_data*2*pi/total_emotions;
I_i = data.intensity;

id = find(isnan(th_i));
th_i(id) = [];
I_i(id) = [];


polarhistogram(th_i,0:2*pi/total_emotions:2*pi,'Normalization','probability');
rlim([0 1])
tick = 360/total_emotions;
thetaticks(tick:tick:360)
thetaticklabels([1:total_emotions])

n = length(emotion_data);


for j = 1:n
   e_num = emotion_data(j);
   if e_num == 0
       e_num = 20;
   end
end

[x,y] = pol2cart(th_i, I_i);

X_e = sum(I_i .* cos(th_i))./n;
Y_e = sum(I_i .* sin(th_i))./n;

th_e = atan2(Y_e, X_e);
I_e = sqrt(X_e^2 + Y_e^2);

polarscatter(th_i, I_i, '+');
tick = 360/total_emotions;
thetaticks(tick:tick:360)
thetaticklabels([1:total_emotions])

hold on
polarplot([0 th_e], [0 I_e], '->')
title(strcat('Emotion',' ',string(p)))

weighted_circular_mean = wrapTo2Pi(th_e);
unweighted_circular_mean = wrapTo2Pi(atan2(sum(sin(th_i)), sum(cos(th_i))));

weighted_circular_variance = 1-sum(I_i.*cos((anglediff(th_e,th_i))))/sum(I_i);
unweighted_circular_variance = 1-sum(cos((anglediff(unweighted_circular_mean,th_i))))/n;

degrees_variance = rad2deg(acos(sum(I_i.*cos((anglediff(th_e,th_i))))/sum(I_i)));
estimated_emotion = weighted_circular_mean*total_emotions/(2*pi);
emotion_variance = degrees_variance*total_emotions/360;

unweighted_radians_variance = acos(sum(cos((anglediff(unweighted_circular_mean,th_i))))/n);
unweighted_emotion_variance = unweighted_radians_variance*total_emotions/(2*pi);

mean_intensity = I_e;

th_e_str = strcat('\theta_e =', string(estimated_emotion));
I_e_str = strcat('I_e =', string(I_e));
V_e_str = strcat('V_e =', string(emotion_variance));

h(1) = polarplot(NaN,NaN,'or');
h(2) = polarplot(NaN,NaN,'ob');
h(3) = polarplot(NaN,NaN,'ok');
legend(h, th_e_str,I_e_str,V_e_str);

% All this should generate some pleasant graphs with your data.

%% EDIT HERE %%
% If you want to export the statistical summary, uncomment all the rest of the code to the end.
% It will be saved as "stats.csv".

% % End of the loop, now let's get all the data to export to csv
% f_th_e(p) = weighted_circular_mean;
% f_i_e(p) = mean_intensity;
% f_v_e_e(p) = emotion_variance;
% f_v_e_ep(p) = unweighted_emotion_variance;
% f_n(p) = n;

end

% f_closest_matching_emotion = ["Disgust","Guilt","Fear","Amusement","Anger","Pleasure","Joy","Pleasure","Anger"];
%
% % Now write out
% header = ["emotion_number", "n" ,"emotion_name", "th_e", "closest_matching_emotion", "i_e", "v_e_ep", "v_e_e"];
%
% f_all = [header;
%             string(num2cell(f_emotion_number')) string(num2cell(f_n')) string(num2cell(f_emotion_name')) string(num2cell(f_th_e')) string(num2cell(f_closest_matching_emotion')) string(num2cell(f_i_e')) string(num2cell(f_v_e_ep')) string(num2cell(f_v_e_e'))];
%
% outfilename = 'stats.csv';
%
% cell2csv(outfilename, f_all)
