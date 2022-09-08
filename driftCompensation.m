data_1 = xlsread('training_examples.xlsx');
%%
data_2 = xlsread('Best_oocyte_06102022_peak.xlsx');
%%
ctr2 = 1; 
for i = 1:length(data_1)
    if data_1(i,1) == 50
        tmp(ctr2) = i;
        ctr2 = ctr2 + 1;
    end
end
%%
close all;clc;
for ii = 1 : length(tmp)
    t1 = tmp(ii);
    if ii == length(tmp)
        t2 = length(data_1);
    else
        t2 = tmp(ii+1)-1;
    end
    tt = data_1(t1:t2,1);
    data = data_1(t1:t2,2);
%     plot(tt,data);
%     hold on
    %
    test_end = 2000;
    test_scale = 1;
    err = zeros(1,test_end/test_scale);
    ctr = 1;
    min_err = inf;
    min_idx = 0;
    for i = 0:test_scale:test_end-1
        fitSig = data(end)+(data(1)-data(end))*exp(-tt/i);
        for j = 1:length(fitSig)
            if j > length(fitSig)*0.6
                temp = 10*(data(j) - fitSig(j))^2;
            else
                temp = (data(j) - fitSig(j))^2;
            end
            err(ctr) = err(ctr) + temp; 
        end
        if err(ctr) < min_err
            min_err = err(ctr);
            min_idx = i;
        end
        ctr = ctr + 1;
    end
    idx(ii) = min_idx;
% fitSig_best = data(end)+(data(1)-data(end))*exp(-tt/min_idx);
% plot(tt,fitSig_best)
 
end
%% for checking results of a specific set of data
close all;
x = 2;
tt1 = tmp(x);
tt2 = tmp(x+1)-1;
data = data_1(tt1:tt2,2);
tt = data_1(tt1:tt2,1);
fitSig_best = data(end)+(data(1)-data(end))*exp(-tt/idx(x));
plot(tt,data)
hold on
plot(tt,fitSig_best,'--')
legend('observed','fitted')
% plot(tt,data-fitSig_best+data_1(tt2,2))
% legend('observed','compensated')
%%
close all
fitSig_best = data(end)+(data(1)-data(end))*exp(-data_2(:,1)/idx(2));
% plot(data_2(:,1),fitSig_best,'--')
% hold on
% % plot(data_2(:,1),data_2(:,2),'--')
% hold on
plot(data_2(:,1),data_2(:,2)-fitSig_best+data_1(tt2,2))
hold on
plot(data_2(:,1),data_2(:,2))
%%
close all;clc;
tt = 50:50:50*32;
for ii = 1 : length(tmp)-1
    t1 = tmp(ii);
    if t2 == tmp(end)
        t2 = data_1(end,1)
    else
        t2 = tmp(ii+1)-1;
    end
    for i = 1:length(idx)
        data = data_1(t1:t2,2);
        y_train(1+32*(i-1):32+32*(i-1)) = data(end)+(data(1)-data(end))*exp(-tt/idx(i));
    end
end
y_train = y_train';
plot(y_train)
