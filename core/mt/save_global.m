function save_global(mat_file)

names = whos('global');
num_gb_vars = numel(names);
if num_gb_vars > 0
    name = names(1).name;
    eval(sprintf('global %s', name));
    save(mat_file, name);
    for i = 2 : num_gb_vars
        name = names(i).name;
        eval(sprintf('global %s', name));
        save(mat_file, name, '-append');
    end
end

end