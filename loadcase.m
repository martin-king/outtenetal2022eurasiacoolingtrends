clear all; close all;
  
load('case4_era5.mat')

scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.5 scrsz(4)/2]);
figure(1),clf
h=bar(hm.BinEdges(1:end-1)+hm.BinWidth/2.0,hm.Values); % plot prob. hist. of artificial trends
axis([-4 4 0 0.1])
set(gca,'Xtick',[-3.5 -3. -2.5,-2,-1.5,-1,-0.5,0.,0.5,1.,1.5,2.,2.5 3. 3.5]);
title('Prob. Dist. of trends from AR1')



%{
Standard deviations
case 1 1948-2020 : 1.4901

case 2 1998-2012 : 1.6996

case 3 1986-2000 : 0.8960

case 4 1969-1983 : 1.9486
%}

%{
%What is inside the mat files

>> hm

hm = 

  Histogram with properties:

             Data: [1x20000 double]
           Values: [1x104 double]
          NumBins: 104
         BinEdges: [1x105 double]
         BinWidth: 0.1000
        BinLimits: [-5.2000 5.2000]
    Normalization: 'probability'
        FaceColor: 'auto'
        EdgeColor: [0 0 0]

  Show all properties

%}
