function data = generate_sensor_output(obj)
  n=0;
  for i=obj.sensors  
      n=n+1;
      data(n).name=i.name;
      data(n).unit=i.unit;
      [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(obj);
      data(n).timedata=[x_pos;beta_pos;y_pos;alpha_pos];
  end
end