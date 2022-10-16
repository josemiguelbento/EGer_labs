%% Leitura dos ficheiros
clear all
close all
clc

%filename = './lab_3/2_5_4_lab2.xlsx';
filename = './lab_4/eger_lab_4.xlsx';
data = read_excel(filename);

T1 = theoretical_bode_plot;

bode_plot(data,'P2_6_3','ch2','T1 - Band-pass', T1);


%% Calculos 1_6_3
% Ganhos
v1_data = data.P2_6_3.ch2;

% da expressao do passa-banda sai que o ganho quando s = j*w0, o ganho é
% K/Q. Como K e Ganho máximo estão ambos em dB, a suaa divisão fica:
K = max(v1_data.gain); %Q em dB


% Declives
[v1_dec_low, v1_dec_high] = declives(v1_data);

%Tive que aldrabar aqui um bocado paa dar um valor decente
%f_db = log10(v3_data.f);
%v3_dec_high = (v3_data.gain(end-2) - v3_data.gain(end-3))/(f_db(end-2) - f_db(end-3));
%opts = bodeoptions;

%% Functions
function file_struct = read_excel(filename)
    %sheets = sheetnames(filename);
    sheets = ["P2_6_3"];
    file_struct = struct();
    aux_struct_template = struct('v_avg',[],'v_rms',[],'v_ptp',[],'v_max',[],'v_min',[],'rise_t',[], ...
        'fall_t',[],'pos_pulse_width',[],'neg_pulse_width',[],'T',[],'f',[],'duty_cycle',[]);
    names = fieldnames(aux_struct_template);
    colum_no = [2 6];

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
    
    [min_value,closestIndex] = min(abs(data.(sheet).(channel).f-1000));
    
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
    p2=polyfit(f_db(1:2), data.gain(1:2), 1);
    dec_low = p2(1);
    dec_high = p1(1);
end

function T1 = theoretical_bode_plot
    s = tf('s');
    T1 = 2*pi*3962.5*s/(s^2+2*pi*250*s+3.947*10^7);
end