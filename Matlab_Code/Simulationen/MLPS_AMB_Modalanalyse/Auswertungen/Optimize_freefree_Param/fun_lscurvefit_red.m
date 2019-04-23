function y = fun_lscurvefit_red(x,xData)
% xData = given inpuData
% x = zu optimierende Daten

% zu optimierende Parameterwerte
raR = x(1)
raL = x(2)

% cnfg=xData;

Simulation_optimization_red %liefert fFEM, HFEM von 0-0.25-400Hz

y = abs(HFEM(41:1000)); % von 10 bis 250Hz
semilogy(fFEM(41:1000),y)
drawnow
end

