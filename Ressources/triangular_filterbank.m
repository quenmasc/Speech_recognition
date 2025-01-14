%% MASCRET Quentin - Copyright 2017 %%
%% 20/02/2017 %%
% This function allow to create a triangular filterbank matrix in order to
% use that to determine Mel Feature Cepstral Coefficients
%% INPUT %%
% nb_filter : number of filters
% freq_response : length of frequency response for each filter
% frequency_limits: row of two values : frequency min and frequency max
% fs: sample rate 

%% OUTPUT %%
% tri_filterbank_matrix : an nb_filter x freq_response matrix

function tri_filterbank_matrix=triangular_filterbank(nb_filter,freq_response,frequency_limits,fs)
%     % flags
%     flags=0;
% 
%     % checking input values 
%     while (frequency_limits(2)>(fs/2)|| frequency_limits(1)>frequency_limits(2))
%         flags=1;
%         if (frequency_limits(2)>(fs/2))
%             clc;
%             disp('---------------------------------------------------------');
%             disp('                    FATAL ERROR                          ');
%             disp('---------------------------------------------------------');
%             fprintf(strcat('F_max : ', num2str(frequency_limits(2)),'\n','Fs : ',num2str(fs),'\n' ));
%             disp('---------------------------------------------------------');
%             disp('Frequency max over sample rate, please fix this problem');
%             a='Enter a new frequency max (need to be under or equal to ~ ';
%             b=') :  \n';
%             c=strcat(a,num2str(fs/2),b);
%             frequency_limits(2)=input(c);
%         end
%         if (frequency_limits(1)>frequency_limits(2))
%             clc;
%             disp('-----------------------------------------------------------');
%             disp('                    FATAL ERROR                            ');
%             disp('-----------------------------------------------------------');
%             fprintf(strcat('F_min : ',num2str(frequency_limits(1)), '\n ', 'F_max : ', num2str(frequency_limits(2)),'\n'));
%             disp('-----------------------------------------------------------');
%             disp('Frequency min over frequency max, please fix this problem');
%             a='Enter new frequency min : \n';
%             b='Enter new frequency max : \n';
%             frequency_limits(1)=input(a);
%             frequency_limits(2)=input(b);
%             
%         end
%     end
%     clc;
%     if (flags==1)
%         disp('-----------------------------------------------------------');
%         disp('                   FIX APPLIED PATCH                       ');
%         disp('-----------------------------------------------------------');
%         fprintf(strcat('F_min : ',num2str(frequency_limits(1)), '\n ', 'F_max : ', num2str(frequency_limits(2)),'\n'));
%     end
%     
    % 
    Hz=linspace(frequency_limits(1),frequency_limits(2),freq_response);
    
    % hz_scale in mel-scale
    mel_low=1127*log(1+(frequency_limits(1)/700));
    mel_high=1127*log(1+(frequency_limits(2)/700));
    
    % filter cut off
    C=mel_low+[0:nb_filter+1]*((mel_high-mel_low)/(nb_filter+1));
    Cep=700*exp(C/1127)-700;
    
    % allocation before loop
    tri_filterbank_matrix=zeros(nb_filter, freq_response);
    % Loop
     for m = 1:nb_filter
        k = Hz>=Cep(m)&Hz<=Cep(m+1); % up-slope
        tri_filterbank_matrix(m,k) = (Hz(k)-Cep(m))/(Cep(m+1)-Cep(m));
        k = Hz>=Cep(m+1)&Hz<=Cep(m+2); % down-slope
        tri_filterbank_matrix(m,k) = (Cep(m+2)-Hz(k))/(Cep(m+2)-Cep(m+1));
       
     end
end