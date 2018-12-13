function warn_for_non_integrable_component(self)

wrnMsgGerman = ['Achtung! Es wurde ein Lager als Kennfeld vorgegeben. Dies kann',...
    'unerw�nschte Effekte in der Zeitintegration bedeuten. Die ',...
    'Lagerkoeffizienten bedeuten eine Linearisierung um den Arbeitspunkt. ',...
    'Evtl. wollen Sie das Lager als load einbinden, womit es als ',...
    'dynamische Kraft, welche in jedem Zeitschritt neu berechnet wird, ',...
    'eingebunden wird.'];
wrnMsg = ['Attention! You specified a BEARING as a look up table. ',...
    'This may cause unexpected results in the time integration. The ',...
    'bearing coefficients are a linearization around the operating point. ',... 
    'You may want to include the bearing as a load, which is recalculated ',...
    'in every time step and integrated as a dynamic force.'];

warning(wrnMsg);

promptGerman = 'Wollen Sie die Zeitintegration trotzdem fortsetzen? [y/n]   ';
prompt = 'Do you want to continue the time integration anyway? [y/n]   ';

selection = input(prompt,'s');

if ~strcmp(selection,'y')
    error('Aborted time integration, because of problematic bearing.');
end

end
