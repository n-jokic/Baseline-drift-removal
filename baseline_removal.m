% example9_8.m
% Resampling and baseline correction of MALDI-TOF mass spectra data.
%
close all; clear all; clc;

% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

% read input file
%%
filename = 'noisy';
both = load([filename '.csv']);
x = both(:,1);
y = both(:, 2);
%%

% display 200 semples
x200 = x(1:201);
y200 = y(1:201);
figure();
    plot(x200, y200, 'black');
        xlim([min(x200), max(x200)]);
        ylim([min(y200)*0.95, max(y200)*1.05]);
        xlabel('mz [a.u.]');
        ylabel('Relative intensity[a.u.]');
        grid('on');
        title(['First 200 samples ' filename ' data']);

        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\200s_' filename],'epsc')  ; 
% decimate the MALDI data to estimate the baseline
x_dec = x200(1:2:200);
y_dec = y200(1:2:200);

% compute the spline estimate from the decimated data
% force the endpoint conditions to be zero slope as described in the book
% pp is the piecewise polynomial 

%%

y_spline = [0; y_dec; 0]; %Drugi izvod u krajnjim tackama ce biti 0

pp = spline(x_dec, y_spline);

% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp,x200);

% plot:original data in blue dots,spline estimate of baseline in red dashes

figure()
    plot(x200, y200, 'black.', x200, yy, 'black-.');
        xlim([min(x200), max(x200)]);
        ylim([min(y200)*0.95, max(y200)*1.05]);
        xlabel('mz [a.u.]');
        ylabel('Relative intensity [a.u.]');
        grid('on');
        title(['Original and fitted ' filename ' data']);
        legend({'original data', 'baseline estimation'});
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\200spline_' filename],'epsc')  ; 
%% Removing baseline 
figure()
    plot(x200, y200 - yy, 'black');
        xlim([min(x200), max(x200)]);
        ylim([min(y200-yy)*0.95, max(y200- yy)*1.05]);
        xlabel('$mz$ [a.u.]');
        ylabel('Relative intensity [a.u.]');
        grid('on');
        title(['Removed baseline from ' filename ' data']);
        %legend({'original data', 'remo'});
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\200remove_' filename],'epsc')  ; 
%% Splining and removing baseline from full data

% compute the spline from linearly spread data
indicies = floor( linspace(1,length(x), 1000) );
x_dec = x(indicies);

% force the endpoint conditions to be zero slope as described in the book

y_spline = [0; y(indicies); 0];


pp = spline(x_dec, y_spline);

% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp, x);

% plot:original data in black dots,spline estimate of baseline in red dashes
figure()
    plot(x, y, 'black.', x, yy, 'r--');
        xlim([min(x), max(x)]);
        ylim([min(y)*0.95, max(y)*1.05]);
        xlabel('mz [a.u.]');
        ylabel('Relative intensity [a.u.]');
        grid('on');
        title(['Original and fitted ' filename ' data']);
        legend({'original data', 'baseline estimation'});
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\spline_' filename],'epsc')  ; 

figure()
    p = plot(x, y- yy, 'black', x(7464), y(7464)- yy(7464), 'r*');
        xlim([min(x), max(x)]);
        ylim([min(y-yy)*0.95, max(y- yy)*1.05]);
        xlabel('mz [a.u.]');
        ylabel('Relative intensity [a.u.]');
        grid('on');
        title(['Removed baseline from ' filename ' data']);
        legend(p(2), 'peak visible in original data');
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\remove_' filename],'epsc')  ; 
%%       
%close all;
%% 
ecgData = load('118.txt');
baselineData = load('baseline.txt');

range = 1 : 10001;
channel_1 = ecgData(range, 1) + baselineData(range, 1);
channel_2 = ecgData(range, 2) + baselineData(range, 2);

channel_1 = channel_1 - mean(channel_1);
channel_2 = channel_2 - mean(channel_2);

figure();
    subplot(2, 1, 1);
    p = plot(channel_1, 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n   [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['ECG with baseline ch1']);
        
   subplot(2, 1, 2);
    p = plot(channel_2 , 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['ECG with baseline ch2']);
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\ecg_base'],'epsc')  ;
%% Channel 1 baseline removal 
% compute the spline from linearly spread data

n = 1:length(channel_1);
decimate = 50;
indicies = floor(linspace(1,length(channel_1), round(length(channel_1)/decimate))) ;
x_dec_1 = n(indicies);

% force the endpoint conditions to be zero slope as described in the book

y_spline_1 = [0; channel_1(indicies); 0];


pp = spline(x_dec_1, y_spline_1);

% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp, n);

% plot:original data in black dots,spline estimate of baseline in red dashes
figure();
    subplot(3, 1, 1);
    plot(n, channel_1, 'black.');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Ecg with baseline ch1']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
       
       
    subplot(3, 1, 2);
    plot(n, baselineData(range, 1), 'black-');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline data ch1']);
        legend(p,{'baseline estimation'},'Location','southeast');
        legend('boxoff');
      
       
    subplot(3, 1, 3);
    plot(n, channel_1 - yy', 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1 - yy')*1.05, max(channel_1 - yy')*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline removed from ecg ch1']);

       saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\ecg_remove_1'],'epsc')  ;  
 %% Channel 2 baseline removal 
 % compute the spline from linearly


n = 1:length(channel_2);
decimate = 50;
indicies = floor(linspace(1,length(channel_2), round(length(channel_2)/decimate))) ;
x_dec_1 = n(indicies);

% force the endpoint conditions to be zero slope as described in the book

y_spline_1 = [0; channel_2(indicies); 0];


pp = spline(x_dec_1, y_spline_1);

% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp, n);

% plot:original data in black dots,spline estimate of baseline in red dashes
figure();
    subplot(3, 1, 1);
    plot(n, channel_2, 'black.');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Ecg with baseline ch2']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
       
       
    subplot(3, 1, 2);
    plot(n, baselineData(range, 2), 'black-');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_2)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline data ch2']);
        legend(p,{'baseline estimation'},'Location','southeast');
        legend('boxoff');
      
       
    subplot(3, 1, 3);
    plot(n, channel_2 - yy', 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_2 - yy')*1.05, max(channel_2 - yy')*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline removed from ecg ch2']);

       saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\ecg_remove_2'],'epsc')  ;  
%% extra
d = designfilt('lowpassiir', ...
    'PassbandFrequency',0.02,'StopbandFrequency',0.04, ...
    'PassbandRipple',0.1,'StopbandAttenuation',60);
%%
range = 1: 10000;
channel_1 = filtfilt(d, ecgData(range, 1) + baselineData(range, 1) - mean(ecgData(range, 1) + baselineData(range, 1)));



figure();
    p = plot(channel_1, 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['ECG with baseline ch1']);
        
        
% compute the spline from linearly spread data
%%
channel_1 = filtfilt(d, ecgData(range, 1) + baselineData(range, 1) - mean(ecgData(range, 1) + baselineData(range, 1)));

n = 1:length(channel_1);
decimate = 50;
indicies = floor(linspace(1,length(channel_1), round(length(channel_1)/decimate))) ;
x_dec_1 = n(indicies);

% force the endpoint conditions to be zero slope as described in the book

y_spline_1 = [0; channel_1(indicies); 0];


pp = spline(x_dec_1, y_spline_1);


% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp, n);
yy = smooth(yy, 5);
% plot:original data in black dots,spline estimate of baseline in red dashes
channel_1 = ecgData(range, 1) + baselineData(range, 1) - mean(ecgData(range, 1) + baselineData(range, 1));
figure();
    subplot(3, 1, 1);
    plot(n, channel_1, 'black.');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Ecg with baseline ch1']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
       
       
    subplot(3, 1, 2);
    plot(n, baselineData(range, 1), 'black-');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline data ch1']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
      
       
    subplot(3, 1, 3);
    plot(n, channel_1 - yy, 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1 - yy)*1.05, max(channel_1 - yy)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline removed from ecg ch1']);
        
        saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\ecg_remove_1_filt'],'epsc')  ;  
        
        
 %%
 
range = 1: 10000;
channel_2 = filtfilt(d, ecgData(range, 2) + baselineData(range, 2) - mean(ecgData(range, 2) + baselineData(range, 2)));



figure();
    p = plot(channel_2, 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_2)*1.05, max(channel_2)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['ECG with baseline ch2']);
 
 %% Channel 2 baseline removal 
 % compute the spline from linearly
channel_2 = filtfilt(d, ecgData(range, 2) + baselineData(range, 2) - mean(ecgData(range, 2) + baselineData(range, 2)));

n = 1:length(channel_2);
decimate = 50;
indicies = floor(linspace(1,length(channel_2), round(length(channel_2)/decimate))) ;
x_dec_1 = n(indicies);

% force the endpoint conditions to be zero slope as described in the book

y_spline_1 = [0; channel_2(indicies); 0];


pp = spline(x_dec_1, y_spline_1);

% evaluate the polynomial (interpolate) on the original m/z range
yy = ppval(pp, n);
channel_2 = ecgData(range, 2) + baselineData(range, 2) - mean(ecgData(range, 2) + baselineData(range, 2));

% plot:original data in black dots,spline estimate of baseline in red dashes
figure();
    subplot(3, 1, 1);
    plot(n, channel_2, 'black.');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_1)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Ecg with baseline ch2']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
       
       
    subplot(3, 1, 2);
    plot(n, baselineData(range, 2), 'black-');
    hold on;
    p = plot(n, yy, 'r-.');
        xlim([0, length(channel_1)]);
        ylim([min(channel_1)*1.05, max(channel_2)*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline data ch2']);
        legend(p, {'baseline estimation'},'Location','southeast');
        legend('boxoff');
      
       
    subplot(3, 1, 3);
    plot(n, channel_2 - yy', 'black');
        xlim([0, length(channel_1)]);
        ylim([min(channel_2 - yy')*1.05, max(channel_2 - yy')*1.05]);
        xlabel('n [a.u.]');
        ylabel('Amplitude [a.u.]');
        grid('on');
        title(['Baseline removed from ecg ch2']);

       saveas(gcf,['C:\Users\milos\OneDrive\VII semestar\MAS\vezbe\vezba 3\izvestaj\slike\ecg_remove_2_filt'],'epsc')  ; 
 %%
 %pause; 
 %close all;