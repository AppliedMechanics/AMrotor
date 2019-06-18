clear, close all
import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);
Pos.MLleft = 113e-3;
Pos.MLright = 623e-3;
TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);

% kMLvec = [1e3,3.5e4,1.1e5,1e6,1e7];
kMLvec = 3.5e5;
% modeNrvec= {[], [], []};
modeNrvec = cell(size(kMLvec));
maxModes = 6;
for i=1:length(modeNrvec)
    modeNrvec{i} = 1:2:2*maxModes;
end

for i=1:length(kMLvec)
    i
    kSchaetzung = kMLvec(i);
    % kSchaetzung = 1;
    dSchaetzung = 0; % ohne Daempfung
    Simulation
    
    index = find(imag(m.eigenValues.lateral)/2/pi>0); % EF > 1 Hz finden
    % index = index([1,2,5,6]); % nur die erste Biegemode in x- und y-Richtung
    m.eigenValues.lateral=m.eigenValues.lateral(index);
    m.eigenVectors.lateral_x=m.eigenVectors.lateral_x(:,index);
    m.eigenVectors.lateral_y=m.eigenVectors.lateral_y(:,index);
    m.eigenVectors.complex=m.eigenVectors.complex(:,index);
    m.n_ew = length(index);
    EF{i} = m.eigenValues.lateral;
    
    disp(['k=',num2str(kSchaetzung)])
    esf.print_frequencies();
    [x{i},EVmain{i}]=esf.plot_displacements();
    
    %extrahiere Biegemoden
        ModenNummern = 1:length(EF{i});
        clear boolBiegung
        for n = 1:length(ModenNummern)
            boolBiegung(n) = norm(EVmain{i}(:,n))>1e-3;
            %         EVmain{i}(:,n)=EVmain{i}(:,indexBiegung); % nur Moden mit Biegung
            %         EF{i}=EF{i}(indexBiegung);
        end
        EVmain{i} = EVmain{i}(:,boolBiegung);
        EF{i}=EF{i}(boolBiegung);
    
    
    numModes= length(modeNrvec{i});
    for k = 1:numModes
        kMode = modeNrvec{i}(k);
        % figures zeichnen
        figMode(k) = figure;
        EVcurr = EVmain{i}(:,kMode);
%         plot(x{i},EVcurr)
        ylim([-1 1]*max(abs(EVcurr)));
        figName = ['k=',num2str(kSchaetzung,'%.2g'),'_f=',num2str(imag(EF{i}(kMode))/2/pi,'%.2f'),'Hz'];
        figName = regexprep(figName,'\.','-');
        figName = regexprep(figName,'\+','');
        ylim(ylim);
        xlim([min(x{i}),max(x{i})]);
        hold on
        plot(xlim,[0, 0],'black','DisplayName','Nulllinie') %Nulllinie
        plot([-1],[0])%plot([1 1]*Pos.MLleft,ylim,'k','DisplayName','MLleft')
        plot([-1],[0])%nurPlatzhalter, damit Code danach noch funzt%plot([1 1]*Pos.MLright,ylim,'k','DisplayName','MLright')
        xlimits=xlim;ylimits=ylim;
        xIndex = [1,2,2,1,1];
        yIndex = [1,1,2,2,1];
        plot(xlimits(xIndex),ylimits(yIndex),'k','LineWidth',1.5);% schwarze Umrandung
        clear xIndex yIndex;
        plot(x{i},EVcurr)
        
        % figures speichern
        figNameTikz = ['tikz/',figName,'.tikz'];
        
        set(0, 'currentfigure', figMode(k));
        ax = gca;
        axObjs = figMode(k).Children;
        
        axObjs.Children;
        dataObjs=ans;
        
        yticks(0)
        %         xticks([Pos.MLleft,Pos.MLright])
        %         xticklabels({'ML L','ML R'})
        %         grid on
        
        % Farben aendern
        for j=2:4 %MLright,MLleft,Nulllinie
            dataObjs(j).Color = grau;
            %             delete(dataObjs(kMode));
        end
        dataObjs(1).Color = 'black'; %Simulation
        dataObjs(1).LineWidth = 1.5;
        
        ax.Title.String='';
        xlabel('')%xlabel('$z$/mm','Interpreter','Latex')
        ylabel('')%ylabel('$u$/mm','Interpreter','Latex')
        ax.Visible='off';
        
%         % Exportiere zu tikz
%         matlab2tikz(figNameTikz, 'height', '\fheight', 'width', '\fwidth' )
%         
%         % mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
%         to_find = '\\addlegendentry{data';
%         to_replace = '\%\\addlegendentry{data';
%         find_and_replace(figNameTikz, to_find, to_replace)
%         to_find = '\\addlegendentry{Nulllinie';
%         to_replace = '\%\\addlegendentry{Nulllinie';
%         find_and_replace(figNameTikz, to_find, to_replace)
%         to_find = '\\addlegendentry{MLleft';
%         to_replace = '\%\\addlegendentry{MLleft';
%         find_and_replace(figNameTikz, to_find, to_replace)
%         to_find = '\\addlegendentry{MLright';
%         to_replace = '\%\\addlegendentry{MLright';
%         find_and_replace(figNameTikz, to_find, to_replace)
        
        %save as pdf
        figMode(k).Units = 'Centimeters';
        figMode(k).Position(3:4) = [2,2];
        pos = get(figMode(k),'Position');
        set(figMode(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
        print(figMode(k),['pdf/',figName],'-dpdf','-painters' )
    end
    
    
    close all
    % pause
end

% save as pdf
% ohne Hintergrund, ohne Skala, nur Nullinie und Markeirung der Lagerpositionen