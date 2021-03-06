% Bench Test report - analysis

close all;
clear all;
clc;

%% Setting inputs
% Choose one of these Time to alert HR RR simulation database:
% #1 OEM WA_1_3_6
% flg5_2_24=0;
% folder = 'C:\Data\BenchTest\A_WA_1_3_6sm';
% folderRR = 'C:\Data\BenchTest\A_RR'; %contains files with 1 minute means of the RR
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestA_res_WA_1_3_6';
% %
% flg5_2_24=0;
% folder = 'C:\Data\BenchTest\B_WA_1_3_6sm';
% folderRR = 'C:\Data\BenchTest\B_RR'; %contains files with 1 minute means of the RR
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestB_res_WA_1_3_6';

% flg5_2_24=0;
% folder = 'C:\Data\BenchTest\new17_6_13bench_WA_1_3_6sm';
% folderRR = 'C:\Data\BenchTest\new17_6_13bench_RR'; %contains files with 1 minute means of the RR
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestN_res_WA_1_3_6';

% flg5_2_24=0;
% folder = 'C:\Data\BenchTest\V2_added_signals_RR_WA_1_4_1sm';
% folderRR = 'C:\Data\BenchTest\V2_added_signals_RR'; %contains files with 1 minute means of the RR
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestN_res_WA_1_4_1';

flg5_2_24=0;
folder = 'C:\SENSORS\Japan\Bench Test\Bench Test Algs Results 7_6_97H\long';
folderRR = 'C:\SENSORS\Japan\Bench Test\Simulated signals RR\long'; %contains files with 1 minute means of the RR
mypath = 'C:\SENSORS\Japan\Bench Test\Bench Test Results\';
filename='BenchTestJapan_res_7_6_97H_long';

% #2 PR Ver_5_2_24
% flg5_2_24=1;
% folder = 'C:\Data\BenchTest\A_Ver_5_2_24';
% folderRR = 'C:\Data\BenchTest\A_RR';
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestA_Ver_5_2_24';
%
% flg5_2_24=1;
% folder = 'C:\Data\BenchTest\B_Ver_5_2_24';
% folderRR = 'C:\Data\BenchTest\B_RR';
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestB_Ver_5_2_24';

% flg5_2_24=1;
% folder = 'C:\Data\BenchTest\new17_6_13bench_Ver_5_2_24';
% folderRR = 'C:\Data\BenchTest\new17_6_13bench_RR'; %contains files with 1 minute means of the RR
% mypath = 'C:\Data\BenchTest\Results\';
% filename='BenchTestN_Ver_5_2_24';

d = dir(folder);
simInRR=[];
simInHR=[];
simOutRR=[];
RRAmp=[];
HRAmp=[];
% simOutHR=[];
testRR=[];
testHR=[];
OOR_HR=[];
OOR_RR=[];
q=1;
counter=1;
while q<(length(d)+1)
    if ~isempty(strfind(d(q).name,'_hr')) || ~isempty(strfind(d(q).name,'_rr'))
        if ~isempty(strfind(d(q).name,'_hr'))
            load([folder,'\',d(q).name]);
            tmpHR=(hr_params.hr_dec);
            if flg5_2_24==0
                tmpOOR_HR=(hr_params.hr_OOR); %this field does not exist in 5_2_24
            else
                tmpOOR_HR=zeros(size(tmpHR));
            end
            clear hr_params
            q=q+2; % assuming 2 files difference between rr and hr
            load([folder,'\',d(q).name]);
            tmpRR=(rr_params.rr_dec);
            if flg5_2_24==0
                tmpOOR_RR=(rr_params.rr_OOR); %this field does not exist in 5_2_24
            else
                tmpOOR_RR=zeros(size(tmpRR));
            end
            clear rr_params
                        for n=1:5
%             for n=1:7
                %                 tmpHRn=tmpHR(2*60*(n+2):2*60*(n+3)); %one minute averages starting from the 4th minute
                %                 tmpRRn=tmpRR(2*60*(n+2):2*60*(n+3));
                %                 if length(tmpHR)==1800 % 900sec signal
                if length(tmpHR)==1802 % 900sec signal
                    tmpHRn=tmpHR(2*60*(n+7):2*60*(n+8)); %one minute averages starting from the 9th minute
                    tmpRRn=tmpRR(2*60*(n+7):2*60*(n+8));
                    tmpOOR_HRn=tmpOOR_HR(2*60*(n+7):2*60*(n+8));
                    tmpOOR_RRn=tmpOOR_RR(2*60*(n+7):2*60*(n+8));
                elseif length(tmpHR)==3603 % merged 900sec+900sec=1800sec signal
                    tmpHRn=tmpHR(2*60*(n+7+3):2*60*(n+8+3)); %one minute averages starting from the 11th minute
                    tmpRRn=tmpRR(2*60*(n+7+3):2*60*(n+8+3));
                    tmpOOR_HRn=tmpOOR_HR(2*60*(n+7+3):2*60*(n+8+3));
                    tmpOOR_RRn=tmpOOR_RR(2*60*(n+7+3):2*60*(n+8+3));
                end
                if sum(tmpHRn>0)/length(tmpHRn)>=0.2 %at least 20% valid results for a mean to be calculated
                    meanHR(n)=mean(tmpHRn(tmpHRn>0));
                else
                    meanHR(n)=NaN;
                end
                if sum(tmpRRn>0)/length(tmpRRn)>=0.2 %at least 20% valid results for a mean to be calculated
                    meanRR(n)=mean(tmpRRn(tmpRRn>0));
                else
                    meanRR(n)=NaN;
                end
                mOOR_HR(n)=median(tmpOOR_HRn);
                mOOR_RR(n)=median(tmpOOR_RRn);
            end
            RRfilename=d(q).name(1:end-6); %leave last underscore
            load([folderRR,'\',RRfilename(1:end-1),'RRmeans.mat']);
            %             RRloc=strfind(RRfilename,'RR')+2;
            %             HRloc=strfind(RRfilename,'HR')+2;
            %             HRloc_end_tmp=strfind(RRfilename,'_')-1;
            %             HRloc_end_tmp = HRloc_end_tmp(HRloc_end_tmp>HRloc);
            %             HRloc_end = min(HRloc_end_tmp);
            %             simRRnew=ones(5,1).*str2num(RRfilename(RRloc:HRloc-3));
            %             simHRnew=ones(5,1).*str2num(RRfilename(HRloc+1:HRloc_end));
            RRloc=strfind(RRfilename,'RR')+3;
            HRloc=strfind(RRfilename,'HR')+3;
            Plusloc=strfind(RRfilename,'+')-1;
            Noiseloc=strfind(RRfilename,'Noise')-1;
            HRloc_end_tmp=strfind(RRfilename,'_')-1;
            HRloc_end = HRloc_end_tmp(end-5);
            simRRnew=ones(5,1).*str2num(RRfilename(RRloc:Plusloc));
            simHRnew=ones(5,1).*str2num(RRfilename(HRloc:HRloc_end));
%             simRRnew=ones(7,1).*str2num(RRfilename(RRloc:Plusloc));
%             simHRnew=ones(7,1).*str2num(RRfilename(HRloc:HRloc_end));
            simInHR=[simInHR;simHRnew];
            simInRR=[simInRR;simRRnew];
            RRAmpnew=ones(5,1).*str2num(RRfilename(Plusloc+7:HRloc-5));
            HRAmpnew=ones(5,1).*str2num(RRfilename(HRloc_end+2:Noiseloc-1));
%             RRAmpnew=ones(7,1).*str2num(RRfilename(Plusloc+7:HRloc-5));
%             HRAmpnew=ones(7,1).*str2num(RRfilename(HRloc_end+2:Noiseloc-1));
            RRAmp=[RRAmp;RRAmpnew];
            HRAmp=[HRAmp;HRAmpnew];
            %             simOutRR=[simOutRR;(RRall.RR_1min_means(4:8))]; %one minute averages starting from the 4th minute to 8th
            %             if length(tmpHR)==1800 % 900sec signal
            if length(tmpHR)==1802 % 900sec signal
                                simOutRR=[simOutRR;(RRall.RR_1min_means(9:13))]; %one minute averages starting from the 9th minute to 13th
%                 simOutRR=[simOutRR;(RRall.RR_1min_means(9:15))]; %one minute averages starting from the 9th minute to 15th
            elseif length(tmpHR)==3603 % merged 900sec+900sec=1800sec signal
                simOutRR=[simOutRR;(RRall.RR_1min_means(9+3:13+3))]; %one minute averages starting from the 11th minute to 13th
            end
            testRR=[testRR;meanRR'];
            testHR=[testHR;meanHR'];
            OOR_HR = [OOR_HR;mOOR_HR'];
            OOR_RR = [OOR_RR;mOOR_RR'];
            clear RRall
            q=q+1;
        else %depending on either rr or hr are first in order
            load([folder,'\',d(q).name]);
            tmpRR=(rr_params.rr_dec);
            tmpOOR_RR=(rr_params.rr_OOR); %this field does not exist in 5_2_24
            clear rr_params
            q=q+2; % assuming 2 files difference between rr and hr
            load([folder,'\',d(q).name]);
            tmpHR=(hr_params.hr_dec);
            tmpOOR_HR=(hr_params.hr_OOR); %this field does not exist in 5_2_24
            clear hr_params
                        for n=1:5
%             for n=1:7
                %                 tmpHRn=tmpHR(2*60*(n+2):2*60*(n+3)); %one minute averages starting from the 4th minute
                %                 tmpRRn=tmpRR(2*60*(n+2):2*60*(n+3));
                if length(tmpHR)==1800 % 900sec signal
                    tmpHRn=tmpHR(2*60*(n+7):2*60*(n+8)); %one minute averages starting from the 9th minute
                    tmpRRn=tmpRR(2*60*(n+7):2*60*(n+8));
                    tmpOOR_HRn=tmpOOR_HR(2*60*(n+7):2*60*(n+8));
                    tmpOOR_RRn=tmpOOR_RR(2*60*(n+7):2*60*(n+8));
                elseif length(tmpHR)==3600 % merged 900sec+900sec=1800sec signal
                    tmpHRn=tmpHR(2*60*(n+7+15):2*60*(n+8+15)); %one minute averages starting from the 9th minute
                    tmpRRn=tmpRR(2*60*(n+7+15):2*60*(n+8+15));
                    tmpOOR_HRn=tmpOOR_HR(2*60*(n+7+15):2*60*(n+8+15));
                    tmpOOR_RRn=tmpOOR_RR(2*60*(n+7+15):2*60*(n+8+15));
                end
                if sum(tmpHRn>0)/length(tmpHRn)>=0.2 %at least 20% valid results for a mean to be calculated
                    meanHR(n)=mean(tmpHRn(tmpHRn>0));
                else
                    meanHR(n)=NaN;
                end
                if sum(tmpRRn>0)/length(tmpRRn)>=0.2 %at least 20% valid results for a mean to be calculated
                    meanRR(n)=mean(tmpRRn(tmpRRn>0));
                else
                    meanRR(n)=NaN;
                end
                mOOR_HR(n)=median(tmpOOR_HRn);
                mOOR_RR(n)=median(tmpOOR_RRn);
            end
            RRfilename=d(q).name(1:end-6); %leave last underscore
            load([folderRR,'\',RRfilename(1:end-1),'RRmeans.mat']);
            RRloc=strfind(RRfilename,'RR')+2;
            HRloc=strfind(RRfilename,'HR')+2;
            HRloc_end_tmp=strfind(RRfilename,'_')-1;
            HRloc_end_tmp = HRloc_end_tmp(HRloc_end_tmp>HRloc);
            HRloc_end = min(HRloc_end_tmp);
            simRRnew=ones(5,1).*str2num(RRfilename(RRloc:HRloc-3));
            simHRnew=ones(5,1).*str2num(RRfilename(HRloc:HRloc_end));
%                 simRRnew=ones(7,1).*str2num(RRfilename(RRloc:HRloc-3));
%             simHRnew=ones(7,1).*str2num(RRfilename(HRloc:HRloc_end));
            simInHR=[simInHR;simHRnew];
            simInRR=[simInRR;simRRnew];
            %             simOutRR=[simOutRR;(RRall.RR_1min_means(4:8))]; %one minute averages starting from the 4th minute to 8th
            if length(tmpHR)==1800 % 900sec signal
                simOutRR=[simOutRR;(RRall.RR_1min_means(9:13))]; %one minute averages starting from the 9th minute to 13th
%                  simOutRR=[simOutRR;(RRall.RR_1min_means(9:15))]; %one minute averages starting from the 9th minute to 15th
            elseif length(tmpHR)==3600 % merged 900sec+900sec=1800sec signal
                simOutRR=[simOutRR;(RRall.RR_1min_means(9+15:13+15))]; %one minute averages starting from the 9th minute to 13th
            end
            testRR=[testRR;meanRR'];
            testHR=[testHR;meanHR'];
            OOR_HR = [OOR_HR;mOOR_HR'];
            OOR_RR = [OOR_RR;mOOR_RR'];
            clear RRall
            q=q+1;
        end
    end
    q=q+1;
end
simOutHR=simInHR; %no tolerance is defined for HR
testRR(isnan(testRR))=-1;
testHR(isnan(testHR))=-1;

%% Save results
res.simInputRR = simInRR; % [RPM] simulation values of RR
res.simInputHR = simInHR; % [BPM] simulation values of HR
res.simOutputRR = simOutRR; % [RPM] true simulation values of RR (with tolerance)
res.simOutputHR = simOutHR; % [BPM] true simulation values of HR (with tolerance)
res.testRR = testRR; % [RPM] Earlysense output values of RR (1 minute averages)
res.testHR = testHR; % [BPM] Earlysense output values of HR (1 minute averages)
res.OOR_RR = OOR_RR; % out of range indication for RR 1 minute averages (if = 0: in range, else: out of range)
res.OOR_HR = OOR_HR; % out of range indication for HR 1 minute averages (if = 0: in range, else: out of range)

Title = {'Sim input BR'; 'Sim input HR';... % simulation values of HR and RR
    'Sim output BR'; 'Sim output HR';... % true simulation values of HR and RR (with tolerance)
    'ES BR'; 'ES HR';...   % Earlysense output values of HR and RR (1 minute averages)
    'RR Amp'; 'HR Amp';... %HR and RR amplitudes
    'flag OOR BR'; 'flag OOR HR';... %Indication of values out of range (0=in range. +/-1=out of range)
    'flag BR'; 'flag HR';... % 0 for no result displayed. 1 for the rest.
    'aRE BR'; 'aRE HR';...% absolute relative error (abs(test-ref)/ref)
    'difference BR'; 'difference HR';... % test-ref
    'True/False BR'; 'True/False HR'}';   %1 meets the accuracy criteria. (-1) if does not.

TitleData = [simInRR'; simInHR'; ...
    simOutRR'; simOutHR'; ...
    testRR'; testHR';...
    RRAmp'; HRAmp';...
    OOR_RR'; OOR_HR']';

save([mypath,filename],'res')

fid = fopen([mypath,filename,'.csv'],'a' );
for n=1:length(Title)
    fprintf(fid,'%s, ',Title{n});
end
fclose(fid);
dlmwrite([mypath,filename,'.csv'],TitleData, '-append','roffset',1);


