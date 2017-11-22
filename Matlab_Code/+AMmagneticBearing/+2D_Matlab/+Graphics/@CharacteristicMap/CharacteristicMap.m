classdef CharacteristicMap
    %CHARACTERISTIC_MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        map
    end
    
    methods
         %Konstruktor
       function obj = CharacteristicMap(name,map)
           obj.name = name;
           obj.map = map;
          %
       end
    end
    
end

