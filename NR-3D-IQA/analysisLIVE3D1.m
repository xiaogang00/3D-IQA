function analysisLIVE3D1(algoName)
% This function quantifies the performance of a 3D IQA method, with indices
% PLCC, SRCC, KRCC, and RMSE. The objective scores must be prepared
% beforehand.
% Input:
% 'algoName': The name of the tested IQA method.
% Output:
% The function has no output, it saves the results in a CSV file in the
% directory named after the IQA methods' name (i.e. 'algoName').
% Note:
% When the prepared objective score matrix contains more than one column,
% i.e. more than one feature is extraced from each image, SVM is adopted
% for regression.
load(strcat(algoName, '/LIVE3D1_results.mat')); % load subjective and objective scores.
Qs = results.Qs; Qo = results.Qo;
for i = 1 : size(Qo, 2) % feature normalization
    Qo(:, i) = (Qo(:, i) - min(Qo(:, i))) ./ ...
        (max(Qo(:, i)) - min(Qo(:, i))) * 100;
end
% Grid search for the best parameters for SVM, if it is needed.
if size(Qo, 2) > 1
    disp('Grid searching...');
    currentFolder = pwd;
    cd('./libsvm-3.21/matlab/');
    minMSE = 1e5;
    for log2c = -10 : 10
        for log2g = -10 : 10
            for log2p = -10 : 10
                cmd = ['-s 3 -v 5 -c ', num2str(2^log2c),...
                    ' -g ', num2str(2^log2g),' -p ', num2str(2^log2p)];
                mse = svmtrain2(Qs, Qo, cmd);
                if (mse < minMSE),
                    minMSE = mse;
                    bestc = 2^log2c; bestg = 2^log2g; bestp = 2^log2p;
                end
                fprintf('%g %g %g %g (best c=%g, g=%g, p=%g, rate=%g)\n',...
                    log2c, log2g, log2p, mse, bestc, bestg, bestp, minMSE);
            end
        end
    end
    % synthesize optimization result
    cmd = ['-s 3 -c ', num2str(bestc),...
        ' -g ', num2str(bestg),' -p ', num2str(bestp)];
    cd(currentFolder);
    save(strcat('./',algoName,'/LIVE3D1_cmd.mat'),'cmd');
end
% Distinguishing Qs with single column (no regression needed) or multiple
% column (regression needed).
if size(Qo, 2) > 1
    expression =...
        'performance = crossValidation(x, y, algoName, currentFolder);';
else
    expression = 'performance = findCorrelation(x, y);';
end
% Overall performance
disp('Calculating overall performance...');
x = Qo, y = Qs; eval(expression); performanceAll = performance;
% Performance of each distortion type
disp('Calculating performance of distortion type');
disp('JP2K...'); x = Qo(1 : 80, :); y = Qs(1 : 80);
eval(expression); perfJ2 = performance;
disp('JPEG...'); x = Qo(81 : 160, :); y = Qs(81 : 160);
eval(expression); perfJP = performance;
disp('WN...'); x = Qo(161 : 240, :); y = Qs(161 : 240);
eval(expression); perfWN = performance;
disp('Blur...'); x = Qo(241 : 285, :); y = Qs(241 : 285);
eval(expression); perfB = performance;
disp('FF...'); x = Qo(286 : 365, :); y = Qs(286 : 365);
eval(expression); perfFF = performance;
% Save the results.
datasheet = cell(5, 7);
datasheet(1, 2 : 7) = {'JP2K', 'JPEG', 'WN', 'Blur', 'FF', 'ALL'};
datasheet(2 : 5, 1) = {'PLCC', 'SRCC', 'KRCC', 'RMSE'};
datasheet(2 : 5, 2 : 7) = ...
    num2cell([perfJ2', perfJP', perfWN', perfB', perfFF', performanceAll']);
xlswrite(strcat(algoName, '/LIVE3D1_performance.xls'), datasheet);
end

function performance = crossValidation(x, y, algoName, currentFolder)
% Output format
performance = zeros(1, 4); % PLCC, SRCC, KRCC, and RMSE
% Cross-validation, repeating 1000 times
repeatTime = 1000; currentFolder = pwd; performanceTemp = []; 
for i = 1 : repeatTime
    indices = crossvalind('Kfold', length(y), 5);
    for j = 1 : 5
        test = (indices == j); train = ~test;
        x_train = x(train, : ); y_train = y(train, : );
        x_test = x(test, : ); y_test = y(test, : );
        load(strcat('./',algoName,'/LIVE3D1_cmd.mat'));
        cd('./libsvm-3.21/matlab/');
        model = svmtrain2(y_train, x_train, cmd);
        y_predict = svmpredict2(y_test, x_test, model);
        cd(currentFolder);
        performanceTemp = [performanceTemp; findCorrelation(y_predict, y_test)];
    end
end
performance = mean(performanceTemp);
end

function performance = findCorrelation(x, y)
beta0(1) = max(y);
beta0(2) = min(y);
beta0(3) = mean(x);
beta0(4) = 0.1;
beta0(5) = 0.1;
beta = nlinfit(x,y,@logistic5,beta0);
y_predict = feval(@logistic5, beta, x);
PLCC = abs(corr(y, y_predict, 'type', 'Pearson'));
SRCC = abs(corr(y, x, 'type', 'Spearman'));
KRCC = abs(corr(y, x, 'type', 'Kendall'));
RMSE = sqrt(sum((y_predict - y).^2) / length(y));
performance = [PLCC, SRCC, KRCC, RMSE];
end

function f = logistic5(beta, x)
f = beta(1).*(0.5-(1./(1+exp(beta(2).*(x-beta(3)))))) + beta(4).*x + beta(5);
end