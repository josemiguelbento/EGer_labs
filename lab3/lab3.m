close all
clear all
period_time = 1;
sample_time = 0.01;
miu = 0.025;
coef_hibrido = [0 0.2 1 0.3 -0.4 -0.1 0.1 -0.05 -0.02 -0.01];

%% 5_1 - Baralhador de dados 0

% Entrada a zero
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

figure
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

figure
%title('Entrada e saídas do baralhador de dados')
subplot(3,1,1);
plot(simout_5_1b.bar_input.time,simout_5_1b.bar_input.signals.values)
title('Entrada do baralhador de dados')
xlabel('time (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.2])

subplot(3,1,2);
plot(simout_5_1b.bar_local.time,simout_5_1b.bar_local.signals.values)
title('Saída do baralhador local')
xlabel('time (s)')
ylabel('Amplitude (V)')
ylim([-1.2 1.2])

subplot(3,1,3);
plot(simout_5_1b.bar_remoto.time,simout_5_1b.bar_remoto.signals.values)
title('Saída do baralhador remoto')
xlabel('time (s)')
ylabel('Amplitude (V)')
ylim([-1.2 1.2])

%% 5_2 
sim_time = 0.15;
simout_5_2 = sim('teste_hibrido_5_2',sim_time);

figure
%title('Entrada e saídas do baralhador de dados')
subplot(2,1,1);
plot(simout_5_2.hibrido_input.time,simout_5_2.hibrido_input.signals.values)
title('Entrada do híbrido')
xlabel('time (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.2])

subplot(2,1,2);
plot(simout_5_2.hibrido_output.time,simout_5_2.hibrido_output.signals.values)
title('Saída do híbrido')
xlabel('time (s)')
ylabel('Amplitude (V)')
ylim([-0.2 1.7])


