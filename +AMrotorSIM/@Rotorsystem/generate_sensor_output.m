function data = generate_sensor_output(obj)
% Extracts position data from all sensors into a data struct
%
%    :param obj: Object of type rotorsystem
%    :type obj: object
%    :return: data

% Licensed under GPL-3.0-or-later, check attached LICENSE file

  n=0;
  for i=obj.sensors  
      n=n+1;
      data(n).name=i.name;
      data(n).unit=i.unit;
      [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(obj);
      data(n).timedata=[x_pos;beta_pos;y_pos;alpha_pos];
  end
end