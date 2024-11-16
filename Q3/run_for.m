function run_for(id, r_n, s_n, w_n)

rng(1)


% Plotting the PSD
figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, pos] = tight_subplot(1, 3, [0.2, 0.05], .1);

axes(subplot_axis(1)); axis on; hold on
histogram(s_n);
title("s[n]")

axes(subplot_axis(2)); axis on; hold on
histogram(w_n);
title("w[n]")

axes(subplot_axis(3)); axis on; hold on
histogram(r_n);
title("r[n]")


exportgraphics(gcf, sprintf('results/hist-%d.pdf', id), 'Append', false);



tr = -1:0.05:1;
x_n = 2*(r_n >= tr) - 1;
px = sum(x_n == s_n) / length(s_n);

px_max = max(px);
locs = find(px > px_max - px_max * 1e-5);
locs = [min(locs), max(locs)];


figure; hold on;
yline(1, "LineStyle",":", "Color", .2*ones(3,1))
plot(tr, px, "LineWidth", 1)    
plot(tr(locs), px(locs), "ro")
xlim([-1, 1])
ylim([0, 1.2])

for i = locs
    text(tr(i), px(i)+.08, sprintf("(%.3g, %.3g)", tr(i), px(i)), "HorizontalAlignment", "center", "Color", .4*ones(1,3))
end

exportgraphics(gcf, sprintf('results/px-%d.pdf', id), 'Append', false);




