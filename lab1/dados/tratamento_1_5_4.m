clear all
close all
clc

%% Leitura dos ficheiros
HP_filename = './lab_1_5/1_5_4/bode_plot_HP.xlsx';
BP_filename = './lab_1_5/1_5_4/bode_plot_BP.xlsx';
LP_filename = './lab_1_5/1_5_4/bode_plot_LP.xlsx';

HP_data = read_excel(HP_filename);
BP_data = read_excel(BP_filename);
LP_data = read_excel(LP_filename);

bode_plot(HP_data,'T1 - High-pass');
bode_plot(BP_data,'T2 - Band-pass');
bode_plot(LP_data,'T3 - Low-pass');

%% Calculos
% Ganhos
K_HP = (HP_data.gain(end) + HP_data.gain(end-1))/2;
K_LP = (LP_data.gain(1) + LP_data.gain(2))/2;

% Consideramos para o valor de K a média dos ganhos obtidos nos filtros
% passa-alto e passa-baixo para altas e baixas frequencias, respetivamente

K = (K_HP+K_LP)/2;

% da expressao do passa-banda sai que o ganho quando s = j*w0, o ganho é
% K/Q. Como K e Ganho máximo estão ambos em dB, a suaa divisão fica:
Q = K-max(BP_data.gain); %Q em dB


% Declives
[HP_dec_low, HP_dec_high] = declives(HP_data);
[BP_dec_low, BP_dec_high] = declives(BP_data);
[LP_dec_low, LP_dec_high] = declives(LP_data);

%% Functions
function aux_struct = read_excel(filename)
    [num,txt,raw] = xlsread(filename);
    aux_struct = struct('v_avg',[],'v_rms',[],'v_ptp',[],'v_max',[],'v_min',[],'rise_t',[], ...
        'fall_t',[],'pos_pulse_width',[],'neg_pulse_width',[],'T',[],'f',[],'duty_cycle',[]);
    column_number_1 = 1;
    column_number_2 = 5;

    names = fieldnames(aux_struct);
    for i = 1:size(raw,1)
        if contains(string(raw{i,column_number_1}),'CH1')
            for j = 1:size(names,1)
                value = [raw{i+j,column_number_1}*get_units(raw,i+j,column_number_1) ...
                    raw{i+j,column_number_2}*get_units(raw,i+j,column_number_2)];
                aux_struct.(names{j}) = cat(1,aux_struct.(names{j}), value);
            end
        end
    end
    
    [f_sorted,sortIdx_ch1] = sort(aux_struct.f(:,1));
    [f_sorted,sortIdx_ch2] = sort(aux_struct.f(:,2));
    for j = 1:size(names,1)
        aux_ch1 = aux_struct.(names{j})(:,1);
        aux_ch2 = aux_struct.(names{j})(:,2);
        aux_struct.(names{j})(:,1) = aux_ch1(sortIdx_ch1);
        aux_struct.(names{j})(:,2) = aux_ch2(sortIdx_ch2);
    end
    
    aux_struct.gain = 20*log(aux_struct.v_ptp(:,2)./aux_struct.v_ptp(:,1));
end

function units = get_units(raw,line,column)
    if raw{line,column+1}(1) == 'm'
        units = 10^-3;
    elseif raw{line,column+1}(1) == 'k'
        units = 10^3;
    elseif raw{line,column+1}(1) == 'u'
        units = 10^-6;
    else
        units = 1;
    end
end

function bode_plot(data,name)
    %gain = 20*log(data.v_ptp(:,2)./data.v_ptp(:,1));
    
    [min_value,closestIndex] = min(abs(data.f(:,2)-3800));
    
    figure
    semilogx(data.f(:,2),data.gain)
    hold on
    semilogx(data.f(closestIndex,2),data.gain(closestIndex),'o')
    point_text = "f_0(Hz) = 3800"+ newline +"G(dB) = " + string(data.gain(closestIndex));
    text(data.f(closestIndex,2)*1.1,data.gain(closestIndex)*1.1,point_text)
    title(name)
    xlabel('frequency (Hz) - logarithmic scale') 
    ylabel('Gain (dB')
    
end

function [dec_low, dec_high] = declives(data)
    f_db = log(data.f(:,2));
    %dec_low = (data.gain(3) - data.gain(1))/(f_db(3) - f_db(1));
    %dec_high = (data.gain(end) - data.gain(end-2))/(f_db(end) - f_db(end-2));
    p1=polyfit(f_db(end-2:end), data.gain(end-2:end), 1);
    p2=polyfit(f_db(1:3), data.gain(1:3), 1);
    dec_low = p2(1);
    dec_high = p1(1);
end