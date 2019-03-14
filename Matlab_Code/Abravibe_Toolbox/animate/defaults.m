function varargout = defaults(action,DATA);

switch action
    case 'loadDefaults'
        TEMP    = defaults('readINI',DATA);
        DATA.Animation  = TEMP.Animation;
        DATA.Display    = TEMP.Display;
        DATA.View       = TEMP.View;
        DATA.AVI        = TEMP.AVI;
        DATA.Snapshot   = TEMP.Snapshot;
        DATA.Colors     = TEMP.Colors;
        varargout{1}    = DATA;
    case 'addPaths'
        TEMP    = defaults('readINI',DATA);
        TEMP.Path = DATA.Path;
        defaults('writeINI',TEMP);
        varargout   = {};
    case 'addRecentFiles'
        TEMP    = defaults('readINI',DATA);
        TEMP.RecentFiles    = DATA.RecentFiles;
        defaults('writeINI',TEMP);
        varargout   = {};
    case 'readINI'
       fid  = fopen(fullfile(DATA.Path.Root,'animate.ini'),'r');
       str  = fgetl(fid);
       while ischar(str)
           if ~isempty(str)
               if ~strcmp(str(1),';')
                   if strcmp(str(1),'['); % Variable Name
                       FIELD    = str(2:end-1);
                   else
                       ind      = findstr(str,'=');
                       vars     = str(1:ind-1);
                       if ~isempty(vars)
                           vars    = ['.' vars];
                       end
                       val  = str(ind+1:end);
                       if all([isempty(str2num(val)),length(str)>2])
                           eval(['DATA.' FIELD vars '=''' val ''';']);
                       else
                           eval(['DATA.' FIELD vars '=[' val '];']);
                       end
                   end
               end
           end
           str  = fgetl(fid);
       end
       fclose(fid);
       varargout{1}=DATA;

    case 'writeINI'
        FIELDS  = fieldnames(DATA);

        fid = fopen(fullfile(DATA.Path.Root,'animate.ini'),'w+');
        fprintf(fid,';Modal Vector Animation Saved : %s\n',datestr(now,0));
        for fld=1:size(FIELDS,1)
            if ~strcmp(FIELDS{fld},'Component')
                fprintf(fid,'\n[%s]\n',FIELDS{fld});
                if isstruct(eval(['DATA.' FIELDS{fld}]))
                    VARS    = fieldnames(eval(['DATA.' FIELDS{fld}]));
                    for vrs = 1:size(VARS,1)
                        val = eval(['DATA.' FIELDS{fld} '.' VARS{vrs}]);
                        if ischar(val)
                            fprintf(fid,'%s=%s\n',VARS{vrs},val);
                        else
                            if all([~mod(val,1),length(val)==1])
                                fprintf(fid,'%s=%d\n',VARS{vrs},val);
                            else
                                strFrmt = '';
                                if length(val)>1
                                    for ii=1:length(val)
                                        strFrmt = [strFrmt '%9.8f,'];
                                    end
                                else
                                    strFrmt = '%s,';
                                end
                                strFrmt = strFrmt(1:end-1);
                                if isempty(val)
                                    fprintf(fid,['%s=' strFrmt '\n'],VARS{vrs},'[]');
                                else
                                    fprintf(fid,['%s=' strFrmt '\n'],VARS{vrs},val);
                                end
                            end
                        end
                    end
                else
                    val = eval(['DATA.' FIELDS{fld}]);
                    if ischar(val)
                        fprintf(fid,'=%s\n',val);
                    else
                        if all([~mod(val,1),length(val)==1])
                            fprintf(fid,'=%d\n',val);
                        else
                            if length(val)>1
                                val =[];
                            end
                            fprintf(fid,'=%8.7f\n',val);
                        end
                    end
                end
            end
        end
        fclose(fid);
        varargout   = {};
end