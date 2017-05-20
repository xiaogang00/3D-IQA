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