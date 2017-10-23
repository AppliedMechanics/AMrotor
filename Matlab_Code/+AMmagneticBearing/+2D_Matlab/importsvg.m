function data = importsvg(filename)

data = struct();

if ~nargin
  return
end

fid = fopen(filename);

tline = fgetl(fid);
while ischar(tline)
  if ~isempty(strfind(tline,'<line '))
    nameEnd = strfind(tline,'="')-1;
    nameStart = [strfind(tline,'<line ')+length('<line '),strfind(tline,'" ')+2];
    numStart = strfind(tline,'="')+2;
    numEnd = strfind(tline,'" ')-1;
    nameStart(end) = [];
    for i = 1:length(nameStart)
      if sum(strcmpi(fieldnames(data),tline(nameStart(i):nameEnd(i)))) == 0
        data.(tline(nameStart(i):nameEnd(i))) = str2double(tline(numStart(i):numEnd(i)));
      else
        data.(tline(nameStart(i):nameEnd(i))) = [data.(tline(nameStart(i):nameEnd(i))); ...
          str2double(tline(numStart(i):numEnd(i)))];
      end
    end
  end
  tline = fgetl(fid);
end

fclose(fid);

end
