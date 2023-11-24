%-------------------------------------------%
%               Marco Callado               %
%                24-11-2023                 %
%            mavcallado@gmail.com           %
%-------------------------------------------%

%Loading the station data

Dados = readtable('rel_24-11-23_08-27-08.xls'); % put your excel, csv or txt file here
Dia   = table2array(Dados(1:end-3,1)); % Separating day and hour and deleting my 3 last rows (mean, sum, median)
Hora  = table2array(Dados(1:end-3,2));

Time  = string(Dia(:))+' '+string(Hora(:)); %Grouping them in a string
Time = datetime(Time); % Transforming to datetime

Data = table2array(Dados(1:end-3,3:end)); % Loading my meteoroligcal data to array

%% In case my data is not cronological as my time, the script begins to sort your data cronologicaly

[~,Tsort] = sort(Time); %Getting my sorted index based on my datetime vector
Data = Data(Tsort,:); % Sorting Data by the datetime vector
Time = sort(Time); % Sorting my datetime

%% Smoothing my data for a smooth line plot (interpolation)

t = datenum(Time);
samplingRateIncrease = 20;
newt = linspace(min(t), max(t), length(t) * samplingRateIncrease)';

for i = 1:length(Data(1,:))
    sData(:,i) = spline(t, Data(:,i), newt);
end

%Testing my smoothed plot
plot(newt,sData(:,2),'color','#053B50','LineStyle','--') %Temp
hold on
plot(datenum(Time),Data(:,2),'color','#176B87') %Temp
datetick('x','dd-mmm HH:MM','keepticks')

%% Testing the plots

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

%% For my wind rose plot please check: https://dpereira.asempyme.com/windrose/
% And for my colormaps i used: https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap

Options = {'anglenorth', 0, 'angleeast', 90, 'labels',{'N','NE','E','SE','S','SW','W','NW'}, 'freqlabelangle', 50,...
    'TitleString','Velocidade dos ventos Água Preta','LabLegend', 'Intensidade m/s','nDirections',15,...
    'cMap', slanCM(85), 'LegendType',1, 'Min_Radius', 0};
WindRose(sData(:,7),sData(:,6),Options)
