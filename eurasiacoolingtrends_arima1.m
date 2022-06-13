clear all; close all; startup;
tic

%JFM, aave 60-120E, 40-60N, air temp at 925hPa
ceu = load('ceu_air925.txt','-ascii');
ceuanom=ceu(:,3)-mean(ceu(:,3));
Pobs=polyfit(ceu(:,1),ceuanom,1);
ceuanom=ceuanom-Pobs(1,1).*ceu(:,1)-Pobs(1,2); %detrend

%scrsz = get(0,'ScreenSize');
%[left, bottom,  width, height]
%figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
%figure(1),clf
%autocorr(ceuanom); %requires econometrics toolbox

iy=find(ceu(:,1)>=1997 & ceu(:,1)<=2012); % years with strongest negative trend
Pobs=polyfit(ceu(iy,1),ceu(iy,3),1); %Pobs is observed trend in this period

scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
figure(1),clf
plot(ceu(:,1),ceuanom,'k-o') % plot the whole observed time series
axis([1948 2020 -8 5])

%specifying the AR1 model
rho = 0.2;
var = (1.0-rho^2.0)*var(ceuanom);
Mdl = arima('ARLags',1,'AR',rho,'Constant',0.0,'Variance',var); % requires econometrics toolbox

rng('shuffle')
trendsboot=[];
stdsaved=[];
acfsaved=[];

% simulate the AR1 model
imcsimax=20000;
xt = simulate(Mdl,16,'NumPaths',imcsimax);
for i=1:imcsimax
% faster to do it before the loop xt = simulate(Mdl,16,'NumPaths',1);
    P=polyfit(ceu(iy,1),xt(:,i),1);
%    [acf,lags,bounds] =autocorr(xt(:,i),1); % for checking autocorrelation and std
%    acfsaved=[acfsaved acf(2,1)];
%    stdsaved=[stdsaved std(xt(:,i))];
    trendsboot=[trendsboot P(1,1)*10.0]; % K per decade in simulated AR1
end
%

%
scrsz = get(0,'ScreenSize');
%[left, bottom, width, height]
figure('Position',[1 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/1.7]);
figure(2),clf
h=histogram(trendsboot,100,'Normalization','probability'); % plot prob. hist. of artificial trends
axis([-4 4 0 0.05])
set(gca,'Xtick',[-3.5 -3. -2.5,-2,-1.5,-1,-0.5,0.,0.5,1.,1.5,2.,2.5 3. 3.5]);
ax = gca;
ax.TickLength = [0.02, 0.02]; % Make tick marks longer.
ax.LineWidth = 3;

hold on;
plot(Pobs(1,1)*10.0,0,'ro','MarkerSize',14) %plot obs trend K per dec

i=find(cumsum(h.Values)<=0.05); 
fifthpctl=h.BinEdges(max(i)); %find 5th pctl artificial trend
plot(fifthpctl,0,'bx','MarkerSize',30,'LineWidth',5) %plot it

i=find(cumsum(h.Values)>=0.95); 
fifthpctl=h.BinEdges(min(i)); %find 95th pctl artificial trend
plot(fifthpctl,0,'bx','MarkerSize',30,'LineWidth',5) %plot it
%

toc

