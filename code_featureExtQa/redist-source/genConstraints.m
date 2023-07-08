function [O, S, C_O, C_S] = genConstraints(data)
    
    disp('Generating all pairwise constraints ...');
    
    %% total number of training samples
    N = 0; 
    for i = 1:length(data)
        N = N + size(data{i},1);
    end
    
    %% '=' constriants
    num_eq = 0;
    for i = 1:length(data)
        num_eq = num_eq + nchoosek(size(data{i},1),2);
    end
    Ridx_all = zeros(1, 2*num_eq);
    Val_all = zeros(1, 2*num_eq);
    Cidx_all = zeros(1, 2*num_eq);
    count = 0;
    for i = 1:length(data)
        L = size(data{i},1);
        Ridx = [1:nchoosek(L,2) 1:nchoosek(L,2)]+count/2;
        Val = [ones(1, nchoosek(L,2)) -ones(1, nchoosek(L,2))];
        Cidx = zeros(1, 2*nchoosek(L,2));
        idx = 1;
        for j = 1:size(data{i},1)-1
            Cidx(idx:idx+size(data{i},1)-1-j) = j;
            idx = idx+size(data{i},1)-j;
        end
        for j = 1:size(data{i},1)-1
            Cidx(idx:idx+size(data{i},1)-1-j) = (j+1:size(data{i},1));
            idx = idx+size(data{i},1)-j;
        end
        for k = 1:i-1
            Cidx = Cidx + size(data{k},1);
        end
        
        Ridx_all(count+1:count+2*nchoosek(L,2)) = Ridx;
        Cidx_all(count+1:count+2*nchoosek(L,2)) = Cidx;
        Val_all(count+1:count+2*nchoosek(L,2)) = Val;
        count = count + 2*nchoosek(L,2);
    end
    S = sparse(Ridx_all, Cidx_all, Val_all);
    C_S = ones(size(S,1),1)*0.1;
    
    %% '>' constraints
    num_ineq = nchoosek(N,2) - num_eq;
    Ridx_all = zeros(1, 2*num_ineq);
    Val_all = zeros(1, 2*num_ineq);
    Cidx_all = zeros(1, 2*num_ineq);    
    count = 0;
    for i = 1:length(data)-1
        for j = i+1:length(data)
            L1 = size(data{i},1);
            L2 = size(data{j},1);
            Ridx = [1:L1*L2 1:L1*L2]+count/2;
            Val = [ones(1, L1*L2) -ones(1, L1*L2)];
            T1 = ones(L2,1)*(1:L1);
            for k = 1:i-1
                T1 = T1 + size(data{k},1);
            end
            T2 = (1:L2)'*ones(1,L1);
            for k = 1:j-1
                T2 = T2 + size(data{k},1);
            end
            Cidx = [T1(:); T2(:)]';
            Ridx_all(count+1:count+2*L1*L2) = Ridx;
            Cidx_all(count+1:count+2*L1*L2) = Cidx;
            Val_all(count+1:count+2*L1*L2) = Val;
            count = count +2*L1*L2; 
        end
    end
    O = sparse(Ridx_all, Cidx_all, Val_all);
    C_O = ones(size(O,1),1)*0.1;
    
end