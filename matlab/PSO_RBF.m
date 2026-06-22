function [net,ty_new,spreadbest,mnbest,test_mse,test_rmse,test_mae,test_mape,gbestsum,pbestfitnessaveragesum] = PSO_RBF(trainnumber,testnumber)
    clc
    
    [spreadbest,mnbest,gbestsum,pbestfitnessaveragesum] = PSO(1,10,1,10,trainnumber,testnumber);
    [net,ty_new,test_mse,test_rmse,test_mae,test_mape] = RBF(spreadbest,mnbest,trainnumber,testnumber);

end

