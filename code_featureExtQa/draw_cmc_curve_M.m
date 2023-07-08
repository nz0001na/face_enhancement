clear;clc;
close all;

addpath('./redist-source');


src = 'F:\zn1\znMCM\MsCeleb1M_code\facerecognitionM\IJB-A_gabor\';
curvedata = csvread([src 'listcmck.csv']); 

plot(curvedata(1:50,1),curvedata(1:50,2),'LineWidth',2);
xlabel('Rank');
ylabel('Recognition Rate(%)');
axis([0 50 0.1 0.6]);
title('Middle Quality versus High Quality using IJB-A Gabor Feature','FontSize',15);
set(gca,'fontweight','bold','FontSize',15);
grid on;
hold on;

marklist = [];
%get pairs where k=1,5,10,20,30
cmc1 = curvedata(find(curvedata(:,1)==1),2);   % ????
marklist(1,1) = 1;
marklist(1,2) = cmc1;
plot(1,cmc1,'r*');
text(1,cmc1,['(' num2str(1) ', ' num2str(cmc1) ')']);

cmc5 = curvedata(find(curvedata(:,1)==5),2);
marklist(2,1) = 5;
marklist(2,2) = cmc5;
plot(5,cmc5,'r*');
text(5,cmc5,['(' num2str(5) ', ' num2str(cmc5) ')']);

cmc10 = curvedata(find(curvedata(:,1)==10),2);
marklist(3,1) = 10;
marklist(3,2) = cmc10;
plot(10,cmc10,'r*');
text(10,cmc10,['(' num2str(10) ', ' num2str(cmc10) ')']);

cmc20 = curvedata(find(curvedata(:,1)==20),2);
marklist(4,1) = 20;
marklist(4,2) = cmc20;
plot(20,cmc20,'r*');
text(20,cmc20,['(' num2str(20) ', ' num2str(cmc20) ')']);

cmc30 = curvedata(find(curvedata(:,1)==30),2);
marklist(5,1) = 30;
marklist(5,2) = cmc30;
plot(30,cmc30,'r*');
text(30,cmc30,['(' num2str(30) ', ' num2str(cmc30) ')']);

cmc50 = curvedata(find(curvedata(:,1)==50),2);
marklist(6,1) = 50;
marklist(6,2) = cmc50;
plot(50,cmc50,'r*');
text(50,cmc50,['(' num2str(50) ', ' num2str(cmc50) ')']);

%marked points
csvwrite([src 'marked_cmck.csv'], marklist);





