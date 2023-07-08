clear;clc;
close all;

path='F:\zn1\znMCM\MsCeleb1M_code\statistic_rqs_3f';
qd = importdata([path '/quality_distribution.csv'], 'r');
%% compute Low vs High positive pairs
% count = 0;
% for n=2:501
%     str = qd(n);
%     str1 = str{1,1};
%     datas=regexp(str1,',','split');
%     L = datas{1,4};
%     H = datas{1,2};
%     count = count+str2num(L).*str2num(H);
% end

%% compute Low vs High negative pairs
count = 0;
matrix = [];
for n=2:501
     str = qd(n);
    str1 = str{1,1};
    datas=regexp(str1,',','split');
    L = datas{1,4};
    H = datas{1,2};
    matrix = [matrix;str2num(H),str2num(L)];
end
for i=1:500
    L = matrix(i,2);
    for j=1:500
        if(j==i) 
            continue;
        end
        h=matrix(j,1);
        count = count + h.*L;        
    end
end

