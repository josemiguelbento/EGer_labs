close all
clear all
period_time = 1;
sample_time = 0.01;
miu = 0.025;
coef_hibrido = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01];

%% 5_1 - Baralhador de dados Entrada a 0

select_input = 0;
sim_time = 1;
simout_5_1a = sim('teste_bar_dados_5_1',sim_time);

% figure
% 
% %subplot(2,1,1);
% 
% plot(simout_5_1.bar_input.time,simout_5_1.bar_input.signals.values)
% hold on 
% 
% plot(simout_5_1.bar_input.time,simout_5_1.bar_local.signals.values)
% plot(simout_5_1.bar_input.time,simout_5_1.bar_remoto.signals.values)
% legend('input','local','remoto')
% 
% ylim([-1.2 0.5])
% 
% xlabel('time (s)')
% ylabel('saída do baralhador')
% title('Entrada e saídas do baralhador de dados')

f=figure;
f.Position = [100 100 1000 400];
%title('Entrada e saídas do baralhador de dados')
subplot(3,1,1);
plot(simout_5_1a.bar_input.time,simout_5_1a.bar_input.signals.values)
title('Entrada do baralhador de dados')
xlabel('time (s)')
ylabel('Amplitude (V)')
%ylim([-0.2 1.2])

subplot(3,1,2);
plot(simout_5_1a.bar_local.time,simout_5_1a.bar_local.signals.values)
title('Saída do baralhador local')
xlabel('time (s)')
ylabel('Amplitude (V)')
%ylim([-1.2 1.2])

subplot(3,1,3);
plot(simout_5_1a.bar_remoto.time,simout_5_1a.bar_remoto.signals.values)
title('Saída do baralhador remoto')
xlabel('time (s)')
ylabel('Amplitude (V)')
%ylim([-1.2 1.2])


%% 5_1 - Baralhador de dados onda retangular

select_input = 1;
sim_time = 1;
simout_5_1b = sim('teste_bar_dados_5_1',sim_time);

f=figure;
f.Position = [100 100 1000 400];
%title('Entrada e saídas do baralhador de dados')
subplot(3,1,1);
plot(simout_5_1b.bar_input.time,simout_5_1b.bar_input.signals.values)
title('Entrada do baralhador de dados')
xlabel('tempo (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.2])

subplot(3,1,2);
plot(simout_5_1b.bar_local.time,simout_5_1b.bar_local.signals.values)
title('Saída do baralhador local')
xlabel('tempo (s)')
ylabel('Amplitude (V)')
ylim([-1.2 1.2])

subplot(3,1,3);
plot(simout_5_1b.bar_remoto.time,simout_5_1b.bar_remoto.signals.values)
title('Saída do baralhador remoto')
xlabel('tempo (s)')
ylabel('Amplitude (V)')
ylim([-1.2 1.2])

%% 5_2 - Teste do Híbrido
sim_time = 0.15;
simout_5_2 = sim('teste_hibrido_5_2',sim_time);

f=figure;
f.Position = [100 100 1000 350];
%title('Entrada e saídas do baralhador de dados')
subplot(2,1,1);
plot(simout_5_2.hibrido_input.time,simout_5_2.hibrido_input.signals.values)
title('Entrada do híbrido')
xlabel('tempo (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.2])

subplot(2,1,2);
plot(simout_5_2.hibrido_output.time,simout_5_2.hibrido_output.signals.values)
title('Saída do híbrido')
xlabel('tempo (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.7])


%% 5_3 - Teste do Cancelador de Eco
sim_time = 20;
simout_5_3 = sim('teste_cancel_eco_5_3',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_3.erle.time,simout_5_3.erle.signals.values)
title(strcat('ERLE no teste do cancelador de eco para \mu = ',string(miu)')) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_3.c_i.signals.values,2),1);

for i = 1:size(simout_5_3.c_i.signals.values,2)
    plot(simout_5_3.c_i.time,simout_5_3.c_i.signals.values(:,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes no teste do cancelador de eco para \mu = ',string(miu)))
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
ylim([-0.2,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_3.c_i.signals.values,2)
    plot(simout_5_3.c_i.time(1:10001),simout_5_3.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes no teste do cancelador de eco para \mu = ',string(miu)))   
xlabel('tempo (s)')
ylabel('valor do coeficiente')
ylim([-0.2,1.1])


%% 5_4_1a Teste do Sistema Sem Ruído miu = 0.025
%close all
miu = 0.025;
sim_time = 20;
G = 0;
simout_5_4_1a = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_1a.erle.time,simout_5_4_1a.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_1a.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_1a.c_i.signals.values,2)
    plot(simout_5_4_1a.c_i.time,simout_5_4_1a.c_i.signals.values(:,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))  
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_1a.c_i.signals.values,2)
    plot(simout_5_4_1a.c_i.time(1:10001),simout_5_4_1a.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))   
xlabel('tempo (s)')
ylabel('valor do coeficiente')
ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_1a.('miu') = miu;
simout_5_4_1a.('c_i_it') = [];
for i = 1:size(simout_5_4_1a.c_i.signals.values,2)
    simout_5_4_1a.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_1a.c_i_it(2,i) = simout_5_4_1a.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_1a.c_i_it(3,i) = simout_5_4_1a.c_i.signals.values(200001,i);
end

%% 5_4_1b Teste do Sistema Sem Ruído miu = 0.0025
%close all
miu = 0.0025;
sim_time = 200;
G = 0;
simout_5_4_1b = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_1b.erle.time,simout_5_4_1b.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_1b.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_1b.c_i.signals.values,2)
    plot(simout_5_4_1b.c_i.time,simout_5_4_1b.c_i.signals.values(:,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))  
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_1b.c_i.signals.values,2)
    plot(simout_5_4_1b.c_i.time(1:100001),simout_5_4_1b.c_i.signals.values(1:100001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))   
xlabel('tempo (s)')
ylabel('valor do coeficiente')
ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_1b.('miu') = miu;
simout_5_4_1b.('c_i_it') = [];
for i = 1:size(simout_5_4_1b.c_i.signals.values,2)
    simout_5_4_1b.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_1b.c_i_it(2,i) = simout_5_4_1b.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_1b.c_i_it(3,i) = simout_5_4_1b.c_i.signals.values(200001,i);
    % 20000 iteracoes
    simout_5_4_1b.c_i_it(4,i) = simout_5_4_1b.c_i.signals.values(2000001,i);
end

%% 5_4_1c Teste do Sistema Sem Ruído miu = max1
%close all
miu = 0.062;
sim_time = 1200;
G = 0;
simout_5_4_1c = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_1c.erle.time,simout_5_4_1c.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_1c.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_1c.c_i.signals.values,2)
    plot(simout_5_4_1c.c_i.time(1:600001),simout_5_4_1c.c_i.signals.values(1:600001,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))  
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
%ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_1c.c_i.signals.values,2)
    plot(simout_5_4_1c.c_i.time(1:10001),simout_5_4_1c.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))   
xlabel('tempo (s)')
ylabel('valor do coeficiente')
%ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_1c.('miu') = miu;
simout_5_4_1c.('c_i_it') = [];
for i = 1:size(simout_5_4_1c.c_i.signals.values,2)
    simout_5_4_1c.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_1c.c_i_it(2,i) = simout_5_4_1c.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_1c.c_i_it(3,i) = simout_5_4_1c.c_i.signals.values(200001,i);
    % 6000 iteracoes
    simout_5_4_1c.c_i_it(3,i) = simout_5_4_1c.c_i.signals.values(600001,i);
end

%% 5_4_1d Teste do Sistema Sem Ruído miu = max2
%close all
miu = 0.063;
sim_time = 1200;
G = 0;
simout_5_4_1d = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_1d.erle.time,simout_5_4_1d.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_1d.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_1d.c_i.signals.values,2)
    plot(simout_5_4_1d.c_i.time(1:600001),simout_5_4_1d.c_i.signals.values(1:600001,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'Location','northwest','NumColumns',8)
%ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_1d.c_i.signals.values,2)
    plot(simout_5_4_1d.c_i.time(1:10001),simout_5_4_1d.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G)))  
xlabel('tempo (s)')
ylabel('valor do coeficiente')
%ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_1d.('miu') = miu;
simout_5_4_1d.('c_i_it') = [];
for i = 1:size(simout_5_4_1d.c_i.signals.values,2)
    simout_5_4_1d.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_1d.c_i_it(2,i) = simout_5_4_1d.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_1d.c_i_it(3,i) = simout_5_4_1d.c_i.signals.values(200001,i);
    % 6000 iteracoes
    simout_5_4_1d.c_i_it(3,i) = simout_5_4_1d.c_i.signals.values(600001,i);
end


%% 5_4_2a Teste do Sistema Com Ruído miu = 0.025 G = 0.1
%close all
miu = 0.025;
sim_time = 20;
G = 0.1;
simout_5_4_2a = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_2a.erle.time,simout_5_4_2a.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_2a.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_2a.c_i.signals.values,2)
    plot(simout_5_4_2a.c_i.time,simout_5_4_2a.c_i.signals.values(:,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_2a.c_i.signals.values,2)
    plot(simout_5_4_2a.c_i.time(1:10001),simout_5_4_2a.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('valor do coeficiente')
ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_2a.('miu') = miu;
simout_5_4_2a.('c_i_it') = [];
for i = 1:size(simout_5_4_2a.c_i.signals.values,2)
    simout_5_4_2a.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_2a.c_i_it(2,i) = simout_5_4_2a.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_2a.c_i_it(3,i) = simout_5_4_2a.c_i.signals.values(200001,i);
end


%% 5_4_2b Teste do Sistema Sem Ruído miu = max1
%close all
miu = 0.062;
sim_time = 20;
G = 0.4;
simout_5_4_2b = sim('teste_sistema_5_4',sim_time);

f=figure; f.Position = [100 100 1000 300];
plot(simout_5_4_2b.erle.time,simout_5_4_2b.erle.signals.values)
title(strcat('ERLE para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('Ganho (dB)')

f=figure;
f.Position = [100 100 1200 600];
subplot(2,1,1)
%Legend=cell(size(simout_5_3.c_i.signals.values,2)/4,4);
Legend=cell(size(simout_5_4_2b.c_i.signals.values,2),1);

for i = 1:size(simout_5_4_2b.c_i.signals.values,2)
    plot(simout_5_4_2b.c_i.time,simout_5_4_2b.c_i.signals.values(:,i))
    hold on
    Legend{i}= strcat('c_{',string(i-1),'}');
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('valor do coeficiente')
legend(Legend,'NumColumns',2)
%ylim([-0.5,1.1])

subplot(2,1,2)

for i = 1:size(simout_5_4_2b.c_i.signals.values,2)
    plot(simout_5_4_2b.c_i.time(1:10001),simout_5_4_2b.c_i.signals.values(1:10001,i))
    hold on
    %Legend{idivide(i-1,int8(4))+1,rem(i-1,4)+1}= strcat('c_{',string(i),'}');
end
title(strcat('Detalhe - Valor dos coeficientes do cancelador de eco para \mu = ',string(miu), ' G = ',string(G))) 
xlabel('tempo (s)')
ylabel('valor do coeficiente')
%ylim([-0.5,1.1])

% análise dos dados

expected_c_i = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01 0 0 0 0 0 0];
simout_5_4_2b.('miu') = miu;
simout_5_4_2b.('c_i_it') = [];
for i = 1:size(simout_5_4_2b.c_i.signals.values,2)
    simout_5_4_2b.c_i_it(1,i) = expected_c_i(i);
    % 100 iteracoes
    simout_5_4_2b.c_i_it(2,i) = simout_5_4_2b.c_i.signals.values(10001,i);
    % 2000 iteracoes
    simout_5_4_2b.c_i_it(3,i) = simout_5_4_2b.c_i.signals.values(200001,i);
end





