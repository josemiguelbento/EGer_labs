%% Leitura dos ficheiros
clear all
close all
clc


filename = './lab_2/1_6_4.xlsx';
data = read_excel(filename);

[T1,T2,T3] = theoretical_bode_plots;

bode_plot(data,'R9_69','ch2','T1 - Band-pass', T1);
bode_plot(data,'R9_69','ch3','T2 - Low-pass', T2);
bode_plot(data,'R9_69','ch4','T3 - Low-pass', T3);


%% Calculos 1_6_3
% Ganhos
v1_data = data.R9_69.ch2;
v2_data = data.R9_69.ch3;
v3_data = data.R9_69.ch4;

K_v2 = (v2_data.gain(1) + v2_data.gain(2))/2;
K_v3 = (v3_data.gain(1) + v3_data.gain(2))/2;

% Consideramos para o valor de K a média dos ganhos obtidos nos filtros
% passa-alto e passa-baixo para altas e baixas frequencias, respetivamente

K = (K_v2+K_v3)/2;

% da expressao do passa-banda sai que o ganho quando s = j*w0, o ganho é
% K/Q. Como K e Ganho máximo estão ambos em dB, a suaa divisão fica:
Q = K-max(v1_data.gain); %Q em dB


% Declives
[v1_dec_low, v1_dec_high] = declives(v1_data);
[v2_dec_low, v2_dec_high] = declives(v2_data);
[v3_dec_low, v3_dec_high] = declives(v3_data);

%Tive que aldrabar aqui um bocado paa dar um valor decente
%f_db = log10(v3_data.f);
%v3_dec_high = (v3_data.gain(end-2) - v3_data.gain(end-3))/(f_db(end-2) - f_db(end-3));
%opts = bodeoptions;

%% Calculos 1_6_4
sheets = sheetnames(filename);
for i = 1:length(sheets)
    v1_data = data.(sheets(i)).ch2;
    v2_data = data.(sheets(i)).ch3;
    v3_data = data.(sheets(i)).ch4;

    K_v2 = (v2_data.gain(1) + v2_data.gain(2))/2;
    K_v3 = (v3_data.gain(1) + v3_data.gain(2))/2;

    % Consideramos para o valor de K a média dos ganhos obtidos nos filtros
    % passa-alto e passa-baixo para altas e baixas frequencias, respetivamente

    K = (K_v2+K_v3)/2;

    % da expressao do passa-banda sai que o ganho quando s = j*w0, o ganho é
    % K/Q. Como K e Ganho máximo estão ambos em dB, a suaa divisão fica:
    Q = K-max(v1_data.gain); %Q em dB


    % Declives
    [v1_dec_low, v1_dec_high] = declives(v1_data);
    [v2_dec_low, v2_dec_high] = declives(v2_data);
    [v3_dec_low, v3_dec_high] = declives(v3_data);
    
    data.(sheets(i)).K = K;
    data.(sheets(i)).Q = Q;
end

%% Plot effect of variable resistance on K and Q
K_pot = [];
Q_pot = [];
sheets = sheetnames(filename);
for i = 1:length(sheets)
    K_pot = cat(1,K_pot,data.(sheets(i)).K);
    Q_pot = cat(1,Q_pot,data.(sheets(i)).Q);
end
%% Functions
function file_struct = read_excel(filename)
    sheets = sheetnames(filename);
    file_struct = struct();
    aux_struct_template = struct('v_avg',[],'v_rms',[],'v_ptp',[],'v_max',[],'v_min',[],'rise_t',[], ...
        'fall_t',[],'pos_pulse_width',[],'neg_pulse_width',[],'T',[],'f',[],'duty_cycle',[]);
    names = fieldnames(aux_struct_template);
    colum_no = [2 7 12 17];

    for sheet_no = 1:length(sheets)
        sheet = sheets(sheet_no);
        aux_struct = struct();
        [num,txt,raw] = xlsread(filename, sheet);
        for i = 1:size(raw,1)
            if contains(string(raw{i,colum_no(1)}),'CH1')
                for col = 1:length(colum_no)
                    field = 'ch'+string(col);
                    for j = 1:size(names,1)
                        if isfield(aux_struct, field) & isfield(aux_struct.(field), names{j})
                            value = raw{i+j,colum_no(col)}*get_units(raw,i+j,colum_no(col));
                            aux_struct.(field).(names{j}) = cat(1,aux_struct.(field).(names{j}), value);
                        else
                            value = raw{i+j,colum_no(col)}*get_units(raw,i+j,colum_no(col));
                            aux_struct.(field).(names{j}) = [value];
                        end
                    end
                end
            end
        end
        
        for i = 1:length(colum_no)
            field = 'ch'+string(i);
            [f_sorted,sortIdx] = sort(aux_struct.(field).f);
            for j = 1:size(names,1)
                aux = aux_struct.(field).(names{j});
                aux_struct.(field).(names{j}) = aux(sortIdx);
            end
            aux_struct.(field).gain = 20*log10(aux_struct.(field).v_ptp./aux_struct.ch1.v_ptp);
        end
    
        file_struct.(sheet) = aux_struct;
    end
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

function bode_plot(data,sheet,channel,name,TF)
    %gain = 20*log10(data.v_ptp(:,2)./data.v_ptp(:,1));
    
    [min_value,closestIndex] = min(abs(data.(sheet).(channel).f-3800));
    
    f = figure;
    f.Position = [100 50 350 400];
    semilogx(2*pi*data.(sheet).(channel).f,data.(sheet).(channel).gain,'x','Color','red')
    hold on
    semilogx(2*pi*data.(sheet).(channel).f(closestIndex),data.(sheet).(channel).gain(closestIndex),'o','Color','g')
    point_text = "f_0(Hz) = "+ string(data.(sheet).(channel).f(closestIndex)) + newline +"G(dB) = " + string(data.(sheet).(channel).gain(closestIndex));
    text(2*pi*data.(sheet).(channel).f(closestIndex)*1.1,data.(sheet).(channel).gain(closestIndex)*1.1,point_text)

    %opts = bodeoptions;
    %opts.Title.FontSize = 15;
    %opts.YLimMode = {'manual'};
    %opts.YLim = {[min(data.gain)-10,max(data.gain)+10],[-inf,inf]};
    %opts.YLimMode = {'manual'};
    bode(TF);
    phase_arr = [];
    for i = 1:length(data.(sheet).(channel).f)
        [mag,phase,wout] = bode(TF,2*pi*data.(sheet).(channel).f(i));
        phase_arr = cat(1,phase_arr, phase);
    end
    semilogx(2*pi*data.(sheet).(channel).f,phase_arr,'x','Color','red')
    axes_handles = findall(0, 'type', 'axes');
    axes(axes_handles(3))
    ylim([min(data.(sheet).(channel).gain)-10,max(data.(sheet).(channel).gain)+10])
    title(name)
end

function [dec_low, dec_high] = declives(data)
    f_db = log10(data.f);
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

    T1 = -(s/(C1*P2))/(s^2+s/(C1*R6)+R5/(C1*C2*R2*R4*R11));
    T2 = (1/(C1*C2*P2*R11))/(s^2+s/(C1*R6)+R5/(C1*C2*R2*R4*R11));
    T3 = (-R5/(C1*C2*P2*R2*R11))/(s^2+s/(C1*R6)+R5/(C1*C2*R2*R4*R11));
end