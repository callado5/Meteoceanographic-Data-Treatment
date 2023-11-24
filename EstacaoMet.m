clear all; close all;
%Dados estação

Dados = readtable('C:\Users\mavca\Downloads\rel_24-11-23_08-27-08.xls'); %Abrindo matrix de dados
Dia   = table2array(Dados(1:end-3,1)); %Separando dia e Hora
Hora  = table2array(Dados(1:end-3,2));

Time  = string(Dia(:))+' '+string(Hora(:)); %Juntando eles em formato de string para ler com datetime
Time = datetime(Time);
Data = table2array(Dados(1:end-3,3:end));
Data(:,end+1) = datenum(Time);

[~,Tsort] = sort(Time); %Pegando ordenamento baseado nas datas (index)
Data = Data(Tsort,:); % Ordenando os dados baseado na matrix de tempo
Time = sort(Time); % Ordenando o tempo
%% Suavizando plot (interpolação)
t = datenum(Time);
samplingRateIncrease = 20;
newt = linspace(min(t), max(t), length(t) * samplingRateIncrease)';

for i = 1:length(Data(1,:))
    sData(:,i) = spline(t, Data(:,i), newt);
end

% 
 plot(newt,sData(:,2),'color','#053B50','LineStyle','--') %Temp
 hold on
 plot(datenum(Time),Data(:,2),'color','#176B87') %Temp
 datetick('x','dd-mmm HH:MM','keepticks')

%% Testando Plots

figure(1)
plot(newt,sData(:,2),'color','#176B87') %Temp
hold on
plot(newt,sData(:,10),'color','#053B50','LineStyle','--')% Temp agua
legend('Temperatura Ar','Temperatura Água')
datetick('x','dd-mmm HH:MM','keepticks')
title('Temperatura (ºC)')

figure(2)
bar(Time,Data(:,1),'EdgeColor','none','FaceColor','#64CCC5');%Precip
title('Precipitação (mm)')

%%
addpath('C:\Users\mavca\OneDrive\Documentos\Cotonho\Rotinas MAT\COLORMAPS\slanCM\slanCM')
Options = {'anglenorth', 0, 'angleeast', 90, 'labels',{'N','NE','E','SE','S','SW','W','NW'}, 'freqlabelangle', 50,...
    'TitleString','Velocidade dos ventos Água Preta','LabLegend', 'Intensidade m/s','nDirections',15,...
    'cMap', slanCM(85), 'LegendType',1, 'Min_Radius', 0};
WindRose(sData(:,7),sData(:,6),Options)
