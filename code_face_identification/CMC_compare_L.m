clear;clc;
close all;

%% before enhancement
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_deep_fr\face_recognition_result\IJBA_dataset\VGGface\0126_V2_low\';
curvedata = csvread([src 'listcmck.csv']); 
plot(curvedata(1:50,1),curvedata(1:50,2),'r-', 'LineWidth',2);

xlabel('Rank');
ylabel('Recognition Rate (%)');
axis([0 50 0 1]);
title('Low Quality vs. High Quality using Deblurring','FontSize',15);
set(gca,'fontweight','bold','FontSize',15);
grid on;
hold on;

%% photo measure all high
src = 'F:\zn1\znMCM\MsCeleb1M_code\code_face_recognition_enhancedface_with_VGGface\VGG_facerecognition\deblur_low\';
curvedata = csvread([src 'listcmck.csv']); 
plot(curvedata(1:50,1),curvedata(1:50,2),'b-', 'LineWidth',2);


%% legend
%legend('cropped faces','Before Enhancement','deblur','photometric normalization','Frontalization','three together');
legend('Before Enhancement','After Enhancement');


