names = whos('global');
for jj=1:numel(names)
    name = names(jj).name;
    eval(sprintf('global %s',name));
end
