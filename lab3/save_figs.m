%% save figures
FolderName = './figures/';   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  %FigName   = get(FigHandle, 'Name');
  FigName = string(iFig);
  saveas(FigHandle, strcat(FolderName,'test_fig_' ,FigName, '.png'));
end


%% save tables
table_5_4_1a = simout_5_4_1a.c_i_it;
save('./tables/tab_5_4_1a','table_5_4_1a')

table_5_4_1b = simout_5_4_1b.c_i_it;
save('./tables/tab_5_4_1b','table_5_4_1b')

table_5_4_1c = simout_5_4_1c.c_i_it;
save('./tables/tab_5_4_1c','table_5_4_1c')

table_5_4_1d = simout_5_4_1d.c_i_it;
save('./tables/tab_5_4_1d','table_5_4_1d')

table_5_4_2a = simout_5_4_2a.c_i_it;
save('./tables/tab_5_4_2a','table_5_4_2a')

table_5_4_2b = simout_5_4_2b.c_i_it;
save('./tables/tab_5_4_2b','table_5_4_2b')


