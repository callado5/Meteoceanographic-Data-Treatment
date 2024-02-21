%=============================================%
%          CTD Treatment in Matlab            %
%                   Lakes                     %
%                 21/02/2024                  %
%=============================================%
clear all; close all; clc

%Opening data in the directory
cd 'Directory with my CTD data'
file_dir = 'Directory with my CTD data\'; 
textFiles = dir([file_dir '*.cnv']); %Here i get the information of the .cnv files in my folder
text_names = struct2cell(textFiles); 
text_names = text_names(1,:)'; %Getting only the folder names

%Loading my file headers
Header = readtable('HEADS.txt','Delimiter',"", 'ReadVariableNames', false); %Here I created a text file with my variable names to save as table
Header = table2cell(Header);

%Reading Data

for i = 1:length(text_names)

     fid1 = fopen(text_names{i},'rt');
     temp{i} = textscan(fid1,repmat('%f ',1,length(Header)),'HeaderLines',548);
     df{i} = cell2mat(temp{1,i});

end

%% Filtering
%Descending rate = 4
%Depth Fresh = 1
for i = 1:length(df)
    
%Pegando apenas a descida
    m=1;
    while df{i}(m,1) < max(df{i}(:,1))
        m=m+1;
    end
    df{i} = df{i}(1:m,:); 

%Retirando ruidos de momentos parados
    for n =1:length(df{i}(:,1))
        if df{i}(n,4) <=0 || df{i}(n,1) <=0.3
            df{i}(n,:) = NaN;
        end
    end
    df{i}= rmmissing(df{i});
    data{i} = array2table(df{1,i},'VariableNames',Header); 
end

clear file_dir fid1 textFiles temp i text_names i m n Header
%save Filetered_Data.mat % Salvando dados filtrados
