function [net,ty_new,spreadbest,mnbest,test_mse,test_rmse,test_mae,test_mape,gbestsum,pbestfitnessaveragesum] = IPSO_RBF(trainnumber,testnumber)
    clc

    [spreadbest,mnbest,gbestsum,pbestfitnessaveragesum] = IPSO(1,10,7,7,trainnumber,testnumber);
    [net,ty_new,test_mse,test_rmse,test_mae,test_mape] = RBF(spreadbest,mnbest,trainnumber,testnumber);

end

