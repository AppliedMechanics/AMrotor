function [dataset, datasetNeu]= Datenaufbereitung()
% Test Datenpaket für Initialisierungslauf
path='.\+AMrotorMONI\MeasurementData\';

data1800=[path,'data1800','.mat'];
load(data1800)
dataset(1,:,:)=data;
data1900=[path,'data1900','.mat'];
load(data1900)
dataset(2,:,:)=data;
data2000=[path,'data2000','.mat'];
load(data2000)
dataset(3,:,:)=data;

% Test Datenpake für wiederholung des Monitorings
data200=[path,'data200','.mat'];
load(data200)
datasetNeu(1,:,:)=data;
data300=[path,'data300','.mat'];
load(data300)
datasetNeu(2,:,:)=data;
data400=[path,'data400','.mat'];
load(data400)
datasetNeu(3,:,:)=data;
end