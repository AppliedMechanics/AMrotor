function unit = make_unit(obj)
sensorIn = obj.sensorIn;
sensorOut = obj.sensorOut;

unit = ['\frac{',sensorOut.unit,'}{',sensorIn.unit,'}'];
obj.unit = unit;

end