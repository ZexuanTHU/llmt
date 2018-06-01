function clear_global_var

names = whos('global');
for jj=1:numel(names)
    name = names(jj).name;
    % eval(sprintf('global %s',name));
    eval(sprintf('clearvars -global %s',name));
end
