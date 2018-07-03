classdef Unit < handle
    
    properties
        BaseDimensions
        BaseUnitNames
        BaseUnits
        Defaults
        DefaultsNames
        DimVector
        Name
        SIFactor
        Symbol
        dBref
    end
    
    methods
        function self = Unit()
            self.BaseUnits = {'m','kg','s','A','K','mol','cd','rad'};
            self.BaseDimensions = {'Length','Mass','Time','Electric Current',...
                'Temperature','Amount of Substance','Luminous Intensity', 'Angle'};
            self.BaseUnitNames = {'meter','kilogramm','seconds','ampere',...
                'kelvin','mol','candela','radiant'};
            self.Defaults = {'m','kg','s','A','K','mol','cd','rad','Hz','N','Pa','J','W','C','V','F',char(937),...
                'S','Wb','T','H',char(8451)};
            self.DefaultsNames = {'meter','kilogramm','seconds','ampere',...
                'kelvin','mol','candela','radiant','hertz','newton','pascal','joule','watt',...
                'coulomb','volt','farad','ohm','siemens','weber','tesla','henry','degree celcius'};
            self.DimVector = [0, 0, 0, 0, 0, 0, 0, 0];
            self.SIFactor = [0, 0];
        end
        
        function getBaseUnits(self)
            disp(self.BaseUnits)
        end
        
        function getBaseDimensions(self)
            disp(self.BaseDimensions)
        end
        
        function getDefaults(self)
            disp(self.Defaults)
        end
        
        function getBaseUnitNames(self)
            disp(self.BaseUnitNames)
        end
        
        function getUnitName(Einheit)
            unit = char(Einheit);
%             if find(strcmp(self.BaseUnits,unit)) > 0
%                 index = find(strcmp(self.BaseUnits,unit));
%                 disp(self.BaseUnitsNames(1,index));
            
            if find(strcmp(self.Defaults,unit)) > 0
                index = find(strcmp(self.Defaults,unit));
                disp(self.DefaultsNames(1,index));  
            else
                error('Unit not found')
            end
        end
        
        function getFromDefaults(self,Einheit)
              if nargin == 1
                self.Name = 'Dimensionless';
                disp(['Name: ',self.Name]);
                self.Symbol = '-';
                disp(['Symbol: ',self.Symbol])
                disp(['DimVector: ', num2str(self.DimVector)])
                disp(['SIFactor: ', num2str(self.SIFactor)])
                disp(['dBref: ', 0])
                return
              end  
            
            x= isa(Einheit,'numeric');
            
            if x ==  1
            unit = num2str(Einheit);
            else
            unit = Einheit;    
            end
            
            if find(strcmp(self.Defaults,unit)) > 0
                index = find(strcmp(self.Defaults,unit));
                self.Name = self.DefaultsNames{1,index};
                self.Symbol = self.Defaults{1,index};
                
            elseif find(strcmp(self.DefaultsNames,unit)) > 0
                index = find(strcmp(self.DefaultsNames,unit));
                self.Name = self.DefaultsNames{1,index};
                self.Symbol = self.Defaults{1,index};
            else
                error('Unit not found')
            end
            
             switch self.Name
                 case 'meter'
                     self.Name = 'Meter';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'm';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [1,0,0,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'kilogramm'                    
                     self.Name = 'Kilogramm';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'kg';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,1,0,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'seconds'
                     self.Name = 'Seconds';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 's';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,1,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'ampere'
                     self.Name = 'Ampere';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'A';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,1,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'kelvin'
                     self.Name = 'Kelvin';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'K';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,0,1,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'mol'
                     self.Name = 'Mol';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'mol';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,0,0,1,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'candela'
                     self.Name = 'Candela';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'candela';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,0,0,0,1,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'radiant'
                     self.Name = 'Radiant';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'rad';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,0,0,0,0,1];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'hertz'
                     self.Name = 'Hertz';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'Hz';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,-1,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'newton'
                     self.Name = 'Newton';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'N';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [1,1,-2,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'pascal'
                     self.Name = 'Pascal';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'Pa';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [-1,1,-2,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'joule'
                     self.Name = 'Joule';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'J';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-2,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'watt'
                     self.Name = 'Watt';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'W';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-3,0,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'coulomb'
                     self.Name = 'Coulomb';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'C';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,1,1,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'volt'
                     self.Name = 'Volt';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'V';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-3,-1,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'farad'
                     self.Name = 'Farad';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'F';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [-2,-1,4,2,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'ohm'
                     self.Name = 'Ohm';
                     disp(['Name: ',self.Name]);
                     self.Symbol = char(937);
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-3,2,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'siemens'
                     self.Name = 'Siemens';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'S';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [-2,-1,3,2,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])   
                 case 'weber'
                     self.Name = 'Weber';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'Wb';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-2,-1,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'tesla'
                     self.Name = 'Tesla';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'T';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,1,-2,1,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'henry'
                     self.Name = 'Henry';
                     disp(['Name: ',self.Name]);
                     self.Symbol = 'H';
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [2,1,-2,-2,0,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                 case 'degree celcius'
                     self.Name = 'Degree Celcius';
                     disp(['Name: ',self.Name]);
                     self.Symbol = char(8451);
                     disp(['Symbol: ',self.Symbol])
                     self.DimVector = [0,0,0,0,1,0,0,0];
                     disp(['DimVector: ', num2str(self.DimVector)])
                     self.SIFactor = [1,0];
                     disp(['SIFactor: ', num2str(self.SIFactor)])
                     disp(['dBref: ', num2str(1)])
                     Offset = 273.5 ;
                     disp(['Offset: 0 K = -273,5',char(8451)])
             end       
            
        end    
    end
    
end

