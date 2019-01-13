function data = read_dataset(dataset)
% READ_DATASET
% read the dataset from the simulation that was saved as a map
% example code to generate the dataset:
%   d = Dataoutput.TimeDataOutput(St_Lsg);
%   dataset_modalanalysis = d.compose_data();
%   d.save_data(dataset_modalanalysis,'Hochlauf_DPS_U_fwd_bwd_sweep_0_12krpm');
% 
% gives out the data{krpm} as a struct, with the corresponding keys as names
% 
% data = read_dataset(dataset)

keysDataset = keys(dataset);

for krpm = 1:length(keysDataset)
    
    currData = dataset(keysDataset{krpm});
    keysSensor = keys(currData);
    currRpm = keysDataset(krpm);
    currRpm = currRpm{1};
    data{krpm}.rpm = currRpm;
    data{krpm}.time = currData(keysSensor{2});
    
    for jSensor = 3:length(keysSensor)
        name = keysSensor(jSensor);
        %varName = genvarname(name); %genvarname will be removed in a future release.
        varName = matlab.lang.makeValidName(name);
        name = name{1};
        data{krpm}.(varName{1}) = currData(name);
    end
    
end

end