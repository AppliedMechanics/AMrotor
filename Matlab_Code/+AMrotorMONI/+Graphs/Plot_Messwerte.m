    figure();
    schluessel=keys(dataset_monitoring);
    
    i=1;
    
    for data=dataset_monitoring   % Anzahl Simulationsparameter
            subplot(k,4,i);
                for y=1:size(dataset_monitoring,1)
                    local=dataset_monitoring(schluessel{y});
                    localkey=keys(local);
                    Vektor=[1,2,3,4,5,6,7,13,14,15,16,17,18,19];
                    localkeysorted=localkey(Vektor);
                    meinSet(K,:)=local(localkeysorted{K});
                    hold on;
                    plot(meinSet(K,:));
                    title(localkeysorted{K});
                end
            hold off;
            i=i+1;
     end