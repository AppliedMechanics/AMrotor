function write_dataset_for_EMA_of_Sim(dataset,filename)
% WRITE_DATASET_FOR_EXPERIMENTAL_POST
% read the dataset from the simulation that was saved as a map
% example code to generate the dataset:
%   d = Dataoutput.TimeDataOutput(St_Lsg);
%   dataset_modalanalysis = d.compose_data();
%   d.save_data(dataset_modalanalysis,'Hochlauf_DPS_U_fwd_bwd_sweep_0_12krpm');
% 
% writes the data into a file, that can be postprocessed the same way as
% the data from the experiments
% write_dataset_for_experimental_post(dataset,filename)

keysDataset = keys(dataset);

for kRpm = 1:length(keysDataset)    
    currData = dataset(keysDataset{kRpm});
    keysSensor = keys(currData);
    kRpmKeys = keysDataset(kRpm);
    currRpm = kRpmKeys{1};
    data.rpm = currRpm;
    data.time = currData(keysSensor{2});
    
    for jSensor = 3:length(keysSensor)
        name = keysSensor(jSensor);
        %varName = genvarname(name); %genvarname will be removed in a future release.
        varName = matlab.lang.makeValidName(name);
        name = name{1};
        data.(varName{1}) = currData(name);
    end
    
    name2 = [filename,'_rpm',num2str(currRpm),'.mat'];
    save(name2,'data')
end

end