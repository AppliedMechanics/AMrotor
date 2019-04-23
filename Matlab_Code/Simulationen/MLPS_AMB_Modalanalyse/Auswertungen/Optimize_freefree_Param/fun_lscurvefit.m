function y = fun_lscurvefit(x,xData)
% xData = given inpuData
% x = zu optimierende Daten

% zu optimierende Parameterwerte
raR = x(1);
raL = x(2);
discS.m = x(3);
discS.Jx = x(4);
discS.Jz = x(5);
discML.m = x(6);
discML.Jx = x(7);
discML.Jz = x(8);

% cnfg=xData;

Simulation_optimization %liefert fFEM, HFEM von 0-0.25-400Hz

y = abs(HFEM(41:1000)); % von 10 bis 250Hz

figure(1)
semilogy(fFEM(41:1000),y)
drawnow
end

