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

[T1,T2,T3] = theoretical_bode_plots;

bode_plot(HP_data,'T1 - High-pass', T1);
bode_plot(BP_data,'T2 - Band-pass', T2);
bode_plot(LP_data,'T3 - Low-pass', T3);

%% Calculos
% Ganhos
K_HP = (HP_data.gain(end) + HP_data.gain(end-1))/2;
K_LP = (LP_data.gain(1) + LP_data.gain(2))/2;

% Consideramos para o valor de K a média dos ganhos obtidos nos filtros
% passa-alto e passa-baixo para altas e baixas frequencias, respetivamente

K = 20*log10((10^(K_HP/20)+10^(K_LP/20))/2);

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
    
    aux_struct.gain = 20*log10(aux_struct.v_ptp(:,2)./aux_struct.v_ptp(:,1));
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

function bode_plot(data,name,TF)
    %gain = 20*log(data.v_ptp(:,2)./data.v_ptp(:,1));
    
    [min_value,closestIndex] = min(abs(data.f(:,2)-3800));
    f = figure;
    f.Position = [100 50 350 400];
    semilogx(2*pi*data.f(:,2),data.gain,'x','Color','red')
    hold on
    semilogx(2*pi*data.f(closestIndex,2),data.gain(closestIndex),'o','Color','g')
    point_text = "f_0(Hz) = 3800"+ newline +"G(dB) = " + string(data.gain(closestIndex));
    text(2*pi*data.f(closestIndex,2)*1.1,data.gain(closestIndex)*1.1,point_text)
    
    bode(TF);
    
    phase_arr = [];
    for i = 1:length(data.f(:,2))
        [mag,phase,wout] = bode(TF,2*pi*data.f(i,2));
        phase_arr = cat(1,phase_arr, phase);
    end
    semilogx(2*pi*data.f(:,2),phase_arr,'x','Color','red')
    
    axes_handles = findall(0, 'type', 'axes');
    axes(axes_handles(3))
    ylim([min(data.gain)-10,max(data.gain)+10])
    title(name)
    
end

function [dec_low, dec_high] = declives(data)
    f_db = log10(data.f(:,2));
    %dec_low = (data.gain(3) - data.gain(1))/(f_db(3) - f_db(1));
    %dec_high = (data.gain(end) - data.gain(end-2))/(f_db(end) - f_db(end-2));
    p1=polyfit(f_db(end-2:end), data.gain(end-2:end), 1);
    p2=polyfit(f_db(1:3), data.gain(1:3), 1);
    dec_low = p2(1);
    dec_high = p1(1);
end

function [T1,T2,T3] = theoretical_bode_plots
    R1 =	5.10E+04;
    R2 =	1.00E+05;
    R3 =	1.00E+04;
    R4 =	1.00E+04;
    R5 =	1.00E+05;
    R6 =	1.00E+04;
    R7 =	1.00E+06;
    R8 =	1.00E+05;
    R9 =	5.10E+04;
    R10 =	1.00E+05;
    R11 =	1.00E+04;

    P1 = 	1.00E+05;
    P2 =	1.00E+04;
    C1 =	4.70E-09;
    C2 =	4.70E-09;

    k = ((R5+R2)*P2)/(R2*(R3+P2));
    Q = 1/(((R5+R2)*R3)/(R2*(R3+P2)));
    T = R6*C1;

    s = tf('s');

    T1 = (k*s^2)/(s^2+s/(Q*T)+1/(T^2));
    T2 = ((-k/T)*s)/(s^2+s/(Q*T)+1/(T^2));
    T3 = (k/(T^2))/(s^2+s/(Q*T)+1/(T^2));
end