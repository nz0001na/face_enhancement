clear;clc;
close all;

%% Mid vs high deep
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\face_recognition_result\Facescrub_dataset\FaceNet\0220_V2_MidvsHigh\';
curvedata = csvread([src 'listcmck.csv']); 
plot(curvedata(1:50,1),curvedata(1:50,2),'b-','LineWidth',2);

xlabel('Rank');
ylabel('Recognition Rate (%)');
axis([0 50 0 1]);
title('Matching High, Middle & Low Quality Images using FaceNet on FaceScrub','FontSize',15);
set(gca,'fontweight','bold','FontSize',15);
grid on;
hold on;

%% low vs middle deep
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\face_recognition_result\Facescrub_dataset\FaceNet\0220_V2_LowvsMid\';
curvedata = csvread([src 'listcmck.csv']); 
plot(curvedata(1:50,1),curvedata(1:50,2),'g-','LineWidth',2);

%% low vs High deep
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\face_recognition_result\Facescrub_dataset\FaceNet\0220_V2_LowvsHigh\';
curvedata = csvread([src 'listcmck.csv']); 
plot(curvedata(1:50,1),curvedata(1:50,2),'r-','LineWidth',2);

legend('Middle vs. High','Low vs. Middle','Low vs. High');
